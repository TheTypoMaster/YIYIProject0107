//
//  MatchWaterflowView.m
//  YiYiProject
//
//  Created by soulnear on 14-12-25.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "MatchWaterflowView.h"

@implementation MatchWaterflowView

///这里不需要刷新
-(void)createHeaderView
{
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    qtmquitView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
//    qtmquitView.top = 0;
    
    if (scrollView.contentOffset.y <= 50)
    {
        ///up show
        
        if (upHidden)
        {
            [self setValue:@"1" forKey:@"isShowUp"];
            upHidden = NO;
        }
        
    }else
    {
        ///up hidden
        if (!upHidden)
        {
            [self setValue:@"0" forKey:@"isShowUp"];
            upHidden = YES;
        }
    }
}

-(void)setWaterBlock:(MatchWaterflowViewBlock)aBlock
{
    match_waterflow_block = aBlock;
}


@end
