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
    
    [self.womanBtn setBackgroundImage:[UIImage imageNamed:@"bianji_gir_nor"] forState:UIControlStateNormal];
    [self.womanBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [self.manBtn setBackgroundImage:[UIImage imageNamed:@"bianji_boy_nor"] forState:UIControlStateNormal];
    [self.manBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
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
