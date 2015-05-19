//
//  UserInfo.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/13.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "UserInfo.h"
#import <objc/runtime.h>

@implementation UserInfo

- (void)encodeWithCoder:(NSCoder *)coder
{
    //    [super encodeWithCoder:coder];
    unsigned int num = 0;
    Ivar *ivars = class_copyIvarList([UserInfo class], &num);
    
    for (int i = 0; i < num; i ++) {
        
        //取出i位置成员变量
        Ivar ivar = ivars[i];
        
        //查看成员变量
        const char *name = ivar_getName(ivar);
        
        //归档
        
        NSString *key = [NSString stringWithUTF8String:name];
        
        NSLog(@"归档 key %@",key);
        
        id value = [self valueForKey:key];
        
        [coder encodeObject:value forKey:key];
    }
    free(ivars);
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        unsigned int num = 0;
        Ivar *ivars = class_copyIvarList([UserInfo class], &num);
        
        for (int i = 0; i < num; i ++) {
            
            Ivar ivar = ivars[i];
            
            const char *name = ivar_getName(ivar);
            
            NSString *key = [NSString stringWithUTF8String:name];
            
            //解档
            
            id value = [coder decodeObjectForKey:key];
            
            [self setValue:value forKey:key];
        }
    }
    return self;
}


@end
