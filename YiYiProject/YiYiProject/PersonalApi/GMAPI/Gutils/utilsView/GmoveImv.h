//
//  GmoveImv.h
//  testTouchMove
//
//  Created by gaomeng on 15/4/1.
//  Copyright (c) 2015年 gaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GmoveImv : UIImageView
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

@end
