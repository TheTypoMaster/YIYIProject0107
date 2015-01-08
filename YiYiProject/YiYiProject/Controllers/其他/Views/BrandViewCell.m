//
//  ShopViewCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BrandViewCell.h"

@implementation BrandViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithModel:(BrandModel *)aModel
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:aModel.brand_logo] placeholderImage:nil];
    self.nameLabel.text = aModel.brand_name;
    
    self.cancelButton.layer.cornerRadius = 3.f;
    self.cancelButton.layer.borderColor = [UIColor colorWithHexString:@"ef7186"].CGColor;
    self.cancelButton.layer.borderWidth = 1.f;
    
    self.iconImageView.layer.cornerRadius = 35.f;
    self.iconImageView.clipsToBounds = YES;
}

@end
