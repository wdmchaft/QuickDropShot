//
//  ImageSizeTableViewController.h
//  QuickDropShot
//
//  Created by 水野 真史 on 12/02/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSizeTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *stableView;
}

@property (strong, nonatomic) UITableView *stableView;

@end
