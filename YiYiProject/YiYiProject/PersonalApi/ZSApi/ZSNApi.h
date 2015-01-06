//
//  ZSNApi.h
//  YiYiProject
//
//  Created by soulnear on 14-12-21.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSNApi : NSObject

///时间转换
/*
 placetime:时间戳
 aFormat:时间格式 全格式为YYYY-MM-dd HH:mm:ss
 */
+(NSString *)timechange:(NSString *)placetime WithFormat:(NSString *)aFormat;







@end
