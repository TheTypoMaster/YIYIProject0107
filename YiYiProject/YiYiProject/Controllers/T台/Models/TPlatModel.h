//
//  TPlatModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"

@interface TPlatModel : BaseModel

@property(nonatomic,retain)NSString *tt_id;//T台id
@property(nonatomic,retain)NSString *img_url;
@property(nonatomic,retain)NSString *add_time;
@property(nonatomic,retain)NSArray *tt_detail;//t台详情 数组

@property(nonatomic,retain)NSString *tt_content;//T台描述

@property(nonatomic,retain)NSString *tt_like_num;//红心个数
@property(nonatomic,retain)NSString *tt_share_num;
@property(nonatomic,retain)NSString *tt_comment_num;
@property(nonatomic,retain)NSDictionary *image;//图片字典
@property(nonatomic,retain)NSString *imagesize;
@property(nonatomic,retain)NSDictionary *uinfo;//用户信息

@property(nonatomic,retain)NSString *status;

@property(nonatomic,assign)int is_like;//是否喜欢 赞
@property(nonatomic,assign)int is_favor;//是否收藏



//新版本0812添加
@property(nonatomic,retain)NSArray *tag;//标签
@property(nonatomic,retain)NSArray *sameStyleArray;//同款单品列表
@property(nonatomic,retain)NSString *brand_name;//品牌名字
@property(nonatomic,retain)NSString *brand_logo;//品牌logo
@property(nonatomic,retain)NSDictionary *official_pic;//官方固定介绍图
@property(nonatomic,retain)NSDictionary *official_activity;//官方活动
@property(nonatomic,retain)NSArray *images;//图片数组(T台详情)
@property(nonatomic,strong)NSString *tPlat_like_num;//赞数量
@property(nonatomic,strong)NSString *distance;//距离
@property(nonatomic,strong)NSString *mall_name;//所在商场名称
@property(nonatomic,strong)NSDictionary *activity;//所在商场活动

//测试数据
@property(nonatomic,strong)NSString *tPlat_name;
@property(nonatomic,strong)NSString *original_price;



//T台详情
@property(nonatomic,strong)NSString *photo_mall_name;//拍摄地
@property(nonatomic,strong)NSArray *tags;//标签
@property(nonatomic,strong)NSArray *reply;//回复
@property(nonatomic,strong)NSArray *same_tts;//相同的T台



@property(nonatomic,strong)NSDictionary *official_act;//官方活动




@end
