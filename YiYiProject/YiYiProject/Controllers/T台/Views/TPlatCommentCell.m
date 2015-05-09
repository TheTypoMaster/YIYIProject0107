//
//  TPlatCommentCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/5/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "TPlatCommentCell.h"
#import "TopicSubCommentsModel.h"

#define REPLY_ID @"replyId" //该条回复的id

@implementation TPlatSecondForwardView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,0.5)];
//        lineView.backgroundColor = RGBCOLOR(201,201,205);
//        
//        [self addSubview:lineView];
        
//        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

-(CGFloat)setupWithArray:(NSMutableArray *)array
{
    comments_array = [NSArray arrayWithArray:array];
    CGFloat height = 0;
    
    CGFloat sum = 0;
    
    for (int i = 0;i < array.count;i++)
    {
        
        TopicSubCommentsModel * model = [array objectAtIndex:i];
        
        //头像
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, height, 25, 25)];
        [iconImageView addRoundCorner];
        [self addSubview:iconImageView];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:DEFAULT_HEADIMAGE];
        
        //评论内容
        
        CGFloat aWidth = self.width - iconImageView.right - 35;
        
        CGRect labelFrame = CGRectMake(iconImageView.right + 5,iconImageView.top + 6,aWidth,0);

        if (model.user_name.length == 0) {
            continue;
        }
        
        NSString * content = model.repost_content;
        
        if (model.r_reply_user_name.length)
        {
            content = [NSString stringWithFormat:@"%@:回复 %@:%@",model.user_name,model.r_reply_user_name,content];
        }else
        {
            content = [NSString stringWithFormat:@"%@:%@",model.user_name,content];
        }
        
        OHAttributedLabel * label = [[OHAttributedLabel alloc] initWithFrame:labelFrame];
        label.tag = 10000 + i;
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
        [OHLableHelper creatAttributedText:content Label:label OHDelegate:self WithWidht:14 WithHeight:14 WithLineBreak:NO];
        NSRange range = [content rangeOfString:model.user_name];
        label.underlineLinks = NO;
        [label addCustomLink:[NSURL URLWithString:model.repost_uid] inRange:range];
//        [label setLinkColor:RGBCOLOR(87,106,154)];
        [label setLinkColor:[UIColor colorWithHexString:@"5175a7"]];
        label.textColor = [UIColor colorWithHexString:@"727272"];
        label.labelSelectedColor = [UIColor lightGrayColor];

        //label赋值
        NSDictionary *params = @{USER_NAME:model.user_name,USER_UID:model.uid,REPLY_ID:model.father_id};
        label.params = params;
        
        height += iconImageView.height + 5;
        
        
        sum = label.bottom > iconImageView.bottom ? label.bottom : iconImageView.bottom;

    }
    
    if (array.count == 0) {
        height = 0.f;
    }
    
    return sum;
}

-(void)setSeconForwardViewBlock:(TPlatCommentCellBlock)aBlock
{
    SecondForwardView_block = aBlock;
}

#pragma mark - OHAttributedLabelDelegate
///点击用户名跳转到个人信息界面
-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo
{
//    NSString * uid = [linkInfo.URL absoluteString];
    
    NSDictionary *params = attributedLabel.params;
    
    if (params && [params isKindOfClass:[NSDictionary class]]) {
        
        NSString *userName = params[USER_NAME];
        NSString *uid = params[USER_UID];
        
        //点击名字 调到个人中心
        
        SecondForwardView_block(TPlatCommentCellClickType_UserCenter,userName,uid,@"");
    }
    
    return YES;
}

-(void)didSelectedAttributedLabel:(OHAttributedLabel*)attributedLabel//整个label被选中
{
    
    NSDictionary *params = attributedLabel.params;
    
    if (params && [params isKindOfClass:[NSDictionary class]]) {
        
        NSString *userName = params[USER_NAME];
        NSString *uid = params[USER_UID];
        
        NSString *replyId = params[REPLY_ID];
        
        //点击名字 调到个人中心
        
        SecondForwardView_block(TPlatCommentCellClickType_Comment,userName,uid,replyId);
    }

}

@end


