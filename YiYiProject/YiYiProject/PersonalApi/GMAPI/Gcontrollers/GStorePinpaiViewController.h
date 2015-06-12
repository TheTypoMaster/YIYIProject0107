//
//  GStorePinpaiViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/1/10.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//店铺主页
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


//需要传参

@property(nonatomic,strong)NSString *guanzhuleixing;//收藏类型  品牌店 精品店  品牌
@property(nonatomic,strong)NSString *storeIdStr;//商家id  点击附近的商家 商场店的时候为shop_id  精品店的时候为mall_id    点击附近的品牌为店铺id
@property(nonatomic,strong)NSString *storeNameStr;//商家名称
@property(nonatomic,strong)NSString *pinpaiNameStr;//品牌名称
@property(nonatomic,strong)NSString *pinpaiId;//品牌id

//提示：
//跳转品牌店需要传 1 guanzhuleixing（品牌店）   2 storeIdStr (品牌店的shop_id)  3 pinpaiNameStr(品牌名) 4storeNameStr(商场名)
//跳转精品店需要传 1 guanzhuleixing (精品店)   2 storeIdStr (精品店的 mall_id)  3 storeNameStr(店铺名)


@property(nonatomic,assign)BOOL isChooseProductLink;//是否为发布T台选择商品

@property(nonatomic,assign)BOOL isTPlatPush;//是否是T台push过来

@end
