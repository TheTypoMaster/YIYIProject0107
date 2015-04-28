//
//  NSString+Additions.m
//  YiYiProject
//
//  Created by lichaowei on 15/4/28.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

-(NSString *)safeString
{
    if (self == nil) {
        
        return @"";
    }
    
    return self;
}

@end
