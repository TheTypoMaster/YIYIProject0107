//
//  GCustomNearByView.h
//  YiYiProject
//
//  Created by gaomeng on 15/4/7.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//衣加衣首页带小脚丫的自定义view

#import <UIKit/UIKit.h>

typedef enum{
    GjiaoyaTypeNone = 0,
    GjiaoyaTypeDown,
    GjiaoyaTypeUp
}GjiaoyaType;

@interface GCustomNearByView : UIView




@property(nonatomic,assign)GjiaoyaType theType;//类型 根据脚丫上下位置判断

@property(nonatomic,strong)NSString *shopType;//1商场店铺 2精品店

@property(nonatomic,strong)UILabel *titleLabel;//商场名字

@property(nonatomic,strong)UIImageView *xiaohongdian;//小红点

@property(nonatomic,strong)UILabel *distanceLabel;//距离文字

@property(nonatomic,strong)UIImageView *jiaoya;//小脚丫图标

@property(nonatomic,strong)NSDictionary *dataDic;//数据源


-(void)loadCustomView;


@end
