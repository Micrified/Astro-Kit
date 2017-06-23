//
//  CXSettingsViewController.h
//  AstroKit
//
//  Created by Owatch on 5/25/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXSettingsCollectionViewCell.h"

@interface CXSettingsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

#pragma mark CXSettingsViewController UIButton Properties
@property (nonatomic,weak)IBOutlet UIButton *returnButton;

#pragma mark CXSettingsViewController UILabel Properties
@property (nonatomic,weak)IBOutlet UILabel *showStarFieldLabel;
@property (nonatomic,weak)IBOutlet UILabel *objectsDestroyLabel;
@property (nonatomic,weak)IBOutlet UILabel *setSceneLimitObjectsLabel;
@property (nonatomic,weak)IBOutlet UILabel *objectNumber;
@property (nonatomic,weak)IBOutlet UILabel *sandboxBackgroundColorLabel;
@property (nonatomic,weak)IBOutlet UILabel *replayTutorialNumber;
@property (nonatomic,weak)IBOutlet UILabel *gameSettingsLabel;
@property (nonatomic,weak)IBOutlet UILabel *experienceSettingsLabel;

#pragma mark CXSettingsViewController UISwitch Properties
@property (nonatomic,weak)IBOutlet UISwitch *showStarFieldSwitch;
@property (nonatomic,weak)IBOutlet UISwitch *objectsDestroySwitch;
@property (nonatomic,weak)IBOutlet UISwitch *replayTutorialSwitch;

#pragma mark CXSettingsViewController UISlider Properties
@property (nonatomic,weak)IBOutlet UISlider *objectNumberSlider;

#pragma mark CXSettingsViewController UIView Properties
@property (nonatomic,weak)IBOutlet UIView *colorView;

#pragma mark CXSettingsViewController UICollectionView Properties
@property (nonatomic,weak)IBOutlet UICollectionView *colorCollectionView;

#pragma mark CXSettingsViewController NSArray Properties
@property (nonatomic,strong) NSArray *colorOptions;

#pragma mark CXSettingsViewController UISwitch Methods & Other Methods
-(IBAction)switchChanged:(id)sender;
-(IBAction)showTutorialSwitchChanged:(id)sender;
-(IBAction)showStarFieldSwitchChanged:(id)sender;
-(IBAction)sliderChanged:(id)sender;
-(IBAction)returnToMainMenu:(id)sender;

@end
