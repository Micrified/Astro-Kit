//
//  CXTutorialEndChildViewController.h
//  AstroKit
//
//  Created by Owatch on 6/5/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXGameViewController.h"
#import "CXMenuViewController.h"

@class CXMenuViewController;

@interface CXTutorialEndChildViewController : UIViewController

#pragma mark CXTutorialEndChildViewController NSUInteger Properties
@property (nonatomic)NSUInteger index;

#pragma mark CXTutorialEndChildViewController UILabel Properties
@property (nonatomic,weak)IBOutlet UILabel *label;

#pragma mark CXTutorialEndChildViewController UIButton Properties
@property (nonatomic)UIButton *button;

#pragma mark CXTutorialEndChildViewController UIViewController Property
@property (nonatomic,strong)CXGameViewController *gameViewController;

#pragma mark CXTutorialEndChildViewController UIButton Action Methods
-(void)buttonPressed:(id)sender;

@end
