//
//  MailMessageCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MailMessageCell.h"

#import "MessageModel.h"
#import "ActivityModel.h"

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
- (void)setCellWithModel:(id)aModel cellType:(Cell_Type)aType seeAll:(BOOL)seeAll
{
    CGFloat top = 12;
    
    NSString *name;
    NSString *photo;
    NSString *title;
    NSString *image_url;
    NSString *content;
    NSString *time;
    
    CGFloat image_height = 0.f;
    CGFloat image_width = 0.f;
    
    //消息
    if ([aModel isKindOfClass:[MessageModel class]]) {
        
        MessageModel *model = (MessageModel *)aModel;
        title = model.title;
        image_url = model.pic;
        content = model.content;
        name = model.from_username;
        photo = model.photo;
        time = model.send_time;
        
        image_height = [model.pic_height floatValue];
        image_width = [model.pic_width floatValue];
        
        NSLog(@"--> %f %f",image_height,image_width);
    }
    //活动
    else if ([aModel isKindOfClass:[ActivityModel class]]){
        
        ActivityModel *model = (ActivityModel *)aModel;
        title = model.activity_title;
        image_url = model.pic;
        content = model.activity_info;
        time = model.add_time;
        
        image_height = [model.pic_height floatValue];
        image_width = [model.pic_width floatValue];
    }
    
    if (aType == icon_Yes) {
        
        top = self.userView.bottom + 12;
        
        self.iconImageView.layer.cornerRadius = _iconImageView.width / 2.f;
        _iconImageView.layer.masksToBounds = YES;
        self.nameLabel.text = name;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:nil];
        
    }else
    {
        self.userView.hidden = YES;
        
        top = 12;
    }
    
    //标题
    self.aTitleLabel.top = top;
    self.aTitleLabel.text = title;
    CGFloat height = [LTools heightForText:title width:_aTitleLabel.width font:16];
    _aTitleLabel.height = height;
    
    //时间
    self.timeLabel.text = [LTools timechangeMMDD:time];
    _timeLabel.top = _aTitleLabel.bottom + 10;
    
    //图片
    self.centerImageView.top = _timeLabel.bottom + 12;
    //有图
    if (image_url.length > 0 && [image_url hasPrefix:@"http://"]) {
        
//        CGFloat ratio = 274 / 156;
        
        CGFloat ratio = image_height == 0 ? 0 : (image_width / image_height);
        
        CGFloat realWidth = (DEVICE_WIDTH - 46) / 1.f;
        CGFloat needHeight = ratio == 0 ? 0 : realWidth / ratio;
        
        _centerImageView.height = needHeight;
        
        top = _centerImageView.bottom + 10;
        
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:nil];
        
    }else
    {
        _centerImageView.height = 0;
        top = _centerImageView.bottom;
    }
    //摘要
    
    _contentLabel.top = top;
    height = [LTools heightForText:content width:_contentLabel.width font:13];
    self.contentLabel.height = height;
    _contentLabel.text = content;
    
    
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

+ (CGFloat)heightForModel:(id)aModel cellType:(Cell_Type)aType  seeAll:(BOOL)seeAll
{
    CGFloat aHeight = 0;
    
    if (aType == icon_Yes) {
        
        aHeight += (55 + 12);//用户信息view高度 + 间距12
    }else
    {
        aHeight = 12;
    }
    
    NSString *title;
    NSString *image_url;
    NSString *content;
    
    CGFloat image_height = 0.f;
    CGFloat image_width = 0.f;
    
    //消息
    if ([aModel isKindOfClass:[MessageModel class]]) {
        
        MessageModel *model = (MessageModel *)aModel;
        title = model.title;
        image_url = model.pic;
        content = model.content;
        image_height = [model.pic_height floatValue];
        image_width = [model.pic_width floatValue];
        
    }
    //活动
    else if ([aModel isKindOfClass:[ActivityModel class]]){
        
        ActivityModel *model = (ActivityModel *)aModel;
        title = model.activity_title;
        image_url = model.pic;
        content = model.activity_info;
        
        image_height = [model.pic_height floatValue];
        image_width = [model.pic_width floatValue];
    }
    
    //标题高度
    CGFloat aWidth = DEVICE_WIDTH/2.f - 23;
    CGFloat height = [LTools heightForText:title width:aWidth font:16];
    
    aHeight += height;
    
    //时间高度
    
    aHeight += (15 + 10);
    
    //图片
    if (image_url.length > 0 && [image_url hasPrefix:@"http://"])
    {
        
//        CGFloat ratio = 274 / 156;
        
        CGFloat ratio = image_height == 0 ? 0 : (image_width / image_height);
        
        CGFloat realWidth = (DEVICE_WIDTH - 46) / 1.f;
        CGFloat needHeight = ratio == 0 ? 0 : realWidth / ratio;
        
        aHeight += (needHeight + 12 + 10);//图片高度 + 上面间距 + 下间距
    }else
    {
        aHeight += 12;
    }
    
    //内容高度
    height = [LTools heightForText:content width:aWidth font:13];
    
    aHeight += height;
    
    if (seeAll) {
        
       aHeight += (15 + 45 + 15);
    }else
    {
        aHeight += (15 + 15);
    }
    
    NSLog(@"---%@",NSStringFromFloat(aHeight));
    
    return aHeight;
}

@end
