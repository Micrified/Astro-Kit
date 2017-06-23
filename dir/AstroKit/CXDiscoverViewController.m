//
//  CXDiscoverViewController.m
//  AstroKit
//
//  Created by Owatch on 5/25/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXDiscoverViewController.h"

@interface CXDiscoverViewController ()
@property (nonatomic,strong)NSArray *supportedLanguages;
@end

@implementation CXDiscoverViewController

#pragma mark CXDiscoverViewController Default Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Set Data Arrays
    [self setOptionsArray:@[@"Stars",@"Planets",@"Moons"]];
    [self setSupportedLanguages:@[@"en",@"fr",@"de",@"nl"]];
    
    // Set Texts
    NSString *returnButtonText = [NSString stringWithFormat:NSLocalizedString(@"Return", nil)];
    [self.returnButton.titleLabel setText:returnButtonText];
    
    // Register UICollectionViewCell Subclass
    [self.collectionView registerNib:[UINib nibWithNibName:@"CXDiscoverCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CXCell"];
    
    // Load Data
    if (!_starsArray || !_planetsArray || !_moonsArray)
    {
        [self loadData];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!_starsArray || !_planetsArray || !_moonsArray)
    {
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Clear Arrays
    [self setStarsArray:nil];
    [self setPlanetsArray:nil];
    [self setMoonsArray:nil];
    // Clear SubMenuViewController
    [self.subMenuViewController setObjectArray:nil];
    [self setSubMenuViewController:nil];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark CXDiscoverViewController UIButton Action Methods
-(void)returnToMainMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark CXDiscoverViewController UICollectionView Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.optionsArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CXDiscoverCollectionViewCell *cell = (CXDiscoverCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CXCell" forIndexPath:indexPath];
    NSString *text = [self.optionsArray objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:text];
    NSString *localizedText = [NSString stringWithFormat:NSLocalizedString(text, nil)];
    [cell.label setText:localizedText];
    [cell.image setImage:image];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.row;
    NSString *option = [self.optionsArray objectAtIndex:index];

    if (!self.subMenuViewController)
    {
        [self setSubMenuViewController:[[CXSubMenuViewController alloc]init]];
    }
    if ([option isEqualToString:@"Stars"])
    {
        [self.subMenuViewController setObjectArray:self.starsArray];
    } else if ([option isEqualToString:@"Planets"])
    {
        [self.subMenuViewController setObjectArray:self.planetsArray];
    } else if ([option isEqualToString:@"Moons"])
    {
        [self.subMenuViewController setObjectArray:self.moonsArray];
    }
    
    [self.navigationController pushViewController:self.subMenuViewController animated:YES];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark CXDiscoverViewController: Obsolete Language-check Method

-(NSString *)getAppropriateLanguage
{
    BOOL approved = NO;
    NSArray *supportedLanguages = self.supportedLanguages;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    for (NSString *lang in supportedLanguages)
    {
        if ([language isEqualToString:lang])
        {
            approved = YES;
        }
    }
    if (approved)
    {
        return language;
    } else {
        return @"en";
    }
}


#pragma mark CXDiscoverViewController Loading Data

-(void)loadData
{
    // Create Mutable Object Array
    NSMutableArray *allStellarObjects = [[NSMutableArray alloc]init];
    // Create Data Paths
    NSString *planetDataPath = [[NSBundle mainBundle]pathForResource:@"CXPlanets" ofType:@"plist"];
    NSString *starDataPath = [[NSBundle mainBundle]pathForResource:@"CXStars" ofType:@"plist"];
    NSString *moonDataPath = [[NSBundle mainBundle]pathForResource:@"CXMoons" ofType:@"plist"];
    
    // Create Arrays
    NSArray *planetsDictArray = [NSArray arrayWithContentsOfFile:planetDataPath];
    NSArray *starsDictArray = [NSArray arrayWithContentsOfFile:starDataPath];
    NSArray *moonsDictArray = [NSArray arrayWithContentsOfFile:moonDataPath];
    NSArray *allDictionaries = @[planetsDictArray,starsDictArray,moonsDictArray];
    
    for (NSArray *array in allDictionaries)
    {
        for (NSDictionary *dictionary in array)
        {
            CXStellarObject *object = [[CXStellarObject alloc]init];
            [object setType:[dictionary valueForKey:@"Type"]];
            [object setName:[dictionary valueForKey:@"Name"]];
            [object setImageName:[dictionary valueForKey:@"ImageName"]];
            [object setDescriptor:[dictionary valueForKey:@"Descriptor"]];
            [allStellarObjects addObject:object];
        }
    }
    
    // Set Properties
    NSPredicate *starPredicate = [NSPredicate predicateWithFormat:@"SELF.type == 'star'"];
    [self setStarsArray:[allStellarObjects filteredArrayUsingPredicate:starPredicate]];
    
    NSPredicate *planetPredicate = [NSPredicate predicateWithFormat:@"SELF.type == 'planet'"];
    [self setPlanetsArray:[allStellarObjects filteredArrayUsingPredicate:planetPredicate]];
    
    NSPredicate *moonPredicate = [NSPredicate predicateWithFormat:@"SELF.type == 'moon'"];
    [self setMoonsArray:[allStellarObjects filteredArrayUsingPredicate:moonPredicate]];
}


#pragma mark CXDiscoverViewController Designated Initializer

-(instancetype)init
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"CXDiscoverViewController" bundle:appBundle];
    return self;
}


@end
