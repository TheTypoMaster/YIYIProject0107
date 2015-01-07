//
//  MatchCaseCell.h
//  YiYiProject
//
//  Created by soulnear on 14-12-21.
//  Copyright (c) 2014年 lcw. All rights reserved.
//
/*
 搭配师界面搭配案例cell
 */

#import <UIKit/UIKit.h>
#import "TMPhotoQuiltViewCell.h"
#import "MatchCaseModel.h"


///图片宽度
#define PIC_WIDTH DEVICE_WIDTH/2.0f-10

@interface MatchCaseCell : TMQuiltViewCell

///用户头像
@property (strong, nonatomic) UIImageView *header_imageView;
///用户昵称
@property (strong, nonatomic) UILabel *userName_label;
///搭配图片
@property (strong, nonatomic) UIImageView *pic_imageView;


-(void)setContentWithModel:(MatchCaseModel *)model;

@end
