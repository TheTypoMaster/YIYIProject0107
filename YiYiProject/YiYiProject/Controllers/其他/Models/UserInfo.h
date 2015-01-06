//
//  UserInfo.h
//  YiYiProject
//
//  Created by lichaowei on 14/12/13.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "BaseModel.h"

/**
 *  用户信息 model
 */
@interface UserInfo : BaseModel

@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *uid;
@property(nonatomic,retain)NSString *user_name;
@property(nonatomic,retain)NSString *password;
@property(nonatomic,retain)NSString *admin_id;
@property(nonatomic,retain)NSString *user_grade;
@property(nonatomic,retain)NSString *gender;
@property(nonatomic,retain)NSString *age;
@property(nonatomic,retain)NSString *email;
@property(nonatomic,retain)NSString *mobile;
@property(nonatomic,retain)NSString *dateline;
@property(nonatomic,retain)NSString *state;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *photo;
@property(nonatomic,retain)NSString *third_photo;
@property(nonatomic,retain)NSString *thirdid;
@property(nonatomic,retain)NSString *score;
@property(nonatomic,retain)NSString *devicetoken;
@property(nonatomic,retain)NSString *job;
@property(nonatomic,retain)NSString *decription;
@property(nonatomic,retain)NSString *role;
@property(nonatomic,retain)NSString *birthday;
@property(nonatomic,retain)NSString *friends_num;
@property(nonatomic,retain)NSString *fans_num;
@property(nonatomic,retain)NSString *favor_num;
@property(nonatomic,retain)NSString *authcode;

@end
