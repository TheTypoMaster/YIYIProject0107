//
//  DynamicMessageCell.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/21.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "DynamicMessageCell.h"
#import "MessageModel.h"

@implementation DynamicMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCellWithModel:(MessageModel *)aModel
{
    self.iconImageView.layer.cornerRadius = _iconImageView.width / 2.f;
    _iconImageView.layer.masksToBounds = YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:aModel.photo] placeholderImage:nil];
    self.nameLabel.text = aModel.from_username;
    self.contentLabel.text = aModel.content;
}

@end
