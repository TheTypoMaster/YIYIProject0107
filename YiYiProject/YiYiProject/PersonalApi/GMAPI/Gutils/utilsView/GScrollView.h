//
//  GScrollView.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GView.h"

@class HomeClothController;

typedef enum{
    GNEARBYNONE = 0,
    GNEARBYSTORE,
    GNEARBYPINPAI
}GSCROLLVIEWTYPE;

typedef void (^pinpaiViewBlock)(NSInteger index);//定义block

@interface GScrollView : UIScrollView


@property(nonatomic,strong)NSMutableArray *dataArray;//数据源数组
@property(nonatomic,assign)GSCROLLVIEWTYPE gtype;
@property(nonatomic,assign)HomeClothController *delegate1;


@property(nonatomic,copy)pinpaiViewBlock pinpaiViewBlock;//弄成属性
-(void)setPinpaiViewBlock:(pinpaiViewBlock)pinpaiViewBlock;//block的set方法


-(void)gReloadData;

@end
