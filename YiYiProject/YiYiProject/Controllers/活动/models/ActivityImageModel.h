//
//  ActivityImageModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/6/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"
/**
 *  发布活动时上传图片model
 */
@interface ActivityImageModel : BaseModel

@property(nonatomic,retain)NSString *image_540;
@property(nonatomic,retain)NSString *image_height;//原图高度
@property(nonatomic,retain)NSString *image_url;
@property(nonatomic,retain)NSString *image_width;

@property(nonatomic,retain)NSString *image_resize_height;//截图高度
@property(nonatomic,retain)NSString *image_resize_url;//截图地址
@property(nonatomic,retain)NSString *image_resize_width;//截图宽度

@end
