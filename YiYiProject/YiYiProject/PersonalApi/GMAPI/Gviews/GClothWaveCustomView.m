//
//  GClothWaveCustomView.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/6.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GClothWaveCustomView.h"

@implementation GClothWaveCustomView

-(void)loadCustomViewWithDataArray:(NSArray *)dataArray pageIndex:(NSInteger)index{
    
    UIImageView *imv_back = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height-50)];
    [imv_back setImage:[UIImage imageNamed:@"gimv_back.png"]];
    
    
    [self addSubview:imv_back];
    
}

@end
