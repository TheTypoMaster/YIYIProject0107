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

@property(nonatomic,assign)BOOL isChooseProductLink;//是否为发布T台商品链接

@property(nonatomic,strong)NSString *mallName;//商场名称


@property(nonatomic,assign)CGFloat upinfoview_height;



-(void)showTheUpDownViewFullView;

-(void)showTheUpDownViewHalfView;

@end
