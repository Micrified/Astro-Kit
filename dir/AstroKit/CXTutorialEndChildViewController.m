//
//  CXTutorialEndChildViewController.m
//  AstroKit
//
//  Created by Owatch on 6/5/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXTutorialEndChildViewController.h"

@interface CXTutorialEndChildViewController ()

@end

@implementation CXTutorialEndChildViewController

#pragma mark CXTutorialEndChildViewController Default Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Label Text
    NSString *labelText = [NSString stringWithFormat:NSLocalizedString(@"That's it! ;D", nil)];
    [self.label setText:labelText];
    
    // Create & Set Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    CGSize screensize = [UIScreen mainScreen].bounds.size;
    [button setFrame:CGRectMake((screensize.width/2 - 50), (screensize.height/2)-50, 100, 100)];
    [button setClipsToBounds:YES];
    [button.layer setCornerRadius:100/2.0f];
    [button.layer setBorderColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0].CGColor];
    [button.layer setBorderWidth:2.0f];
    [self setButton:button];
    
    
    
    NSString *buttonText = [NSString stringWithFormat:NSLocalizedString(@"Finish", nil)];
    [self.button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
    [self.button setTitle:buttonText forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    
    // Load GameViewController in background
    [self performSelectorInBackground:@selector(loadGameViewController) withObject:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark CXTutorialEndChildViewController Custom Methods
-(void)loadGameViewController
{
    CXGameViewController *gameViewController = [[CXGameViewController alloc]init];
    [self setGameViewController:gameViewController];
}

#pragma mark CXTutorialEndChildViewController UIButton Action Methods
-(void)buttonPressed:(id)sender
{
    // Set NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"n" forKey:@"ShouldReplayTutorial"];
    
    CXMenuViewController *menuViewController = (CXMenuViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    if ([menuViewController respondsToSelector:@selector(setGameViewController:)])
    {
        CXGameViewController *gameViewController = self.gameViewController;
        if (!menuViewController.gameViewController)
        {
            [menuViewController setGameViewController:gameViewController];
            [self.navigationController pushViewController:gameViewController animated:YES];
            [self setGameViewController:nil];
        } else {
            [self.navigationController pushViewController:menuViewController.gameViewController animated:YES];
        }
    }
}

#pragma mark CXTutorialEndChildViewController Designated Initializers
-(instancetype)init
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"CXTutorialEndChildViewController" bundle:appBundle];
    return self;
}


@end
