//
//  TDetailModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/6.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"

/**
 *  t台详情model
 */
@interface TDetailModel : BaseModel

@property(nonatomic,retain)NSString *tt_id;
@property(nonatomic,retain)NSString *img_url;
@property(nonatomic,retain)NSString *tt_content;
@property(nonatomic,retain)NSString *uid;
@property(nonatomic,retain)NSString *add_time;
@property(nonatomic,retain)NSArray *tt_detail;//t台详情 数组
@property(nonatomic,retain)NSString *tt_like_num;
@property(nonatomic,retain)NSString *tt_share_num;
@property(nonatomic,retain)NSString *tt_comment_num;
@property(nonatomic,retain)NSDictionary *image;//图片字典
@property(nonatomic,retain)NSDictionary *uinfo;//用户信息
@property(nonatomic,assign)int is_like;

@property(nonatomic,assign)int is_favor;//是否收藏

//史忠坤修改
@property(nonatomic,assign)int have_detail;
@property(nonatomic,strong)NSArray *img_detail;
//end

/**
 *  单品详情model
 */

@property(nonatomic,retain)NSString *product_id;
@property(nonatomic,retain)NSString *product_name;//品牌名
@property(nonatomic,retain)NSString *product_like_num;//赞数量
@property(nonatomic,retain)NSString *product_fav_num;//收藏数量
@property(nonatomic,retain)NSString *product_brand_id;
@property(nonatomic,retain)NSString *product_brand_name;//品牌名
@property(nonatomic,retain)NSString *product_share_num;
@property(nonatomic,retain)NSString *product_add_time;
@property(nonatomic,retain)NSDictionary *brand_info;
@property(nonatomic,retain)NSDictionary *mall_info;


@end
