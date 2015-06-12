//
//  TopicDetailBottomView.m
//  YiYiProject
//
//  Created by soulnear on 14-12-28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "TopicDetailBottomView.h"

@implementation TopicDetailBottomView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    NSArray * image_array = [NSArray arrayWithObjects:[UIImage imageNamed:@"productDetail_zan_normal"],[UIImage imageNamed:@"xq_pinglun"],[UIImage imageNamed:@"fenxiangb"], nil];
    
    for (int i = 0;i < 3;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(DEVICE_WIDTH/3.0f*i,0,DEVICE_WIDTH/3.0f,self.height);
        button.tag = 100 + i;
        [button setImage:[image_array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitle:@"0" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0,30,0,0)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
        if (i == 0)
        {
            [button setImage:[UIImage imageNamed:@"productDetail_zan_selected"] forState:UIControlStateSelected];
        }
    }
}

-(void)buttonTap:(UIButton *)button
{
    topicDetailBottomView_block((int)(button.tag-100));
}

-(void)setBottomBlock:(TopicDetailBottomViewBlock)aBlock
{
    topicDetailBottomView_block = aBlock;
}

///设置button标题
-(void)setTitleWithTopicModel:(TopicModel *)model
{
    UIButton * zan_button = (UIButton *)[self viewWithTag:100];
    UIButton * pinglun_button = (UIButton *)[self viewWithTag:101];
    UIButton * zhuanfa_button = (UIButton *)[self viewWithTag:102];
    
    [zan_button setTitle:model.topic_like_num forState:UIControlStateNormal];
    [pinglun_button setTitle:model.topic_repost_num forState:UIControlStateNormal];
    [zhuanfa_button setTitle:model.topic_share_num forState:UIControlStateNormal];
}

///设置赞状态
-(void)setZanButtonSelected:(BOOL)isSelected
{
    UIButton * button = (UIButton *)[self viewWithTag:100];
    
    button.selected = isSelected;
}



@end








