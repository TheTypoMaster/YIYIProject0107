//
//  UIViewController+Addtions.h
//  YiYiProject
//
//  Created by lichaowei on 15/5/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Addtions)

/**
 *  给导航栏加返回按钮
 *
 *  @param target   事件响应者
 *  @param selector 方法选择器
 */
- (void)addBackButtonWithTarget:(id)target action:(SEL)selector;

@end
