//
//  EditInfoView.m
//  YiYiProject
//
//  Created by 王龙 on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "EditInfoView.h"

@implementation EditInfoView


-(void)setPropertiesUi{
    self.headImageView.layer.masksToBounds = YES;

    
    self.womanBtn.selected = YES;
    self.manBtn.selected = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//性别选择


@end
