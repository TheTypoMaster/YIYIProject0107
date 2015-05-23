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

@property (nonatomic,strong)id aModel;//传递一个对象

/**
 *  设置三个属性值
 *
 *  @param imageUrls 图片url数组
 *  @param infoId    信息id
 *  @param aModel    传递model
 */
-(void)setImageUrls:(NSArray *)imageUrls
             infoId:(NSString *)infoId
             aModel:(id)aModel;

@end
