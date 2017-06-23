//
//  CXCatalogueTableViewCell.h
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXCatalogueCellProtocol.h"

@interface CXCatalogueTableViewCell : UITableViewCell <UIScrollViewDelegate>

#pragma mark CXCatalogueTableViewCell Boolean Properties
@property (nonatomic)BOOL isShowingMenu;

#pragma mark CXCatalogueTableViewCell Low Level UIView Properties
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *scrollViewContentView;
@property (nonatomic,strong)UIView *scrollViewButtonView;

#pragma mark CXCatalogueTableViewCell High Level UIView Properties
@property (nonatomic,strong)UIImageView *scrollViewImageView;
@property (nonatomic,strong)UILabel *scrollViewTitleLabel;
@property (nonatomic,strong)UILabel *scrollViewMassLabel;
@property (nonatomic,strong)UILabel *scrollViewScaleLabel;
@property (nonatomic,strong)UIButton *scrollViewEditButton;

#pragma mark CXCatalogueTableViewCell Protocol Delegate Properties
@property (nonatomic,weak)id<CXCatalogueCellProtocol>delegate;

@end
