//
//  MatchWaterflowView.h
//  YiYiProject
//
//  Created by soulnear on 14-12-25.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "LWaterflowView.h"

///offsetY 偏移量，计算滑动速度
typedef void(^MatchWaterflowViewBlock)(float offsetY);


@interface MatchWaterflowView : LWaterflowView
{
    MatchWaterflowViewBlock match_waterflow_block;
}

-(void)setWaterBlock:(MatchWaterflowViewBlock)aBlock;

@end
