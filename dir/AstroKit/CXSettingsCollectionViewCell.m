//
//  CXSettingsCollectionViewCell.m
//  AstroKit
//
//  Created by Charles Randolph on 8/17/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXSettingsCollectionViewCell.h"

@implementation CXSettingsCollectionViewCell

- (void)awakeFromNib {
    [self.colorItem.layer setCornerRadius:(_colorItem.frame.size.height/2)];
}

@end
