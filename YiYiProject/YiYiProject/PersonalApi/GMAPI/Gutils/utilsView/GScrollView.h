//
//  GScrollView.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeClothController;

typedef void (^pinpaiViewBlock)(NSInteger index);//定义block

@interface GScrollView : UIScrollView


@property(nonatomic,strong)NSMutableArray *dataArray;//数据源数组
@property(nonatomic,assign)NSInteger gtype;
@property(nonatomic,assign)HomeClothController *delegate1;


@property(nonatomic,copy)pinpaiViewBlock pinpaiViewBlock;//弄成属性
-(void)setPinpaiViewBlock:(pinpaiViewBlock)pinpaiViewBlock;//block的set方法


-(void)gReloadData;

@end
