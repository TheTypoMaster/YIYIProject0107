//
//  MatchInfoModel.h
//  YiYiProject
//
//  Created by soulnear on 14-12-28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//
/*
 搭配师信息model
 */

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface MatchInfoModel : BaseModel

///搭配师uid
@property(nonatomic,strong)NSString * uid;
///搭配师昵称
@property(nonatomic,strong)NSString * name;
///搭配师评级
@property(nonatomic,strong)NSString * grade;
///搭配师简介
@property(nonatomic,strong)NSString * t_intro;
///搭配师头像
@property(nonatomic,strong)NSString * photo;
///1已关注，2未关注，3已互相关注
@property(nonatomic,strong)NSString * relation;
///搭配师标签
@property(nonatomic,strong)NSMutableArray * t_tags;


-(id)initWithDic:(NSDictionary *)dic;

@end
