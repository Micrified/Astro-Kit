//
//  CXGameCatalogueViewController.m
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXGameCatalogueViewController.h"

@interface CXGameCatalogueViewController ()

@end

@implementation CXGameCatalogueViewController

#pragma mark CXGameCatalogueViewController Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    // Register CXCatalogueTableViewCell
    [self.tableView registerClass:[CXCatalogueTableViewCell class] forCellReuseIdentifier:@"CXCell"];
    
    // Set Text
    NSString *returnButtonString = [NSString stringWithFormat:NSLocalizedString(@"Return", nil)];
    [self.returnButton.titleLabel setText:returnButtonString];
    
    // Special Configuration for Header Text
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor darkGrayColor]];
    
    // Fix BackgroundColor Issue (iOS 9)
    [self.tableView setBackgroundColor:[UIColor clearColor]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    if (index)
    {
        [self.tableView deselectRowAtIndexPath:index animated:NO];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark CXGameCatalogueViewController UIButton Action Methods
-(void)returnToScene:(id)sender
{
    id<CXCatalogueToSceneProtocol>delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(userAborted)])
    {
        [delegate userAborted];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideOptions" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark CXGameCatalogueViewController UITableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.stellarContent count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.stellarContent objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerString;
    if (section == 0)
    {
        headerString = [NSString stringWithFormat:NSLocalizedString(@"Planets & Moons", nil)];
    } else {
        headerString = [NSString stringWithFormat:NSLocalizedString(@"Systems", nil)];
    }
    
    return headerString;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CXCatalogueTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CXCell" forIndexPath:indexPath];
    [cell setDelegate:self];
    
    if (indexPath.section == 0)
    {
        CXStellarObjectDescriptor *stellarObject = [[self.stellarContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        UIImage *image = [UIImage imageNamed:stellarObject.imageName];
        // Obtain Localized Text
        NSString *title = [NSString stringWithFormat:NSLocalizedString(stellarObject.name, nil)];
        NSString *mass = [NSString stringWithFormat:NSLocalizedString(@"Mass", nil)];
        NSString *scale = [NSString stringWithFormat:NSLocalizedString(@"Scale", nil)];
        // Create Localized Text Arrays
        NSArray *massStringArray  = @[mass,[NSString stringWithFormat:@"%.0f u",stellarObject.mass]];
        NSArray *scaleStringArray = @[scale,[NSString stringWithFormat:@"%.02f",stellarObject.scale]];
        // Compile Localized Text Strings
        NSString *massTextString = [massStringArray componentsJoinedByString:@": "];
        NSString *scaleTextString = [scaleStringArray componentsJoinedByString:@": "];
        
        [cell.scrollViewTitleLabel setText:title];
        [cell.scrollViewImageView setImage:image];
        [cell.scrollViewMassLabel setText:massTextString];
        [cell.scrollViewScaleLabel setText:scaleTextString];
        
        // Adjust Font Size
        [cell.scrollViewTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
        [cell.scrollViewMassLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        [cell.scrollViewScaleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        
    } else {
        
        CXStellarSystemDescriptor *system = [[self.stellarContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        // Create Generic Image
        UIImage *image = [UIImage imageNamed:@"System"];
        // Obtain Title of System
        NSString *title = [NSString stringWithFormat:NSLocalizedString(system.name, nil)];
        // Obtain Parent Planet Name:
        NSString *parentPlanetName = system.parent.name;
        // Obtain Satellite Parent Names:
        NSMutableArray *names = [[NSMutableArray alloc]init];
        for (CXStellarObjectDescriptor *d in system.satellites)
        {
            [names addObject:d.name];
        }
        NSString *satelliteNames = [names componentsJoinedByString:@", "];
        
        // Set Properties
        [cell.scrollViewTitleLabel setText:title];
        [cell.scrollViewImageView setImage:image];
        [cell.scrollViewMassLabel setText:[NSString stringWithFormat:@"Parent: %@",parentPlanetName]];
        [cell.scrollViewScaleLabel setText:[NSString stringWithFormat:@"Satellites: %@",satelliteNames]];
        
        // Adjust Font Size
        [cell.scrollViewMassLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [cell.scrollViewScaleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideOptions" object:nil];
    if (indexPath.section == 0)
    {
        CXStellarObjectDescriptor *stellarDescriptor = [[self.stellarContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.myDelegate addStellarSpriteWith:stellarDescriptor];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        CXStellarSystemDescriptor *systemDescriptor = [[self.stellarContent objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        [self.myDelegate addStellarSystemWith:systemDescriptor];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)returnToGame:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideOptions" object:nil];
    id<CXCatalogueToSceneProtocol>delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(userAborted)])
    {
        [delegate userAborted];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadGameMenuManager:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideOptions" object:nil];
    [self.navigationController pushViewController:self.gameManagerViewController animated:NO];
}

#pragma mark CXGameCatalogueViewController UIScrollView Delegate Handling

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideOptions" object:scrollView];
}

#pragma mark CXGameCatalogueViewController Protocol Handling

-(void)cellDidTouchEditButton:(CXCatalogueTableViewCell *)cell
{
    // Removed
}

#pragma mark CXGameCatalogueViewController Designated Initializer

-(instancetype)init
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"CXGameCatalogueViewController" bundle:appBundle];
    return self;
}


@end
