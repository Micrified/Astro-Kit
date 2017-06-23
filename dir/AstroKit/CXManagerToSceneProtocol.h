//
//  CXManagerToSceneProtocol.h
//  AstroKit
//
//  Created by Owatch on 6/21/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CXManagerToSceneProtocol <NSObject>

#pragma mark CXManagerToScene Methods
-(void)setRepositionForObjectAtIndex:(NSUInteger)index;
-(void)removeSceneObjectAtIndex:(NSUInteger)index;
-(void)userAborted;

@end
