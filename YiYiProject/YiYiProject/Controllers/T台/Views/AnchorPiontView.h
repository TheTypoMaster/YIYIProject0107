//
//  AnchorPiontView.h
//  YiYiProject
//
//  Created by lichaowei on 15/4/24.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PulsingHaloLayer.h"

typedef void(^AnchorClickBlock)(NSString *infoId,NSString *infoName,ShopType shopType);

/**
 *  锚点view
 */
@interface AnchorPiontView : UIView
{
    AnchorClickBlock _anchorClickBlock;
}

@property (nonatomic,strong)PulsingHaloLayer *halo;//动画layer
@property (nonatomic,strong)UIView *annimationView;//动画底部view
@property (nonatomic,strong)UILabel *titleLabel;//文字显示
@property (nonatomic,strong)UIImageView *imageView;

//额外需要参数
@property (nonatomic,weak)AnchorClickBlock anchorBlock;//锚点点击block
@property (nonatomic,strong)NSString *infoId;
@property (nonatomic,strong)NSString *infoName;
@property (nonatomic,assign)ShopType shopType;


//gm修改
@property(nonatomic,strong)UIButton *deleteBtn;//删除按钮
@property(nonatomic,assign)BOOL isRight;
@property(nonatomic,assign)CGFloat location_x;
@property(nonatomic,assign)CGFloat location_y;

- (void)setAnchorBlock:(AnchorClickBlock)anchorBlock;

/**
 *  锚点初始化
 *
 *  @param anchorPoint 锚点位置 CGPoint
 *  @param title       锚点name
 */
-(instancetype)initWithAnchorPoint:(CGPoint)anchorPoint
                             title:(NSString *)title
                             price:(NSString*)thePrice;


-(instancetype)initWithAnchorPoint:(CGPoint)anchorPoint
                             title:(NSString *)title
                    superViewWidth:(CGFloat)superViewWidth;

@end
