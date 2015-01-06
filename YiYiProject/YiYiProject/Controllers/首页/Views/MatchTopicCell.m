//
//  MatchTopicCell.m
//  YiYiProject
//
//  Created by soulnear on 14-12-20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "MatchTopicCell.h"

@implementation MatchTopicCell

- (void)awakeFromNib {
    // Initialization code
    _line_view.width = DEVICE_WIDTH;
    _title_label.width = DEVICE_WIDTH-24;
    _header_imageView.layer.cornerRadius = _header_imageView.width/2.0f;
    _header_imageView.layer.masksToBounds = YES;
    
    _jiantou_imageView.left = DEVICE_WIDTH - 27;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfoWith:(MatchTopicModel *)model
{
    [_header_imageView sd_setImageWithURL:[NSURL URLWithString:model.t_user_photo] placeholderImage:nil];
    _user_name_label.text = model.t_username;
    
    ///计算用户名占用的宽度
    CGFloat origin_x = 58 + [LTools widthForText:model.t_username font:15] + 10;
    _date_imageView.left = origin_x;
    _date_label.left = _date_imageView.right + 5;
    
    _pinglun_imageView.left = _date_label.right + 10;
    _pinglun_label.left = _pinglun_imageView.right+5;
    
    _date_label.text = [ZSNApi timechange:model.topic_last_post WithFormat:@"HH:mm"];
    _pinglun_label.text = model.topic_repost_num;
    
    _title_label.text = model.topic_title;
    
}























@end
