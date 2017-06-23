//
//  CXCatalogueTableViewCell.m
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXCatalogueTableViewCell.h"

static int kCatchWidth = 80;

@implementation CXCatalogueTableViewCell

#pragma mark CXCatalogueTableViewCell Default Methods

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark CXCatalogueTableViewCell Non-Default Methods
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.scrollView setContentSize:(CGSize){CGRectGetWidth(self.bounds)+kCatchWidth,CGRectGetHeight(self.bounds)}];
    [self.scrollView setFrame:(CGRect){0,0,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)}];
    [self.scrollViewButtonView setFrame:(CGRect){CGRectGetWidth(self.bounds)-kCatchWidth,0,kCatchWidth, CGRectGetHeight(self.bounds)}];
    [self.scrollViewContentView setFrame:(CGRect){0,0,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)}];
    [self.scrollViewEditButton setFrame:(CGRect){0,0,kCatchWidth,CGRectGetHeight(self.bounds)}];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [self.scrollView setContentOffset:CGPointZero animated:NO];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.scrollView.scrollEnabled = !self.editing;
    self.scrollViewButtonView.hidden = editing;
}

#pragma mark CXCatalogueTableViewCell Custom Methods
-(void)editButtonWasTouched:(id)sender
{
    [self.delegate cellDidTouchEditButton:self];
    
}

-(void)hideButtons:(NSNotification *)notification
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark CXCatalogueTableViewCell UITableView Cell Setup
-(void)setupViews
{
    // Create UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:(CGRect){0,0,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)}];
    [scrollView setContentSize:(CGSize){CGRectGetWidth(self.bounds)+kCatchWidth, CGRectGetHeight(self.bounds)}];
    [scrollView setDelegate:self];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:scrollView];
    [self setScrollView:scrollView];
    
    // Create ScrollViewButtonView
    UIView *scrollViewButtonView = [[UIView alloc]initWithFrame:(CGRect){CGRectGetWidth(self.bounds) - kCatchWidth, 0, kCatchWidth, CGRectGetHeight(self.bounds)}];
    [self setScrollViewButtonView:scrollViewButtonView];
    [self.scrollView addSubview:scrollViewButtonView];
    
    // Create ScrollViewEditButton
    UIButton *scrollViewEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scrollViewEditButton setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0]];
    [scrollViewEditButton setAlpha:0.0f];
    [scrollViewEditButton addTarget:self action:@selector(editButtonWasTouched:) forControlEvents:UIControlEventTouchUpInside];
    [scrollViewEditButton setFrame:(CGRect){0,0,kCatchWidth,CGRectGetHeight(self.bounds)}];
    [scrollViewEditButton setImage:[UIImage imageNamed:@"AddIcon.png"] forState:UIControlStateNormal];
    [scrollViewEditButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [scrollViewButtonView addSubview:scrollViewEditButton];
    [self setScrollViewEditButton:scrollViewEditButton];
    
    // Create ScrollViewContentView
    UIView *scrollViewContentView = [[UIView alloc]initWithFrame:(CGRect){0,0,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)}];
    [scrollView addSubview:scrollViewContentView];
    [scrollViewContentView setBackgroundColor:[UIColor clearColor]];
    [self setScrollViewContentView:scrollViewContentView];
    
    // Create ScrollViewImageView
    UIImageView *scrollViewImageView = [[UIImageView alloc]initWithFrame:(CGRect){10,10,80,80}];
    [scrollViewImageView setContentMode:UIViewContentModeScaleAspectFit];
    [scrollViewContentView addSubview:scrollViewImageView];
    [self setScrollViewImageView:scrollViewImageView];
    
    // Create ScrollViewTitleLabel
    UILabel *scrollViewTitleLabel = [[UILabel alloc]initWithFrame:(CGRect){120,10,120,20}];
    [scrollViewTitleLabel setTextColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0]];
    [scrollViewTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [scrollViewContentView addSubview:scrollViewTitleLabel];
    [self setScrollViewTitleLabel:scrollViewTitleLabel];
    
    // Create ScrollViewMassLabel
    UILabel *scrollViewMassLabel = [[UILabel alloc]initWithFrame:(CGRect){120,35,120,20}];
    [scrollViewMassLabel setTextColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0]];
    [scrollViewMassLabel setTextAlignment:NSTextAlignmentLeft];
    [scrollViewContentView addSubview:scrollViewMassLabel];
    [self setScrollViewMassLabel:scrollViewMassLabel];
    
    // Create ScrollViewScaleLabel
    UILabel *scrollViewScaleLabel = [[UILabel alloc]initWithFrame:(CGRect){120,60,120,20}];
    [scrollViewScaleLabel setTextColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0]];
    [scrollViewScaleLabel setTextAlignment:NSTextAlignmentLeft];
    [scrollViewContentView addSubview:scrollViewScaleLabel];
    [self setScrollViewScaleLabel:scrollViewScaleLabel];
    
    // Create Notification if Parent Table Scrolls
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideButtons:) name:@"HideOptions" object:nil];
}

#pragma mark UIScrollView Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.scrollViewEditButton setAlpha:(scrollView.contentOffset.x/kCatchWidth)];
    
    if (scrollView.contentOffset.x < 0)
    {
        scrollView.contentOffset = CGPointZero;
    }
    [self.scrollViewButtonView setFrame:(CGRect){scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - kCatchWidth),0.0f,kCatchWidth,CGRectGetHeight(self.bounds)}];
    
    if (scrollView.contentOffset.x >= kCatchWidth)
    {
        if (!self.isShowingMenu)
        {
            [self setIsShowingMenu:YES];
        }
        
    } else if (scrollView.contentOffset.x == 0.0f){
        if (self.isShowingMenu)
        {
            [self setIsShowingMenu:NO];
        }
    }
    
}

#pragma mark CXCatalogueTableViewCell UIScrollView Delegate Methods

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.x > (kCatchWidth/2))
    {
        targetContentOffset->x = kCatchWidth;
    } else {
        *targetContentOffset = CGPointZero;
        dispatch_async(dispatch_get_main_queue(), ^{[scrollView setContentOffset:CGPointZero animated:YES];});
    }
}

#pragma mark CXCatalogueTableViewCell Designated Initializer

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupViews];
        [self.scrollView setUserInteractionEnabled:NO];
    }
    return self;
}


@end
