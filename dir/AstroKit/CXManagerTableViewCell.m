//
//  CXManagerTableViewCell.m
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXManagerTableViewCell.h"

static int kCatchWidth = 160;

@implementation CXManagerTableViewCell

#pragma mark CXManagerTableViewCell Default Methods
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark CXManagerTableViewCell Non-Default Methods
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.scrollView setContentSize:(CGSize){CGRectGetWidth(self.bounds)+kCatchWidth,CGRectGetHeight(self.bounds)}];
    [self.scrollView setFrame:(CGRect){0,0,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)}];
    [self.scrollViewButtonView setFrame:(CGRect){CGRectGetWidth(self.bounds)-kCatchWidth,0,kCatchWidth, CGRectGetHeight(self.bounds)}];
    [self.scrollViewContentView setFrame:(CGRect){0,0,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)}];
    [self.scrollViewRepositionButton setFrame:(CGRect){0,0,kCatchWidth/2.0f,CGRectGetHeight(self.bounds)}];
    [self.scrollViewRemoveButton setFrame:(CGRect){kCatchWidth/2.0f,0,kCatchWidth/2.0f,CGRectGetHeight(self.bounds)}];
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

#pragma mark Custom Methods
-(void)repositionButtonWasTouched:(id)sender
{
    [self.delegate cellDidTouchRepositionButton:self];
    
}

-(void)removeButtonWasTouched:(id)sender
{
    [self.delegate cellDidTouchRemoveButton:self];
}

-(void)hideButtons:(NSNotification *)notification
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark Cell View Setup
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
    
    // Create ScrollViewRepositionButton
    UIButton *scrollViewRepositionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scrollViewRepositionButton setAlpha:0.0f];
    [scrollViewRepositionButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.49 blue:1.0 alpha:1.0]];
    [scrollViewRepositionButton addTarget:self action:@selector(repositionButtonWasTouched:) forControlEvents:UIControlEventTouchUpInside];
    [scrollViewRepositionButton setFrame:(CGRect){0,0,kCatchWidth/2.0f,CGRectGetHeight(self.bounds)}];
    [scrollViewRepositionButton setImage:[UIImage imageNamed:@"RepositionIcon.png"] forState:UIControlStateNormal];
    [scrollViewButtonView addSubview:scrollViewRepositionButton];
    [self setScrollViewRepositionButton:scrollViewRepositionButton];
    
    // Create ScrollViewRemoveButton
    UIButton *scrollViewRemoveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scrollViewRemoveButton setAlpha:0.0f];
    [scrollViewRemoveButton setBackgroundColor:[UIColor redColor]];
    [scrollViewRemoveButton addTarget:self action:@selector(removeButtonWasTouched:) forControlEvents:UIControlEventTouchUpInside];
    [scrollViewRemoveButton setFrame:(CGRect){kCatchWidth/2.0f,0,kCatchWidth/2.0f,CGRectGetHeight(self.bounds)}];
    [scrollViewRemoveButton setImage:[UIImage imageNamed:@"RemoveIcon.png"] forState:UIControlStateNormal];
    [scrollViewButtonView addSubview:scrollViewRemoveButton];
    [self setScrollViewRemoveButton:scrollViewRemoveButton];
    
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
    [scrollViewTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    [scrollViewTitleLabel setTextColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0]];
    [scrollViewTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [scrollViewContentView addSubview:scrollViewTitleLabel];
    [self setScrollViewTitleLabel:scrollViewTitleLabel];
    
    // Create ScrollViewMassLabel
    UILabel *scrollViewMassLabel = [[UILabel alloc]initWithFrame:(CGRect){120,35,120,20}];
    [scrollViewMassLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [scrollViewMassLabel setTextColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0]];
    [scrollViewMassLabel setTextAlignment:NSTextAlignmentLeft];
    [scrollViewContentView addSubview:scrollViewMassLabel];
    [self setScrollViewMassLabel:scrollViewMassLabel];
    
    // Create ScrollViewOnScreenLabel
    UILabel *scrollViewOnScreenLabel = [[UILabel alloc]initWithFrame:(CGRect){120,60,120,20}];
    [scrollViewOnScreenLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [scrollViewOnScreenLabel setTextColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0]];
    [scrollViewOnScreenLabel setTextAlignment:NSTextAlignmentLeft];
    [scrollViewContentView addSubview:scrollViewOnScreenLabel];
    [self setScrollViewOnScreenLabel:scrollViewOnScreenLabel];
    
    // Create Notification if Parent Table Scrolls
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideButtons:) name:@"HideOptions" object:nil];
}

#pragma mark CXManagerTableViewCell UIScrollView Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.scrollViewRepositionButton setAlpha:(scrollView.contentOffset.x/kCatchWidth)];
    [self.scrollViewRemoveButton setAlpha:(scrollView.contentOffset.x/kCatchWidth)];
    
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

#pragma mark CXManagerTableViewCell Designated Initializers

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupViews];
    }
    return self;
}

@end
