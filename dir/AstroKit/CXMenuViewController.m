//
//  CXMenuViewController.m
//  AstroKit
//
//  Created by Owatch on 5/25/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXMenuViewController.h"

@interface CXMenuViewController ()

@end

@implementation CXMenuViewController


#pragma mark CXMenuViewController: Default Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Set CXMenuViewController UITableView Arrays
    NSArray *tableOptions = @[@"Sandbox",@"Discover",@"Settings",@"Credits"];
    [self setTableOptions:tableOptions];
    
    // Register Custom UITableViewCell
    [self.tableView registerNib:[UINib nibWithNibName:@"CXMenuTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CXCell"];
    
    // Fix BackgroundColor Issue (iOS 9)
    [self.tableView setBackgroundColor:[UIColor clearColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    // If first time start: Set User Defaults.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults valueForKey:@"ShouldDestroyObjectsOnImpact"])
    {
        [self setDefaults];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark CXMenuViewController: Set Defaults Method;

-(void)setDefaults
{
    NSLog(@"Setting Defaults");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"y" forKey:@"ShouldShowStarField"];
    [defaults setValue:@"y" forKey:@"ShouldDestroyObjectsOnImpact"];
    [defaults setValue:@"y" forKey:@"ShouldReplayTutorial"];
    [defaults setInteger:5 forKey:@"SceneObjectLimit"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.133 green:0.274 blue:0.439 alpha:1.0]] forKey:@"SceneBackgroundColor"];
    [defaults synchronize];
}

#pragma mark CXMenuViewController: IBAction Methods & Standard Methods

-(void)showCredits
{
    if (!self.creditsViewController)
    {
        [self setCreditsViewController:[[CXCreditsViewController alloc]init]];
    }
    [self.navigationController pushViewController:self.creditsViewController animated:YES];
}

-(void)showSettings
{
    if (!self.settingsViewController)
    {
        [self setSettingsViewController:[[CXSettingsViewController alloc]init]];
    }
    [self.navigationController pushViewController:self.settingsViewController animated:YES];
}

-(void)showPlay
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *showTutorial = [defaults valueForKey:@"ShouldReplayTutorial"];
    
    if ([showTutorial isEqualToString:@"y"])
    {
        CXTutorialPageViewController *tutorialViewController = [[CXTutorialPageViewController alloc]init];
        [self setTutorialViewController:tutorialViewController];
        [self.navigationController pushViewController:tutorialViewController animated:YES];
    } else {
        
        if (!self.gameViewController)
        {
            [self setGameViewController:[[CXGameViewController alloc]init]];
        }
        [self.navigationController pushViewController:self.gameViewController animated:YES];
    }
    
}

-(void)showDiscover
{
    if (!self.discoverViewController)
    {
        [self setDiscoverViewController:[[CXDiscoverViewController alloc]init]];
    }
    [self.navigationController pushViewController:self.discoverViewController animated:YES];
}

#pragma mark CXMenuViewController: UITableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableOptions count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CXMenuTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CXCell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];

    NSString *option = [self.tableOptions objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:option];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(option, nil)];
    [cell.title setText:title];
    [cell.image setImage:image];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.row;
    if (index == 0)
    {
        [self showPlay];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (index == 1)
    {
        [self showDiscover];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (index == 2)
    {
        [self showSettings];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (index == 3)
    {
        [self showCredits];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // To "clear" the footer view
    return [[UIView alloc]init];
}

#pragma mark CXMenuViewController: Designated Initializer

-(instancetype)init
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"CXMenuViewController" bundle:appBundle];
    return self;
}



@end
