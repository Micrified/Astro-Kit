//
//  CXCreditsViewController.h
//  AstroKit
//
//  Created by Owatch on 5/25/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXCreditsTableViewCell.h"

@interface CXCreditsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

#pragma mark CXCreditsViewController UIButton Properties
@property (nonatomic,weak)IBOutlet UIButton *returnButton;

#pragma mark CXCreditsViewController UIImage Properties
@property (nonatomic,weak)IBOutlet UIImageView *imageView;

#pragma mark CXCreditsViewController UILabel Properties
@property (nonatomic,weak)IBOutlet UILabel *header;

#pragma mark CXCreditsViewController UITableView Properties
@property (nonatomic,weak)IBOutlet UITableView *tableView;

#pragma mark CXCreditsViewController NSArray Properties
@property (nonatomic,strong)NSArray *sectionHeaders;
@property (nonatomic,strong)NSArray *sectionArrays;

@property (nonatomic,strong)NSArray *contributors;
@property (nonatomic,strong)NSArray *others;


#pragma mark CXCreditViewController UIButton Action Methods
-(IBAction)returnToMainMenu:(id)sender;

@end
