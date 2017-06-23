//
//  CXStellarSystem.h
//  AstroKit
//
//  Created by Charles Randolph on 7/6/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXStellarObjectDescriptor.h"


@interface CXStellarSystemDescriptor : NSObject

#pragma mark CXStellarSystemDescriptor NSString Properties
@property (nonatomic,strong)NSString *name;

#pragma mark CXStellarSystemDescriptor CXStellarObjectDescriptor Properties
@property (nonatomic,strong)CXStellarObjectDescriptor *parent;

#pragma mark CXStellarSystemDescriptor NSArray Properties
@property (nonatomic,strong)NSArray *satellites;
@property (nonatomic,strong)NSArray *offsets;

#pragma mark CXStellarSystemDescriptor Designated Initializers
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
