//
//  CXScene.m
//  AstroKit
//
//  Created by Owatch on 6/18/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXScene.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#pragma mark CXGameScene: Scrolling Constants
typedef NS_ENUM(NSInteger, MySceneZPosition)
{
    kMySceneZPositionScrolling = 0,
    kMySceneZPositionVerticalAndHorizontalScrolling,
    kMySceneZPositionStatic,
};

#pragma mark CXScene: SKSpriteNode Collision Bitmasks
static const uint32_t stellarCategory =  0x1 << 0;

// Event States (Used by Switch)#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
// 0: no action
// 1: pending spawn
// 2: pending reposition
// 3: prending parent selection | Orbit menu open
// 4: pending child selection | Orbit menu open
// 5: adjusting orbit path
// 6: menu popup is open
// 7: object is being moved
// 8: pending system spawn (special)

NSString *const font = @"HelveticaNeue";
NSInteger const padding = 10;

@implementation CXScene

#pragma mark CXScene: Default Methods & Setup
-(void)didMoveToView:(SKView *)view
{
    if (!self.sceneCreated){
        [self createPopupInterface];
        [self setScenePhysics];
        [self setAmPaused:NO];
        [self setSceneCreated:YES];
    }
}

-(void)createPopupInterface
{
    CXPopupInterfaceNode *popupInterface = [[CXPopupInterfaceNode alloc]init];
    [popupInterface setMyDelegate:self];
    [popupInterface setPosition:(CGPoint){self.size.width/2,self.size.height/2}];
    [popupInterface setZPosition:1];
    [self.spriteForStaticGeometry addChild:popupInterface];
    [self setPopupInterface:popupInterface];
}

-(void)showStarField
{
    SKEmitterNode *stars = (SKEmitterNode *)[self.backgroundNode childNodeWithName:@"StarField"];
    if (!stars)
    {
        SKEmitterNode *starField = [self newStarField];
        [starField setParticlePositionRange:CGVectorMake(self.backgroundNode.size.width, self.backgroundNode.size.height)];
        [starField setName:@"StarField"];
        [starField setPosition:CGPointMake(self.backgroundNode.size.width/2,self.backgroundNode.size.height/2)];
        [self.backgroundNode addChild:starField];
    } else {
        //NSLog(@"Star Emitter Already Exists: Not spawning.");
    }
}

-(void)removeStarField
{
    SKEmitterNode *stars = (SKEmitterNode *)[self.backgroundNode childNodeWithName:@"StarField"];
    if (stars)
    {
        [self.backgroundNode removeChildrenInArray:@[stars]];
    }
}

-(void)setScenePhysics
{
    [self setTimeStep:[NSNumber numberWithFloat:0.010]];
    [self setTimeStepState:[NSNumber numberWithInteger:0]];
    [self setGravity:[NSNumber numberWithInteger:500]];
    
    SKPhysicsBody *scenePhysics = [[SKPhysicsBody alloc]init];
    [scenePhysics setFriction:0];
    [scenePhysics setRestitution:0];
    [self setPhysicsBody:scenePhysics];
    [self.physicsWorld setContactDelegate:self];
    
}

#pragma mark CXScene: Button Methods
-(void)showCatalogue
{
    CXButtonNode *button = (CXButtonNode *)[self.spriteForStaticGeometry childNodeWithName:@"AddObjectButton"];
    [button setOff];
    // Close any open panels
    if (self.orbitPopup)
    {
        [self showOrbitPanel];
    }
    [self setAmPaused:YES];
    id <CXSceneToControllerProtocol>delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(switchToCatalogue)])
    {
        [delegate switchToCatalogue];
    }
}

-(void)showOrbitPanel
{
    CXButtonNode *button = (CXButtonNode *)[self.spriteForStaticGeometry childNodeWithName:@"AddOrbitButton"];
    [button setOff];
    
    if (!self.orbitPopup)
    {
        [self setAmPaused:YES];
        CXOrbitPopup *orbitPopup = [[CXOrbitPopup alloc]init];
        [orbitPopup setMyDelegate:self];
        [self.spriteForStaticGeometry addChild:orbitPopup];
        CXButtonNode *anyButton = (CXButtonNode *)[self.sceneButtons objectAtIndex:0];
        CGPoint position = CGPointMake((self.size.width/2),anyButton.position.y + anyButton.size.height/2 + padding);
        [orbitPopup setPosition:position];
        [self setOrbitPopup:orbitPopup];
        // Set appropriate mode
        [self normalizeSpriteScales];
        
        [self setEventState:[NSNumber numberWithInteger:3]];
        
    } else {
        [self restoreSpriteScales];
        
        [self.spriteForStaticGeometry removeChildrenInArray:@[self.orbitPopup]];
        _orbitPopup = nil;
        [self setEventState:[NSNumber numberWithInteger:0]];
        
        if (![self.timeStepState isEqualToNumber:[NSNumber numberWithInt:2]])
        {
            [self setAmPaused:NO];
        }
    }
}

-(void)showManager
{
    CXButtonNode *button = (CXButtonNode *)[self.spriteForStaticGeometry childNodeWithName:@"MenuButton"];
    // Close any open panels
    if (self.orbitPopup)
    {
        [self showOrbitPanel];
    }
    [button setOff];
    [self setAmPaused:YES];
    id <CXSceneToControllerProtocol> delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(switchToManager)])
    {
        [delegate switchToManager];
    }
}

