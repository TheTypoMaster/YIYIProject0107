//
//  LPhotoView.m
//  YiYiProject
//
//  Created by lichaowei on 15/4/24.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "LPhotoView.h"
#import "ZoomScrollView.h"

@implementation LPhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        ZoomScrollView *firstView = [[ZoomScrollView alloc]initWithFrame:CGRectMake(_imageScroll.frame.size.width*pageIndex, 0, _imageScroll.frame.size.width, _imageScroll.frame.size.height) ];
//        //    NSURL *url = [NSURL URLWithString:[_imageArr objectAtIndex:pageIndex]];
//        
//        firstView.imageView.image = [_imageArr objectAtIndex:pageIndex];
    }
    return self;
}

@end
