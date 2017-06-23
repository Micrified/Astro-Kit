//
//  CXStandardGradientView.m
//  AstroKit
//
//  Created by Owatch on 5/25/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXStandardGradientView.h"

@implementation CXStandardGradientView

+(Class)layerClass
{
    return [CAGradientLayer class];
}

-(void)createGradientLayer
{
    CAGradientLayer *gLayer = (CAGradientLayer *)[self layer];
    UIColor *myBlue = [UIColor colorWithRed:0.11f green:0.23f blue:0.51f alpha:1.00f];
    UIColor *myWhite = [UIColor colorWithRed:0.54f green:0.25f blue:0.30f alpha:1.00f];
    [gLayer setColors:[NSArray arrayWithObjects:(id)[myBlue CGColor], (id)[myWhite CGColor], nil]];
}



#pragma mark CXStandardGradientView: Initializer Overrides

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self createGradientLayer];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createGradientLayer];
    }
    return self;
}

@end
