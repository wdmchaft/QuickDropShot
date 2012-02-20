//
//  PhotoPickerViewController.m
//  QuickDropShot
//
//  Created by 水野 真史 on 12/02/08.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "SettingViewController.h"

@interface PhotoPickerViewController() {
    DBRestClient *restClient;
}

- (DBRestClient *)restClient;

@end


@implementation PhotoPickerViewController

@synthesize picker, isCamera, stButton, upStatus, indicator, saveCount, exportFilePath;

//-------------------------------------------------------
//初期化
//-------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"init");
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.view.backgroundColor = [UIColor clearColor];
        self.isCamera = YES;        
        self.saveCount = 0;
    }
    return self;
}

//-------------------------------------------------------
//メモリ不足時に呼ばれる
//-------------------------------------------------------
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -------------------------------------------------------
#pragma mark - view life cycle
#pragma mark -------------------------------------------------------

//-------------------------------------------------------
//Viewが読み込まれた時に呼ばれる
//-------------------------------------------------------
- (void)loadView {
    [super loadView];
    NSLog(@"loadView");
            
    //設定ボタン
    self.stButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stButton.frame = CGRectMake(250, 360, 60, 35);
    self.stButton.backgroundColor = [UIColor clearColor];
    [self.stButton addTarget:self action:@selector(openSettingView:) forControlEvents:UIControlEventTouchUpInside];
    [self.stButton setImage:[UIImage imageNamed:@"stBT_normal.png"] forState:UIControlStateNormal];
    [self.stButton setImage:[UIImage imageNamed:@"stBT_active.png"] forState:UIControlStateHighlighted];
    
    //写真転送状況
    self.upStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, 320, 27)];
    self.upStatus.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    self.upStatus.textAlignment = UITextAlignmentLeft;
    self.upStatus.font = [UIFont systemFontOfSize:14.0f];
    self.upStatus.textColor = [UIColor whiteColor];
    self.upStatus.alpha = 0;
    
    //写真転送中のインジケーター
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.frame = CGRectMake(5, 403.5, 20, 20);
    
    //picker
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.cameraOverlayView = self.view;
    self.picker.allowsEditing = NO;
    
    //デバイスの回転感知
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //通知センターを利用して位置を取得する
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil]; 
}

//-------------------------------------------------------
//Viewが読み込まれる直前に呼ばれる
//-------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"cameraRoll%@", [userDefault objectForKey:@"cameraRoll"]);
    if (![userDefault boolForKey:@"iconBadge"]) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];        
    } else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:saveCount];
    }
}

//-------------------------------------------------------
//Viewが読み込まれた直後に呼ばれる
//-------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    
    //カメラ起動フラグがYESであれば
    if (isCamera) {
        //カメラをモーダルで表示
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            [self.view addSubview:self.stButton];
            [self.view addSubview:upStatus];
            [self.view addSubview:indicator];
            [self presentModalViewController:picker animated:YES];
        } else {
            //カメラ非搭載端末であればアラートを出す。
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"カメラ非搭載" message:@"カメラ搭載端末でお試しください" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

//-------------------------------------------------------
//Viewが非表示される直前に呼ばれる
//-------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");    
}

//-------------------------------------------------------
//Viewが非表示された直後に呼ばれる
//-------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");    
}

//-------------------------------------------------------
//メモリ不足時にここでインスタンスにnillを入れる。
//-------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    NSLog(@"viewDidUnLoad");
    self.picker = nil;
    self.upStatus = nil;
    self.stButton = nil;
}

//-------------------------------------------------------
//回転対応させるかどうか
//-------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)didRotate:(NSNotification *)notification {
    UIDeviceOrientation or = [[notification object] orientation];
    if (or == UIDeviceOrientationPortrait) {
        NSLog(@"縦");
        [self correspondToDeviceRotation:0];
        self.stButton.frame = CGRectMake(250, 360, 60, 35);
        self.upStatus.frame = CGRectMake(0, 400, 320, 27);
        self.indicator.frame = CGRectMake(5, 403.5, 20, 20);

    } else if (or == UIDeviceOrientationPortraitUpsideDown) {
        NSLog(@"縦（逆）");
        [self correspondToDeviceRotation:180];
        self.stButton.frame = CGRectMake(250, 360, 60, 35);
        self.upStatus.frame = CGRectMake(0, 400, 320, 27);
        self.indicator.frame = CGRectMake(295, 403.5, 20, 20);

    } else if (or == UIDeviceOrientationLandscapeLeft) {
        NSLog(@"横（右）");
        [self correspondToDeviceRotation:90];
        self.stButton.frame = CGRectMake(35, 350, 35, 60);
        self.upStatus.frame = CGRectMake(0, 0, 27, 460);
        self.indicator.frame = CGRectMake(3.5, 5, 20, 20);

    } else if (or == UIDeviceOrientationLandscapeRight) {
        NSLog(@"横（左）");
        [self correspondToDeviceRotation:270];
        self.stButton.frame = CGRectMake(250, 360, 35, 60);
        self.upStatus.frame = CGRectMake(293, 0, 27, 430);
        self.indicator.frame = CGRectMake(296.5, 403.5, 20, 20);
    }
}

