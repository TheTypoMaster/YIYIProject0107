//
//  GnearbyStoreViewController.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//


//衣加衣界面点击附近商家跳转的界面  附近商家详情页面

#import <UIKit/UIKit.h>

@interface GnearbyStoreViewController : MyViewController


@property(nonatomic,strong)NSString *storeIdStr;
@property(nonatomic,strong)NSString *storeNameStr;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate_store;//经纬度


@property(nonatomic,strong)NSString *guanzhu;//0未关注  1已关注
@property(nonatomic,strong)NSString *mall_id;//需要关注的商场id


@property(nonatomic,strong)NSString *activityId;//活动id

@end
