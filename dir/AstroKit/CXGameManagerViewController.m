//
//  CXGameManagerViewController.m
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXGameManagerViewController.h"

@interface CXGameManagerViewController ()

@end

@implementation CXGameManagerViewController

#pragma mark CXGameManagerViewController Default Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Text
    NSString *returnButtonText = [NSString stringWithFormat:NSLocalizedString(@"Return", nil)];
    [self.returnButton.titleLabel setText:returnButtonText];
    
    // Register CXManagerTableViewCell & Manager UITableView
    [self.tableView registerClass:[CXManagerTableViewCell class] forCellReuseIdentifier:@"CXCell"];
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    // Special Configuration for Header Text
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor darkGrayColor]];
    
    // Fix BackgroundColor Issue (iOS 9)
    [self.tableView setBackgroundColor:[UIColor clearColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark CXGameManagerViewController UIButton Action Methods

-(void)returnToScene:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideOptions" object:nil];
    id<CXManagerToSceneProtocol>delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(userAborted)])
    {
        [delegate userAborted];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)returnToHome:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideOptions" object:nil];
    id<CXManagerToSceneProtocol>delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(userAborted)])
    {
        [delegate userAborted];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark CXGameManagerViewController UITableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.inGameObjects count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerString = [NSString stringWithFormat:NSLocalizedString(@"Objects In Scene", nil)];
    
    return headerString;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CXManagerTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CXCell" forIndexPath:indexPath];
    [cell setDelegate:self];
    
    CXStellarSprite *stellarSprite = [self.inGameObjects objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:stellarSprite.imageName];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(stellarSprite.objectName, nil)];
    NSString *mass = [NSString stringWithFormat:NSLocalizedString(@"Mass", nil)];
    NSArray *massTextArray = @[mass, [NSString stringWithFormat:@"%.0f",stellarSprite.mass]];
    NSString *massTextString = [massTextArray componentsJoinedByString:@": "];
    
    [cell.scrollViewImageView setImage:image];
    [cell.scrollViewTitleLabel setText:title];
    [cell.scrollViewMassLabel setText:massTextString];
    return cell;
}

#pragma mark CXGameManagerViewController UIScrollView Delegate Handling
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideOptions" object:scrollView];
}

#pragma mark CXGameManagerViewController Protocol Handling
-(void)cellDidTouchRepositionButton:(CXManagerTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id<CXManagerToSceneProtocol> delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(setRepositionForObjectAtIndex:)])
    {
        [delegate setRepositionForObjectAtIndex:indexPath.row];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cellDidTouchRemoveButton:(CXManagerTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id<CXManagerToSceneProtocol> delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(removeSceneObjectAtIndex:)])
    {
        [delegate removeSceneObjectAtIndex:indexPath.row];
    }

    [self.inGameObjects removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark CXGameManagerViewController Designated Initializer
-(instancetype)init
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"CXGameManagerViewController" bundle:appBundle];
    return self;
}

@end
