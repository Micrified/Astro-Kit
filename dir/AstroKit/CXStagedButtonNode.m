//
//  CXStagedButtonNode.m
//  AstroKit
//
//  Created by Charles Randolph on 6/29/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXStagedButtonNode.h"

@interface CXStagedButtonNode ()

#pragma mark CXStagedButtonNode Boolean Properties
@property (nonatomic)BOOL isSelected;

#pragma mark CXStagedButtonNode Target and Selectors
@property (nonatomic,readonly)SEL touchAction;
@property (nonatomic,readonly,weak)id touchTarget;

#pragma mark CXStagedButtonNode Texture Properties
@property (nonatomic,readwrite,strong)SKTexture *textureA;
@property (nonatomic,readwrite,strong)SKTexture *textureB;
@property (nonatomic,readwrite,strong)SKTexture *textureC;

@end

@implementation CXStagedButtonNode

#pragma mark CXStagedButtonNode Setters
-(void)setTouchTarget:(id)target action:(SEL)action
{
    _touchTarget = target;
    _touchAction = action;
}

#pragma mark CXStagedButtonNode Custom Methods
-(void)setStageA
{
    SKAction *changeTexture = [SKAction setTexture:_textureA];
    SKAction *scaleTo = [SKAction scaleTo:1.0f duration:0.2];
    SKAction *sequence = [SKAction sequence:@[changeTexture,scaleTo]];
    [self runAction:sequence];
}

-(void)setStageB
{
    SKAction *changeTexture = [SKAction setTexture:_textureB];
    SKAction *scaleTo = [SKAction scaleTo:1.2f duration:0.2];
    SKAction *sequence = [SKAction sequence:@[changeTexture,scaleTo]];
    [self runAction:sequence];
}

-(void)setStageC
{
    SKAction *changeTexture = [SKAction setTexture:_textureC];
    [self runAction:changeTexture];
}

-(void)fire
{
    if(_touchAction)
    {
        [self.parent.parent performSelectorOnMainThread:_touchAction withObject:_touchTarget waitUntilDone:YES];
    }
}

#pragma mark CXStagedButtonNode Custom Initializer
-(instancetype)initWithTextureNamedNeutral:(SKTexture *)neutral StageB:(SKTexture *)stageB StageC:(SKTexture *)stageC
{
    self = [super initWithTexture:neutral color:[UIColor whiteColor] size:neutral.size];
    if (self)
    {
        [self setTextureA:neutral];
        [self setTextureB:stageB];
        [self setTextureC:stageC];
        [self setIsSelected:NO];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

-(instancetype)initWithImageNamedNeutral:(NSString *)neutral StageB:(NSString *)stageB StageC:(NSString *)stageC
{
    SKTexture *neutralTexture = nil;
    if (neutral)
    {
        neutralTexture = [SKTexture textureWithImageNamed:neutral];
    }
    
    SKTexture *stageBTexture = nil;
    if (stageB)
    {
        stageBTexture = [SKTexture textureWithImageNamed:stageB];
    }
    
    SKTexture *stageCTexture = nil;
    if (stageC)
    {
        stageCTexture = [SKTexture textureWithImageNamed:stageC];
    }
    
    return [self initWithTextureNamedNeutral:neutralTexture StageB:stageBTexture StageC:stageCTexture];
}


@end
