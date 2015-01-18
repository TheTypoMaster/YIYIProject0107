//
//  LDataInstance.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "LDataInstance.h"

@implementation LDataInstance

+ (id)shareInstance
{
    static LDataInstance *Instance = nil;
    static dispatch_once_t once_t;
    
    dispatch_once(&once_t, ^{
        
        Instance = [[LDataInstance alloc]init];
        
    });
    return Instance;
}

@end
