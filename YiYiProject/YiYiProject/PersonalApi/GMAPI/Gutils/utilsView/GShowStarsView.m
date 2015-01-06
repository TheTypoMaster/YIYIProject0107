//
//  GShowStarsView.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GShowStarsView.h"

@implementation GShowStarsView

-(GShowStarsView*)initWithStartNum:(int)num Frame:(CGRect)theFrame starBackName:(NSString *)theBackStarNameStr starWidth:(CGFloat)theStarWidth{
    self = [super initWithFrame:theFrame];
    if (self) {
        
        self.starWidth = theStarWidth;
        self.maxStartNum = num;
        
        CGFloat kuan = theStarWidth;
        
        for (int i = 0; i<num; i++) {
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*kuan, 0, kuan, theFrame.size.height)];
            
            //设置底层星星的image
            [imv setImage:[UIImage imageNamed:theBackStarNameStr]];
            
            NSLog(@"%@",NSStringFromCGRect(imv.frame));
            [self addSubview:imv];
        }
    }
    
    return self;
}


-(void)updateStartNum{
    
    //星星如果底层是带边框的虚星 就把下面代码注释掉
//    for (UIView *view in self.subviews) {
//        [view removeFromSuperview];
//    }
    
    self.startNum = self.startNum>self.maxStartNum ? self.maxStartNum : self.startNum;
    
    int nnn_int = (int)self.startNum;
    
    CGFloat kuan = self.starWidth;
    
    if (nnn_int<self.startNum) {//有半颗星
        
        for (int i = 0; i<nnn_int; i++) {
            NSLog(@"%d",i);
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*kuan, 0, kuan, self.frame.size.height)];
            
            //整颗星的image
            [imv setImage:[UIImage imageNamed:self.starNameStr]];
            [self addSubview:imv];
            
            if ((i+1)>=nnn_int) {
                UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0+(i+1)*kuan, 0, kuan, self.frame.size.height)];
                //半颗星的image
                [imv setImage:[UIImage imageNamed:self.star_halfNameStr]];
                [self addSubview:imv];
            }
        }
        
    }else{//没有半颗星
        for (int i = 0; i<self.startNum; i++) {
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*kuan, 0, kuan, self.frame.size.height)];
            
            [imv setImage:[UIImage imageNamed:self.starNameStr]];
            [self addSubview:imv];
        }
    }
    
    
}

@end
