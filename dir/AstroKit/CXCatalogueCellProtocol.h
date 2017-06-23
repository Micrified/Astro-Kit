//
//  CXCatalogueCellProtocol.h
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CXCatalogueTableViewCell;

@protocol CXCatalogueCellProtocol <NSObject>
-(void)cellDidTouchEditButton:(CXCatalogueTableViewCell *)cell;
@end
