//
//  CXTutorialPageViewController.m
//  AstroKit
//
//  Created by Owatch on 6/5/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXTutorialPageViewController.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface CXTutorialPageViewController ()

@end

@implementation CXTutorialPageViewController

#pragma mark CXTutorialPageViewController Default Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create Colors
    UIColor *panelBackgroundA = Rgb2UIColor(44, 62, 80);
    UIColor *panelBackgroundB = Rgb2UIColor(231, 76, 60);
    UIColor *panelBackgroundC = Rgb2UIColor(52, 152, 219);
    UIColor *panelBackgroundD = Rgb2UIColor(78, 122, 199);
    UIColor *panelBackgroundE = Rgb2UIColor(234, 46, 73);
    UIColor *panelBackgroundF = Rgb2UIColor(0, 163, 136);
    UIColor *panelBackgroundG = Rgb2UIColor(55, 93, 129);
    UIColor *panelBackgroundH = Rgb2UIColor(40, 40, 40);
    
    [self setColors:@[panelBackgroundA,panelBackgroundB,panelBackgroundC,panelBackgroundD,panelBackgroundE,panelBackgroundF,panelBackgroundG,panelBackgroundH]];
    
    // Create Images
    UIImage *imageA = [UIImage imageNamed:@"TPanelA.png"];
    UIImage *imageB = [UIImage imageNamed:@"TPanelB.png"];
    UIImage *imageC = [UIImage imageNamed:@"TPanelC.png"];
    UIImage *imageD = [UIImage imageNamed:@"TPanelD.png"];
    UIImage *imageE = [UIImage imageNamed:@"TPanelE.png"];
    UIImage *imageF = [UIImage imageNamed:@"TPanelF.png"];
    UIImage *imageG = [UIImage imageNamed:@"TPanelG.png"];
                                 
    NSArray *images = @[imageA,imageB,imageC,imageD,imageE,imageF,imageG];
    [self setPanelImages:images];
    
    // Create Panel Descriptions
    NSString *panelADescription = [NSString stringWithFormat:NSLocalizedString(@"Hold Objects to Move Them", nil)];
    NSString *panelBDescription = [NSString stringWithFormat:NSLocalizedString(@"Tap Objects to Show Information", nil)];
    NSString *panelCDescription = [NSString stringWithFormat:NSLocalizedString(@"Tap Button To Toggle Simulation Rate", nil)];
    NSString *panelDDescription = [NSString stringWithFormat:NSLocalizedString(@"This Label Indicates Remaining Objects",nil)];
    NSString *panelEDescription = [NSString stringWithFormat:NSLocalizedString(@"Tap Button to Add Objects", nil)];
    NSString *panelFDescription = [NSString stringWithFormat:NSLocalizedString(@"Tap Button to Set Orbits", nil)];
    NSString *panelGDescription = [NSString stringWithFormat:NSLocalizedString(@"Tap Button to Manage Objects", nil)];
    
    [self setPanelDescriptions:@[panelADescription,panelBDescription,panelCDescription,panelDDescription,panelEDescription,panelFDescription,panelGDescription]];
    
    // Setup UIPageViewController
    UIPageViewController *pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [pageViewController setDataSource:self];
    [pageViewController.view setFrame:[self.view bounds]];
    [self setPageViewController:pageViewController];
    
    CXTutorialChildViewController *childViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:childViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [[self view] addSubview:[self.pageViewController view]];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark CXTutorialPageViewController Custom Methods
-(CXTutorialChildViewController *)viewControllerAtIndex:(NSUInteger)index
{
    
    CXTutorialChildViewController *viewController = [[CXTutorialChildViewController alloc]init];
    UIColor *panelColor = [self.colors objectAtIndex:index];
    [viewController.view setBackgroundColor:panelColor];
    [viewController setIndex:index];
    [viewController.imageView setImage:[self.panelImages objectAtIndex:index]];
    [viewController.descriptionLabel setText:[self.panelDescriptions objectAtIndex:index]];
    return viewController;
}

#pragma mark CXTutorialPageViewController UIPageViewController Delegate Methods
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(CXTutorialChildViewController *)viewController index];
    if (index == 0)
    {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(CXTutorialChildViewController *)viewController index];
    index++;
    if (index == 8)
    {
        return nil;
    } else if (index == 7)
    {
        CXTutorialEndChildViewController *viewController = [[CXTutorialEndChildViewController alloc]init];
        
        [viewController.view setBackgroundColor:[self.colors objectAtIndex:index]];
        [viewController setIndex:index];
        return viewController;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 8;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
