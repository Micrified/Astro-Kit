//
//  CXPopupInterfaceButtonNode.h
//  AstroKit
//
//  Created by Owatch on 5/30/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CXPopupInterfaceButtonNode : SKSpriteNode

#pragma mark CXPopupInterfaceButtonNode: Action Assignment Methods
-(void)performAssignedSelector;
-(void)setTouchDownTarget:(id)target action:(SEL)action;
-(void)setTouchUpTarget:(id)target action:(SEL)action;

#pragma mark CXPopupInterfaceButtonNode: Selected Method
-(void)setIsSelected:(BOOL)isSelected;
-(void)toggle;

#pragma mark CXPopupInterfaceButtonNode: Designated Initializer
-(instancetype)initWithImageNamedNeutral:(NSString *)neutral selected:(NSString *)selected;

@end
