//
//  ChouJiangModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/6/29.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"
/**
 *  抽奖
 */
@interface ChouJiangModel : BaseModel

@property(nonatomic,retain)NSString *prize_id;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *describe;
@property(nonatomic,retain)NSString *mall_id;
@property(nonatomic,retain)NSString *mall_name;
@property(nonatomic,retain)NSString *start_time;
@property(nonatomic,retain)NSString *end_time;
@property(nonatomic,retain)NSString *place;
@property(nonatomic,retain)NSString *url;//抽奖活动链接
@property(nonatomic,retain)NSString *type;//1=》内部跳转 2=》外部跳转 (目前只考虑2)
@property(nonatomic,retain)NSString *big_pic;
@property(nonatomic,retain)NSString *big_pic_size;
@property(nonatomic,retain)NSString *small_pic;
@property(nonatomic,retain)NSString *small_pic_size;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *del_status;
@property(nonatomic,retain)NSString *theme_id;
@property(nonatomic,retain)NSString *big_pic_url;
@property(nonatomic,retain)NSString *big_pic_width;
@property(nonatomic,retain)NSString *big_pic_height;
@property(nonatomic,retain)NSString *small_pic_url;
@property(nonatomic,retain)NSString *small_pic_width;
@property(nonatomic,retain)NSString *small_pic_height;
@property(nonatomic,retain)NSNumber *pop;//是否显示 pop=0不弹出 等于1弹出
@property(nonatomic,retain)NSNumber *pop_small;//是否显示小窗口 pop=0不弹出 等于1弹出


@end
