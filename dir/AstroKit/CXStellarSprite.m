//
//  CXStellarSprite.m
//  AstroKit
//
//  Created by Owatch on 5/30/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXStellarSprite.h"

@implementation CXStellarSprite

#pragma mark CXStellarSprite Designated Initializer
-(instancetype)initWithDescriptor:(CXStellarObjectDescriptor *)descriptor
{
    self = [self initWithImageNamed:descriptor.imageName];
    if (self)
    {
        // Set Descriptor Info
        [self setObjectName:descriptor.name];
        [self setType:descriptor.type];
        [self setImageName:descriptor.imageName];
        [self setMass:descriptor.mass];
        [self setScale:descriptor.scale];
        [self setGameScale:descriptor.scale];
        
        if ([descriptor.ringImageName length] == 0)
        {
            [self setRingImageName:descriptor.ringImageName];
            CXStellarRingSprite *ring = [CXStellarRingSprite spriteNodeWithImageNamed:descriptor.ringImageName];
            [ring setUserInteractionEnabled:NO];
            [ring setZPosition:-1];
            [ring setScale:descriptor.scale *5];
            [ring setZPosition:1];
            [self addChild:ring];
        }
        
        // Set Physics Info
        [self setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:(self.size.width/2)]];
        [self.physicsBody setAffectedByGravity:NO];
        [self.physicsBody setUsesPreciseCollisionDetection:YES];
        [self.physicsBody setDynamic:YES];
        [self setVelocity:(CXVector){0,0}];
        [self setAcceleration:(CXVector){0,0}];
        
    }
    return self;
}

-(instancetype)initWithImageNamed:(NSString *)name
{
    self = [super initWithImageNamed:name];
    _shouldRemove = NO;
    return self;
}
           
           
@end
