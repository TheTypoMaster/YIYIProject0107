//
//  GchooseAdressViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/1/24.
//  Copyright (c) 2015年 lcw. All rights reserved.
//



//创建商场店地图选点

#import <UIKit/UIKit.h>
@class ShenQingDianPuViewController;

@interface GchooseAdressViewController : MyViewController


@property(nonatomic,assign)UITextField *delegate;//地址
@property(nonatomic,assign)ShenQingDianPuViewController *delegate2;//经纬度
@property(nonatomic,assign)UILabel *delegate3;//已选择;

@end
