//
//  MatchInfoModel.m
//  YiYiProject
//
//  Created by soulnear on 14-12-28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "MatchInfoModel.h"

@implementation MatchInfoModel


-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
        _name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        _grade = [NSString stringWithFormat:@"%@",[dic objectForKey:@"grade"]];
        _t_intro = [NSString stringWithFormat:@"%@",[dic objectForKey:@"t_intro"]];
        _photo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"photo"]];
        _relation = [NSString stringWithFormat:@"%@",[dic objectForKey:@"relation"]];
        _uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
        
        _t_tags = [NSMutableArray array];
        NSArray * array = [dic objectForKey:@"t_tags"];
        if ([array isKindOfClass:[NSArray class]] && array.count > 0)
        {
            for (NSDictionary * tags in array) {
                [_t_tags addObject:tags];
            }
        }
        
        
    }
    
    return self;
}





@end
