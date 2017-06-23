//
//  CXPopupInterfaceNode.h
//  AstroKit
//
//  Created by Owatch on 5/30/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CXStellarSprite.h"
#import "CXButtonNode.h"
#import "CXPopupContainerNode.h"
#import "CXPopupToSceneProtocol.h"

@interface CXPopupInterfaceNode : SKNode

#pragma mark CXPopupInterface CXStellarSprite Properties
@property (nonatomic)CXStellarSprite *currentObject;

#pragma mark CXPopupInterfaceNode Protocol Delegate Properties
@property (nonatomic,weak)id <CXPopupToSceneProtocol> myDelegate;

#pragma mark CXPopupInterfaceNode SKShapeNode Properties: (Base Layer)
@property (nonatomic)SKShapeNode *currentOverlay;
@property (nonatomic)SKShapeNode *temporaryOverlay;

#pragma mark CXPopupInterfaceNode SKLabel Properties & Subclasses
@property (nonatomic)SKLabelNode *titleLabel;
@property (nonatomic)SKLabelNode *dataLabel;
@property (nonatomic)CXPopupContainerNode *descriptorContainer;

#pragma mark CXPopupInterfaceNode UIImage Properties
@property (nonatomic)SKSpriteNode *displayImage;

#pragma mark CXPopupInterfaceNode UIButton Properties
@property (nonatomic)CXButtonNode *exitButton;
@property (nonatomic)CXButtonNode *checkButton;
@property (nonatomic)CXButtonNode *editButton;
@property (nonatomic)CXButtonNode *recycleButton;

#pragma mar CXPopupInterfaceNode Methods
-(void)actionForTappedNode:(SKNode *)node;

-(void)presentInfoInterfaceFor:(CXStellarSprite *)planet;
-(void)presentEditInterface;

-(void)removeInterface;
-(void)removeEditInterface;

@end
