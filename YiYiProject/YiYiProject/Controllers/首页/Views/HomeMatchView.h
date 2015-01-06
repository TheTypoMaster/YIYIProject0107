//
//  HomeMatchView.h
//  YiYiProject
//
//  Created by soulnear on 14-12-16.
//  Copyright (c) 2014年 lcw. All rights reserved.
//
/*
 我的搭配师、人气搭配师视图
 */

#import <UIKit/UIKit.h>
#import "HomeMatchModel.h"

typedef void(^HomeMatchViewBlock)(int index);

@interface HomeMatchView : UIView
{
    HomeMatchViewBlock home_match_view_block;
}

///show是否显示申请搭配师
-(void)setupWithArray:(NSMutableArray *)array WithTitle:(NSString *)aTitle WithShowApplyView:(BOOL)show WithMyBlock:(HomeMatchViewBlock)aBlock;

@end
