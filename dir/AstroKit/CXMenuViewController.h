//
//  CXMenuViewController.h
//  AstroKit
//
//  Created by Owatch on 5/25/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXMenuTableViewCell.h"
#import "CXSettingsViewController.h"
#import "CXCreditsViewController.h"
#import "CXDiscoverViewController.h"
#import "CXGameViewController.h"
#import "CXTutorialPageViewController.h"

@class CXTutorialPageViewController;

@interface CXMenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

#pragma mark Main Menu: UIViewController Properties
@property (nonatomic,strong)CXSettingsViewController *settingsViewController;
@property (nonatomic,strong)CXCreditsViewController *creditsViewController;
@property (nonatomic,strong)CXDiscoverViewController *discoverViewController;
@property (nonatomic,strong)CXGameViewController *gameViewController;
@property (nonatomic,strong)CXTutorialPageViewController *tutorialViewController;

#pragma mark Main Menu: UITableView Properties
@property (nonatomic,weak)IBOutlet UITableView *tableView;

#pragma mark Main Menu: UITableView Data Array
@property (nonatomic,strong) NSArray *tableOptions;

#pragma mark Main Menu: Other Methods
-(void)showPlay;
-(void)showDiscover;
-(void)showSettings;
-(void)showCredits;

@end
