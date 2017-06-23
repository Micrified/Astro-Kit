//
//  CXStagedButtonNode.h
//  AstroKit
//
//  Created by Charles Randolph on 6/29/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CXStagedButtonNode : SKSpriteNode

#pragma mark CXButtonNode Selectors
-(void)setTouchTarget:(id)target action:(SEL)action;

#pragma mark CXButtonNode Control Methods
-(void)setStageA;
-(void)setStageB;
-(void)setStageC;
-(void)fire;

#pragma mark CXButtonNode Initializers
-(instancetype)initWithImageNamedNeutral:(NSString *)neutral StageB:(NSString *)stageB StageC:(NSString *)stageC;


@end
