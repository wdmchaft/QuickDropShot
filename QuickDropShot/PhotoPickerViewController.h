//
//  PhotoPickerViewController.h
//  QuickDropShot
//
//  Created by 水野 真史 on 12/02/08.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface PhotoPickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, DBRestClientDelegate> {
    
    UIImagePickerController *picker;
    BOOL isCamera;
    
    UIButton *stButton;
    UILabel *upStatus;
    UIActivityIndicatorView *indicator;
    
    NSInteger saveCount;
    NSString *exportFilePath;
    
}

@property (strong, nonatomic) UIImagePickerController *picker;
@property (nonatomic) BOOL isCamera;

@property (strong, nonatomic) UIButton *stButton;
@property (strong, nonatomic) UILabel *upStatus;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@property (nonatomic) NSInteger saveCount;
@property (strong, nonatomic) NSString *exportFilePath;

- (void)dataSaveWrite:(UIImage *)image;
- (void)openSettingView:(id)sender;
- (void) correspondToDeviceRotation : (int)angle;

@end
