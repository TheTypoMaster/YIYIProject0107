//
//  TopicCommentsCell.m
//  YiYiProject
//
//  Created by soulnear on 14-12-28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "TopicCommentsCell.h"


@implementation SecondForwardView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,0.5)];
        lineView.backgroundColor = RGBCOLOR(89,89,89);
        [self addSubview:lineView];
    }
    return self;
}

-(CGFloat)setupWithArray:(NSMutableArray *)array
{
    CGFloat height = 5;
    
    for (int i = 0;i < array.count;i++)
    {
        CGRect labelFrame = CGRectMake(0,height,self.frame.size.width,0);
        
        TopicCommentsModel * model = [array objectAtIndex:i];
        NSString * content = model.repost_content;
        content = [NSString stringWithFormat:@"%@:%@",model.user_name,content];
        
        OHAttributedLabel * label = [[OHAttributedLabel alloc] initWithFrame:labelFrame];
        label.textColor = RGBCOLOR(3,3,3);
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
        [OHLableHelper creatAttributedText:content Label:label OHDelegate:self WithWidht:14 WithHeight:14 WithLineBreak:NO];
        NSRange range = [content rangeOfString:model.user_name];
        label.underlineLinks = NO;
        [label addCustomLink:[NSURL URLWithString:model.repost_uid] inRange:range];
        [label setLinkColor:RGBCOLOR(87,106,154)];
        //        label.backgroundColor = [UIColor clearColor];
        height += label.frame.size.height+3;
    }
    
    return height;
}

#pragma mark - OHAttributedLabelDelegate
///点击用户名跳转到个人信息界面
-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo
{
    NSString * uid = [linkInfo.URL absoluteString];

    return YES;
}

@end




@implementation TopicCommentsCell

- (void)awakeFromNib
{
    _header_imageView.frame = CGRectMake(12,12,36,36);
    _header_imageView.layer.masksToBounds = YES;
    _header_imageView.layer.cornerRadius = _header_imageView.width/2.0;
    
    
    _userName_label.frame = CGRectMake(60,10,DEVICE_WIDTH-60-12,16);
    _date_label.frame = CGRectMake(60,30,DEVICE_WIDTH-60-12,16);
    _content_label.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setInfoWithCommentsModel:(TopicCommentsModel *)model
{
    [_header_imageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil];
    _userName_label.text = model.user_name;
    _date_label.text = [ZSNApi timechange:model.post_time WithFormat:@"MM月dd日 HH:mm"];
    
    
    CGFloat string_height = [LTools heightForText:model.repost_content width:DEVICE_WIDTH-60-12 font:14];
    _content_label.frame = CGRectMake(60,58,DEVICE_WIDTH-60-12,string_height);
    _content_label.text = model.repost_content;
    
    if (model.child_array.count > 0)
    {
        _second_view = [[SecondForwardView alloc] initWithFrame:CGRectMake(60,string_height+70,DEVICE_WIDTH-60-12,0)];
        CGFloat second_height = [_second_view setupWithArray:model.child_array];
        _second_view.height = second_height;
        [self.contentView addSubview:_second_view];
    }
    
}

@end








