//
//  UIViewController+Addtions.m
//  YiYiProject
//
//  Created by lichaowei on 15/5/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "UIViewController+Addtions.h"

@implementation UIViewController (Addtions)

/**
 *  给导航栏加返回按钮
 *
 *  @param target   事件响应者
 *  @param selector 方法选择器
 */
- (void)addBackButtonWithTarget:(id)target action:(SEL)selector
{
    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton1.width = MY_MACRO_NAME?-10:5;
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(0,8,40,44)];
    [button_back addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [button_back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    self.navigationItem.leftBarButtonItems=@[spaceButton1,back_item];
}

@end