-(void)switchTimeStep
{
    // States
    // 0 = Normal
    // 1 = slow
    // 3 = paused
    
    // A: Save current state (Paused/unpaused) & current mode.
    BOOL wasPaused = _amPaused;
    NSNumber *lastState = self.timeStepState;
    
    [self setAmPaused:YES];
    
    
    // B Change Accordingly
    if ([self.timeStepState isEqualToNumber:[NSNumber numberWithInteger:0]])
    {
        // Make Slow
        [self setTimeStep:[NSNumber numberWithFloat:0.0025]];
        [(CXStagedButtonNode *)[self.spriteForStaticGeometry childNodeWithName:@"TimeStepButton"] setStageB];
        //NSLog(@"TimeStep: 0.0025");
        [self setTimeStepState:[NSNumber numberWithInteger:1]];
        
    } else if ([self.timeStepState isEqualToNumber:[NSNumber numberWithInteger:1]])
    {
        // Make Paused
        [(CXStagedButtonNode *)[self.spriteForStaticGeometry childNodeWithName:@"TimeStepButton"] setStageC];
        //NSLog(@"Button: Paused");
        [self setTimeStepState:[NSNumber numberWithInteger:2]];
    } else {
        // Make unpaused
        [(CXStagedButtonNode *)[self.spriteForStaticGeometry childNodeWithName:@"TimeStepButton"] setStageA];
        //NSLog(@"TimeStep: 0.010");
        [self setTimeStep:[NSNumber numberWithFloat:0.010]];
        [self setTimeStepState:[NSNumber numberWithInt:0]];
    }
    
    // Unpause if needed. Leave paused if not.
    if (!wasPaused && ![lastState isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [self setAmPaused:NO];
    } else
    {
        if ([lastState isEqualToNumber:[NSNumber numberWithInt:2]])
        {
            [self setAmPaused:NO];
        }
    }
}

#pragma mark CXScene: Protocol: CXPopupToScene

-(void)updateSliderValue:(float)value
{
    if (self.popupInterface.dataLabel)
    {
        [self.popupInterface.dataLabel setText:[NSString stringWithFormat:@"%.0f u",value]];
    }
}

-(void)requestSliderWithValue:(int)value
{
    id<CXSceneToControllerProtocol>delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(showSliderWithValue:)])
    {
        [delegate showSliderWithValue:value];
    }
}

-(void)requestSliderRemoval
{
    id<CXSceneToControllerProtocol>delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(hideSlider)])
    {
        [delegate hideSlider];
    }
}

