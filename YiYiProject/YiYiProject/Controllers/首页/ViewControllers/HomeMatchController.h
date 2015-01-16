//
//  HomeMatchController.h
//  YiYiProject
//
//  Created by lichaowei on 14/12/12.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  搭配师
 */

typedef enum{
    HomeMatchTeacherTypeZhiYe = 0,//职业
    HomeMatchTeacherTypeShiShang=1,//时尚
    HomeMatchTeacherTypeXiuXian=2,//休闲
    HomeMatchTeacherTypeYunDong,//运动
}HomeMatchTeacherType;//搭配师类型

typedef enum{
    HomeMatchRequestTypeMy = 0,
    HomeMatchRequestTypeHot
}HomeMatchRequestType;

typedef enum{
    MatchSelectedTypeTopic = 0,
    MatchSelectedTypeMatch
}MatchSelectedType;

@interface HomeMatchController : MyViewController
{
    MatchSelectedType selected_type;
    HomeMatchTeacherType teacher_type;
}

@property(nonatomic,assign)UIViewController *rootViewController;
@property(nonatomic,assign)BOOL isNormal;//判断是否是 普通使用方式

@end
