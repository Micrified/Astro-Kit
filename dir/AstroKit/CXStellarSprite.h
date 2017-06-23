//
//  CXStellarSprite.h
//  AstroKit
//
//  Created by Owatch on 5/30/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CXStellarObjectDescriptor.h"
#import "CXPhysicsTypes.h"
#import "CXStellarRingSprite.h"

@interface CXStellarSprite : SKSpriteNode

#pragma mark CXStellarSprite Boolean Properties
@property (nonatomic)BOOL shouldRemove;

#pragma mark CXStellarSprite Descriptive Properties
@property (nonatomic)NSString *type;
@property (nonatomic)NSString *objectName;
@property (nonatomic)NSString *imageName;
@property (nonatomic)NSString *ringImageName;
@property (nonatomic)float gameScale;

#pragma mark CXStellarSprite Physics Properties
@property (nonatomic)double mass;
@property (nonatomic)CXVector velocity;
@property (nonatomic)CXVector acceleration;

#pragma mark CXStellarSprite Methods

-(instancetype)initWithDescriptor:(CXStellarObjectDescriptor *)descriptor;

@end
