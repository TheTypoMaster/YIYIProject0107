//
//  TTaiBigPhotoCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/4/20.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "TTaiBigPhotoCell.h"
#import "TPlatModel.h"

@implementation TTaiBigPhotoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithModel:(TPlatModel *)aModel
{
    NSString *imageUrl = aModel.image[@"url"];
    CGFloat image_width = [aModel.image[@"width"]floatValue];
    CGFloat image_height = [aModel.image[@"height"]floatValue];
    
    self.bigImageView.height = [LTools heightForImageHeight:image_height imageWidth:image_width showWidth:DEVICE_WIDTH];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    
    self.bigImageView.imageUrls = @[imageUrl];//imageView对应的图集url
    self.bigImageView.infoId = aModel.tt_id;//imageView对应的信息id
    
    NSString *userImageUrl = aModel.uinfo[@"photo"];
    
    _iconImageView.layer.cornerRadius = 35/2.f;
    _iconImageView.clipsToBounds = YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userImageUrl] placeholderImage:DEFAULT_HEADIMAGE];
    self.nameLabel.text = aModel.uinfo[@"user_name"];
    self.timeLabel.text = [LTools timechange:aModel.add_time];
    
    self.zanNumLabel.text = aModel.tt_like_num;
    _zanNumLabel.width = [LTools widthForText:aModel.tt_like_num font:12] + 5;
    self.commentNumLabel.text = aModel.tt_comment_num;
    _commentNumLabel.width = [LTools widthForText:aModel.tt_comment_num font:12] + 5;
    
    _zanButton.selected = aModel.is_like == 1 ? YES : NO;
    
//    [self layoutSubviews];
}

@end
