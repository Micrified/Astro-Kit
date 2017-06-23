//
//  CXStellarObjectDescriptor.h
//  AstroKit
//
//  Created by Owatch on 5/30/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXStellarObjectDescriptor : NSObject
#pragma mark CXStellarObjectDescriptor Boolean Properties
@property (nonatomic) BOOL hasRings;
#pragma mark CXStellarObjectDescriptor NSString Properties
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) NSString *ringImageName;
#pragma mark CXStellarObjectDescriptor float Properties
@property (nonatomic) float mass;
@property (nonatomic) float scale;
#pragma mark CXStellarObjectDescriptor Methods

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
