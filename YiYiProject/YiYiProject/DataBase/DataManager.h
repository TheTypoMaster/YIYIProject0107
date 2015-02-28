//
//  DataManager.h
//  YiYiProject
//
//  Created by lichaowei on 15/2/28.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDataBase.h"

typedef enum {
  
    Cache_DeserveBuy = 0,
    Cache_TPlat
    
}Cache_Type;

@interface DataManager : NSObject

+ (BOOL)cacheDataType:(Cache_Type)atype content:(NSDictionary *)content;

+ (NSDictionary *)getCacheDataForType:(Cache_Type)aType;

@end
