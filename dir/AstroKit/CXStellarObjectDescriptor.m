//
//  CXStellarObjectDescriptor.m
//  AstroKit
//
//  Created by Owatch on 5/30/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXStellarObjectDescriptor.h"

@implementation CXStellarObjectDescriptor

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    _name = [dict objectForKey:@"Name"];
    _type = [dict objectForKey:@"Type"];
    _imageName = [dict objectForKey:@"ImageName"];
    _ringImageName = [dict objectForKey:@"RingImageName"];
    _mass = [[dict objectForKey:@"Mass"] floatValue];
    _scale = [[dict objectForKey:@"Scale"] floatValue];
    return self;
}

@end
