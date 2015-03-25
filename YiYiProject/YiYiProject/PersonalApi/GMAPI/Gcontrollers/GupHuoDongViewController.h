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

#import "ActivityModel.h"

typedef enum{
    GUPHUODONGTYPE_NONE = 0,
    GUPHUODONGTYPE_EDIT
}GUPHUODONGTYPE;

@interface GupHuoDongViewController : MyViewController

@property(nonatomic,strong)MailInfoModel *mallInfo;//店铺信息
@property(nonatomic,strong)UserInfo *userInfo;

//修改活动
@property(nonatomic,assign)GUPHUODONGTYPE thetype;
@property(nonatomic,strong)ActivityModel *theEditActivity;
@property(nonatomic,strong)NSMutableArray *oldImageArray;

@end
