//
//  TopicDetailBottomView.h
//  YiYiProject
//
//  Created by soulnear on 14-12-28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//
/*
 话题详情页底部半透明view
 */
#import <UIKit/UIKit.h>
#import "TopicModel.h"

typedef void(^TopicDetailBottomViewBlock)(int index);

@interface TopicDetailBottomView : UIView
{
    TopicDetailBottomViewBlock topicDetailBottomView_block;
}

-(void)setBottomBlock:(TopicDetailBottomViewBlock)aBlock;

-(void)setTitleWithTopicModel:(TopicModel *)model;
-(void)setZanButtonSelected:(BOOL)isSelected;

@end