-(void)hasClosed
{
    if (![self.timeStepState isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        [self setAmPaused:NO];
    }
    [self setEventState:[NSNumber numberWithInt:0]];
}

#pragma mark CXScene: Protocol: CXCatalogueToScene
-(void)userAborted
{
    if (![self.timeStepState isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        [self setAmPaused:NO];
    }
}

-(void)addStellarSpriteWith:(CXStellarObjectDescriptor *)descriptor
{
    NSInteger points = ([self.objectLimit integerValue]-[self.sceneObjects count]);
    if (points > 0)
    {
        CXStellarSprite *object = [[CXStellarSprite alloc]initWithDescriptor:descriptor];
        [self setSavedObject:object];
        [self.sceneObjects addObject:object];
        [object.physicsBody setContactTestBitMask:stellarCategory];
        [object.physicsBody setCategoryBitMask:stellarCategory];
        [object.physicsBody setCollisionBitMask:stellarCategory];
        [self showGenericPopupWithText:@"Tap To Place Object!"];
        [self setEventState:[NSNumber numberWithInt:1]];
    } else {
        [self showObjectCountWarning];
    }
}

-(void)addStellarSystemWith:(CXStellarSystemDescriptor *)descriptor
{
    NSInteger points = ([self.objectLimit integerValue] - [self.sceneObjects count]);
    NSInteger systemCount = 1 + [descriptor.satellites count];
    if (points >= systemCount)
    {
        // Create Parent, Set Physics
        CXStellarSprite *parent = [[CXStellarSprite alloc]initWithDescriptor:descriptor.parent];
        [parent.physicsBody setContactTestBitMask:stellarCategory];
        [parent.physicsBody setCategoryBitMask:stellarCategory];
        [parent.physicsBody setCollisionBitMask:stellarCategory];
        
        // Create Satellites, Set Physics
        NSMutableArray *satellites = [[NSMutableArray alloc]init];
        for (CXStellarObjectDescriptor *objectDescriptor in descriptor.satellites)
        {
            CXStellarSprite *satellite = [[CXStellarSprite alloc]initWithDescriptor:objectDescriptor];
            [satellite.physicsBody setContactTestBitMask:stellarCategory];
            [satellite.physicsBody setCategoryBitMask:stellarCategory];
            [satellite.physicsBody setCollisionBitMask:stellarCategory];
            [satellites addObject:satellite];
        }
        
        // Create Dictionary Storing Positions and Satellites
        NSMutableDictionary *satelliteInformation = [[NSMutableDictionary alloc]init];
        [satelliteInformation setValue:satellites forKey:@"Satellites"];
        [satelliteInformation setValue:descriptor.offsets forKey:@"Offsets"];
        
        // Add Parent & Satellites to Scene Objects
        [self.sceneObjects addObjectsFromArray:satellites];
        [self.sceneObjects addObject:parent];
        
        // Set Scene Saved-Object to Parent & Satellite Dictionary
        [self setSavedObject:parent];
        [self setTemporarySatelliteInformation:satelliteInformation];
        
        // Set Event state and show popup
        [self showGenericPopupWithText:@"Tap To Place System"];
        [self setEventState:[NSNumber numberWithInt:8]];
    } else {
        if (![self.timeStepState isEqualToNumber:[NSNumber numberWithInt:2]])
        {
            [self setAmPaused:NO];
        }
        [self setEventState:[NSNumber numberWithInt:0]];
        [self showGenericPopupWithText:@"Too Many Objects in Scene!"];
        [self showObjectCountWarning];
    }
    
}

#pragma mark CXScene: Protocol: CXManagerToScene
-(void)setRepositionForObjectAtIndex:(NSUInteger)index
{
    CXStellarSprite *object = [self.sceneObjects objectAtIndex:index];
    [self setSavedObject:object];
    [self showGenericPopupWithText:@"Tap To Reposition!"];
    [self setEventState:[NSNumber numberWithInteger:2]];
}

-(void)removeSceneObjectAtIndex:(NSUInteger)index
{
    CXStellarSprite *object = [self.sceneObjects objectAtIndex:index];
    [object setShouldRemove:YES];
}

#pragma mark CXScene: Protocol: CXOrbitToScene
-(void)finishOrbitSetup
{
    [self restoreSpriteScales];
    if (_parentObject && _childObject)
    {
        // Close Interface
        [self.spriteForStaticGeometry removeChildrenInArray:@[self.orbitPopup]];
        _orbitPopup = nil;
        
        // Adjust Positons
        CGPoint midPoint = [self convertPoint:(CGPoint){self.spriteForStaticGeometry.size.width/2,-self.spriteForStaticGeometry.size.height/2} toNode:self.backgroundNode];
        
        CGVector adjustment = (CGVector){_parentObject.position.x - midPoint.x, _parentObject.position.y - midPoint.y};
        
        id<CXSceneToControllerProtocol>delegate = self.myDelegate;
        if ([delegate respondsToSelector:@selector(moveScrollViewWithOffset:)])
        {
            [delegate moveScrollViewWithOffset:adjustment];
        }

        // Set Indicator to show orbit path.
        [self attachOrbitPathIndicatorToParent:_parentObject withChild:_childObject];
        
        // Set event state to await tap to confirm orbital radius
        [self setEventState:[NSNumber numberWithInteger:5]];
        
        
    } else {
        [self showGenericPopupWithText:@"Please fill required slots"];
    }
}

-(void)abortOrbitSetup
{
    [self restoreSpriteScales];
    _parentObject = nil;
    _childObject = nil;
    [self.spriteForStaticGeometry removeChildrenInArray:@[self.orbitPopup]];
    _orbitPopup = nil;
    [self setEventState:[NSNumber numberWithInteger:0]];
    
    if (![self.timeStepState isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        [self setAmPaused:NO];
    }
}

#pragma mark CXScene: Increase | Decrease Object Count
-(void)refreshObjectCount
{
    NSInteger points = ([self.objectLimit integerValue]-[self.sceneObjects count]);
    [self.objectNumberLabel setText:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:points]]];
}

-(void)showObjectCountWarning
{
    SKAction *scaleUp = [SKAction scaleTo:1.5 duration:0.2];
    SKAction *scaleDown = [SKAction scaleTo:1.0 duration:0.2];
    SKAction *warning = [SKAction sequence:@[scaleUp,scaleDown]];
    [self.objectNumberLabel runAction:warning withKey:@"warning"];
}

#pragma mark CXScene: Add Systems
-(void)spawnSystemAtPoint:(CGPoint)point
{
    NSDictionary *satelliteInfo = _temporarySatelliteInformation;
    CXStellarSprite *parent = _savedObject;
    
    // Set Parent Position
    [self.backgroundNode addChild:parent];
    [parent setPosition:point];
    
    // Set Satellite Positions & Velocities
    NSArray *satellites = [satelliteInfo valueForKey:@"Satellites"];
    NSArray *offsets = [satelliteInfo valueForKey:@"Offsets"];
    for (CXStellarSprite *s in satellites)
    {
        NSArray *offsetPoints = [offsets objectAtIndex:[satellites indexOfObject:s]];
        int xOffset = (int)[[offsetPoints objectAtIndex:0]integerValue];
        int yOffset = (int)[[offsetPoints objectAtIndex:1]integerValue];
        CGPoint offset = CGPointMake(xOffset, yOffset);
        // Determine Position
        CGPoint position = CGPointMake(point.x + offset.x, point.y + offset.y);
        [s setPosition:position];
        
        // Determine Velocity
        CGVector distance = CGVectorMake(parent.position.x - s.position.x, parent.position.y - s.position.y);
        CGFloat r = sqrtf(powf(distance.dx, 2) + powf(distance.dy, 2));
        CGFloat vOrbit = sqrtf(([self.gravity integerValue] * (parent.mass + s.mass))/r);
        
        CGVector trajectory = CGVectorMake(-distance.dy, distance.dx);
        float trajectoryMagnitude = sqrtf(powf(trajectory.dx, 2) + powf(trajectory.dy, 2));
        float adjustmentFactor = (vOrbit/trajectoryMagnitude);
        CXVector velocityTrajectory = (CXVector){trajectory.dx * adjustmentFactor, trajectory.dy * adjustmentFactor};
        [s setVelocity:velocityTrajectory];
        
        // Add Object to Scene
        [self.backgroundNode addChild:s];
    }
}

#pragma mark CXScene: Move Objects
-(void)moveSavedObjectToPoint:(CGPoint)point
{
    CGPoint newPoint = [self convertPointFromView:point];
    CGPoint pointInBackground = [self convertPoint:newPoint toNode:self.backgroundNode];
    [self.savedObject setPosition:pointInBackground];
}

#pragma mark CXScene: Remove Objects
-(void)removeObjects
{
    NSMutableArray *objectsToRemove = [[NSMutableArray alloc]init];
    for (CXStellarSprite *i in self.sceneObjects)
    {
        if (i.shouldRemove)
        {
            [objectsToRemove addObject:i];
        }
    }
    
    for (CXStellarSprite *i in objectsToRemove)
    {
        [self.backgroundNode removeChildrenInArray:@[i]];
        [self.sceneObjects removeObject:i];
        [self refreshObjectCount];
    }
}

#pragma mark CXGameScene: Object Collisions & Particle Systems
-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if (self.shouldDestroyObjects)
    {
        if (!self.amPaused)
        {
            CXStellarSprite *bodyA = (CXStellarSprite *)contact.bodyA.node;
            CXStellarSprite *bodyB = (CXStellarSprite *)contact.bodyB.node;
            if (bodyA.mass > (bodyB.mass * 4))
            {
                SKEmitterNode *emitter = [self newEmitter];
                [self.backgroundNode addChild:emitter];
                [emitter setPosition:bodyB.position];
                [bodyB setShouldRemove:YES];
            } else if (bodyB.mass > (bodyA.mass * 4))
            {
                SKEmitterNode *emitter = [self newEmitter];
                [self.backgroundNode addChild:emitter];
                [emitter setPosition:bodyA.position];
                [bodyA setShouldRemove:YES];
            } else {
                SKEmitterNode *emitterA = [self newEmitter];
                SKEmitterNode *emitterB = [self newEmitter];
                [self.backgroundNode addChild:emitterA];
                [self.backgroundNode addChild:emitterB];
                [emitterA setPosition:bodyA.position];
                [emitterB setPosition:bodyB.position];
                [bodyA setShouldRemove:YES];
                [bodyB setShouldRemove:YES];
            }
        }
    }
}

