//
//  CXPopupInterfaceButtonNode.m
//  AstroKit
//
//  Created by Owatch on 5/30/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXPopupInterfaceButtonNode.h"

@interface CXPopupInterfaceButtonNode ()
@property (nonatomic,readonly)SEL actionTouchUp;
@property (nonatomic,readonly)SEL actionTouchDown;
@property (nonatomic,readonly,weak)id targetTouchUp;
@property (nonatomic,readonly,weak)id targetTouchDown;

@property (nonatomic)BOOL isSelected;
@property (nonatomic,readwrite,strong)SKTexture *neutralTexture;
@property (nonatomic,readwrite,strong)SKTexture *selectedTexture;

@end


@implementation CXPopupInterfaceButtonNode

#pragma mark CXPopupInterfaceButtonNode: Custom Methods

-(void)setTouchDownTarget:(id)target action:(SEL)action
{
    _targetTouchDown = target;
    _actionTouchDown = action;
}

-(void)setTouchUpTarget:(id)target action:(SEL)action
{
    _targetTouchUp = target;
    _actionTouchUp = action;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if ([self selectedTexture])
    {
        if (_isSelected)
        {
            [self setTexture:_selectedTexture];
            [self performAssignedSelector];
        }
        else
        {
            [self setTexture:_neutralTexture];
        }
    }
}

-(void)toggle
{
    if (_isSelected)
    {
        [self setIsSelected:NO];
    } else {
        [self setIsSelected:YES];
    }
    [self setTexture:_selectedTexture];
}

-(void)performAssignedSelector
{
    if(_actionTouchDown)
    {
        [self.parent.parent performSelectorOnMainThread:_actionTouchDown withObject:_targetTouchDown waitUntilDone:YES];
    }
    [self setIsSelected:NO];
}

#pragma mark CXPopupInterfaceButtonNode: Designated Initializers

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


-(instancetype)initWithImageNamedNeutral:(NSString *)neutral selected:(NSString *)selected
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
