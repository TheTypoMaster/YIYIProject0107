//
//  GChooseLocationMoveAnViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/4/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//



//申请店铺 地图选点 拖动标注

#import <UIKit/UIKit.h>
@class ShenQingDianPuViewController;

@interface GChooseLocationMoveAnViewController : MyViewController

@property(nonatomic,assign)UITextField *delegate;//地址
@property(nonatomic,assign)ShenQingDianPuViewController *delegate2;//经纬度
@property(nonatomic,assign)UILabel *delegate3;//已选择;


@end