@implementation TPlatCommentCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.header_imageView addRoundCorner];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfoWithCommentsModel:(TopicCommentsModel *)model
{
    aModel = model;
    
    [self.header_imageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:DEFAULT_HEADIMAGE];
    
    self.commentButton.center = CGPointMake(_commentButton.center.x, _header_imageView.center.y);
    
    [self.commentButton addTarget:self action:@selector(clickToComment) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *contentString = [NSString stringWithFormat:@"%@:%@",model.user_name,model.repost_content];
    
    CGFloat aWidth = DEVICE_WIDTH - 40 - 36;//减掉左侧和右侧
    
//    CGFloat string_height = [LTools heightForText:model.repost_content width:aWidth font:14];
    
    //名字显示蓝色,并且可以点击
    
    _content_label.hidden = YES;
    
    _content_label.width = aWidth;
    OHAttributedLabel * label = [[OHAttributedLabel alloc] initWithFrame:_content_label.frame];
    
//    label.tag = 10000 + i;
    label.userInteractionEnabled = YES;

    label.font = [UIFont systemFontOfSize:13];
    [self addSubview:label];
    [OHLableHelper creatAttributedText:contentString Label:label OHDelegate:self WithWidht:13 WithHeight:14 WithLineBreak:NO];
    NSRange range = [contentString rangeOfString:model.user_name];
    label.underlineLinks = NO;
    [label addCustomLink:[NSURL URLWithString:model.repost_uid] inRange:range];

    [label setLinkColor:[UIColor colorWithHexString:@"5175a7"]];
    label.textColor = [UIColor colorWithHexString:@"727272"];

//    label.backgroundColor = [UIColor orangeColor];
    label.labelSelectedColor = [UIColor lightGrayColor];
    //label赋值
    NSDictionary *params = @{USER_NAME:model.user_name,USER_UID:model.repost_uid};
    label.params = params;

    //底部线的坐标top
    
    CGFloat lineTop = label.bottom > _header_imageView.bottom ? label.bottom + 5 : _header_imageView.bottom + 5;
    
    if (model.child_array.count > 0)
    {
        CGFloat aBottom = label.bottom > _header_imageView.bottom ? label.bottom + 5 : _header_imageView.bottom + 5;
        
        _second_view = [[TPlatSecondForwardView alloc] initWithFrame:CGRectMake(label.left,aBottom,DEVICE_WIDTH - label.left - 10,0)];
        CGFloat second_height = [_second_view setupWithArray:model.child_array];
        _second_view.height = second_height;
        [self.contentView addSubview:_second_view];
        
        lineTop = _second_view.bottom + 5;
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, lineTop, DEVICE_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"e4e4e4"];
    [self.contentView addSubview:line];

}

- (void)clickToComment:(UIButton *)sender
{
    NSLog(@"点击了button");
}

+ (CGFloat)heightForCellWithModel:(TopicCommentsModel *)model
{
    NSString *content_string = [NSString stringWithFormat:@"%@:%@",model.user_name,model.repost_content];
    
    //主题评论宽度
    CGFloat aWidth = DEVICE_WIDTH - 40 - 36;//减掉左侧和右侧
    
    CGFloat string_height = [LTools heightForText:content_string width:aWidth font:13];
    
    //评论的评论高度
    
    aWidth = DEVICE_WIDTH - 40 - 10;
    
    TPlatSecondForwardView * _second_view = [[TPlatSecondForwardView alloc] initWithFrame:CGRectMake(40,string_height + 10,aWidth , 0)];
    CGFloat second_height = [_second_view setupWithArray:model.child_array];
    
    _second_view = nil;
    //    /数字一次代表距离顶部距离、头像高度、内容离头像距离、底部距离、评论的回复高度
    
    //头像top 10 头像height:25 下间距10
    
    //如果没有 二级评论 则去掉
    
    if (model.child_array.count == 0) {
        
        CGFloat aHeight = 10 + string_height + 10 + 10;
        CGFloat bHeight = 10 + 25 + 10;
        
        return (aHeight > bHeight ? aHeight : bHeight) - 5;
    }
    
    return string_height + second_height + 10 + 25 - 5;

}

-(void)setTopicCommentsCellBlock:(TPlatCommentCellBlock)aBlock
{
    TopicCommentsCell_block = aBlock;
}

///点击内容去评论
-(void)tapCnontentToComment:(UITapGestureRecognizer *)sender
{
    TopicCommentsCell_block(TPlatCommentCellClickType_Comment,aModel.user_name,aModel.repost_uid,aModel.reply_id);
}

/// 点击评论按钮进行评论
- (void)clickToComment
{
    TopicCommentsCell_block(TPlatCommentCellClickType_Comment,aModel.user_name,aModel.repost_uid,aModel.reply_id);
}


#pragma mark - OHAttributedLabelDelegate

///点击用户名跳转到个人信息界面

-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo
{
    
    TopicCommentsCell_block(TPlatCommentCellClickType_UserCenter,aModel.user_name,aModel.repost_uid,aModel.reply_id);
    
    return YES;
}

///点击label 对该评论进行回复

-(void)didSelectedAttributedLabel:(OHAttributedLabel*)attributedLabel//整个label被选中
{
    TopicCommentsCell_block(TPlatCommentCellClickType_Comment,aModel.user_name,aModel.repost_uid,aModel.reply_id);
}


@end
