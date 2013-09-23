//
//  ViewController.h
//  DragonMobile
//
//  Created by naotaro on 2013/09/23.
//
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>

@interface ViewController : UIViewController<SKRecognizerDelegate, UITextFieldDelegate>{
    // メンバ変数宣言
    SKRecognizer* voiceSearch;
    enum {
        TS_IDLE,
        TS_INITIAL,
        TS_RECORDING,
        TS_PROCESSING,
    } transactionState;
}
// 音声入力開始ボタン
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@end
