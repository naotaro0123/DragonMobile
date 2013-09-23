//
//  ViewController.m
//  DragonMobile
//
//  Created by naotaro on 2013/09/23.
//
//

#import "ViewController.h"

// API Key (このキーは期限切れなので登録したキーを貼付ける)
const unsigned char SpeechKitApplicationKey[] = {0x7c, 0xc6, 0xc6, 0x9e, 0xd7, 0x9c, 0x44, 0x26, 0xa4, 0x84, 0xaf, 0x3c, 0xe5, 0x72, 0x00, 0x5c, 0x52, 0xac, 0x8b, 0x00, 0x04, 0xe4, 0x25, 0xab, 0x10, 0x94, 0xc4, 0x44, 0x8c, 0x0b, 0x62, 0x09, 0xd2, 0x29, 0xa7, 0xa9, 0xc5, 0xeb, 0xcf, 0x69, 0x6f, 0x7e, 0xa6, 0x54, 0xf0, 0xa6, 0xb0, 0x43, 0x52, 0x3b, 0x43, 0x56, 0x20, 0x68, 0x02, 0x30, 0xfd, 0xc6, 0x74, 0x89, 0xd1, 0xd7, 0x92, 0xa3};

@interface ViewController ()
    // 音声結果出力テキスト
    @property (weak, nonatomic) IBOutlet UITextView *outputText;
@end

@implementation ViewController
@synthesize recordButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 音声認識の初期化(ここのキーも期限切れなのでsetupWithIDを変更する)
 	[SpeechKit setupWithID:@"NMDPTRIAL_naotaro20130101040713"
                      host:@"sandbox.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// 音声入力開始ボタン押下時
- (IBAction)inputVoice:(id)sender {
    self.outputText.text = @"音声入力開始・・・";
    [self.outputText resignFirstResponder];
    // レコード中
    if (transactionState == TS_RECORDING) {
        // レコード中止
        [voiceSearch stopRecording];
    }
    else if (transactionState == TS_IDLE) {
        // レコード開始
        SKEndOfSpeechDetection detectionType;
        NSString* recoType;
        NSString* langType;
        
        transactionState = TS_INITIAL;
        
        detectionType = SKLongEndOfSpeechDetection;
        /* Dictations tend to be long utterances that may include short pauses. */
        recoType = SKDictationRecognizerType;
        /* Optimize recognition performance for dictation or message text. */
		
        langType = @"ja_JP";
		
        voiceSearch = [[SKRecognizer alloc] initWithType:recoType
                                               detection:detectionType
                                                language:langType
                                                delegate:self];
    }
}

- (void)updateVUMeter {
    [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
}

// 音声入力中
- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    NSLog(@"【音声入力中...】");
    
    transactionState = TS_RECORDING;
    self.outputText.text = @"音声入力待ち...";
    [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
}

// 音声入力終了
- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    NSLog(@"【音声入力完了！】");
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateVUMeter) object:nil];
    transactionState = TS_PROCESSING;
    self.outputText.text = @"解析中...";
}

// 音声入力判別が正常終了時
- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    NSLog(@"【音声解析完了】");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]);
    // for debugging purpose: printing out the speechkit session id
    
    long numOfResults = [results.results count];
    
    transactionState = TS_IDLE;
    
    if (numOfResults > 0)
        // テキストに解析結果を入れる
        self.outputText.text = [results firstResult];
    
    if (results.suggestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:results.suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
	voiceSearch = nil;
}

// 音声入力判別が異常終了時
- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    self.outputText.text = @"音声解析失敗！";
    NSLog(@"【音声解析失敗！】");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]);
    // for debugging purpose: printing out the speechkit session id
    
    transactionState = TS_IDLE;
    [recordButton setTitle:@"音声入力" forState:UIControlStateNormal];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    if (suggestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
	voiceSearch = nil;
}

@end
