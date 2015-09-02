//
//  ChouJiangView.h
//  YiYiProject
//
//  Created by lichaowei on 15/6/29.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChouJiangModel;

typedef enum {
    ActionStyle_Close = 1,//点击关闭
    ActionStyle_ChouJiang //抽奖
}ActionStyle;

typedef void(^ChouJiangeActionBlock)(ActionStyle actionStyle);

@interface ChouJiangView : UIView

@property(nonatomic,copy)ChouJiangeActionBlock actionBlock;

- (id)initWithChouJiangModel:(ChouJiangModel *)aModel;

- (id)initWithChouJiangModelNew:(ChouJiangModel *)aModel;

- (void)show;

- (void)showWithView:(UIView *)aView;

- (void)hidden;

@end
