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
    
//    MessageType_yiyiTeam = 1,//衣衣团队消息
//    MessageType_concernUser = 2,//关注用户消息
//    MessageType_concernShop = 12,//关注商家通知消息
//    MessageType_replyTopic = 3,//回复主题
//    MessageType_replyTopicReply = 4,//回复主题的回复
//    MessageType_replyTPlat = 5,//评论t台
//    MessageType_replyTPlatReply = 6,//回复t台评论
//    MessageType_promotionBrand = 7,//平铺促销
//    MessageType_promotionMarket = 8,//商场促销
//    MessageType_applyShopSuccess = 9,//申请店铺成功
//    MessageType_applyShopFail = 10,//申请店铺失败
    
    MessageType aType = [aModel.type intValue];
    if (aType == MessageType_applyShopSuccess || aType == MessageType_applyShopFail) {
        //不需要查看全文
        self.seeAllView.hidden = YES;//高度减45
    }else
    {
        self.seeAllView.hidden = NO;
    }
}

+ (CGFloat)heightForWithModel:(MessageModel *)aModel
{
    CGFloat aHeight = 0.f;

    MessageType aType = [aModel.type intValue];
    
//    aType == MessageType_concernUser 关注用户调整至粉丝
    
    if (aType == MessageType_applyShopSuccess || aType == MessageType_applyShopFail) {
        //不需要查看全文
        aHeight = 45 + 55 + 50 - 45;
    }else
    {
        aHeight = 45 + 55 + 50;
    }
    return aHeight;
}

@end
