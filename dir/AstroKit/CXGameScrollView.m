//
//  CXGameScrollView.m
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXGameScrollView.h"

@implementation CXGameScrollView

#pragma mark CXGameScrollView Hit-test Handling

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    
    if ([result.superview isKindOfClass:[UISlider class]])
    {
        self.scrollEnabled = NO;
    }
    else
    {
        self.scrollEnabled = YES;
    }
    return result;
}

#pragma mark CXGameScrollView UIGestureRecognizer Methods

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)respondToTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint tapPoint = [recognizer locationInView:self.gameScene.view];
    [self.gameScene respondToTapAtPoint:tapPoint];
}

-(void)respondToPan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if ([self.gameScene.eventState integerValue] == 7)
        {
            [self setScrollEnabled:NO];
        }
    }
    
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint touchPoint = [recognizer locationInView:self.gameScene.view];
        
        if ([self.gameScene.eventState integerValue] == 7)
        {
            [self.gameScene moveSavedObjectToPoint:touchPoint];
        } 
    }
    
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self setScrollEnabled:YES];
    }
    
}

-(void)respondToLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint touchPoint = [recognizer locationInView:self.gameScene.view];
        [self.gameScene respondToLongPressAtPoint:touchPoint];
    }
    
}

-(void)respondToPinch:(UIPinchGestureRecognizer *)recognizer
{
    if ([self.gameScene.eventState integerValue] == 2)
    {
        //CGFloat scale = [recognizer scale];
        //[self.gameScene.orbitPathShapeNode setScale:scale];
        //[self.gameScene adjustSatelliteOffset];
    }
}

#pragma mark CXGameScrollView Designated Initializer

-(instancetype)init
{
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondToTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(respondToPan:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(respondToLongPress:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(respondToPinch:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    // Set Scroller color
    [self setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    
    return self;
}


@end
