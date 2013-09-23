DragonMobile
============

iphoneで音声認識するサンプルです。

Siriなどで有名なDragonMobile SDKを使用してます。

提供されているサンプルから必要な部分のみ抜き出したソースになります。

使用方法
----------
（１）DragonMobileのユーザ登録をする(90日間は無料です)

　http://www.nuancemobiledeveloper.com/public/index.php

（２）ユーザ登録後にメールが届くので、プログラムの以下の2箇所を修正する

  [ViewController.m]

    // APIキー
    const unsigned char SpeechKitApplicationKey[] = {xxxxx};

    // ユーザーキー
    [SpeechKit setupWithID:@"NMDPTRIAL_xxxx"
                    host:@"sandbox.nmdp.nuancemobility.net"
                    port:443
                    useSSL:NO
                    delegate:nil];


※　このコードのライセンスは有効期限が切れています
![キャプチャ](http://simplecode.jp/lolipop/github/DragonMobile1.png)
![キャプチャ](http://simplecode.jp/lolipop/github/DragonMobile2.png)

