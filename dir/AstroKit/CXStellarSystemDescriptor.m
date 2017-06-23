//
//  CXStellarSystem.m
//  AstroKit
//
//  Created by Charles Randolph on 7/6/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXStellarSystemDescriptor.h"

@implementation CXStellarSystemDescriptor

#pragma mark CXStellarSystemDescriptor Designated Initializers

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        // Get Name
        NSString *name = [dictionary valueForKey:@"Name"];
        
        // Create Parent Object
        CXStellarObjectDescriptor *parent = [[CXStellarObjectDescriptor alloc]initWithDictionary:[dictionary valueForKey:@"Parent"]];
        // Create Satellite Objects
        NSArray *satelliteDictionaries = [dictionary valueForKey:@"Satellites"];
        NSMutableArray *satellites = [[NSMutableArray alloc]init];
        for (NSDictionary *dictionary in satelliteDictionaries)
        {
            CXStellarObjectDescriptor *satellite = [[CXStellarObjectDescriptor alloc]initWithDictionary:dictionary];
            [satellites addObject:satellite];
        }
        // Create Offsets
        NSArray *satelliteOffsets = [dictionary valueForKey:@"Offsets"];
        
        // Set Properties
        _name = name;
        _parent = parent;
        _satellites = satellites;
        _offsets = satelliteOffsets;
    }
    return self;
}

@end