-(SKEmitterNode *)newEmitter
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CXContactParticle" ofType:@"sks"];
    SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return node;
}

-(SKEmitterNode *)newStarField
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CXStarFieldParticle" ofType:@"sks"];
    SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return node;
}

#pragma mark CXScene: Orbital Radius Indicator
// We have one 'Scene indicator' slot reserved for this node
-(void)attachOrbitPathIndicatorToParent:(CXStellarSprite *)parent withChild:(CXStellarSprite *)child
{
    // Create and display Orbit UI
    [self showOrbitButtons];
    
    SKSpriteNode *indicatorNode = [[SKSpriteNode alloc]init];
    
    // Get Current Radius (From Parent to Child)!
    CGVector distance = CGVectorMake(child.position.x - parent.position.x, child.position.y - parent.position.y);
    CGFloat radius = sqrtf(powf(distance.dx, 2)+powf(distance.dy,2));
    
    
    SKShapeNode *shape = [SKShapeNode shapeNodeWithCircleOfRadius:radius];
    [shape setName:@"ShapeNode"];
    
    // Set Properties, Hierarchy, and add to scene
    [self setSceneIndicator:indicatorNode];
    [self.backgroundNode addChild:indicatorNode];
    [indicatorNode addChild:shape];
    
    // Set Position
    [indicatorNode setPosition:parent.position];
    
    // Show popup
    [self showGenericPopupWithText:@"Tap to adjust"];
}

-(void)setOrbitPathRadiusToPoint:(CGPoint)point
{
    SKShapeNode *node = (SKShapeNode *)[self.sceneIndicator childNodeWithName:@"ShapeNode"];
    [node removeFromParent];
    
    [self.childObject setPosition:point];
    CGVector distance = CGVectorMake(point.x - _parentObject.position.x, point.y - _parentObject.position.y);
    CGFloat radius = sqrt(powf(distance.dx, 2) + powf(distance.dy, 2));
    
    SKShapeNode *shape = [SKShapeNode shapeNodeWithCircleOfRadius:radius];
    [shape setName:@"ShapeNode"];
    [self.sceneIndicator addChild:shape];
}

