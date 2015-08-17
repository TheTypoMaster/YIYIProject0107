//
//  MallListViewController.h
//  YiYiProject
//
//  Created by lichaowei on 15/8/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//
/**
 *  所在商场列表
 */
#import "MyViewController.h"

@interface MallListViewController : MyViewController

@property(nonatomic,retain)NSString *product_id;
@property(nonatomic,assign)CGFloat latitude;
@property(nonatomic,assign)CGFloat longtitude;

@end
