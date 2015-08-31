//
//  TopicCommentsModel.h
//  YiYiProject
//
//  Created by soulnear on 14-12-28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//
/*
 话题详情评论
 */

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface TopicCommentsModel : BaseModel
{
    
}

/////回复id
//@property(nonatomic,strong)NSString * reply_id;
/////回复人uid
//@property(nonatomic,strong)NSString * repost_uid;
///回复内容
@property(nonatomic,strong)NSString * repost_content;
///回复
@property(nonatomic,strong)NSString * parent_post;
///回复id
@property(nonatomic,strong)NSString * r_reply_id;
///回复等级
@property(nonatomic,strong)NSString * level;
///回复时间
@property(nonatomic,strong)NSString * post_time;
///回复昵称
@property(nonatomic,strong)NSString * user_name;
///回复人头像
@property(nonatomic,strong)NSString * photo;
///对评论进行的回复
@property(nonatomic,strong)NSMutableArray * child_array;

@property(nonatomic,strong)NSString *post_id;//评论id
@property(nonatomic,strong)NSString *uid;//发表回复人的id


-(id)initWithDictionary:(NSDictionary *)dic;


@end