-(void)finalizeOrbitPath;
{
    // Remove the Orbit Button UI
    [self removeOrbitButtons];
    
    SKShapeNode *node = (SKShapeNode *)[self.sceneIndicator childNodeWithName:@"ShapeNode"];
    [node removeFromParent];
    _sceneIndicator = nil;
    
    // Do some physics
    CGVector distance = CGVectorMake(_childObject.position.x - _parentObject.position.x, _childObject.position.y - _parentObject.position.y);
    CGFloat r = sqrtf(powf(distance.dx, 2) + powf(distance.dy, 2));
    CGFloat vOrbit = sqrtf(([self.gravity integerValue] * (_parentObject.mass + _childObject.mass))/r);
    
    CGVector trajectory = CGVectorMake(-distance.dy, distance.dx);
    float trajectoryMagnitude = sqrtf(powf(trajectory.dx, 2) + powf(trajectory.dy, 2));
    float adjustmentFactor = (vOrbit/trajectoryMagnitude);
    CXVector velocityTrajectory = (CXVector){trajectory.dx * adjustmentFactor, trajectory.dy * adjustmentFactor};
    
    // Account for movement of parent:
    CXVector adjustedTrajectory = (CXVector){_parentObject.velocity.dx + velocityTrajectory.dx, _parentObject.velocity.dy + velocityTrajectory.dy};
    [self.childObject setVelocity:adjustedTrajectory];
    
    
    // Remove Child & Parent object slots
    _parentObject = nil;
    _childObject = nil;
    
    // Restore Base Interface
    [self restoreBaseInterface];
    
    // Unpause game, Change mode
    if (![self.timeStepState isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        [self setAmPaused:NO];
    }
    [self setEventState:[NSNumber numberWithBool:0]];
}

-(void)abortOrbitPath
{
    // Remove the Orbit Button UI
    [self removeOrbitButtons];
    
    SKShapeNode *node = (SKShapeNode *)[self.sceneIndicator childNodeWithName:@"ShapeNode"];
    [node removeFromParent];
    _sceneIndicator = nil;
    
    // Remove Child & Parent object slots
    _parentObject = nil;
    _childObject = nil;

    // Unpause game, Change mode
    if (![self.timeStepState isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        [self setAmPaused:NO];
    }
    [self setEventState:[NSNumber numberWithBool:0]];
}

#pragma mark CXScene: Orbit: Assisting Methods
-(void)normalizeSpriteScales
{
    [self.backgroundNode setColor:Rgb2UIColor(40, 40, 40)];
    for (CXStellarSprite *s in self.sceneObjects)
    {
        SKAction *scale = [SKAction scaleTo:0.5 duration:0.2f];
        [s runAction:scale];
    }
}

-(void)restoreSpriteScales
{
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SceneBackgroundColor"];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    [self.backgroundNode setColor:color];
    for (CXStellarSprite *s in self.sceneObjects)
    {
        SKAction *scale = [SKAction scaleTo:s.gameScale duration:0.2f];
        [s runAction:scale];
    }
}

-(void)showOrbitButtons
{
    // Hide Current UI
    [self hideBaseInterface];
    
    // Create, Name, and Set CXButton Selectors
    CXButtonNode *confirmOrbitButton = [[CXButtonNode alloc]initWithImageNamedNeutral:@"CheckButtonClear" Selected:@"CheckButtonClear"];
    CXButtonNode *abortOrbitButton = [[CXButtonNode alloc]initWithImageNamedNeutral:@"ExitButtonClear" Selected:@"ExitButtonClear"];
    [confirmOrbitButton setName:@"ConfirmOrbitButton"];
    [abortOrbitButton setName:@"AbortOrbitButton"];
    [confirmOrbitButton setTouchTarget:self action:@selector(finalizeOrbitPath)];
    [abortOrbitButton setTouchTarget:self action:@selector(abortOrbitPath)];
    
    // Set Alpha
    [confirmOrbitButton setAlpha:0.0f];
    [abortOrbitButton setAlpha:0.0f];
    
    // Scale Buttons
    [confirmOrbitButton setScale:0.8];
    [abortOrbitButton setScale:0.8];
    
    // Add to Scene, and set Position
    [self.spriteForStaticGeometry addChild:confirmOrbitButton];
    [self.spriteForStaticGeometry addChild:abortOrbitButton];
    
    [confirmOrbitButton setPosition:CGPointMake((self.spriteForStaticGeometry.size.width * 0.25), (confirmOrbitButton.size.height/2+padding))];
    [abortOrbitButton setPosition:CGPointMake((self.spriteForStaticGeometry.size.width * 0.75), (confirmOrbitButton.size.height/2+padding))];
    
    // Fade in
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.1];

    [confirmOrbitButton runAction:fadeIn];
    [abortOrbitButton runAction:fadeIn];
}

-(void)removeOrbitButtons
{
    CXButtonNode *confirmOrbitButton = (CXButtonNode *)[self.spriteForStaticGeometry childNodeWithName:@"ConfirmOrbitButton"];
    CXButtonNode *abortOrbitButton = (CXButtonNode *)[self.spriteForStaticGeometry childNodeWithName:@"AbortOrbitButton"];
    [self.spriteForStaticGeometry removeChildrenInArray:@[confirmOrbitButton,abortOrbitButton]];
    
    // Restore UI
    [self restoreBaseInterface];
}

#pragma mark CXScene: Indicators
-(void)showGenericPopupWithText:(NSString *)text
{
    CXPopupMessageNode *message = [[CXPopupMessageNode alloc]initWithMessage:text];
    [message setAlpha:0.0f];
    [self.spriteForStaticGeometry addChild:message];
    [message setPosition:CGPointMake(self.spriteForStaticGeometry.size.width/2 - (message.frame.size.width/2), self.spriteForStaticGeometry.size.height/2)];
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.2];
    SKAction *wait = [SKAction waitForDuration:0.5];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *show = [SKAction sequence:@[fadeIn,wait,fadeOut,remove]];
    [message runAction:show];
}

-(void)attachMovementIndicatorTo:(CXStellarSprite *)sprite
{
    SKSpriteNode *movementIndicator = [[SKSpriteNode alloc]initWithImageNamed:@"SelectedIndicator"];
    SKAction *oneRevolution = [SKAction rotateByAngle:-M_PI*2 duration: 4.0];
    SKAction *repeat = [SKAction repeatActionForever:oneRevolution];
    [movementIndicator runAction:repeat];
    
    [movementIndicator setScale:1.4];
    [sprite addChild:movementIndicator];
    _sceneIndicator = movementIndicator;
}

-(void)removeMovementIndicatorFrom:(CXStellarSprite *)sprite
{
    [self.sceneIndicator removeAllActions];
    [sprite removeChildrenInArray:@[_sceneIndicator]];
    _sceneIndicator = nil;
}


#pragma mark CXScene: Overridden Setters

-(void)setAmPaused:(BOOL)amPaused
{
    _amPaused = amPaused;
}

-(void)setEventState:(NSNumber *)eventState
{
    _eventState = eventState;
    if ([eventState integerValue] == 0)
    {
        [self setSavedObject:nil];
    }
}

-(void)setSceneIndicator:(SKSpriteNode *)sceneIndicator
{
    _sceneIndicator = sceneIndicator;
}

