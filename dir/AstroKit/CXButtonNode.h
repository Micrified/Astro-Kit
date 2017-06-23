//
//  CXButtonNode.h
//  AstroKit
//
//  Created by Owatch on 6/19/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CXButtonNode : SKSpriteNode

#pragma mark CXButtonNode Selectors
-(void)setTouchTarget:(id)target action:(SEL)action;

#pragma mark CXButtonNode Control Methods
-(void)setOn;
-(void)setOff;
-(void)fire;
#pragma mark CXButtonNode Initializers
-(instancetype)initWithImageNamedNeutral:(NSString *)neutral Selected:(NSString *)selected;

@end
