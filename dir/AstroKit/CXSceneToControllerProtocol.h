//
//  CXSceneToControllerProtocol.h
//  AstroKit
//
//  Created by Owatch on 6/19/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CXSceneToControllerProtocol <NSObject>

#pragma mark CXGameSceneToControllerProtocol Methods
-(void)switchToCatalogue;
-(void)switchToManager;
-(void)showSliderWithValue:(int)value;
-(void)hideSlider;
-(void)moveScrollViewWithOffset:(CGVector)offset;

@end
