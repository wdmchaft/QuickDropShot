//
//  SettingViewController.m
//  QuickDropShot
//
//  Created by 水野 真史 on 12/02/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "PhotoPickerViewController.h"
#import "ImageSizeTableViewController.h"

@implementation SettingViewController

@synthesize stTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -------------------------------------------------------
#pragma mark - view life cycle
#pragma mark -------------------------------------------------------

- (void)loadView {
    [super loadView];
        
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);   
    self.stTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    stTableView.delegate = self;
    stTableView.dataSource = self;
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"閉じる" style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.12f green:0.56f blue:1.0f alpha:1.0f];
    self.navigationItem.leftBarButtonItem = done;
    
    [self.view addSubview:self.stTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear_st");
    [self.stTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)done:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -------------------------------------------------------
#pragma mark - UITableView Delegate
#pragma mark -------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 1;
        case 3:
            return 1;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    static NSString *headerTitle;
    switch (section) {
        case 0: {
            headerTitle = @"アカウント認証";
            break;            
        }
        case 1: {
            headerTitle = @"";
            break;
        }
        case 2: {
            headerTitle = @"";
            break;
        }
        case 3: {
            headerTitle = @"保存品質";
            break;
        }
    }
    
    return headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    static NSString *footString;
    switch (section) {
        case 0: {
            footString = @"";
            break;            
        }
        case 1: {
            footString = @"Dropboxへは【/Photos】フォルダに保存されます";
            break;
        }
        case 2: {
            footString = @"";
            break;
        }
        case 3: {
            footString = @"";
            break;
        }
    }
    
    return footString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        //アカウント認証解除
        case 0:
            
            if ([[DBSession sharedSession] isLinked]) {
                cell.textLabel.text = @"認証解除";
            } else {
                cell.textLabel.text = @"アカウント認証";
            }
            break;
        //カメラロールに保存
        case 1: {
            UISwitch *cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(1, 1, 20, 20)];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

            if ([userDefault boolForKey:@"cameraRoll"]) {
                cellSwitch.on = YES; 
                NSLog(@"switch_YES");
            } else {
                cellSwitch.on = NO;
                NSLog(@"switch_NO");
            }
            
            [cellSwitch addTarget:self action:@selector(Cswitching:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = cellSwitch;
            
            cell.textLabel.text = @"カメラロールに保存";
        }
            break;
        
        //アイコンBadge
        case 2: {
            UISwitch *cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(1, 1, 20, 20)];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            if ([userDefault boolForKey:@"iconBadge"]) {
                cellSwitch.on = YES; 
                NSLog(@"Badge_YES");
            } else {
                cellSwitch.on = NO;
                NSLog(@"Badge_NO");
            }
            
            [cellSwitch addTarget:self action:@selector(Bswitching:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = cellSwitch;
            
            cell.textLabel.text = @"アイコンバッジを表示";
        }
            break;
        
        //保存品質
        case 3: {
            cell.textLabel.text = @"画像保存品質を設定";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            if (![[DBSession sharedSession] isLinked]) {
                [[DBSession sharedSession] link];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                [tableView reloadData];
            } else {
                [[DBSession sharedSession] unlinkAll];
                [[[UIAlertView alloc] 
                   initWithTitle:@"認証解除" message:@"Dropboxのアカウント認証を解除しました。" 
                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
                 show];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                [tableView reloadData];
            }
            
            break;
        }
        
        case 3: {
            ImageSizeTableViewController *next = [[ImageSizeTableViewController alloc] init];
            [self.navigationController pushViewController:next animated:YES];
            
        }
    }
}

- (void)Cswitching:(UISwitch*)cellswitch {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (cellswitch.on) {
        [userDefault setBool:YES forKey:@"cameraRoll"];
    } else {
        [userDefault setBool:NO forKey:@"cameraRoll"];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
    [userDefault synchronize];
}

- (void)Bswitching:(UISwitch*)cellswitch {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (cellswitch.on) {
        [userDefault setBool:YES forKey:@"iconBadge"];
    } else {
        [userDefault setBool:NO forKey:@"iconBadge"];
    }
    
    [userDefault synchronize];
}


@end
