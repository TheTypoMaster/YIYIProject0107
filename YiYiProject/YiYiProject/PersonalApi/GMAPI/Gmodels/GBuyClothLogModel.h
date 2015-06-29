//
//  GBuyClothLogModel.h
//  YiYiProject
//
//  Created by gaomeng on 15/6/27.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBuyClothLogModel : BaseModel

@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *brand;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *buy_time;
@property(nonatomic,strong)NSString *buy_place;
@property(nonatomic,strong)NSString *desc;
@property(nonatomic,strong)NSString *pic;
@property(nonatomic,strong)NSString *pic_size;
@property(nonatomic,strong)NSString *add_time;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,assign)BOOL time;//排序标志位
@property(nonatomic,strong)NSString *timeStr;//标准时间 2014-05-25

@end
