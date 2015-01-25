//
//  GupHuoDongViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/1/21.
//  Copyright (c) 2015年 lcw. All rights reserved.
//



//店主发布活动
#import <UIKit/UIKit.h>
#import "MailInfoModel.h"
#import "UserInfo.h"

@interface GupHuoDongViewController : MyViewController

@property(nonatomic,strong)MailInfoModel *mallInfo;//店铺信息
@property(nonatomic,strong)UserInfo *userInfo;

@end
