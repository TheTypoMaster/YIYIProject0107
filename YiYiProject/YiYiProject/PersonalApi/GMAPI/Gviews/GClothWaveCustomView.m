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

    
//    for (int i = 0; i<4; i++) {
//        UIView *infoBackView = [[UIView alloc]initWithFrame:CGRectZero];
//        infoBackView.backgroundColor = [UIColor redColor];
//        if (i == 0 || i == 2) {
//            [infoBackView setFrame:CGRectMake(0, 100, 70, 40)];
//        }else if (i == 1 || i == 3){
//            [infoBackView setFrame:CGRectMake(0+i*70, 20, 70, 40)];
//        }
//        
//        [self addSubview:infoBackView];
//        
//    }
}

@end
