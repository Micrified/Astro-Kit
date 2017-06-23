//
//  CXGameScrollView.h
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "CXScene.h"

@interface CXGameScrollView : UIScrollView

#pragma mark CXGameScrollView SKScene Properties
@property (nonatomic,strong)CXScene *gameScene;

#pragma mark CXGameScrollView Boolean Properties 
@property (nonatomic)BOOL isScrolling;
@property (nonatomic)BOOL hasObjectSelected;

@end
