//
//  CXTutorialChildViewController.m
//  AstroKit
//
//  Created by Owatch on 6/5/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXTutorialChildViewController.h"

@interface CXTutorialChildViewController ()

@end

@implementation CXTutorialChildViewController

#pragma mark CXTutorialChildViewController Default Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Text
    NSString *panelText = [NSString stringWithFormat:NSLocalizedString(@"You are currently viewing Panel", nil)];
    NSArray *textComponenets = @[panelText,[NSString stringWithFormat:@"%lu",(unsigned long)self.index]];
    NSString *labelString = [textComponenets componentsJoinedByString:@": "];
    [self.descriptionLabel setText:labelString];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark CXTutorialChildViewController UIButton Action Methods
-(void)didPressButton:(id)sender
{
    if (self.index == 2)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark CXTutorialChildViewController Designated Initializer
-(instancetype)init
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"CXTutorialChildViewController" bundle:appBundle];
    return self;
}

@end
