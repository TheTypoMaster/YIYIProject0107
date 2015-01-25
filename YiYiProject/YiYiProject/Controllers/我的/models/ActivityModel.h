//
//  ActivityModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/21.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"
/**
 *  活动model
 */
@interface ActivityModel : BaseModel

@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *mall_id;
@property(nonatomic,retain)NSString *shop_id;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *activity_title;
@property(nonatomic,retain)NSString *activity_info;
@property(nonatomic,retain)NSString *pic;
@property(nonatomic,retain)NSString *pic_size;
@property(nonatomic,retain)NSString *add_time;
@property(nonatomic,retain)NSString *start_time;
@property(nonatomic,retain)NSString *end_time;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *pic_width;
@property(nonatomic,retain)NSString *pic_height;

@end
