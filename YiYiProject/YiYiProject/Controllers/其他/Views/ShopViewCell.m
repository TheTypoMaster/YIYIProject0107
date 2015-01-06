//
//  BrandViewCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ShopViewCell.h"

@implementation ShopViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithModel:(MailModel *)aModel
{
    self.cancelButton.layer.cornerRadius = 3.f;
    self.cancelButton.layer.borderColor = [UIColor colorWithHexString:@"ef7186"].CGColor;
    self.cancelButton.layer.borderWidth = 1.f;
    self.nameLabel.text = aModel.mall_name;
    self.addressLabel.text = aModel.address;
}

@end
