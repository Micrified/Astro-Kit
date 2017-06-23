//
//  CXGameSceneSelectedIndicator.m
//  AstroKit
//
//  Created by Owatch on 5/31/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXGameSceneSelectedIndicator.h"

@implementation CXGameSceneSelectedIndicator

#pragma mark CXGameSceneSelectedIndicator Designated Initializer

-(instancetype)init
{
    self = [super initWithImageNamed:@"SelectedIndicator.png"];
    [self setScale:1.2];
    SKAction *oneRevolution = [SKAction rotateByAngle:-M_PI*2 duration:10.0];
    SKAction *repeat = [SKAction repeatActionForever:oneRevolution];
    [self runAction:repeat];
    return self;
}

@end
