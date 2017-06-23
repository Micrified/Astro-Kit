//
//  CXOrbitPopup.h
//  AstroKit
//
//  Created by Owatch on 6/21/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CXButtonNode.h"
#import "CXOrbitToSceneProtocol.h"

@interface CXOrbitPopup : SKNode

#pragma mark CXOrbitPopup SKLabel Properties
@property (nonatomic,strong)SKLabelNode *title;

#pragma mark CXOrbitPopup CXButtonNode Properties
@property (nonatomic,strong)CXButtonNode *checkButton;
@property (nonatomic,strong)CXButtonNode *exitButton;

#pragma mark CXOrbitPopup SKShapeNode Properties
@property (nonatomic,strong)SKShapeNode *base;

#pragma mark CXOrbitPopup CXOrbitAsset Subclasses
@property (nonatomic,strong)SKSpriteNode *parentPlaceholder;
@property (nonatomic,strong)SKSpriteNode *childPlaceholder;

#pragma mark CXOrbitPopup Delegate Properties
@property (nonatomic,weak)id<CXOrbitToSceneProtocol>myDelegate;

#pragma mark CXOrbitPopup Methods
-(void)actionForTappedNode:(SKNode *)node;

-(void)requestParent;
-(void)requestChild;

-(void)setParentToImageNamed:(NSString *)image;
-(void)setChildToImageNamed:(NSString *)image;


@end
