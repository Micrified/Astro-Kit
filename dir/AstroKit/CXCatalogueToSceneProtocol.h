//
//  CXManagerToSceneProtocol.h
//  AstroKit
//
//  Created by Owatch on 6/20/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CXCatalogueToSceneProtocol <NSObject>

-(void)addStellarSystemWith:(CXStellarSystemDescriptor *)descriptor;
-(void)addStellarSpriteWith:(CXStellarObjectDescriptor *)descriptor;
-(void)userAborted;

@end
