//
//  SettingViewController.h
//  QuickDropShot
//
//  Created by 水野 真史 on 12/02/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate> {
    
    UITableView *stTableView;
}

@property (strong, nonatomic) UITableView *stTableView;

@end
