//
//  MailModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"
/**
 *  商家
 */
@interface MailModel : BaseModel

@property(nonatomic,retain)NSString *mall_id;
@property(nonatomic,retain)NSString *mall_name;
@property(nonatomic,retain)NSString *latitude;
@property(nonatomic,retain)NSString *longitude;
@property(nonatomic,retain)NSString *province_id;
@property(nonatomic,retain)NSString *city_id;
@property(nonatomic,retain)NSString *disctrict_id;
@property(nonatomic,retain)NSString *street;
@property(nonatomic,retain)NSString *address;

@end
