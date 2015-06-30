//
//  GMyJianquanViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/6/29.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


/**
 *  我的奖券
 */
#import "MyViewController.h"

@interface GMyJianquanViewController : MyViewController

@property(nonatomic,strong)NSString *jiangQuanId;//奖券id

@property(nonatomic,strong)NSDictionary *infoDic;//奖券详情dic

@property(nonatomic,strong)NSString *shop_Name;//活动地点

//经纬度
@property(nonatomic,strong)NSString *latitude;
@property(nonatomic,strong)NSString *longitude;
@end
