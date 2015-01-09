//
//  TopicImageModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"

/**
 *  话题内容 model
 */
@interface TopicImageModel : BaseModel

@property(nonatomic,assign)CGFloat image_height; //原始
@property(nonatomic,assign)CGFloat image_resize_height;//裁剪过
@property(nonatomic,retain)NSString *image_resize_url;
@property(nonatomic,assign)CGFloat image_resize_width;
@property(nonatomic,retain)NSString *image_url;
@property(nonatomic,assign)CGFloat image_width;

@end
