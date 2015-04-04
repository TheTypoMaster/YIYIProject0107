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
@property(nonatomic,strong)NSString *product_name;
@property(nonatomic,assign)CGFloat location_x;
@property(nonatomic,assign)CGFloat location_y;

@end
