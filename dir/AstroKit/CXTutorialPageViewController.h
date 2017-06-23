//
//  CXTutorialPageViewController.h
//  AstroKit
//
//  Created by Owatch on 6/5/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXTutorialChildViewController.h"
#import "CXTutorialEndChildViewController.h"

@interface CXTutorialPageViewController : UIViewController <UIPageViewControllerDataSource>

#pragma mark CXTutorialPageViewController UIPageViewController Properties
@property (nonatomic,strong)UIPageViewController *pageViewController;

#pragma mark CXTutorialPageViewController NSArray Properties
@property (nonatomic,strong)NSArray *colors;
@property (nonatomic,strong)NSArray *panelImages;
@property (nonatomic,strong)NSArray *panelDescriptions;


@end