//-------------------------------------------------------
//アイテムを回転させるMethod
//-------------------------------------------------------
- (void) correspondToDeviceRotation : (int)angle {
    // 回転させるためのアフィン変形を作成する
    CGAffineTransform t = CGAffineTransformMakeRotation(angle * M_PI / 180);
    // 回転させるのにアニメーションをかけてみた
    [UIView beginAnimations:@"device rotation" context:nil];
    [UIView setAnimationDuration:0.3];
    
    self.stButton.transform = t;
    self.upStatus.transform = t;
    
    [UIView commitAnimations];
}

#pragma mark -------------------------------------------------------
#pragma mark - UIImagePickerViewController Delegate
#pragma mark -------------------------------------------------------

//-------------------------------------------------------
//シャッターが押され[use]を押された時
//-------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    //保存待ちcountを++
    self.saveCount++;
    
    if ([userDefault boolForKey:@"iconBadge"]) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:saveCount];        
    } else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];        
    }

    //転送状況ラベルを更新
    self.upStatus.text = [NSString stringWithFormat:@"　　%dファイル転送中", saveCount];
    //ラベルの不透明度を１に
    self.upStatus.alpha = 1;
    //インジケーターを回す
    [self.indicator startAnimating];
    NSLog(@"保存開始");
    
    //データ保存Methodの呼び出し
    [self dataSaveWrite:image];
    
    if ([userDefault boolForKey:@"cameraRoll"]) {
        // 渡されてきた画像をフォトアルバムに保存する
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(targetImage:didFinishSavingWithError:contextInfo:), NULL);
    }
    
    //ピッカーを閉じる
    [self.picker dismissModalViewControllerAnimated:YES];

}

//-------------------------------------------------------
//キャンセルボタンを押された時に呼ばれる
//-------------------------------------------------------
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"キャンセル押した");
    //設定画面を表示
    [self openSettingView:self];
}

//-------------------------------------------------------
//カメラロール保存完了時に呼ばれる
//-------------------------------------------------------
-(void)targetImage:(UIImage*)image
didFinishSavingWithError:(NSError*)error contextInfo:(void*)context {
    
    if(error){
        // 保存失敗時の処理
    }else{
        // 保存成功時の処理
    }    
}

#pragma mark -------------------------------------------------------
#pragma mark - DropboxSDK Delegate
#pragma mark -------------------------------------------------------

//-------------------------------------------------------
//Dropbox保存成功時に呼ばれる
//-------------------------------------------------------
- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    
    NSLog(@"ファイル保存成功");
    //保存まちcountを--
    self.saveCount--;
    //アイコンバッジを表示
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:saveCount];

    //転送状況ラベルを更新
    self.upStatus.text = [NSString stringWithFormat:@"　　%dファイル転送中", saveCount];
    //もし転送待ちが０だったらラベルを隠す
    if (saveCount == 0) {
        self.upStatus.alpha = 0;
        [self.indicator stopAnimating];
    } 
    
    //サンドボックスに一時保存したファイルを削除
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:exportFilePath error:nil];
    
    //-------------------------------------------------------
    //デバッグ用    
    NSLog(@"ファイルパス%@", exportFilePath);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *array = [[NSFileManager defaultManager]
                      contentsOfDirectoryAtPath:[paths objectAtIndex:0] error:nil];
    NSLog(@"のこってるかな%@", array);
    //-------------------------------------------------------
}

