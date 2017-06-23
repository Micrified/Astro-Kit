//
//  CXPopupInterfaceNode.m
//  AstroKit
//
//  Created by Owatch on 5/30/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXPopupInterfaceNode.h"

@interface CXPopupInterfaceNode ()

@property (nonatomic)int padding;


@end

@implementation CXPopupInterfaceNode
@synthesize padding;

#pragma mark CXPopupInterfaceNode: Tap handling for Interface: (Criticial)
-(void)actionForTappedNode:(SKNode *)node
{
    if ([node isKindOfClass:[CXButtonNode class]])
    {
        [(CXButtonNode *)node fire];
    }
}

#pragma mark CXPopupInterfaceNode: Popup Creation Methods

-(void)presentInfoInterfaceFor:(CXStellarSprite *)planet
{
    // Set Current Object
    _currentObject = planet;
    
    // Create Overlay
    SKShapeNode *overlay = [[SKShapeNode alloc]init];
    [overlay setPath:CGPathCreateWithRoundedRect((CGRect){0,0,280,440}, 20, 20, nil)];
    overlay.strokeColor = overlay.fillColor = [SKColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    
    // Create Background Tint
    SKSpriteNode *tintOverlay = [[SKSpriteNode alloc]initWithColor:[SKColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6] size:CGSizeMake(self.scene.size.width, self.scene.size.height)];
    
    // Create Buttons, Images and Labels
    CXButtonNode *exitButton = [[CXButtonNode alloc]initWithImageNamedNeutral:@"Popup_ExitButton" Selected:@"Popup_ExitButton_S"];
    CXButtonNode *editButton = [[CXButtonNode alloc]initWithImageNamedNeutral:@"Popup_EditButton" Selected:@"Popup_EditButton_S"];
    CXButtonNode *recycleButton = [[CXButtonNode alloc]initWithImageNamedNeutral:@"Popup_TrashButton" Selected:@"Popup_TrashButton"];
    SKLabelNode *titleLabel = [[SKLabelNode alloc]init];
    
    CXPopupContainerNode *descriptorContainer = [[CXPopupContainerNode alloc]initWithType:self.currentObject.type Mass:self.currentObject.mass];
    
    
    SKSpriteNode *displayImage = [[SKSpriteNode alloc]initWithImageNamed:[NSString stringWithFormat:@"%@",planet.imageName]];
    
    // Configure Buttons and Labels
    [exitButton setName:@"exitButton"];
    [editButton setName:@"editButton"];
    [recycleButton setName:@"recycleButton"];
    [titleLabel setName:@"titleLabel"];
    [descriptorContainer setName:@"descriptorContainer"];
    [exitButton setScale:0.8];
    [editButton setScale:0.8];
    [recycleButton setScale:0.8];
    [titleLabel setText:planet.objectName];
    [titleLabel setFontName:@"HelveticaNeue"];
    [titleLabel setFontColor:[SKColor darkGrayColor]];
    [titleLabel setFontSize:30.0];
    
    // Set Button Selectors
    [exitButton setTouchTarget:self action:@selector(removeInterface)];
    [editButton setTouchTarget:self action:@selector(presentEditInterface)];
    [recycleButton setTouchTarget:self action:@selector(removeCurrentObject)];
    
    // Set Positions
    [overlay setPosition:(CGPoint){-(overlay.frame.size.width/2),-(overlay.frame.size.height/2)}];
    [tintOverlay setPosition:(CGPoint){0,0}];
    [tintOverlay setZPosition:-1];
    
    [exitButton setPosition:(CGPoint){overlay.frame.size.width - (0.4 * exitButton.size.width) - padding, (0.4 * exitButton.size.height)+padding}];
    [editButton setPosition:(CGPoint){0 + (0.4 * editButton.size.width) + padding, (0.4 * editButton.size.height)+padding}];
    [recycleButton setPosition:(CGPoint){overlay.frame.size.width/2, (0.4 * recycleButton.size.height)+padding}];
    [titleLabel setPosition:(CGPoint){overlay.frame.size.width/2,overlay.frame.size.height - titleLabel.frame.size.height - padding}];
    [descriptorContainer setPosition:(CGPoint){overlay.frame.size.width/2, overlay.frame.size.height/2}];
    [displayImage setPosition:(CGPoint){overlay.frame.size.width/2,overlay.frame.size.height * 3/4}];
    
    // Set Links
    _currentOverlay = overlay;
    _exitButton = exitButton;
    _editButton = editButton;
    _recycleButton = recycleButton;
    _titleLabel = titleLabel;
    _descriptorContainer = descriptorContainer;
    _displayImage = displayImage;
    
    //Add Components to Overlay
    [self addChild:overlay];
    [self addChild:tintOverlay];
    [overlay addChild:exitButton];
    [overlay addChild:editButton];
    [overlay addChild:recycleButton];
    [overlay addChild:titleLabel];
    [overlay addChild:descriptorContainer];
    [overlay addChild:displayImage];
    
    // Rotate Image
    [self rotateImage];
    
}

-(void)presentEditInterface
{
    
    [self stopImageRotation];
    // Create Overlay
    SKShapeNode *overlay = [[SKShapeNode alloc]init];
    [overlay setPath:CGPathCreateWithRoundedRect((CGRect){0,0,280,180}, 20, 20, nil)];
    overlay.strokeColor = overlay.fillColor = [SKColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    
    // Create Background Tint
    SKSpriteNode *tintOverlay = [[SKSpriteNode alloc]initWithColor:[SKColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6] size:CGSizeMake(self.scene.size.width, self.scene.size.height)];
    
    // Create Buttons and Labels
    CXButtonNode *exitButton = [[CXButtonNode alloc]initWithImageNamedNeutral:@"Popup_ExitButton"  Selected:@"Popup_ExitButton_S"];
    CXButtonNode *checkButton = [[CXButtonNode alloc]initWithImageNamedNeutral:@"Popup_CheckButton" Selected:@"Popup_CheckButton_S"];

    SKLabelNode *titleLabel = [[SKLabelNode alloc]init];
    SKLabelNode *dataLabel = [[SKLabelNode alloc]init];
    
    // Configure Buttons and Labels
    [exitButton setName:@"exitButton"];
    [checkButton setName:@"editButton"];
    [titleLabel setName:@"titleLabel"];
    [dataLabel setName:@"dataLabel"];
    [exitButton setScale:0.8];
    [checkButton setScale:0.8];
    [titleLabel setText:@"Adjust Mass"];
    [titleLabel setFontName:@"HelveticaNeue"];
    [titleLabel setFontColor:[SKColor darkGrayColor]];
    [titleLabel setFontSize:30.0];
    [dataLabel setText:[NSString stringWithFormat:@"%.0f u",self.currentObject.mass]];
    [dataLabel setFontName:@"HelveticaNeue"];
    [dataLabel setFontColor:[SKColor darkGrayColor]];
    [dataLabel setFontSize:20];
    
    // Set Button Selectors
    [exitButton setTouchTarget:self action:@selector(removeEditInterface)];
    [checkButton setTouchTarget:self action:@selector(saveAndRemoveEditInterface)];
    
    // Set Positions
    [overlay setPosition:(CGPoint){-(overlay.frame.size.width/2),-(overlay.frame.size.height/2)}];
    [overlay setZPosition:2];
    [tintOverlay setPosition:(CGPoint){overlay.frame.size.width/2,overlay.frame.size.height/2}];
    [tintOverlay setZPosition:-1];
    
    [exitButton setPosition:(CGPoint){overlay.frame.size.width - (0.4 * exitButton.size.width) - padding ,0 + (0.4 * exitButton.size.height)+padding}];
    [checkButton setPosition:(CGPoint){0 + (0.4 * checkButton.size.width) + padding,0 + (0.4 * checkButton.size.height)+padding}];
    [titleLabel setPosition:(CGPoint){overlay.frame.size.width/2,overlay.frame.size.height - titleLabel.frame.size.height - padding}];
    [dataLabel setPosition:(CGPoint){overlay.frame.size.width/2,overlay.frame.size.height - titleLabel.frame.size.height - dataLabel.frame.size.height - 20}];
    
    // Set Links
    _temporaryOverlay = overlay;
    _exitButton = exitButton;
    _checkButton = checkButton;
    _titleLabel = titleLabel;
    _dataLabel = dataLabel;
    
    //Add Components to Overlay
    [self addChild:overlay];
    [overlay addChild:tintOverlay];
    [overlay addChild:exitButton];
    [overlay addChild:checkButton];
    [overlay addChild:titleLabel];
    [overlay addChild:dataLabel];
    
    // Show the Slider:
    id <CXPopupToSceneProtocol>delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(requestSliderWithValue:)])
    {
        int mass = self.currentObject.mass;
        [delegate requestSliderWithValue:mass];
    }
    
}


