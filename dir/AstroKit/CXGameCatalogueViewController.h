//
//  CXGameCatalogueViewController.h
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXCatalogueTableViewCell.h"
#import "CXStellarObjectDescriptor.h"
#import "CXGameViewController.h"
#import "CXCatalogueCellProtocol.h"
#import "CXCatalogueToSceneProtocol.h"
#import "CXStellarSystemDescriptor.h"

@class CXGameManagerViewController;

@interface CXGameCatalogueViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIToolbarDelegate, CXCatalogueCellProtocol>

#pragma mark CXGameCatalogueViewController UIViewController Properties
@property (nonatomic,strong)CXGameManagerViewController *gameManagerViewController;

#pragma mark CXGameCatalogueViewController NSArray Properties
@property (nonatomic,strong)NSArray *stellarContent;

#pragma mark CXGameCatalogueViewController UIButton Properties
@property (nonatomic,weak)IBOutlet UIButton *returnButton;

#pragma mark CXGameCatalogueViewController UITableView Properties
@property (nonatomic,weak)IBOutlet UITableView *tableView;

#pragma mark CXGameCatalogueViewController UIButton Action Methods
-(IBAction)returnToScene:(id)sender;

#pragma mark CXGameCatalogueViewController Protocol Delegate
@property (nonatomic,weak)id<CXCatalogueToSceneProtocol>myDelegate;


@end
