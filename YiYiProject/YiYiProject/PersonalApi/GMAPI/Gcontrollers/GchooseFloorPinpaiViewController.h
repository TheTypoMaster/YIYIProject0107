//
//  GchooseFloorPinpaiViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/1/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//



//创建商场店 选择楼层和品牌
#import <UIKit/UIKit.h>

@class ShenQingDianPuViewController;

@interface GchooseFloorPinpaiViewController : MyViewController


@property(nonatomic,assign)ShenQingDianPuViewController *delegate;

@property(nonatomic,strong)NSDictionary *havePinpaiFloordic;//有品牌的楼层

@property(nonatomic,strong)NSArray *floorArray;//楼层数组 已排序




@end
