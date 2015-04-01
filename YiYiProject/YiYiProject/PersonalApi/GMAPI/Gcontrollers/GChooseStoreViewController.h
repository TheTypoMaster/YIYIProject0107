//
//  GChooseStoreViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/1/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//



//按地区选择商场

#import <UIKit/UIKit.h>
@class ShenQingDianPuViewController;

@interface GChooseStoreViewController : MyViewController

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,assign)ShenQingDianPuViewController *delegate;


@end
