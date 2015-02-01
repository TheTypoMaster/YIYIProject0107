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

@property(nonatomic,strong)NSString *storeIdStr;//商城id
@property(nonatomic,strong)NSString *pinpaiId;//品牌id

@property(nonatomic,strong)NSString *guanzhu;//0未关注  1已关注

@property(nonatomic,strong)NSString *guanzhuleixing;//关注类型



@end