#pragma mark CXScene: Stray Object Handling
-(void)redirectObjects
{
    for (CXStellarSprite *i in self.sceneObjects)
    {
        CGPoint position = i.position;
        if (position.x > self.backgroundNode.size.width || position.x < 0)
        {
            CGPoint newPosition;
            if (position.x > self.backgroundNode.size.width)
            {
                newPosition = CGPointMake(1, position.y);
            } else {
                newPosition = CGPointMake(self.backgroundNode.size.width-1, position.y);
            }
            [i runAction:[SKAction moveTo:newPosition duration:0.0f]];
        }
        
        if (position.y > self.backgroundNode.size.height || position.y < 0)
        {
            CGPoint newPosition;
            if (position.y > self.backgroundNode.size.height)
            {
                newPosition = CGPointMake(position.x, 1);
            } else {
                newPosition = CGPointMake(position.x, self.backgroundNode.size.height-1);
            }
            [i runAction:[SKAction moveTo:newPosition duration:0.0f]];
        }
    }
}

#pragma mark CXScene: Hide/Show UI

-(void)hideBaseInterface
{
    for (CXButtonNode *i in self.sceneButtons)
    {
        [i setHidden:YES];
    }
}

-(void)restoreBaseInterface
{
    for (CXButtonNode *i in self.sceneButtons)
    {
        [i setHidden:NO];
    }
}

#pragma mark CXScene: Loop

-(void)update:(NSTimeInterval)currentTime
{
    
    [self removeObjects];
    
    if (!self.amPaused)
    {
        [self updatePositions];
        [self redirectObjects];
    }
}

#pragma mark CXScene: Tap & Long Press
-(void)respondToTapAtPoint:(CGPoint)point
{
    CGPoint inView = [self convertPointFromView:point];
    CGPoint pointInScroll = [self convertPoint:inView toNode:self.spriteForScrollingGeometry];
    CGPoint pointInStatic = [self convertPoint:inView toNode:self.spriteForStaticGeometry];
    SKNode *nodeInScroll = [self.spriteForScrollingGeometry nodeAtPoint:pointInScroll];
    SKNode *nodeInStatic = [self.spriteForStaticGeometry nodeAtPoint:pointInStatic];
    
    // Important Conversion
    if ([nodeInScroll isKindOfClass:[CXStellarRingSprite class]])
    {
        nodeInScroll = nodeInScroll.parent;
    }
    
    // Priorities: Conditions > Static > Scroll.
    switch ([self.eventState integerValue]) {
        case 0:
            // No action
            
            break;
        
        case 1:
            // Pending Spawn: Place at point
            [self.backgroundNode addChild:self.savedObject];
            [self.savedObject setPosition:pointInScroll];
            [self refreshObjectCount];
            if (![self.timeStepState isEqualToNumber:[NSNumber numberWithInt:2]])
            {
                [self setAmPaused:NO];
            }
            [self setEventState:[NSNumber numberWithInt:0]];
            break;
            
        case 2:
            // Pending Reposition: Place at point
            [self.savedObject setPosition:pointInScroll];
            
            if (![self.timeStepState isEqualToNumber:[NSNumber numberWithInt:2]])
            {
                [self setAmPaused:NO];
            }
            [self setEventState:[NSNumber numberWithInt:0]];
            break;
            
        case 3:
            // Select Parent Object
            if ([nodeInScroll isKindOfClass:[CXStellarSprite class]])
            {
                [self setParentObject:(CXStellarSprite *)nodeInScroll];
                [self.orbitPopup setParentToImageNamed:[(CXStellarSprite *)nodeInScroll imageName]];
                [self setEventState:[NSNumber numberWithInt:4]];
                [self showGenericPopupWithText:@"Tap Child Object"];
            } else if ([nodeInStatic isKindOfClass:[CXButtonNode class]])
            {
                // If you tapped a button, then it will send it to orbitPopup to use.
                [self.orbitPopup actionForTappedNode:nodeInStatic];
            } else {
                [self showGenericPopupWithText:@"Tap Parent Object"];
            }
            
            break;
            
        case 4:
            // Select Child Object

            if ([nodeInScroll isKindOfClass:[CXStellarSprite class]])
            {
                if (![nodeInScroll isEqual:_parentObject])
                {
                    [self setChildObject:(CXStellarSprite *)nodeInScroll];
                    [self.orbitPopup setChildToImageNamed:[(CXStellarSprite *)nodeInScroll imageName]];
                    // Don't change event state just yet (Must wait for checkmark button!)
                }
                
            } else if ([nodeInStatic isKindOfClass:[CXButtonNode class]])
            {
                [self.orbitPopup actionForTappedNode:nodeInStatic];
            } else {
                if (!_childObject)
                {
                    [self showGenericPopupWithText:@"Tap Child Object"];
                } else {
                    [self showGenericPopupWithText:@"Tap Confirm Button"];
                }
            }
            
            break;
            
        case 5:
            // Adjusting Orbit Path: Widen/Shrink to tapped point. (Long press is to confirm)
            
            if (![nodeInStatic isKindOfClass:[CXButtonNode class]])
            {
                //NSLog(@"Set Radius");
                [self setOrbitPathRadiusToPoint:pointInScroll];
            } else {
                if (![(CXButtonNode *)nodeInStatic isEqual:[self.spriteForStaticGeometry childNodeWithName:@"TimeStepButton"]])
                {
                    [(CXButtonNode *)nodeInStatic fire];
                }
            }
            
            break;
            
        case 6:
            // Popup Menu is open
            [self.popupInterface actionForTappedNode:nodeInStatic];
            
            break;
        
        case 7:
            // Something is being scrolled: Stop that at this point
            [self removeMovementIndicatorFrom:self.savedObject];
            [self setSavedObject:nil];
            [self setEventState:[NSNumber numberWithInt:0]];
            
            if (![self.timeStepState isEqualToNumber:[NSNumber numberWithInt:2]])
            {
                [self setAmPaused:NO];
            }
            
            break;
            
        case 8:
            // Saved Object = Parent, Satellites = Temporary Dictionary. Setup the system.
            [self spawnSystemAtPoint:pointInScroll];
            [self refreshObjectCount];
            [self setTemporarySatelliteInformation:nil];
            [self setSavedObject:nil];
            if (![self.timeStepState isEqualToNumber:[NSNumber numberWithInt:2]])
            {
                [self setAmPaused:NO];
            }
            [self setEventState:[NSNumber numberWithInt:0]];
            
            break;
            
        default:
            
            break;
    }
    
    // Static Handling
    if ([self.sceneButtons containsObject:nodeInStatic] || [nodeInStatic isEqual:[self.spriteForStaticGeometry childNodeWithName:@"TimeStepButton"]])
    {
        if (![self.eventState isEqualToNumber:[NSNumber numberWithInt:5]])
        {
            [(CXStagedButtonNode *)nodeInStatic fire];
        }
        return;
    }
    
    // Scroll Handling
    if ([nodeInScroll isKindOfClass:[CXStellarSprite class]] && !self.orbitPopup && ![self.eventState isEqualToNumber:[NSNumber numberWithInteger:6]])
    {
        [self setAmPaused:YES];
        [self.popupInterface presentInfoInterfaceFor:(CXStellarSprite *)nodeInScroll];
        // Set event state to 'popup menu IS open'
        [self setEventState:[NSNumber numberWithInt:6]];
        return;
    } else {
        // Turn off Certain conditions / handle
        return;
    }
}

