//
//  GTtaiDetailModel.h
//  YiYiProject
//
//  Created by gaomeng on 15/8/24.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//T台详情model

#import "BaseModel.h"

@interface GTtaiDetailModel : BaseModel

@property(nonatomic,strong)NSString *tt_id;
@property(nonatomic,strong)NSString *tt_content;
@property(nonatomic,strong)NSString *tt_like_num;
@property(nonatomic,strong)NSString *tt_comment_num;//评论数
@property(nonatomic,strong)NSDictionary *image;//图片 锚点信息
@property(nonatomic,strong)NSArray *tags;//标签
@property(nonatomic,strong)NSArray *reply;//回复
@property(nonatomic,strong)NSArray *same_tts;//同款T台推荐 里面装的是TPlatModel
@property(nonatomic,strong)NSString *photo_mall_name;//拍摄地
@property(nonatomic,strong)NSDictionary *official_pic;//衣加衣固定图
@property(nonatomic,strong)NSString *brand_name;//品牌名
@property(nonatomic,strong)NSDictionary *official_act;//官方活动
@property(nonatomic,assign)int is_like;
@property(nonatomic,assign)int is_favor;

@end
