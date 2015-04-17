//
//  GStorePinpaiViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/1/10.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//某个商城里的品牌  首页附近的品牌 点击进入商店列表 点击某个商店进入这个商店的某个品牌的页面 


#import <UIKit/UIKit.h>
#import "ParallaxHeaderView.h"

@interface GStorePinpaiViewController : MyViewController
{
    UIView *_upStoreInfoView;
    UILabel *_mallNameLabel;
    UILabel *_huodongTitleLabel;
    UILabel *_huodongLabel;
    UILabel *_dizhiTitleLabel;
    UILabel *_adressLabel;
}

@property(nonatomic,strong)NSString *pinpaiNameStr;//品牌名称
@property(nonatomic,strong)NSString *storeNameStr;//商家名称

@property(nonatomic,strong)NSString *storeIdStr;//商场id  点击附近的商家 商场店的时候为店铺id  精品店的时候为商场id    点击附近的品牌为店铺id
@property(nonatomic,strong)NSString *pinpaiId;//品牌id
@property(nonatomic,strong)NSString *shopId;//店铺id

@property(nonatomic,strong)NSString *guanzhu;//0未关注  1已关注

@property(nonatomic,strong)NSString *guanzhuleixing;//关注类型  品牌店 精品店  品牌


@property(nonatomic,strong)NSString *activityId;//活动id


@property(nonatomic,assign)CLLocationCoordinate2D coordinate_store;//商家经纬度

@property(nonatomic,assign)BOOL isChooseProductLink;//是否为发布T台选择商品

@property(nonatomic,strong)NSString *phoneNumber;//电话号码




@end
