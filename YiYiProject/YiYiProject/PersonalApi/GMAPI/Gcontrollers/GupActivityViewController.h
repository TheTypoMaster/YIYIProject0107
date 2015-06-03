//
//  GupActivityViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/6/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//



//发布活动第一步

#import "MyViewController.h"
#import "MailInfoModel.h"
#import "UserInfo.h"
#import "ActivityModel.h"

typedef enum{
    GUPACTIVITYTYPE_NONE = 0,
    GUPACTIVITYTYPE_EDIT
}GUPACTIVITYTYPE;


@interface GupActivityViewController : MyViewController

@property(nonatomic,strong)MailInfoModel *mallInfo;//店铺信息
@property(nonatomic,strong)UserInfo *userInfo;



//修改活动
@property(nonatomic,assign)GUPACTIVITYTYPE thetype;
@property(nonatomic,strong)ActivityModel *theEditActivity;
@property(nonatomic,strong)NSMutableArray *oldImageArray;

@property(nonatomic,retain)UIViewController *shopViewController;//店铺页面


@end
