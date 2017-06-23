//
//  CXButtonNode.m
//  AstroKit
//
//  Created by Owatch on 6/19/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXButtonNode.h"

@interface CXButtonNode ()

#pragma mark CXButtonNode State Boolean
@property BOOL isSelected;

#pragma mark CXButtonNode Target and Selectors
@property (nonatomic,readonly)SEL touchAction;
@property (nonatomic,readonly,weak)id touchTarget;

#pragma mark CXButtonNode Texture Properties
@property (nonatomic,readwrite,strong)SKTexture *neutralTexture;
@property (nonatomic,readwrite,strong)SKTexture *selectedTexture;

@end

@implementation CXButtonNode

#pragma mark CXButtonNode Setters
-(void)setTouchTarget:(id)target action:(SEL)action
{
    _touchTarget = target;
    _touchAction = action;
}

#pragma mark CXButtonNode Custom Methods
-(void)setOn
{
    SKAction *changeTexture = [SKAction setTexture:_selectedTexture];
    SKAction *scaleTo = [SKAction scaleTo:1.2f duration:0.08];
    SKAction *sequence = [SKAction sequence:@[changeTexture,scaleTo]];
    [self runAction:sequence];
}

-(void)setOff
{
    SKAction *wait = [SKAction waitForDuration:0.1];
    SKAction *scaleTo = [SKAction scaleTo:1.0f duration:0.08];
    SKAction *changeTexture = [SKAction setTexture:_neutralTexture];
    SKAction *sequence = [SKAction sequence:@[wait,scaleTo,changeTexture]];
    [self runAction:sequence];
}

-(void)fire
{
    if(_touchAction)
    {
        [self.parent.parent performSelectorOnMainThread:_touchAction withObject:_touchTarget waitUntilDone:YES];
    }
}

#pragma mark CXButtonNode Custom Initializers
-(instancetype)initWithTextureNeutral:(SKTexture *)neutral selected:(SKTexture *)selected
{
    self = [super initWithTexture:neutral color:[UIColor whiteColor] size:neutral.size];
    if (self){
        [self setNeutralTexture:neutral];
        [self setSelectedTexture:selected];
        [self setIsSelected:NO];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

-(instancetype)initWithImageNamedNeutral:(NSString *)neutral Selected:(NSString *)selected
{
    SKTexture *textureNeutral = nil;
    if (neutral)
    {
        textureNeutral = [SKTexture textureWithImageNamed:neutral];
    }
    
    SKTexture *textureSelected = nil;
    if (selected)
    {
        textureSelected = [SKTexture textureWithImageNamed:selected];
    }
    
    return [self initWithTextureNeutral:textureNeutral selected:textureSelected];
}

@end
