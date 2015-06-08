//
//  DataManager.m
//  YiYiProject
//
//  Created by lichaowei on 15/2/28.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

/**
 *  NSDictionary 转 JSONString
 *
 */
+ (NSString*)DataToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (id)objectForJsonString:(NSString *)string
{
   return [string objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];//来解析
}


//缓存值得买数据或者t台数据
+ (BOOL)cacheDataType:(Cache_Type)atype content:(NSDictionary *)content
{
    sqlite3 *db = [LDataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    //先查询有没有数据,有的话删除,没有的话直接插入
    
    if ([self getCacheDataForType:atype]) {
        
        int result = sqlite3_prepare(db, "delete from cache where type = ?", -1, &stmt, nil);//?相当于%@格式
        
        NSString *type = (atype == Cache_DeserveBuy) ? CACHE_DESERVE_BUY : CACHE_TPLAT;
        
        sqlite3_bind_text(stmt, 1, [type UTF8String], -1, NULL);
        
        result = sqlite3_step(stmt);
        
        if (result == SQLITE_DONE) {
            
            NSLog(@"删除成功");
        }
    }
    
    int result = sqlite3_prepare(db, "insert into cache(type,content) values(?,?)", -1, &stmt, nil);//?相当于%@格式
    
    NSString *type = (atype == Cache_DeserveBuy) ? CACHE_DESERVE_BUY : CACHE_TPLAT;
    
    sqlite3_bind_text(stmt, 1, [type UTF8String], -1, NULL);
    
    
    NSString *jsonstr = [self DataToJsonString:content];
    
    if (jsonstr == nil || jsonstr.length == 0) {
        jsonstr = @"";
    }
    
    sqlite3_bind_text(stmt, 2, [jsonstr UTF8String], -1, NULL);
    
    result = sqlite3_step(stmt);
    
    NSLog(@"save brand %@ brandResult:%d",type,result);
    
    sqlite3_finalize(stmt);
    
    if (result == SQLITE_DONE) {
        
        return YES;
    }
    
    return NO;
}

//获取缓存值得买数据或者t台数据

+ (NSDictionary *)getCacheDataForType:(Cache_Type)aType
{
    //打开数据库
    sqlite3 *db = [LDataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from cache where type = ?", -1, &stmt, nil);
    NSLog(@"All cache result = %d",result);

    if (result == SQLITE_OK) {
        
        NSString *type = (aType == Cache_DeserveBuy) ? CACHE_DESERVE_BUY : CACHE_TPLAT;
        
        sqlite3_bind_text(stmt, 1, [type UTF8String], -1, NULL);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
//            const unsigned char *type = sqlite3_column_text(stmt, 0);
            const unsigned char *content = sqlite3_column_text(stmt, 1);
            
//            NSLog(@"type=%@ content=%@",[NSString stringWithUTF8String:(const char *)type],[NSString stringWithUTF8String:(const char *)content]);
            
            NSString *jsonStr = [NSString stringWithUTF8String:(const char *)content];
            
            NSDictionary *dic = [self objectForJsonString:jsonStr];
            
            return dic;
        }
    }
    sqlite3_finalize(stmt);
    return nil;
    
}

@end
