//
//  GmyshopErweimaViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/4/16.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//店铺二维码

#import <UIKit/UIKit.h>

#import "MailInfoModel.h"

@interface GmyshopErweimaViewController : MyViewController


@property(nonatomic,strong)NSString *shop_id;//店铺id

@property(nonatomic,strong)MailInfoModel *mallInfo;//店铺信息

@property(nonatomic,strong)NSString *shop_Name;//店铺名  商场店时为品牌名加商场名

@end
