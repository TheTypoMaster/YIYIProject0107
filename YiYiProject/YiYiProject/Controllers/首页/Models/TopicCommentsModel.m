//
//  TopicCommentsModel.m
//  YiYiProject
//
//  Created by soulnear on 14-12-28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "TopicCommentsModel.h"
#import "TopicSubCommentsModel.h"

@implementation TopicCommentsModel

-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _repost_content = [NSString stringWithFormat:@"%@",[dic objectForKey:@"repost_content"]];
        _parent_post = [NSString stringWithFormat:@"%@",[dic objectForKey:@"parent_post"]];
        _r_reply_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"r_reply_id"]];
        _level = [NSString stringWithFormat:@"%@",[dic objectForKey:@"level"]];
        _post_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"post_time"]];
        _user_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"user_name"]];
        _photo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"photo"]];
        
        _post_id = [NSString stringWithFormat:@"%@",dic[@"post_id"]];//回复id
        _uid = [NSString stringWithFormat:@"%@",dic[@"uid"]];//评论发布人
        
        _child_array = [NSMutableArray array];
        
        NSArray * array = [dic objectForKey:@"child"];

        
        if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
            for (NSDictionary * aDic in array) {
                TopicSubCommentsModel * model = [[TopicSubCommentsModel alloc] initWithDictionary:aDic];
                [_child_array addObject:model];
            }
        }
    }
    return self;
}

@end
