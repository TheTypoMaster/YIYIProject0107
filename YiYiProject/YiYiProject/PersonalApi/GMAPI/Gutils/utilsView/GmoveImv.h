//
//  GmoveImv.h
//  testTouchMove
//
//  Created by gaomeng on 15/4/1.
//  Copyright (c) 2015年 gaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnchorPiontView.h"

typedef void(^DeleteBlock)(NSInteger theTag);

@interface GmoveImv : UIView
{
    CGPoint _startPoint;
}

@property(nonatomic,strong)NSString *shop_id;
@property(nonatomic,strong)NSString *product_id;
@property(nonatomic,strong)NSString *shop_name;
@property(nonatomic,strong)NSString *product_price;//当锚点类型为店铺的时候为店铺地址
@property(nonatomic,strong)NSString *product_name;
@property(nonatomic,assign)CGFloat location_x;
@property(nonatomic,assign)CGFloat location_y;
@property(nonatomic,strong)NSString *type;//单品 店铺



@property (nonatomic,strong)PulsingHaloLayer *halo;//动画layer
@property (nonatomic,strong)UIView *annimationView;//动画底部view
@property (nonatomic,strong)UILabel *titleLabel;//文字显示
@property (nonatomic,strong)UIImageView *imageView;
@property(nonatomic,assign)BOOL isRight;

//额外需要参数
@property (nonatomic,copy)DeleteBlock deleteBlock;//锚点点击block
@property(nonatomic,strong)UIButton *deleteBtn;//删除按钮
@property (nonatomic,strong)NSString *infoId;
@property (nonatomic,strong)NSString *infoName;
@property (nonatomic,assign)ShopType shopType;




-(instancetype)initWithAnchorPoint:(CGPoint)anchorPoint
                             title:(NSString *)title
                             width:(CGFloat)theWidth
                               tag:(NSInteger)theTag;


-(void)setDeleteBlock:(DeleteBlock)deleteBlock;


-(void)loadNewTitle:(NSString *)title;

@end
