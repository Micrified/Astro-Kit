//
//  CXPopupToSceneProtocol.h
//  AstroKit
//
//  Created by Owatch on 6/20/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CXPopupToSceneProtocol <NSObject>

-(void)requestSliderWithValue:(int)value;
-(void)hasClosed;
-(void)requestSliderRemoval;

@end