-(void)respondToLongPressAtPoint:(CGPoint)point
{
    CGPoint inView = [self convertPointFromView:point];
    CGPoint pointInScroll = [self convertPoint:inView toNode:self.spriteForScrollingGeometry];
    SKNode *nodeInScroll = [self.spriteForScrollingGeometry nodeAtPoint:pointInScroll];
    
    // Important Conversion
    if ([nodeInScroll isKindOfClass:[CXStellarRingSprite class]])
    {
        nodeInScroll = nodeInScroll.parent;
    }
    
    // Priorities: Conditions > Scroll
    
    switch ([self.eventState integerValue]) {
        case 0:
            // Set an object so it can move.
            if ([nodeInScroll isKindOfClass:[CXStellarSprite class]])
            {
                [self setAmPaused:YES];
                [self setSavedObject:(CXStellarSprite *)nodeInScroll];
                [self attachMovementIndicatorTo:self.savedObject];
                [self setEventState:[NSNumber numberWithInteger:7]];
            }
            
            break;
            
        case 1:
            
            break;
            
        case 2:
            
            break;
            
        case 3:
            
            break;
            
        case 4:
            
            break;
        
        case 5:
            
            break;
        
        case 6:
            
            break;
        
        case 7:
            // If another long press, change it to that object
            if ([nodeInScroll isKindOfClass:[CXStellarSprite class]])
            {
                [self removeMovementIndicatorFrom:self.savedObject];
                [self setSavedObject:(CXStellarSprite *)nodeInScroll];
                [self attachMovementIndicatorTo:self.savedObject];
            }
            // Do not change condition yet, they may want to move this one!
            
            break;
        
        case 8:
            
            break;
        
        default:
            
            break;
    }
}

#pragma mark CXScene Scroll & Scaling Management
-(void)didChangeSize:(CGSize)oldSize
{
    CGSize size = [self size];
    CGPoint lowerLeft = CGPointMake(0, -size.height);
    [self.spriteForStaticGeometry setSize:size];
    [self.spriteForStaticGeometry setPosition:lowerLeft];
}

-(void)setContentSize:(CGSize)contentSize
{
    if (!(CGSizeEqualToSize(contentSize, _contentSize)))
    {
        _contentSize = contentSize;
        [self.spriteToScroll setSize:contentSize];
        [self.spriteForScrollingGeometry setSize:contentSize];
        [self.spriteForScrollingGeometry setPosition:CGPointMake(0, -contentSize.height)];
        [self.backgroundNode setSize:contentSize];
    }
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    contentOffset.x *= -1;
    [self.spriteToScroll setPosition:contentOffset];
}

-(void)setContentScale:(CGFloat)scale
{
    [self.spriteToScroll setScale:scale];
}

