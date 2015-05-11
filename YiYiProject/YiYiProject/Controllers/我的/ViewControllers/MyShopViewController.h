//
//  MyShopViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/5/7.
//  Copyright (c) 2015年 lcw. All rights reserved.
//



//我的店铺

#import "MyViewController.h"
#import "MailInfoModel.h"
#import "UserInfo.h"

@interface MyShopViewController : MyViewController


@property(nonatomic,retain)UserInfo *userInfo;
@property(nonatomic,strong)UIImageView *userFaceImv;//头像Imv
@property(nonatomic,strong)UIImage *userBanner;//banner
@property(nonatomic,strong)UIImage *userFace;//头像

@property(nonatomic,strong)MailInfoModel *mallInfo;//店铺信息

@end