//-------------------------------------------------------
//Dropbox保存失敗時に呼ばれる
//-------------------------------------------------------
- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    
    NSLog(@"ファイル保存失敗");
    //アラートを表示
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失敗" message:@"Dropboxへの保存に失敗しました。ネットワーク環境をご確認ください。"/*[NSString stringWithFormat:@"%@", error]*/ delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    //保存まちcountを--
    self.saveCount--;
    //アイコンバッジを更新
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:saveCount];
    
    //もし転送待ちが０だったらラベルを隠す
    if (saveCount == 0) {
        self.upStatus.alpha = 0;
        [self.indicator stopAnimating];
    }
    
    //サンドボックスに一時保存したファイルを削除
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:exportFilePath error:nil];
}

#pragma mark -------------------------------------------------------
#pragma mark - PrivateMethod
#pragma mark -------------------------------------------------------

//-------------------------------------------------------
//画像保存Method
//-------------------------------------------------------
- (void)dataSaveWrite:(UIImage *)image {
    NSLog(@"dataSaveWrite");
    
    //サンドボックスのルートパスを取得
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *userDocumentsPath = [paths objectAtIndex:0];
    
    //ファイル名に使用する日付を取得する
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy_MM_dd_HH_mm_ss";    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [df stringFromDate:[NSDate date]]];    
    NSLog(@"ファイル取得年月%@", fileName);
    
    //JPG画質設定を確認
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger jpgQ = [userDefault integerForKey:@"imageQuality"];
    CGFloat jpgFloat;
    switch (jpgQ) {
        case 1:
            jpgFloat = 0.3f;
            break;
        case 2:
            jpgFloat = 0.5f;
            break;
        case 3:
            jpgFloat = 0.85f;
            break;
        case 4:
            jpgFloat = 1.0f;
            break;
    }
    
    //画像リサイズ
    //TODO
    //現在2048x1536固定
    //例えばどちらかの辺（縦か横か）を320pxにする。
    NSInteger imageSize = [userDefault integerForKey:@"imageSize"];
    UIImage *sImage;
    if (!imageSize == 0) {
    CGImageRef imageRef = [image CGImage];
    
    size_t w,h;  
    if (image.imageOrientation==UIImageOrientationUp ||  
        image.imageOrientation==UIImageOrientationDown) {  
        // 横位置  
        w = CGImageGetWidth(imageRef);  
        h = CGImageGetHeight(imageRef);  
    } else {  
        // 縦位置  
        w = CGImageGetHeight(imageRef);  
        h = CGImageGetWidth(imageRef);  
    }
    
    int r_w, r_h;
    
    //横位置
    if (w > h) {
        NSLog(@"横位置感知");
        r_w = 2048;
        r_h = 1536;        
    } else {
        NSLog(@"縦位置感知");
        r_w = 1536;
        r_h = 2048;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(r_w, r_h));
    [image drawInRect:CGRectMake(0, 0, r_w, r_h)];
    UIImage *sImage;
    sImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    }

    //ファイル名として成形する
    self.exportFilePath = [userDocumentsPath stringByAppendingPathComponent:fileName];    
    
    //撮影データをJPGフォーマットでバイナリにする
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(sImage, jpgFloat)];
    NSLog(@"JPG画質%f", jpgFloat);
    
    //ファイル保存
    [imageData writeToFile:exportFilePath atomically:YES];
    NSLog(@"exportFilePath%@", exportFilePath);
    
    //Dropboxへ保存
    NSString *distDir = @"/Photos";
    [[self restClient] uploadFile:fileName toPath:distDir withParentRev:nil fromPath:exportFilePath];
    NSLog(@"ファイル保存");    
}

//-------------------------------------------------------
//設定画面表示
//-------------------------------------------------------
- (void)openSettingView:(id)sender {
    //カメラ起動フラグをOFFに
    isCamera = NO; 
    
    //設定画面のインスタンスを生成して、モーダルで表示
    SettingViewController *stView = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:stView];
    NSLog(@"設定画面開くよ");
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:nav animated:YES];
    
    //カメラ起動フラグをYESにもどす
    isCamera = YES;
}

#pragma mark -------------------------------------------------------
#pragma mark - PhotoPickerViewController()
#pragma mark -------------------------------------------------------

//-------------------------------------------------------
//Dropboxアクセス準備
//-------------------------------------------------------
- (DBRestClient *)restClient {
    if (!restClient) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
        NSLog(@"restClient生成成功");
    }
    return restClient;    
}

@end
