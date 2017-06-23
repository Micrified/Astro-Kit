//
//  CXDiscoverViewController.h
//  AstroKit
//
//  Created by Owatch on 5/25/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXDiscoverCollectionViewCell.h"
#import <CoreData/CoreData.h>
#import "CXStellarObject.h"
#import "CXSubMenuViewController.h"

@interface CXDiscoverViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

#pragma mark CXDiscoverViewController UIViewController Properties
@property (nonatomic,strong) CXSubMenuViewController *subMenuViewController;

#pragma mark CXDiscoverViewController UIButton Properties
@property (nonatomic,weak)IBOutlet UIButton *returnButton;

#pragma mark CXDiscoverViewController UICollectionView Properties
@property (nonatomic,weak)IBOutlet UICollectionView *collectionView;

#pragma mark CXDiscoverViewController NSArray & NSDictionary Properties
@property (nonatomic,strong) NSArray *optionsArray;
@property (nonatomic,strong) NSArray *starsArray;
@property (nonatomic,strong) NSArray *planetsArray;
@property (nonatomic,strong) NSArray *moonsArray;
@property (nonatomic,strong) NSMutableDictionary *supportedLanguageAssets;

#pragma mark CXDiscoverViewController UIButton Action Methods
-(IBAction)returnToMainMenu:(id)sender;

@end
