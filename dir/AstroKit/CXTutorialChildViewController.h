//
//  CXTutorialChildViewController.h
//  AstroKit
//
//  Created by Owatch on 6/5/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CXTutorialChildViewController : UIViewController

#pragma mark CXTutorialChildViewController NSUInteger Properties
@property (nonatomic)NSUInteger index;

#pragma mark CXTutorialChildViewController UIImageView Properties
@property (nonatomic,weak)IBOutlet UIImageView *imageView;

#pragma mark CXTutorialChildViewController UILabel Properties
@property (nonatomic,weak)IBOutlet UILabel *descriptionLabel;

#pragma mark CXTutorialChildViewController UIButton Action Methods
-(IBAction)didPressButton:(id)sender;

@end
