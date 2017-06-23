//
//  CXMenuTableViewCell.h
//  AstroKit
//
//  Created by Owatch on 5/25/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXMenuTableViewCell : UITableViewCell

#pragma mark CXMenuTableViewCell: UILabel Properties
@property (nonatomic,weak)IBOutlet UILabel *title;

#pragma mark CXMenuTableViewCell: UIImageView Properties
@property (nonatomic,weak)IBOutlet UIImageView *image;


@end
