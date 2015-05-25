//
//  MailModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"
#import "ActivityModel.h"//活动对应model
/**
 *  商家
 */
@interface MailModel : BaseModel

@property(nonatomic,retain)NSString *mall_id;
@property(nonatomic,strong)NSString *shop_id;
@property(nonatomic,retain)NSString *mall_name;
@property(nonatomic,retain)NSString *latitude;
@property(nonatomic,retain)NSString *longitude;
@property(nonatomic,retain)NSString *province_id;
@property(nonatomic,retain)NSString *city_id;
@property(nonatomic,retain)NSString *disctrict_id;
@property(nonatomic,retain)NSString *street;
@property(nonatomic,retain)NSString *address;

@property(nonatomic,retain)NSString *distance;//距离

@property(nonatomic,retain)NSString *mall_type;

@property(nonatomic,retain)NSString *mall_pic;//商家logo

@property(nonatomic,retain)NSDictionary *activity;//商家对应的活动信息

@property(nonatomic,retain)ActivityModel *activityModel;//活动model



@end
