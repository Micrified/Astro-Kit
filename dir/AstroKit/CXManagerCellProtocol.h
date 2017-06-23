//
//  CXManagerCellProtocol.h
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CXManagerTableViewCell;

@protocol CXManagerCellProtocol <NSObject>
-(void)cellDidTouchRepositionButton:(CXManagerTableViewCell *)cell;
-(void)cellDidTouchRemoveButton:(CXManagerTableViewCell *)cell;
@end
