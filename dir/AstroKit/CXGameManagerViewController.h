//
//  CXGameManagerViewController.h
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXManagerTableViewCell.h"
#import "CXManagerCellProtocol.h"
#import "CXGameCatalogueViewController.h"
#import "CXManagerToSceneProtocol.h"
#import "CXGameViewController.h"
#import "CXStellarSprite.h"

@class CXGameCatalogueViewController;

@interface CXGameManagerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIToolbarDelegate, CXManagerCellProtocol>

#pragma mark CXGameManagerViewController NSArray Properties
@property (nonatomic,strong)NSMutableArray *inGameObjects;

#pragma mark CXGameManagerViewController UIButton Properties
@property (nonatomic,weak)IBOutlet UIButton *returnButton;
@property (nonatomic,weak)IBOutlet UIButton *homeButton;

#pragma mark CXGameManagerViewController UITableView Properties
@property (nonatomic,weak)IBOutlet UITableView *tableView;

#pragma mark CXGameManagerViewController Protocol Delegate Methods
@property (nonatomic,weak)id<CXManagerToSceneProtocol>myDelegate;

#pragma mark CXGameManagerViewController UIButton Action Methods
-(IBAction)returnToScene:(id)sender;
-(IBAction)returnToHome:(id)sender;

@end
