//
//  MatchCaseModel.h
//  YiYiProject
//
//  Created by soulnear on 14-12-21.
//  Copyright (c) 2014年 lcw. All rights reserved.
//
/*
 搭配师界面搭配师搭配数据
 */

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface MatchCaseModel : BaseModel



///昵称
@property(nonatomic,strong)NSString * name;
///图片
@property(nonatomic,strong)NSString * t_img;
///搭配id
@property(nonatomic,strong)NSString * tt_id;
///搭配师头像
@property(nonatomic,strong)NSString * u_photo;
///搭配师uid
@property(nonatomic,strong)NSString * uid;
///图片宽度
@property(nonatomic,strong)NSString * tt_img_width;
///图片高度
@property(nonatomic,strong)NSString * tt_img_height;

@end
