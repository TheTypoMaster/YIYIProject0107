//
//  GpinpaiDetailViewController.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//


//点击首页品牌scrollview 进入附近商家列表
#import <UIKit/UIKit.h>

@interface GpinpaiDetailViewController : MyViewController

@property(nonatomic,strong)NSString *pinpaiIdStr;//品牌id
@property(nonatomic,strong)NSString *pinpaiName;//品牌名称

@property(nonatomic,strong)NSDictionary *locationDic;//位置信息

@property(nonatomic,strong)NSString *guanzhu;//0未收藏  1已收藏


@property(nonatomic,assign)BOOL isChooseProductLink;//是否为添加T台链接

@end



