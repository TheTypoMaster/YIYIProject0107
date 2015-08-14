//
//  ProductListForTagController.h
//  YiYiProject
//
//  Created by lichaowei on 15/8/13.
//  Copyright (c) 2015年 lcw. All rights reserved.
//
/**
 *  标签对应的单品列表
 */
#import "MyViewController.h"

@interface ProductListForTagController : MyViewController

@property(nonatomic,retain)NSString *tag_id;//标签id
@property(nonatomic,retain)NSString *tag_name;//标签name

@end
