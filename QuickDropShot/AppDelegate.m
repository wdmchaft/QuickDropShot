//
//  AppDelegate.m
//  QuickDropShot
//
//  Created by 水野 真史 on 12/02/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoPickerViewController.h"

@implementation AppDelegate

@synthesize window = _window;

//-------------------------------------------------------
//アプリケーション起動時の呼ばれる
//-------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //DropboxSDKAPIKey
    NSString* appKey = @"cak082d25s0bajl";
	NSString* appSecret = @"2ilre8bktsn22cy";
	NSString *root = kDBRootDropbox;
    
    //Dropboxへの接続
    DBSession *dbSession = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
    [DBSession setSharedSession:dbSession];
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] link];
    } else {
        //RootViewの設定
        [self setRootView];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (![userDefault boolForKey:@"FirstLaunch"]) {
        NSLog(@"初期値読み込みはじめて");
        QdUserDefault *qdUserDefault = [[QdUserDefault alloc] init];
        
        [qdUserDefault setApplicationUserDefault];        
    }
    
    return YES;
}

//-------------------------------------------------------
//Dropbox認証画面から戻ってきた時によばれる
//-------------------------------------------------------

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            
            //RootViewの設定
            [self setRootView];            
        }
        
        return YES;
    }
    return NO;
}

- (void)setRootView {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]];
    
    PhotoPickerViewController *viewController = [[PhotoPickerViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    backGroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:backGroundTask];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
