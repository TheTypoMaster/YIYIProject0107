//
//  ChouJiangView.m
//  YiYiProject
//
//  Created by lichaowei on 15/6/29.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ChouJiangView.h"
#import "ChouJiangModel.h"

@implementation ChouJiangView
{
    __block UIButton *bigImageBtn;
    CGFloat _realHeight;//图片显示高度
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    }
    return self;
}

- (id)initWithChouJiangModel:(ChouJiangModel *)aModel
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // Initialization code
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.window.windowLevel = UIAlertViewStyleDefault;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
//        self.alpha = 0.0;
        
        CGFloat imageWidth = [aModel.big_pic_width floatValue];
        CGFloat imageHeight = [aModel.big_pic_height floatValue];
        CGFloat realWidth = DEVICE_WIDTH - 20;//显示宽度
        _realHeight = [LTools heightForImageHeight:imageHeight imageWidth:imageWidth originalWidth:realWidth];
        
        //右上角关闭按钮
        
        UIButton *clostBtn = [[UIButton alloc]initWithframe:CGRectMake(DEVICE_WIDTH - 68 - 10, 20 + 3, 68, 54) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"chouJiange_close"] selectedImage:nil target:self action:@selector(clickToClose:)];
        [self addSubview:clostBtn];
        clostBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        bigImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bigImageBtn.frame = CGRectMake(10, clostBtn.bottom - 3, realWidth, 0);
        [self addSubview:bigImageBtn];
        bigImageBtn.backgroundColor = [UIColor clearColor];
        [bigImageBtn addTarget:self action:@selector(clickToAction:) forControlEvents:UIControlEventTouchUpInside];
        [bigImageBtn addCornerRadius:5.f];
        
        UIImageView *bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bigImageBtn.width, _realHeight)];
        [bigImageView l_setImageWithURL:[NSURL URLWithString:aModel.big_pic_url] placeholderImage:DEFAULT_YIJIAYI];
        [bigImageBtn addSubview:bigImageView];
        
        
    }
    return self;
}


#pragma - mark 事件处理

- (void)clickToClose:(UIButton *)sender
{
    [self hidden];
    
    if (self.actionBlock) {
        
        self.actionBlock(ActionStyle_Close);//关闭
    }
}

- (void)clickToAction:(UIButton *)sender
{
    [self hidden];
    
    if (self.actionBlock) {
        
        self.actionBlock(ActionStyle_ChouJiang);//抽奖
    }
}

- (void)show
{
    UIView *root = [UIApplication sharedApplication].keyWindow;
    [root addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        bigImageBtn.height = _realHeight;
        self.alpha = 1.0;
    }];
}

- (void)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
       
        bigImageBtn.height = 0.f;
        bigImageBtn.width = 0.f;
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [bigImageBtn removeFromSuperview];
        bigImageBtn = nil;
    }];
}

@end
