//
//  CXPopupContainerNode.h
//  AstroKit
//
//  Created by Owatch on 5/30/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CXPopupContainerNode : SKSpriteNode

#pragma mark CXPopupContainerNode SKLabel Properties
@property (nonatomic,weak)SKLabelNode *massLabel;

#pragma mark CXPopupContainerNode Initializer Overrides
-(instancetype)initWithType:(NSString *)type Mass:(float)mass;

@end
