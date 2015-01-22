//
//  MessageDetailController.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/18.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyViewController.h"
/**
 *  消息详情
 */
@interface MessageDetailController : MyViewController

@property(nonatomic,retain)NSString *msg_id;

@property(nonatomic,assign)BOOL isActivity;//是否活动

@property(nonatomic,retain)NSString *shopName;
@property(nonatomic,retain)NSString *shopImageUrl;

@end
