//
//  PropertyImageView.h
//  YiYiProject
//
//  Created by lichaowei on 15/4/20.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

///imageView子类 加了两个属性
@interface PropertyImageView : UIImageView

@property(nonatomic,retain)NSArray *imageUrls;//对应的图集url
@property(nonatomic,retain)UITapGestureRecognizer *tapGesture;//点击手势
@property(nonatomic,retain)NSString *infoId;//信息id

@end