#pragma mark CXPopupInterfaceButton DisplayImage Methods
-(void)rotateImage
{
    SKAction *oneRevolution = [SKAction rotateByAngle:-M_PI*2 duration: 20.0];
    SKAction *repeat = [SKAction repeatActionForever:oneRevolution];
    if (_displayImage){
        [self.displayImage runAction:repeat withKey:@"rotate"];
    }
}

-(void)stopImageRotation
{
    [self.displayImage removeActionForKey:@"rotate"];
}


#pragma mark CXPopupInterfaceButton Actions

-(void)removeInterface
{
    
    _currentObject = nil;
    [self stopImageRotation];
    [self.currentOverlay removeAllChildren];
    [self removeChildrenInArray:@[self.currentOverlay]];
    _exitButton = nil;
    _checkButton = nil;
    _editButton = nil;
    _recycleButton = nil;
    _titleLabel = nil;
    _descriptorContainer = nil;
    _displayImage = nil;
    _currentOverlay = nil;
    [self removeAllChildren];
    [self.myDelegate hasClosed];
}

-(void)removeEditInterface
{
    
    id <CXPopupToSceneProtocol>delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(requestSliderRemoval)])
    {
        [delegate requestSliderRemoval];
    }
    [self rotateImage];
    // Revert Interface Properties to previous Overlay
    self.exitButton = (CXButtonNode *)[self.currentOverlay childNodeWithName:@"exitButton"];
    self.editButton = (CXButtonNode *)[self.currentOverlay childNodeWithName:@"editButton"];
    self.titleLabel = (SKLabelNode *)[self.currentOverlay childNodeWithName:@"titleLabel"];
    // Remove Edit Interface
    [self.temporaryOverlay removeAllChildren];
    [self removeChildrenInArray:@[self.temporaryOverlay]];
    _temporaryOverlay = nil;
}

