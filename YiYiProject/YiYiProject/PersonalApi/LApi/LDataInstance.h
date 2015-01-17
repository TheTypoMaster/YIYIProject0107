//
//  LDataInstance.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
/**
 *  存放数据单例
 */
@interface LDataInstance : NSObject

+ (LDataInstance *)shareInstance;

@property(nonatomic,retain)MessageModel *shop_model;//商家消息
@property(nonatomic,retain)MessageModel *yiyi_model;//衣衣消息
@property(nonatomic,retain)MessageModel *other_model;//动态消息

@end
