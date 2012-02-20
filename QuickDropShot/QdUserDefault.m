//
//  UserDefault.m
//  QuickDropShot
//
//  Created by 水野 真史 on 12/02/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QdUserDefault.h"

@implementation QdUserDefault

- (void)setApplicationUserDefault {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    //初回起動フラグ
    [userDefault setBool:NO forKey:@"FirstLaunch"];
    //カメラロール保存（初期値OFF）
    [userDefault setBool:NO forKey:@"cameraRoll"];
    //アイコンバッジ（初期値YES）
    [userDefault setBool:YES forKey:@"iconBadge"];
    //JPG保存品質（初期値中)
    [userDefault setInteger:QdImageQualityMiddle forKey:@"imageQuality"];
    //画像サイズ
    [userDefault setInteger:QdImageSizeQXGA forKey:@"imageSize"];
    
    [userDefault synchronize];    

}



@end
