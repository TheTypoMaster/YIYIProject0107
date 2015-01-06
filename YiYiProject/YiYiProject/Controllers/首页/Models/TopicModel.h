//
//  TopicModel.h
//  YiYiProject
//
//  Created by soulnear on 15-1-4.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface TopicModel : BaseModel

@property(nonatomic,strong)NSString * topic_id;
@property(nonatomic,strong)NSString * topic_title;
@property(nonatomic,strong)NSString * topic_content;
@property(nonatomic,strong)NSString * topic_create_time;
@property(nonatomic,strong)NSString * topic_like_num;
@property(nonatomic,strong)NSString * topic_repost_num;
@property(nonatomic,strong)NSString * topic_share_num;
@property(nonatomic,strong)NSString * topic_uid;
@property(nonatomic,strong)NSString * topic_images;
@property(nonatomic,strong)NSString * topic_last_post;
@property(nonatomic,strong)NSString * t_username;
@property(nonatomic,strong)NSString * t_user_photo;
@property(nonatomic,strong)NSString * is_like;


@end
