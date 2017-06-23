//
//  CXSubMenuViewController.h
//  AstroKit
//
//  Created by Owatch on 5/25/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXStellarObject.h"
#import "CXSubMenuCollectionViewCell.h"
#import "CXExhibitViewController.h"

@interface CXSubMenuViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

#pragma mark CXSubMenuViewController UIViewController Propeties
@property (nonatomic,strong)CXExhibitViewController *exhibitViewController;

#pragma mark CXSubMenuViewController NSArray Properties
@property (nonatomic,strong)NSArray *objectArray;

#pragma mark CXSubMenuViewController UIButton Properties
@property (nonatomic,weak)IBOutlet UIButton *returnButton;

#pragma mark CXSubMenuViewController UICollectionView Properties
@property (nonatomic,weak)IBOutlet UICollectionView *collectionView;

#pragma mark CXSubMenuViewController UIButton Action Methods
-(IBAction)returnToPrevious:(id)sender;

@end
