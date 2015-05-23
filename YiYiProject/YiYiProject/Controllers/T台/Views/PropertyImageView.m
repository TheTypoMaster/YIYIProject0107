//
//  PropertyImageView.m
//  YiYiProject
//
//  Created by lichaowei on 15/4/20.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "PropertyImageView.h"

@implementation PropertyImageView

-(void)setImageUrls:(NSArray *)imageUrls
             infoId:(NSString *)infoId
             aModel:(id)aModel
{
    self.imageUrls = imageUrls;//imageView对应的图集url
    self.aModel = aModel;
    self.infoId = infoId;
}


///nib文件加载
-(void)awakeFromNib
{
//    self.userInteractionEnabled = YES;
//    
//    self.tapGesture = [[UITapGestureRecognizer alloc]init];
//    
//    [self addGestureRecognizer:_tapGesture];
}

//init 初始化
-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
//        self.userInteractionEnabled = YES;
//        
//        self.tapGesture = [[UITapGestureRecognizer alloc]init];
//        
//        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}



@end
