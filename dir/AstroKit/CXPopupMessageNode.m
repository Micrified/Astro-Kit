//
//  CXPopupMessageNode.m
//  AstroKit
//
//  Created by Owatch on 5/31/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXPopupMessageNode.h"

@implementation CXPopupMessageNode

#pragma mark CXPopupMessageNode Designated Initializers

-(instancetype)init
{
    self = [self initWithMessage:@"No Message"];
    return self;
}

-(instancetype)initWithMessage:(NSString *)message
{
    self = [super init];
    
    // Create Label
    SKLabelNode *label = [[SKLabelNode alloc]initWithFontNamed:@"HelveticaNeue"];
    [label setText:message];
    [label setFontColor:[UIColor darkGrayColor]];
    [label setFontSize:20.0f];
    
    // Create Background
    [self setPath:CGPathCreateWithRoundedRect((CGRect){0,0,label.frame.size.width + 50,label.frame.size.height + 30}, label.frame.size.height, label.frame.size.height, nil)];
    SKColor *color = [SKColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [self setStrokeColor:color];
    [self setFillColor:color];
    
    [self addChild:label];
    [label setPosition:(CGPoint){self.frame.size.width/2,((self.frame.size.height/2) - (label.frame.size.height/2))}];
    
    return self;
}
@end
