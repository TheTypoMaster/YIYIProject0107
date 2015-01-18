//
//  TMPhotoViewQuiltViewCell.h
//  YiYiProject
//
//  Created by unisedu on 15/1/16.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "TMQuiltViewCell.h"

@interface TMPhotoViewQuiltViewCell : TMQuiltViewCell
{
    
}

@property(nonatomic,retain)UIView *backGroudView;//背景view

@property (nonatomic, retain) UIImageView *photoView;
-(void)setValueWithDic:(NSDictionary *) dic;
@end

