//
//  CXSubMenuViewController.m
//  AstroKit
//
//  Created by Owatch on 5/25/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXSubMenuViewController.h"

@interface CXSubMenuViewController ()

@end

@implementation CXSubMenuViewController

#pragma mark CXSubMenuViewController Default Methods
-(void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Load Information Display VC
    [self setExhibitViewController:[[CXExhibitViewController alloc]init]];
    
    // Set Text
    NSString *returnButtonText = [[NSString alloc]initWithFormat:NSLocalizedString(@"Return", nil)];
    [self.returnButton.titleLabel setText:returnButtonText];
    
    // Register UICollectionViewCell
    [self.collectionView registerNib:[UINib nibWithNibName:@"CXSubMenuCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CXCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.collectionView reloadData];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark CXSubMenuViewController UIButton Action Methods

-(void)returnToPrevious:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark CXSubMenuViewController UICollectionView Methods

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 16, 2, 16);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.objectArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CXSubMenuCollectionViewCell *cell = (CXSubMenuCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CXCell" forIndexPath:indexPath];
    // Configure ImageView
    [cell.image.layer setCornerRadius:30];
    [cell.image.layer setMasksToBounds:YES];
    
    // Populate Properties
    CXStellarObject *object = [self.objectArray objectAtIndex:indexPath.row];
    
    NSString *imageName = [object imageName];
    NSString *thumbNailImageName = [imageName stringByAppendingString:@"_Thumb.png"];
    UIImage *image = [UIImage imageNamed:thumbNailImageName];
    
    [cell.image setImage:image];
    
    NSString *text = [object name];
    [cell.label setText:text];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.exhibitViewController)
    {
        [self setExhibitViewController:[[CXExhibitViewController alloc]init]];
    }
    [self.exhibitViewController setObject:[self.objectArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:self.exhibitViewController animated:YES];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark CXSubMenuViewController Designated Initializer

-(instancetype)init
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"CXSubMenuViewController" bundle:appBundle];
    return self;
}





@end
