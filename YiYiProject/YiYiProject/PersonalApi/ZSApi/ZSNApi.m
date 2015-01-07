//
//  ZSNApi.m
//  YiYiProject
//
//  Created by soulnear on 14-12-21.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "ZSNApi.h"

@implementation ZSNApi

#pragma mark - 时间转化
+(NSString *)timechange:(NSString *)placetime WithFormat:(NSString *)aFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:aFormat];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[placetime doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


#pragma mark - 正则匹配所有图片
+(NSMutableArray *)regularMatchAllImagesWithContent:(NSString *)content
{
    NSError* error2 = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:REGULAR_IMAGES options:NSRegularExpressionCaseInsensitive  error:&error2];
    
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    
    // 用下面的办法来遍历每一条匹配记录
    
    NSMutableArray * image_array = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = [match range];
        NSString *tagString = [content substringWithRange:matchRange];  // 整个匹配串
        [image_array addObject:tagString];
    }
    
    
    
    NSMutableArray * content_array = [NSMutableArray array];
    
    for (int i = 0;i < image_array.count;i++)
    {
        NSString * image_string = [image_array objectAtIndex:i];
        NSArray * array = [content componentsSeparatedByString:image_string];
        
        NSString * string1 = [array objectAtIndex:0];
        if (string1.length) {
            [content_array addObject:string1];
        }
        
        [content_array addObject:image_string];
        
        if (i < image_array.count - 1)
        {
            content = [content substringFromIndex:[content rangeOfString:image_string].location+image_string.length];
        }else
        {
            NSString * string2 = [array objectAtIndex:1];
            if (string2.length) {
                [content_array addObject:string2];
            }
        }
    }
    
    
    return content_array;
}





@end
