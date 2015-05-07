//
//  UIImageView+Extensions.h
//  YiYiProject
//
//  Created by lichaowei on 15/5/6.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extensions)

/**
 *  imageView 封装一个button,支持点击
 *
 *  @param target   target
 *  @param selector slector
 *  @param tag      包含button tag值
 */
- (void)addTaget:(id)target action:(SEL)selector tag:(int)tag;

@end
