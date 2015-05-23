//
//  UserCenterCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/5/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "UserCenterCell.h"

@implementation UserCenterCell

- (void)awakeFromNib {
    // Initialization code
    [self.iconImageView addRoundCorner];
    [self.iconImageView setBorderWidth:2.f borderColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
