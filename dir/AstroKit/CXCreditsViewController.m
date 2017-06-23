//
//  CXCreditsViewController.m
//  AstroKit
//
//  Created by Owatch on 5/25/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXCreditsViewController.h"

@implementation CXCreditsViewController

#pragma mark CXCreditsViewController Default Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Text
    NSString *returnButtonText = [NSString stringWithFormat:NSLocalizedString(@"Return", nil)];
    [self.returnButton.titleLabel setText:returnButtonText];
    
    // Register UITableViewCell
    [self.tableView registerNib:[UINib nibWithNibName:@"CXCreditsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CXCell"];
    
    // Setup Arrays/Data
    [self setSectionHeaders:@[@"Testing",@"Resources"]];
    [self setContributors:@[@"Matt Curtis",@"Pratiksha Bhisikar",@"Duncan Champney",@"Hippalectryon",@"Enrico Susatyo",@"Kayla Randolph",@"Destiny Faith",@"Maximilian Litteral",@"Farhad Saadetpei"]];
    [self setOthers:@[@"NASA ( Images & Data )", @"ESA ( Images & Data )"]];
    [self setSectionArrays:@[_contributors, _others]];
    
    // Set UIImage
    UIImage *appIcon = [UIImage imageNamed:@"AppIcon60x60.png"];
    [self.imageView.layer setCornerRadius:_imageView.frame.size.height/2];
    [self.imageView setImage:appIcon];
    
    // Fix UITableView (iOS 9 Bug)
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark CXCreditsViewController UIButton Action Methods

-(void)returnToMainMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark CXCreditsViewController UITableView Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionHeaders count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionArrays[section]count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 20)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [label setTextColor:[UIColor colorWithRed:0.235 green:0.235 blue:0.235 alpha:1.0]];
    NSString *string =[self.sectionHeaders objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CXCreditsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CXCell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *properArray = self.sectionArrays[indexPath.section];
    NSString *content = properArray[indexPath.row];
    
    [cell.contentLabel setText:content];
    
    return cell;
}

#pragma mark CXCreditsViewController Designated Initializer

-(instancetype)init
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"CXCreditsViewController" bundle:appBundle];
    return self;
}



@end
