//
//  GmyActivetiesViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/3/25.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//管理活动
#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "MailInfoModel.h"
@class GEditActivityTableViewCell;
@interface GmyActivetiesViewController : MyViewController


@property(nonatomic,retain)UserInfo *userInfo;
@property(nonatomic,strong)MailInfoModel *mallInfo;//店铺信息


-(void)editBtnClickedWithTag:(NSInteger)theTag;


@end
