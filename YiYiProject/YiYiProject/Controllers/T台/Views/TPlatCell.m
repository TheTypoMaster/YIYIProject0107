//
//  TPlatCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "TPlatCell.h"

@implementation TPlatCell

- (void)dealloc {
    _photoView = nil;
    
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.backGroudView = [[UIView alloc]init];
        _backGroudView.clipsToBounds = YES;
        [self addSubview:_backGroudView];
        
        //用户信息部分
        
        self.headBgView = [[UIView alloc]init];
        _headBgView.backgroundColor = [UIColor clearColor];
        [_backGroudView addSubview:_headBgView];
        
        //头像
        self.iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 35/2.f;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.backgroundColor = [UIColor clearColor];
        [_headBgView addSubview:_iconImageView];
        
        //用户名
        self.userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = [UIFont systemFontOfSize:15];
        _userNameLabel.text = @"玛莎爱丽";
        [_headBgView addSubview:_userNameLabel];
        
        //时间
        self.timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        [_headBgView addSubview:_timeLabel];
       
        //图片部分
        
        self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _headBgView.bottom, self.width, 0)];
        [self addSubview:_photoView];
        
        //评论喜欢 背景view
        
        self.infoView = [[UIView alloc]init];
        [_backGroudView addSubview:_infoView];
        
        //评论数量
        self.comment_label = [[UILabel alloc]init];
        _comment_label.backgroundColor = [UIColor clearColor];
        _comment_label.font = [UIFont systemFontOfSize:12];
        _comment_label.textAlignment = NSTextAlignmentRight;
        [_infoView addSubview:_comment_label];
        
        //评论标识
        self.comment_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comment_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_comment_btn setImage:[UIImage imageNamed:@"Ttai_pinglun"] forState:UIControlStateNormal];
        [_comment_btn setImage:[UIImage imageNamed:@"Ttai_pinglun"] forState:UIControlStateSelected];
        [_infoView addSubview:_comment_btn];
        
        //喜欢数量
        self.like_label = [[UILabel alloc]init];
        _like_label.backgroundColor = [UIColor clearColor];
        _like_label.font = [UIFont systemFontOfSize:12];
        _like_label.textAlignment = NSTextAlignmentRight;
        [_infoView addSubview:_like_label];
        
        //喜欢标识
        self.like_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_like_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_like_btn setImage:[UIImage imageNamed:@"love_up"] forState:UIControlStateNormal];
        [_like_btn setImage:[UIImage imageNamed:@"love_down"] forState:UIControlStateSelected];
        [_infoView addSubview:_like_btn];
    }
    return self;
}


- (void)layoutSubviews {
    
    _backGroudView.frame = CGRectMake(0, 0, self.width, self.height);
    _backGroudView.layer.cornerRadius = 3.f;
    
    //用户信息部分
    _headBgView.frame = CGRectMake(0, 0, _backGroudView.width, 55);
    _iconImageView.frame = CGRectMake(10, 0, 35, 35);
    
    _iconImageView.center = CGPointMake(_iconImageView.center.x, _headBgView.height / 2.f);
    
    _userNameLabel.frame = CGRectMake(_iconImageView.right + 10, 10, 120, 15);
    _timeLabel.frame = CGRectMake(_userNameLabel.left, _userNameLabel.bottom + 5, _userNameLabel.width, 10);
    
    CGRect aBound = self.bounds;
    aBound.size.height -= 33;

    self.photoView.frame = CGRectMake(0, _headBgView.bottom, self.width, _photoView.height);

    //评论 喜欢 view

    _infoView.frame = CGRectMake(0, _photoView.bottom, self.width, 36);
    
    _like_label.frame = CGRectMake(self.width - _like_label.width - 5, 0, _like_label.width, _infoView.height);
    self.like_btn.frame = CGRectMake(_like_label.left - 20 - 2, 0, 20, 20);
    _like_btn.center = CGPointMake(_like_btn.center.x, _infoView.height / 2.f);
    
    
    _comment_label.frame = CGRectMake(_like_btn.left - 10 - _comment_label.width, 0, _comment_label.width, _infoView.height);
    self.comment_btn.frame = CGRectMake(_comment_label.left - _like_btn.width - 5, 0, 20, 20);
    _comment_btn.center = CGPointMake(_comment_btn.center.x, _like_label.center.y);
    
    
}

// width - 30 / 3

- (CGFloat)height:(CGFloat)aHeight aWidth:(CGFloat)aWidth
{
    CGFloat realWidth = (DEVICE_WIDTH - 30 / 3);
    
    return realWidth * aHeight / aWidth;
}

- (void)setCellWithModel:(TPlatModel *)aModel
{
    NSString *imageUrl = aModel.image[@"url"];
    CGFloat aWidth = [aModel.image[@"width"]floatValue];
    CGFloat aHeight = [aModel.image[@"height"]floatValue];
    
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    _photoView.height = [self height:aHeight / 2.f aWidth:aWidth];
    
    NSString *userImageUrl = aModel.uinfo[@"photo"];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userImageUrl] placeholderImage:nil];
    self.userNameLabel.text = aModel.uinfo[@"user_name"];
    self.timeLabel.text = [LTools timechange:aModel.add_time];
    
    self.like_label.text = aModel.tt_like_num;
    _like_label.width = [LTools widthForText:aModel.tt_like_num font:12];
    self.comment_label.text = aModel.tt_comment_num;
    _comment_label.width = [LTools widthForText:aModel.tt_comment_num font:12];
    
    _like_btn.selected = aModel.is_like == 1 ? YES : NO;
    
    [self layoutSubviews];
}


@end
