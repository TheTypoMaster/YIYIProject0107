//
//  MailMessageCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MailMessageCell.h"

@implementation MailMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  <#Description#>
 *
 *  @param aModel 消息model
 *  @param aType  是否有头像
 *  @param seeAll 是否有 查看全文
 */
- (void)setCellWithModel:(MessageModel *)aModel cellType:(Cell_Type)aType seeAll:(BOOL)seeAll
{
    CGFloat top = 12;
    
    if (aType == icon_Yes) {
        
        top = self.userView.bottom + 12;
        
        self.iconImageView.layer.cornerRadius = _iconImageView.width / 2.f;
        _iconImageView.layer.masksToBounds = YES;
        self.nameLabel.text = aModel.from_username;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:aModel.photo] placeholderImage:nil];
        
    }else
    {
        self.userView.hidden = YES;
    }
    //标题
    self.aTitleLabel.top = top;
    self.aTitleLabel.text = aModel.title;
    CGFloat height = [LTools heightForText:aModel.title width:_aTitleLabel.width font:16];
    _aTitleLabel.height = height;
    
    //时间
    self.timeLabel.text = [LTools timechangeMMDD:aModel.send_time];
    _timeLabel.top = _aTitleLabel.bottom + 10;
    
    //图片
    self.centerImageView.top = _timeLabel.bottom + 12;
    //有图
    if (aModel.pic.length > 0 && [aModel.pic hasPrefix:@"http://"]) {
        
        CGFloat ratio = 274 / 156;
        CGFloat realWidth = (DEVICE_WIDTH - 46) / 2.f;
        CGFloat needHeight = realWidth / ratio;
        
        _centerImageView.height = needHeight;
        
        top = _centerImageView.bottom + 10;
        
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:aModel.pic] placeholderImage:nil];
        
    }else
    {
        _centerImageView.height = 0;
        top = _centerImageView.bottom;
    }
    //摘要
    
    _contentLabel.top = top;
    height = [LTools heightForText:aModel.content width:_contentLabel.width font:13];
    self.contentLabel.height = height;
    _contentLabel.text = aModel.content;
    
    
    if (seeAll) {
        //底部
        
        self.bottomBackView.top = _contentLabel.bottom + 15;
        
        //背景view
        self.bigBackView.height = _bottomBackView.bottom;
        
        self.bottomBackView.hidden = NO;
    }else
    {
        
        self.bottomBackView.hidden = YES;
        
        //背景view
        self.bigBackView.height = _contentLabel.bottom + 15;
    }
    
    
    self.clickButton.userInteractionEnabled = NO;
    
}

+ (CGFloat)heightForModel:(MessageModel *)aModel cellType:(Cell_Type)aType  seeAll:(BOOL)seeAll
{
    CGFloat aHeight = 0;
    
    if (aType == icon_Yes) {
        
        aHeight += (55 + 12);//用户信息view高度 + 间距12
    }
    //标题高度
    CGFloat aWidth = DEVICE_WIDTH/2.f - 23;
    CGFloat height = [LTools heightForText:aModel.title width:aWidth font:16];
    
    aHeight += height;
    
    //时间高度
    
    aHeight += (15 + 10);
    
    //图片
    if (aModel.pic.length > 0 && [aModel.pic hasPrefix:@"http://"])
    {
        CGFloat ratio = 274 / 156;
        CGFloat realWidth = (DEVICE_WIDTH - 46) / 2.f;
        CGFloat needHeight = realWidth / ratio;
        
        aHeight += (needHeight + 12 + 10);//图片高度 + 上面间距 + 下间距
    }else
    {
        aHeight += 12;
    }
    
    //内容高度
    height = [LTools heightForText:aModel.content width:aWidth font:13];
    
    aHeight += height;
    
    if (seeAll) {
        
       aHeight += (15 + 45 + 15);
    }else
    {
        aHeight += (15 + 15);
    }
    
    return aHeight;
}

@end
