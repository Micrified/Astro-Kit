//
//  CXScene.h
//  AstroKit
//
//  Created by Owatch on 6/18/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CXStellarObject.h"
#import "CXStellarObjectDescriptor.h"
#import "CXStellarSystemDescriptor.h"
#import "CXStellarRingSprite.h"
#import "CXSceneToControllerProtocol.h"
#import "CXCatalogueToSceneProtocol.h"
#import "CXManagerToSceneProtocol.h"
#import "CXPopupToSceneProtocol.h"
#import "CXOrbitToSceneProtocol.h"
#import "CXPopupInterfaceNode.h"
#import "CXPopupMessageNode.h"
#import "CXButtonNode.h"
#import "CXStagedButtonNode.h"
#import "CXOrbitPopup.h"
#import "CXPhysicsTypes.h"


@interface CXScene : SKScene <CXCatalogueToSceneProtocol,CXManagerToSceneProtocol,CXPopupToSceneProtocol,CXOrbitToSceneProtocol,SKPhysicsContactDelegate>

#pragma mark CXScene Numerical Properties
@property (nonatomic,strong)NSNumber *objectLimit;
@property (nonatomic,strong)NSNumber *gravity;
@property (nonatomic,strong)NSNumber *timeStep;
@property (nonatomic,strong)NSNumber *eventState;
@property (nonatomic,strong)NSNumber *timeStepState;

#pragma mark CXScene Boolean Properties
@property (nonatomic)BOOL shouldDestroyObjects;
@property (nonatomic)BOOL sceneCreated;
@property (nonatomic)BOOL amPaused;

#pragma mark CXScene NSArray/NSMutableArray Properties
@property (nonatomic,strong)NSMutableArray *sceneObjects;
@property (nonatomic,strong)NSArray *sceneButtons;

#pragma mark CXScene: NSDictionary Properties
@property (nonatomic,strong)NSDictionary *temporarySatelliteInformation;

#pragma mark CXScene Resizing Properties
@property (nonatomic) CGSize contentSize;
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic,weak) SKSpriteNode *spriteToScroll;
@property (nonatomic,weak) SKSpriteNode *spriteForScrollingGeometry;
@property (nonatomic,weak) SKSpriteNode *spriteForStaticGeometry;

#pragma mark CXScene UI & Background Properties
@property (nonatomic,strong)SKSpriteNode *backgroundNode;
@property (nonatomic,strong)CXPopupInterfaceNode *popupInterface;
@property (nonatomic,strong)CXOrbitPopup *orbitPopup;
@property (nonatomic,strong)SKLabelNode *objectNumberLabel;
@property (nonatomic,strong)CXStagedButtonNode *timeStepButton;

#pragma mark CXScene CXStellarObject Properties
@property (nonatomic)CXStellarSprite *savedObject;
@property (nonatomic)SKSpriteNode *sceneIndicator;

// Special Occasion Sprites for Orbiting UI. 
@property (nonatomic)CXStellarSprite *parentObject;
@property (nonatomic)CXStellarSprite *childObject;

#pragma mark CXScene SKShapeNode Properties
@property (nonatomic)SKShapeNode *orbitPathNode;

#pragma mark CXScene Delegate Properties
@property (nonatomic,weak)id<CXSceneToControllerProtocol>myDelegate;

#pragma mark CXScene Methods

-(void)setContentScale:(CGFloat)scale;

-(void)setContentOffset:(CGPoint)contentOffset;

-(void)respondToLongPressAtPoint:(CGPoint)point;

-(void)respondToTapAtPoint:(CGPoint)point;

-(void)updateSliderValue:(float)value;

-(void)moveSavedObjectToPoint:(CGPoint)point;

-(void)showStarField;

-(void)removeStarField;

-(void)refreshObjectCount;







@end
