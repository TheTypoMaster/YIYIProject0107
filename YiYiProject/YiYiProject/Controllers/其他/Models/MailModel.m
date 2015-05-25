//
//  MailModel.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MailModel.h"

@implementation MailModel

-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dic];
            
            // 对应的活动
            NSDictionary *activityDic = self.activity;
            
            if ([activityDic isKindOfClass:[NSDictionary class]]) {
                
                self.activityModel = [[ActivityModel alloc]initWithDictionary:activityDic];
            }
        }
    }
    return self;
}

@end
