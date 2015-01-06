//
//  TopicSubCommentsModel.h
//  YiYiProject
//
//  Created by soulnear on 15-1-2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//
/*
 对评论进行评论的数据
 */

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface TopicSubCommentsModel : BaseModel
{
    
}



@property(nonatomic,strong)NSString * reply_id;
@property(nonatomic,strong)NSString * repost_uid;
@property(nonatomic,strong)NSString * repost_content;
@property(nonatomic,strong)NSString * parent_post;
@property(nonatomic,strong)NSString * r_reply_id;
@property(nonatomic,strong)NSString * level;
@property(nonatomic,strong)NSString * post_time;
@property(nonatomic,strong)NSString * user_name;
@property(nonatomic,strong)NSString * photo;
@property(nonatomic,strong)NSString * r_reply_uid;
@property(nonatomic,strong)NSString * r_reply_user_name;




@end
