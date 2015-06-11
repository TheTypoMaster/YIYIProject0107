
//
//  ImageTitleView.m
//  YiYiProject
//
//  Created by lichaowei on 15/6/11.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ImageTitleView.h"

@implementation ImageTitleView

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        self.titleLabel = [[UILabel alloc]init];
        [self addSubview:_titleLabel];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //imageView 的宽和高 == self 的高度
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
        [self addSubview:_imageView];
        self.titleLabel = [[UILabel alloc]init];
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
