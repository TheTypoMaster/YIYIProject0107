//
//  UIImageView+Extensions.m
//  YiYiProject
//
//  Created by lichaowei on 15/5/6.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "UIImageView+Extensions.h"

@implementation UIImageView (Extensions)

- (void)addTaget:(id)target action:(SEL)selector tag:(int)tag
{
    self.userInteractionEnabled = YES;
    UIButton *personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    personalButton.frame = self.bounds;
    personalButton.tag = tag;
    [self addSubview:personalButton];
}

@end
