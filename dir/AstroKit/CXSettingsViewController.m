//
//  CXSettingsViewController.m
//  AstroKit
//
//  Created by Owatch on 5/25/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXSettingsViewController.h"

@interface CXSettingsViewController ()

@end

@implementation CXSettingsViewController

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#pragma mark CXSettingsViewController: Default Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUserDefaultStates];
    
    
    // Setup UICollectionView
    [self.colorCollectionView registerNib:[UINib nibWithNibName:@"CXSettingsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CXCell"];
    
    // Set UIColors
    [self setColorOptions:[self createColorArray]];
    
    // Set Rounded corners for UIView
    [self.colorView.layer setCornerRadius:(_colorView.frame.size.width/2)];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateUserDefaultStates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark CXSettingsViewController: NSUserDefault Property Method
-(void)updateUserDefaultStates
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *showStars = [defaults valueForKey:@"ShouldShowStarField"];
    NSString *switchState = [defaults valueForKey:@"ShouldDestroyObjectsOnImpact"];
    NSString *replayTutorial = [defaults valueForKey:@"ShouldReplayTutorial"];
    
    if ([showStars isEqualToString:@"y"])
    {
        [self.showStarFieldSwitch setOn:YES];
    } else {
        [self.showStarFieldSwitch setOn:NO];
    }
    
    if ([switchState isEqualToString:@"y"])
    {
        [self.objectsDestroySwitch setOn:YES];
    } else {
        [self.objectsDestroySwitch setOn:NO];
    }
    
    if ([replayTutorial isEqualToString:@"y"])
    {
        [self.replayTutorialSwitch setOn:YES];
    } else {
        [self.replayTutorialSwitch setOn:NO];
    }
    
    NSInteger count = [defaults integerForKey:@"SceneObjectLimit"];
    NSString *objectCountString = [NSString stringWithFormat:@"%.0ld",(long)count];
    [self.objectNumber setText:objectCountString];
    [self.objectNumberSlider setValue:count animated:NO];
    
    // Set Color
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SceneBackgroundColor"];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    if (!color){
        [self.colorView setBackgroundColor:Rgb2UIColor(34, 70, 112)];
    }
    [self.colorView setBackgroundColor:color];
    
    // Set Text
    NSString *returnLabelText = [NSString stringWithFormat:NSLocalizedString(@"Return", nil)];
    NSString *objectsDestroyLabelText = [NSString stringWithFormat:NSLocalizedString(@"Collisions Destroy Objects", nil)];
    [self.returnButton.titleLabel setText:returnLabelText];
    [self.objectsDestroyLabel setText:objectsDestroyLabelText];
}

#pragma mark CXSettingsViewController: IBAction Methods 

-(void)switchChanged:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.objectsDestroySwitch.isOn)
    {
        [defaults setValue:@"y" forKey:@"ShouldDestroyObjectsOnImpact"];
        [defaults synchronize];
    } else {
        [defaults setValue:@"n" forKey:@"ShouldDestroyObjectsOnImpact"];
        [defaults synchronize];
    }
}

-(void)showStarFieldSwitchChanged:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.showStarFieldSwitch.isOn)
    {
        [defaults setValue:@"y" forKey:@"ShouldShowStarField"];
        [defaults synchronize];
    } else {
        [defaults setValue:@"n" forKey:@"ShouldShowStarField"];
        [defaults synchronize];
    }
}

-(void)showTutorialSwitchChanged:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.replayTutorialSwitch.isOn)
    {
        [defaults setValue:@"y" forKey:@"ShouldReplayTutorial"];
        [defaults synchronize];
    } else {
        [defaults setValue:@"n" forKey:@"ShouldReplayTutorial"];
        [defaults synchronize];
    }
}

-(void)sliderChanged:(id)sender
{
    float value = roundf(self.objectNumberSlider.value);
    [self.objectNumberSlider setValue:value animated:YES];
    [self.objectNumber setText:[NSString stringWithFormat:@"%.0f",value]];
    NSInteger count = value;
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"SceneObjectLimit"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)returnToMainMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark CXSettingsViewCOntroller Custom Methods
-(NSArray *)createColorArray
{
    return @[Rgb2UIColor(0, 0, 0), Rgb2UIColor(20, 20, 20), Rgb2UIColor(40, 40, 40),Rgb2UIColor(34, 70, 112), Rgb2UIColor(62, 96, 111), Rgb2UIColor(22, 149, 163),Rgb2UIColor(41, 128, 185), Rgb2UIColor(52, 152, 219), Rgb2UIColor(119, 196, 211),Rgb2UIColor(41, 217, 194),Rgb2UIColor(169, 207, 84),Rgb2UIColor(181, 230, 85), Rgb2UIColor(255, 211, 78), Rgb2UIColor(255, 176, 59), Rgb2UIColor(255, 176, 59), Rgb2UIColor(255, 133, 152), Rgb2UIColor(234, 46, 73), Rgb2UIColor(231, 76, 60)];
}

#pragma mark CXSettingsViewController UICollectionView Delegate Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.colorOptions count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CXSettingsCollectionViewCell *cell = (CXSettingsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CXCell" forIndexPath:indexPath];
    [cell.colorItem setBackgroundColor:[self.colorOptions objectAtIndex:indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.colorView setBackgroundColor:[self.colorOptions objectAtIndex:indexPath.row]];
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[self.colorOptions objectAtIndex:indexPath.row]];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"SceneBackgroundColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark CXSettingsViewController: Designated Initializer

-(instancetype)init
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"CXSettingsViewController" bundle:appBundle];
    return self;
}


@end
