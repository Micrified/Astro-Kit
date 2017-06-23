//
//  CXGameViewController.h
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "CXScene.h"
#import "CXGameScrollView.h"
#import "CXGameCatalogueViewController.h"
#import "CXGameManagerViewController.h"
#import "CXSceneToControllerProtocol.h"
#import "CXStellarObjectDescriptor.h"
#import "CXStellarSystemDescriptor.h"

@class CXGameCatalogueViewController; // Forward Declared to Avoid Circular Incursion
@class CXGameManagerViewController;

@interface CXGameViewController : UIViewController <SKSceneDelegate, UIScrollViewDelegate, CXSceneToControllerProtocol>

#pragma mark CXGameViewController SKScene Properties
@property (nonatomic,strong)CXScene *gameScene;

#pragma mark CXGameViewController NSArray Properties
@property (nonatomic,strong)NSArray *stellarObjects;
@property (nonatomic,strong)NSArray *stellarSystems; 

#pragma mark CXGameViewController UIViewController Properties
@property (nonatomic,strong)CXGameCatalogueViewController *gameCatalogueViewController;
@property (nonatomic,strong)CXGameManagerViewController *gameManagerViewController;

#pragma mark CXGameViewController UIView Properties
@property (nonatomic,strong)UIView *clearFrame;

#pragma mark CXGameViewController UIScrollView Properties
@property (nonatomic,strong)CXGameScrollView *scrollView;

#pragma mark CXGameViewController UISlider Properties
@property (nonatomic,strong)UISlider *slider;


@end
