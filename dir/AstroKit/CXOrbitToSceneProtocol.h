//
//  CXOrbitToSceneProtocol.h
//  AstroKit
//
//  Created by Owatch on 6/22/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CXOrbitToSceneProtocol <NSObject>

#pragma mark CXOrbitToScene Methods
-(void)abortOrbitSetup;
-(void)finishOrbitSetup;

@end
