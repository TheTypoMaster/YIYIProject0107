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
 *  cell赋值
 *
 *  @param aModel 消息model
 *  @param aType  是否有头像
 *  @param seeAll 是否有 查看全文
 *  @param timeType 显示时间类型 开始和结束 发布时间
 */
- (void)setCellWithModel:(id)aModel
                  seeAll:(BOOL)seeAll
                timeType:(TimeType)timeType
{
    CGFloat top = 12;
    
    NSString *name;
    NSString *photo;
    NSString *title;
    NSString *image_url;
    NSString *content;
    NSString *starttime;
    NSString *endtime;
    
    NSString *sendTime;//发送时间
    
    CGFloat image_height = 0.f;
    CGFloat image_width = 0.f;
    
    BOOL isActivity = NO;//是否是活动
    
    //消息
    if ([aModel isKindOfClass:[MessageModel class]]) {
        
        isActivity = NO;
        MessageModel *model = (MessageModel *)aModel;
        title = model.title;
        image_url = model.pic;
        content = model.content;
        name = model.from_username;
        photo = model.photo;
        starttime = model.start_time;
        endtime = model.end_time;
        image_height = [model.pic_height floatValue];
        image_width = [model.pic_width floatValue];
        sendTime = model.send_time;
    }
//    //活动
//    else if ([aModel isKindOfClass:[ActivityModel class]]){
//        
//        isActivity = YES;
//        ActivityModel *model = (ActivityModel *)aModel;
//        title = model.activity_title;
//        image_url = model.cover_pic;
//        content = model.activity_info;
//        starttime = model.start_time;
//        endtime = model.end_time;
//        image_height = [model.pic_height floatValue];
//        image_width = [model.pic_width floatValue];
//    }
    
    NSLog(@"---title|%@|",title);

    
        top = self.userView.bottom + 12;
        
        self.iconImageView.layer.cornerRadius = _iconImageView.width / 2.f;
        _iconImageView.layer.masksToBounds = YES;
        self.nameLabel.text = name;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:nil];
        
    
    //标题
    self.aTitleLabel.top = top;
    
    CGFloat aWidth = DEVICE_WIDTH/2.f - 23;

    self.aTitleLabel.text = title;
    CGFloat height = [LTools heightForText:title width:aWidth font:16];
    _aTitleLabel.height = height;
    
    if (title == nil || [title isEqualToString:@"0"]) {
        
        self.aTitleLabel.height = 0;
        _timeLabel.top = _aTitleLabel.bottom;
        
    }else
    {
        self.aTitleLabel.hidden = NO;
        _timeLabel.top = _aTitleLabel.bottom + 10;
    }
    
    _endTimeLabel.top = _timeLabel.bottom;
    
    //活动的时候显示起始时间
    //消息的时候显示发布时间
    if (timeType == Time_AddTime) {
        
        //时间
        self.timeLabel.text = [NSString stringWithFormat:@"发布时间:%@",[LTools timeString:sendTime withFormat:@"yyyy年MM月dd日 hh:mm"]];//开始时间
        
    }else if(timeType == Time_StartAndEnd)
    {
        //时间
        self.timeLabel.text = [NSString stringWithFormat:@"有效期:%@ ~ %@",[LTools timeString:starttime withFormat:@"yyyy年MM月dd日 hh:mm"],[LTools timeString:endtime withFormat:@"yyyy年MM月dd日 hh:mm"]];//起止时间
    }
    
    //图片
    self.centerImageView.top = _timeLabel.bottom + 12;
    //有图
    if (image_url.length > 0 && [image_url hasPrefix:@"http://"]) {
        
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


+ (CGFloat)heightForModel:(id)aModel seeAll:(BOOL)seeAll
{
    CGFloat aHeight = (55 + 12);//用户信息view高度 + 间距12
    
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
    
    //标题高度
    CGFloat aWidth = DEVICE_WIDTH/2.f - 23;
    CGFloat height = [LTools heightForText:title width:aWidth font:16];
    
    
//    if (title == nil || [title isEqualToString:@"0"]) {
//        
//        height = -10;
//    }
    aHeight += height;

    
    //时间高度
    
    aHeight += (15 + 10);
    
    //图片
    if (image_url.length > 0 && [image_url hasPrefix:@"http://"])
    {
        
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
        
       aHeight += (15 + 45 + 10);
    }else
    {
        aHeight += (15 + 10);
    }
    
    return aHeight;
}

@end
