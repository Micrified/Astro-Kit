//
//  CXPopupContainerNode.m
//  AstroKit
//
//  Created by Owatch on 5/30/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXPopupContainerNode.h"

@implementation CXPopupContainerNode

#pragma mark CXPopupContainerNode: Designated Initializer
-(instancetype)init
{
    self = [self initWithType:@"None" Mass:0.0];
    return self;
}

-(instancetype)initWithType:(NSString *)type Mass:(float)mass
{
    self = [super initWithColor:[SKColor clearColor] size:(CGSize){100,100}];
    float padding = 30;
    SKLabelNode *typeLabel = [[SKLabelNode alloc]init];
    SKLabelNode *massLabel = [[SKLabelNode alloc]init];

    
    // Fetch Localized Descriptor Labels
    NSString *typeLabelString = [NSString stringWithFormat:NSLocalizedString(@"Type", nil)];
    NSString *massLabelString = [NSString stringWithFormat:NSLocalizedString(@"Mass", nil)];

    // Combine Descriptor Pieces
    NSArray *typeStrings = @[typeLabelString,type];
    NSArray *massStrings = @[massLabelString,[NSString stringWithFormat:@"%.0f u",mass]];
    
    [typeLabel setText:[typeStrings componentsJoinedByString:@": "]];
    [massLabel setText:[massStrings componentsJoinedByString:@": "]];

    [typeLabel setFontSize:20];
    [massLabel setFontSize:20];
    [typeLabel setFontName:@"HelveticaNeue"];
    [massLabel setFontName:@"HelveticaNeue"];
    [typeLabel setFontColor:[SKColor darkGrayColor]];
    [massLabel setFontColor:[SKColor darkGrayColor]];
    
    // Set Property
    [self setMassLabel:massLabel];
    
    // Set Positions of Labels
    [typeLabel setPosition:(CGPoint){0,0}];
    [massLabel setPosition:(CGPoint){0,(typeLabel.position.y - padding)}];

    // Add to self
    [self addChild:typeLabel];
    [self addChild:massLabel];

    return self;
}
@end
