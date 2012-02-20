//
//  AppDelegate.h
//  QuickDropShot
//
//  Created by 水野 真史 on 12/02/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxSDK/DropboxSDK.h"

@class PhotoPickerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIBackgroundTaskIdentifier backGroundTask;
}

@property (strong, nonatomic) UIWindow *window;

- (void)setRootView;

@end
