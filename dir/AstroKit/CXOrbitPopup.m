//
//  CXOrbitPopup.m
//  AstroKit
//
//  Created by Owatch on 6/21/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXOrbitPopup.h"


@implementation CXOrbitPopup

#pragma mark CXOrbitPopup Tap Handling
-(void)actionForTappedNode:(SKNode *)node
{
    if ([node isEqual:self.exitButton])
    {
        [self.exitButton fire];
    } else if ([node isEqual:self.checkButton])
    {
        [self.checkButton fire];
    } else {

    }
}


#pragma mark CXOrbitPopup Methods
-(void)setParentToImageNamed:(NSString *)image
{
    [self.parentPlaceholder setTexture:[SKTexture textureWithImageNamed:image]];
    [self.childPlaceholder setTexture:[SKTexture textureWithImageNamed:@"ActiveIcon"]];
}

-(void)setChildToImageNamed:(NSString *)image
{
    [self.childPlaceholder setTexture:[SKTexture textureWithImageNamed:image]];
}

-(void)requestParent
{

}

-(void)requestChild
{

}

#pragma mark CXOrbitPopup Button Methods
-(void)confirmOrbit
{
    id<CXOrbitToSceneProtocol>delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(finishOrbitSetup)])
    {
        [delegate finishOrbitSetup];
    }
}

-(void)abortOrbit
{
    id<CXOrbitToSceneProtocol>delegate = self.myDelegate;
    if ([delegate respondsToSelector:@selector(abortOrbitSetup)])
    {
        [delegate abortOrbitSetup];
    }
}

#pragma mark CXOrbitPopup Designated Initializer
-(instancetype)init
{
    self = [super init];
    
    int padding = 10;
    
    // Create Base
    SKShapeNode *base = [[SKShapeNode alloc]init];
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.8, [UIScreen mainScreen].bounds.size.height * 0.25);
    [base setPath:CGPathCreateWithRoundedRect(frame, 20, 20, nil)];
    [base setStrokeColor:[SKColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]];
    [base setFillColor:[SKColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]];
    [base setPosition:(CGPoint){-(base.frame.size.width/2),0}];
    [self setBase:base];
    
    // Create Buttons
    CXButtonNode *exitButton = [[CXButtonNode alloc]initWithImageNamedNeutral:@"Popup_ExitButton" Selected:@"Popup_ExitButton_S"];
    CXButtonNode *checkButton = [[CXButtonNode alloc]initWithImageNamedNeutral:@"Popup_CheckButton" Selected:@"Popup_CheckButton_S"];
    [exitButton setTouchTarget:self action:@selector(abortOrbit)];
    [checkButton setTouchTarget:self action:@selector(confirmOrbit)];
    
    CGFloat scale = (base.frame.size.width * 0.15)/(exitButton.size.width);
    
    [exitButton setScale:scale];
    [checkButton setScale:scale];
    
    _exitButton = exitButton;
    _checkButton = checkButton;
    
    // Position Buttons
    [exitButton setPosition:(CGPoint){base.frame.size.width - (0.4 * exitButton.size.width) - padding ,(0.4 * exitButton.size.height)+padding}];
    [checkButton setPosition:(CGPoint){0 + (0.4 * checkButton.size.width) + padding,0 + (0.4 * checkButton.size.height)+padding}];
    
    
    // Setup Asset Nodes
    SKSpriteNode *parentPlaceholder = [[SKSpriteNode alloc]initWithImageNamed:@"ActiveIcon"];
    [parentPlaceholder setScale:(base.frame.size.height * 0.50/parentPlaceholder.size.width)];
    [parentPlaceholder setPosition:(CGPoint){base.frame.size.width * 0.35,base.frame.size.height * 0.5}];
    [self setParentPlaceholder:parentPlaceholder];
    
    SKSpriteNode *childPlaceholder = [[SKSpriteNode alloc]initWithImageNamed:@"InactiveIcon"];
    [childPlaceholder setScale:(base.frame.size.height * 0.25/childPlaceholder.size.width)];
    [childPlaceholder setPosition:(CGPoint){base.frame.size.width * 0.65, base.frame.size.height * 0.5}];
    [self setChildPlaceholder:childPlaceholder];
    
    // Setup Label
    SKLabelNode *title = [[SKLabelNode alloc]initWithFontNamed:@"HelveticaNeue"];
    [title setText:@"Orbit Setup"];
    [title setFontSize:20];
    [title setFontColor:[UIColor darkGrayColor]];
    CGPoint titlePosition  = CGPointMake(base.frame.size.width/2, base.frame.size.height - title.frame.size.height - 5);
    [title setPosition:titlePosition];
    [self setTitle:title];
    
    [self addChild:base];
    [base addChild:title];
    [base addChild:parentPlaceholder];
    [base addChild:childPlaceholder];
    [base addChild:exitButton];
    [base addChild:checkButton];
    
    return self;
}



@end
