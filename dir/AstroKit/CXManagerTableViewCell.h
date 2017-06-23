//
//  CXManagerTableViewCell.h
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXManagerCellProtocol.h"

@interface CXManagerTableViewCell : UITableViewCell <UIScrollViewDelegate>

#pragma mark CXManagerTableViewCell Boolean Properties
@property (nonatomic)BOOL isShowingMenu;

#pragma mark CXManagerTableViewCell Low-Level UIView Properties
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *scrollViewContentView;
@property (nonatomic,strong)UIView *scrollViewButtonView;

#pragma mark CXManagerTableViewCell High-Level UIView Properties
@property (nonatomic,strong)UIImageView *scrollViewImageView;
@property (nonatomic,strong)UILabel *scrollViewTitleLabel;
@property (nonatomic,strong)UILabel *scrollViewMassLabel;
@property (nonatomic,strong)UILabel *scrollViewOnScreenLabel;
@property (nonatomic,strong)UIButton *scrollViewRepositionButton;
@property (nonatomic,strong)UIButton *scrollViewRemoveButton;

#pragma mark CXManagerTableViewCell Protocol Delegate Property
@property (nonatomic,weak)id<CXManagerCellProtocol>delegate;

@end

