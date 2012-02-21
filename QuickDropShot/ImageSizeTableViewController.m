//
//  ImageSizeTableViewController.m
//  QuickDropShot
//
//  Created by 水野 真史 on 12/02/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageSizeTableViewController.h"
#import "SettingViewController.h"


@implementation ImageSizeTableViewController

@synthesize stableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);   
    self.stableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    stableView.delegate = self;
    stableView.dataSource = self;
    
    [self.view addSubview:stableView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *footString = @"";
    return footString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"低画質(JPG圧縮3)";
            break;
        case 1:
            cell.textLabel.text = @"中画質(JPG圧縮5)";
            break;
        case 2:
            cell.textLabel.text = @"やや高画質(JPG圧縮7)";
            break;
        case 3:
            cell.textLabel.text = @"高画質(JPG圧縮10)";
            break;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.row == [userDefault integerForKey:@"imageQuality"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:indexPath.row forKey:@"imageQuality"];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
    
}

@end