#pragma mark CXScene Initializer
-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        // Set AnchorPoint
        [self setAnchorPoint:(CGPoint){0,1}];
        
        // Set SpriteToScroll: (Scrolling,Scaling)
        SKSpriteNode *spriteToScroll = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:size];
        [spriteToScroll setAnchorPoint:(CGPoint){0,1}];
        [spriteToScroll setZPosition:kMySceneZPositionScrolling];
        [self addChild:spriteToScroll];
        
        // Set SpriteForScrollingGeometry: Affected by Scrolling
        SKSpriteNode *spriteForScrollingGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteForScrollingGeometry setAnchorPoint:(CGPoint){0,0}];
        [spriteForScrollingGeometry setPosition:(CGPoint){0,-size.height}];
        [spriteToScroll addChild:spriteForScrollingGeometry];
        
        // Set SpriteForStaticGeometry: Unaffected by Scrolling
        SKSpriteNode *spriteForStaticGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteForStaticGeometry setAnchorPoint:(CGPoint){0,0}];
        [spriteForStaticGeometry setPosition:(CGPoint){0,-size.height}];
        [spriteForStaticGeometry setZPosition:kMySceneZPositionStatic];
        [self addChild:spriteForStaticGeometry];
        
        // Set Background: Background color
        SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithColor:Rgb2UIColor(34, 70, 112) size:(CGSize){.width = size.width,.height = size.height}];
        [backgroundNode setName:@"BackgroundNode"];
        [backgroundNode setAnchorPoint:(CGPoint){0,0}];
        [spriteForScrollingGeometry addChild:backgroundNode];
        
        // Set TimeStepButton
        CXStagedButtonNode *timeStepButton = [[CXStagedButtonNode alloc]initWithImageNamedNeutral:@"TimeStepButton" StageB:@"TimeStepButton_S" StageC:@"TimeStepButton_P"];
        [timeStepButton setName:@"TimeStepButton"];
        [timeStepButton setTouchTarget:self action:@selector(switchTimeStep)];
        [timeStepButton setPosition:(CGPointMake(self.size.width - (timeStepButton.size.width/2) - padding , self.size.height - (timeStepButton.size.height/2)-padding))];
        [spriteForStaticGeometry addChild:timeStepButton];
        
        // Set the Object Limit
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int intObjectLimit = (int)[defaults integerForKey:@"SceneObjectLimit"];
        NSNumber *objectLimit = [NSNumber numberWithInt:intObjectLimit];
        
        // Set Object Number Indicator
        SKLabelNode *objectNumberLabel = [[SKLabelNode alloc]initWithFontNamed:font];
        [objectNumberLabel setFontSize:60.0f];
        [objectNumberLabel setText:[NSString stringWithFormat:@"%@",objectLimit]];
        [objectNumberLabel setPosition:(CGPoint){padding + (objectNumberLabel.frame.size.width/2), self.size.height - objectNumberLabel.frame.size.height - padding}];
        [spriteForStaticGeometry addChild:objectNumberLabel];
        
        // Setup Buttons
        CXButtonNode *addObjectButton = [[CXButtonNode alloc]initWithImageNamedNeutral:@"AddButton" Selected:@"AddButton_S"];
        CXButtonNode *addOrbitButton = [[CXButtonNode alloc]initWithImageNamedNeutral:@"OrbitButton" Selected:@"OrbitButton_S"];
        CXButtonNode *menuButton = [[CXButtonNode alloc]initWithImageNamedNeutral:@"MenuButton" Selected:@"MenuButton_S"];
        [addObjectButton setName:@"AddObjectButton"];
        [addOrbitButton setName:@"AddOrbitButton"];
        [menuButton setName:@"MenuButton"];
        [addObjectButton setTouchTarget:self action:@selector(showCatalogue)];
        [addOrbitButton setTouchTarget:self action:@selector(showOrbitPanel)];
        [menuButton setTouchTarget:self action:@selector(showManager)];
        
        
        NSArray *sceneButtons = @[addObjectButton,addOrbitButton,menuButton];
        CGFloat spacingGap = (self.size.width - ([sceneButtons count] * addOrbitButton.size.width))/([sceneButtons count]+1);
        CGFloat gapCounter = 0;
        // Set's positions for Buttons
        for (SKSpriteNode *node in sceneButtons)
        {
            CGFloat X = (node.size.width/2)+spacingGap+gapCounter;
            CGFloat Y = (node.size.height/2)+padding;
            CGPoint position = CGPointMake(X, Y);
            [node setPosition:position];
            [spriteForStaticGeometry addChild:node];
            gapCounter = X;
            gapCounter += (node.size.width/2);
        }
        // Set Properties
        _contentSize = size;
        _spriteToScroll = spriteToScroll;
        _spriteForScrollingGeometry = spriteForScrollingGeometry;
        _spriteForStaticGeometry = spriteForStaticGeometry;
        _backgroundNode = backgroundNode;
        _objectLimit = objectLimit;
        _objectNumberLabel = objectNumberLabel;
        _timeStepButton = timeStepButton;
        _sceneButtons = sceneButtons;
        _contentOffset = CGPointMake(0, 0);
        _sceneObjects = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark CXScene Physics

-(CXVector)displacementBetween:(CGPoint)a B:(CGPoint)b
{
    return (CXVector){b.x-a.x,b.y-a.y};
}

-(CGFloat)distanceBetween:(CGPoint)a B:(CGPoint)b
{
    CXVector displacement = [self displacementBetween:a B:b];
    CGFloat distance = sqrtf(powf(displacement.dx, 2)+powf(displacement.dy, 2));
    return distance;
}

-(void)updatePositions
{
    NSArray *objects = [NSArray arrayWithArray:_sceneObjects];
    for (CXStellarSprite *s in self.sceneObjects)
    {
        CXVector force = (CXVector){0,0};
        for (CXStellarSprite *i in objects)
        {
            if (![i isEqual:s])
            {
                CXVector displacement = [self displacementBetween:i.position B:s.position];
                CGFloat distance = [self distanceBetween:i.position B:s.position];
                CGFloat nForce = (-[_gravity integerValue] * i.mass)/(powf(distance, 2));
                CXVector unitVector = (CXVector){(displacement.dx/distance),(displacement.dy/distance)};
                force.dx += (nForce * unitVector.dx);
                force.dy += (nForce * unitVector.dy);
            } else {
                continue;
            }
        }
        
        CXVector velocity = s.velocity;
        velocity.dx += ([_timeStep floatValue] * force.dx);
        velocity.dy += ([_timeStep floatValue] * force.dy);
        
        CGPoint position = s.position;
        position.x += ([_timeStep floatValue] * velocity.dx);
        position.y += ([_timeStep floatValue] * velocity.dy);
        [s setVelocity:velocity];
        SKAction *move = [SKAction moveTo:position duration:0.0f];
        [s runAction:move];
    }
}


@end
