//
//  CXGameSceneTargetIndicator.m
//  AstroKit
//
//  Created by Owatch on 5/31/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXGameSceneTargetIndicator.h"

@implementation CXGameSceneTargetIndicator

#pragma mark CXGameSceneTargetIndicator Designated Initializer
-(instancetype)init
{
    self = [super initWithImageNamed:@"TargetIndicator.png"];
    [self setScale:1.0];
    SKAction *pulseDown = [SKAction scaleTo:0.8 duration:0.5];
    SKAction *pulseUp = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *sequence = [SKAction sequence:@[pulseDown,pulseUp]];
    SKAction *repeat = [SKAction repeatActionForever:sequence];
    [self runAction:repeat];
    return self;
}
@end
