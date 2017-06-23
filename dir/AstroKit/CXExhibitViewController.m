//
//  CXExhibitViewController.m
//  AstroKit
//
//  Created by Charles Randolph on 7/9/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXExhibitViewController.h"

@interface CXExhibitViewController ()

@end

@implementation CXExhibitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView.scrollView setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([self shouldReloadData])
    {
        [self loadObjectData];
    }
    [self.webView.scrollView setContentOffset:CGPointZero];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark CXExhibitViewController Custom Methods for Loading Data
-(void)loadObjectData
{
    NSString *htmlString = [_object descriptor];
    UIImage *objectImage = [UIImage imageNamed:[_object imageName]];
    NSString *objectName = [_object name];
    
    [_webView loadHTMLString:htmlString baseURL:nil];
    [_imageView setImage:objectImage];
    [_titleLabel setText:objectName];
}

-(BOOL)shouldReloadData
{
    if ([_titleLabel.text isEqualToString:_object.name])
    {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark CXExhibitViewController UIButton Action Methods
-(void)returnToPrevious:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark CXExhibitViewController Expansion/Contraction of UIWebView
-(void)expandUIWebView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.expandWebViewConstraint.constant -= 120;
        [self.contentContainer layoutIfNeeded];
        [self.webView layoutIfNeeded];
        [self.webView layoutSubviews];
    }];
}

-(void)contractUIWebView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.expandWebViewConstraint.constant += 120;
        [self.contentContainer layoutIfNeeded];
        [self.webView layoutIfNeeded];
        [self.webView layoutSubviews];
    }];
}

#pragma mark CXExhibitViewController UIWebView UIScrollView Methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!self.webViewIsExpanded && scrollView.contentOffset.y < 20)
    {
        [self expandUIWebView];
        [self setWebViewIsExpanded:YES];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.webViewIsExpanded && scrollView.contentOffset.y < -4)
    {
        [self contractUIWebView];
        [self setWebViewIsExpanded:NO];
    }
}

#pragma mark CXExhibitViewController Designated Initializer

-(instancetype)init
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"CXExhibitViewController" bundle:appBundle];
    return self;
}


@end
