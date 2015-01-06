//
//  MatchTopicModel.h
//  YiYiProject
//
//  Created by soulnear on 14-12-20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface MatchTopicModel : BaseModel


///话题id
@property(nonatomic,strong)NSString * topic_id;
///话题标题
@property(nonatomic,strong)NSString * topic_title;
///话题内容
@property(nonatomic,strong)NSString * topic_content;
///话题创建时间
@property(nonatomic,strong)NSString * topic_create_time;
///话题赞数
@property(nonatomic,strong)NSString * topic_like_num;
///话题评论数
@property(nonatomic,strong)NSString * topic_repost_num;
///话题分享数
@property(nonatomic,strong)NSString * topic_share_num;
///话题发起人uid
@property(nonatomic,strong)NSString * topic_uid;
///话题图片
@property(nonatomic,strong)NSString * topic_images;
///话题最后回复时间
@property(nonatomic,strong)NSString * topic_last_post;
///话题发起人昵称
@property(nonatomic,strong)NSString * t_username;
///话题发起人头像
@property(nonatomic,strong)NSString * t_user_photo;



@end
