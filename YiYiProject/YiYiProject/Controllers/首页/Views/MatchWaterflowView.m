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
    
    
//    match_waterflow_block(scrollView.contentOffset.y);
}

-(void)setWaterBlock:(MatchWaterflowViewBlock)aBlock
{
    match_waterflow_block = aBlock;
}


@end
