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
@property(nonatomic,retain)NSString *activity_info;//活动摘要
@property(nonatomic,retain)NSArray *activity_detail;//活动详情

@property(nonatomic,retain)NSString *pic;
@property(nonatomic,retain)NSString *pic_size;
@property(nonatomic,retain)NSString *add_time;
@property(nonatomic,retain)NSString *start_time;
@property(nonatomic,retain)NSString *end_time;
@property(nonatomic,retain)NSString *status;//活动有效无效
@property(nonatomic,retain)NSString *pic_width;
@property(nonatomic,retain)NSString *pic_height;
@property(nonatomic,retain)NSString *ori_pic;//活动原图
@property(nonatomic,retain)NSNumber *ended;//活动是否结束 0未结束 1结束

@property(nonatomic,retain)NSString *cover_pic;//活动封面
@property(nonatomic,retain)NSString *address;//活动地址

@property(nonatomic,retain)NSString *latitude;//维度
@property(nonatomic,retain)NSString *longitude;//经度

@property(nonatomic,strong)NSString *mall_name;//商场名

@property(nonatomic,strong)NSString *activity_id;//活动id



//T台列表
@property(nonatomic,strong)NSString *img_url;//活动图
@property(nonatomic,strong)NSString *adv_type_val; //广告类型1=》外链 2=》商场活动 3=》商铺活动 4=》单品  根据这个参数进行跳转
@property(nonatomic,strong)NSString *redirect_type;//0 原生 1 h5打开



@end
