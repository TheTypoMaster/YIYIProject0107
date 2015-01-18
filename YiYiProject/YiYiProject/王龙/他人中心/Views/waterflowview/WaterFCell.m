//
//  WaterFCell.m
//  CollectionView
//
//  Created by d2space on 14-2-26.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import "WaterFCell.h"
#import "UIImageView+WebCache.h"
#define CELLWIDTH   145
@interface WaterFCell ()
{
   
}
@end

const CGFloat PhotoQuiltViewMargin = 0;
@implementation WaterFCell


@synthesize photoView = _photoView;

- (void)dealloc {
    _photoView = nil;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}



//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//}


#pragma mark - Setup
- (void)setup
{
    [self initCellViews];
}

- (void)initCellViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.backGroudView = [[UIView alloc]init];
    _backGroudView.clipsToBounds = YES;
    [self addSubview:_backGroudView];

    
    //图片部分
    
    self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.width, 0)];
    [self addSubview:_photoView];
    
    //存放 店铺名、距离
    
    
    self.timeView = [[UIView alloc] init];
    _timeView.backgroundColor = [RGBCOLOR(80, 80, 80) colorWithAlphaComponent:0.80];
    [self addSubview:_timeView];
    
    self.timeLabel = [[UILabel alloc]init];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [UIFont systemFontOfSize:11.5];
    [_timeView addSubview:_timeLabel];
    
    
    
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







- (void)layoutSubviews {
    
    _backGroudView.frame = CGRectMake(0, 0, self.width, self.height);
    _backGroudView.layer.cornerRadius = 3.f;

    
    CGRect aBound = self.bounds;
    aBound.size.height -= 33;
    
    self.photoView.frame = CGRectInset(aBound, PhotoQuiltViewMargin, PhotoQuiltViewMargin);
    
    self.timeView.frame = CGRectMake(0, _photoView.bottom - 20, _photoView.width, 20);
    _timeLabel.frame = CGRectMake(0, 0, _photoView.width-5, 20);
    
    _infoView.frame = CGRectMake(0, _photoView.bottom, self.width, 36);
    
    _like_label.frame = CGRectMake(self.width - _like_label.width - 5, 0, _like_label.width, _infoView.height);
    self.like_btn.frame = CGRectMake(_like_label.left - 20 - 2, 0, 20, 20);
    _like_btn.center = CGPointMake(_like_btn.center.x, _infoView.height / 2.f);
    
    self.comment_btn.frame = CGRectMake(10, 0, 20, 20);
    _comment_btn.center = CGPointMake(_comment_btn.center.x, _like_label.center.y);
    _comment_label.frame = CGRectMake(_comment_btn.right+3, 0, _comment_label.width, _infoView.height);
    
    
    
}



- (void)setCellWithModel:(TPlatModel *)aModel
{
    NSString *imageUrl = aModel.image[@"url"];
    
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];

    self.like_label.text = aModel.tt_like_num;
    _like_label.width = [LTools widthForText:aModel.tt_like_num font:12];
    self.comment_label.text = aModel.tt_comment_num;
    _comment_label.width = [LTools widthForText:aModel.tt_comment_num font:12];
    
    _like_btn.selected = aModel.is_like == 1 ? YES : NO;
    
    NSString *addTime = [LTools timechange2:aModel.add_time];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",addTime];
    
    [self layoutSubviews];
}
@end