-(void)saveAndRemoveEditInterface
{
    
    // Save Mass
    [self.currentObject setMass:(CGFloat)[self.dataLabel.text floatValue]];
    // Set Mass in Info
    NSString *massLabelText = [NSString stringWithFormat:NSLocalizedString(@"Mass", nil)];
    NSString *massLabelTextMass = [NSString stringWithFormat:@"%.0f u",[self.dataLabel.text floatValue]];
    NSArray *temporaryTextContainer = @[massLabelText,massLabelTextMass];
    
    [self.descriptorContainer.massLabel setText:[temporaryTextContainer componentsJoinedByString:@": "]];
    // Remove Edit Interface
    id <CXPopupToSceneProtocol>delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(requestSliderRemoval)])
    {
        [delegate requestSliderRemoval];
    }
    [self rotateImage];
    // Revert Interface Properties to previous Overlay
    self.exitButton = (CXButtonNode *)[self.currentOverlay childNodeWithName:@"exitButton"];
    self.editButton = (CXButtonNode *)[self.currentOverlay childNodeWithName:@"editButton"];
    self.titleLabel = (SKLabelNode *)[self.currentOverlay childNodeWithName:@"titleLabel"];
    // Remove Edit Interface
    [self.temporaryOverlay removeAllChildren];
    [self removeChildrenInArray:@[self.temporaryOverlay]];
    _temporaryOverlay = nil;
}

-(void)removeCurrentObject
{
    [self.currentObject setShouldRemove:YES];
    [self removeInterface];
}

#pragma mark CXPopupInterfaceNode: Designated Initialier
-(instancetype)init
{
    self = [super init];
    self.name = @"UISprite";
    [self setUserInteractionEnabled:YES];
    [self setPadding:10];
    return self;
}


@end
