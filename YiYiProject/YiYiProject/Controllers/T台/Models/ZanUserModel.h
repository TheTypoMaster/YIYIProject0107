//
//  ZanUserModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/5/5.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"

typedef enum {
   
    relation_concern_no = 0,//未关注
    relation_concern_yes = 1,//已关注对方
    relation_concern_yes_otherSide = 2,//被对方关注
    relation_concern_all = 3 //相互关注
    
}RelationConcernType;//关注关系

/**
 *  赞人员model
 */
@interface ZanUserModel : BaseModel

@property(nonatomic,retain)NSString *like_id;
@property(nonatomic,retain)NSString *object_id;
@property(nonatomic,retain)NSString *uid;
@property(nonatomic,retain)NSString *add_time;
@property(nonatomic,retain)NSString *user_name;
@property(nonatomic,retain)NSString *photo;
@property(nonatomic,retain)NSString *friend_uid;//粉丝、关注 代表对方uid
@property(nonatomic,assign)int relation;//关注关系 0代表未关注  1代表已关注 3代表以互相关注
@property(nonatomic,assign)int flag;//关注关系 0代表未关注  1代表已关注 2被对方关注 3代表以互相关注 (统一这个)


@end
