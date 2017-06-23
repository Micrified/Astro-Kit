//
//  CXExhibitViewController.h
//  AstroKit
//
//  Created by Charles Randolph on 7/9/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXStellarObject.h"

@interface CXExhibitViewController : UIViewController <UIWebViewDelegate,UIScrollViewDelegate>

#pragma mark CXExhibitViewController Stellar Object Properties
@property (nonatomic,strong)CXStellarObject *object;

#pragma mark CXExhibitViewController UIButton Properties
@property (nonatomic,weak)IBOutlet UIButton *returnButton;

#pragma mark CXExhibitViewController UIImageView Properties
@property (nonatomic,weak)IBOutlet UIImageView *imageView;

#pragma mark CXExhibitViewController UILabel Properties
@property (nonatomic,weak)IBOutlet UILabel *titleLabel;

#pragma mark CXExhibitViewController UIWebView Properties
@property (nonatomic,weak)IBOutlet UIWebView *webView;

#pragma mark CXExhibitViewController UIView Properties
@property (nonatomic,weak)IBOutlet UIView *contentContainer;

#pragma mark CXExhibitViewController NSLayoutConstraint Properties
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *expandWebViewConstraint;

#pragma mark CXExhibitViewController Boolean Properties
@property (nonatomic)BOOL webViewIsExpanded;

#pragma mark CXExhibitViewController UIButton Action Methods
-(IBAction)returnToPrevious:(id)sender;



@end
