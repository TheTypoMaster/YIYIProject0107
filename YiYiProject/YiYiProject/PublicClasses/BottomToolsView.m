//
//  BottomToolsView.m
//  YiYiProject
//
//  Created by lichaowei on 15/6/10.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BottomToolsView.h"

@implementation BottomToolsView

-(instancetype)initWithSuperViewHeight:(CGFloat)superViewheight
                      address:(NSString *)addressString
               isYYChatVcPush:(BOOL)isYYChatVcPush
                           actionBlock:(ACTIONBLOCK)actionBlock
{
    self = [super initWithFrame:CGRectMake(0, superViewheight - 46, DEVICE_WIDTH, 46)];
    if (self) {
        
        _actionBlock = actionBlock;
        
        //底部工具条
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        
        //导航按钮
        
        UIButton *navigationBtn = [[UIButton alloc]initWithframe:CGRectMake(0, 0, 46, 46) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"productDetail_nav"] selectedImage:nil target:self action:@selector(clickToBuy:)];
        [self addSubview:navigationBtn];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(navigationBtn.right,11.5, 1, self.height/2.f)];
        line.image = [UIImage imageNamed:@"productDetail_line"];
        [self addSubview:line];
        
        //地址
        NSString *address = [NSString stringWithFormat:@"地址: %@",addressString];
        
        CGFloat left = line.right + 10;
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(left, 0, DEVICE_WIDTH - left - 46 * 2 - 10, self.height) title:address font:14 align:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
        [self addSubview:addressLabel];
        
        //电话
        UIButton *phoneBtn = [[UIButton alloc]initWithframe:CGRectMake(DEVICE_WIDTH - 46 * 2, 0, 46, self.height) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"productDetail_phone"] selectedImage:nil target:self action:@selector(clickToPhone:)];
        [self addSubview:phoneBtn];
        
        UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(phoneBtn.right, 11.5, 1, self.height/2.f)];
        line2.image = [UIImage imageNamed:@"productDetail_line"];
        [self addSubview:line2];
        
        //聊天
        UIButton *chatBtn = [[UIButton alloc]initWithframe:CGRectMake(phoneBtn.right, 0, 46, self.height) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"productDetail_chat"] selectedImage:nil target:self action:@selector(clickToPrivateChat:)];
        [self addSubview:chatBtn];
        
        if (isYYChatVcPush) {//从聊天界面跳转过来的
            
            //聊天按钮为灰色,并不可点击
            
            chatBtn.alpha = 0.5f;
            chatBtn.userInteractionEnabled = NO;
            
        }

    }
    return self;
}

//导航
- (void)clickToBuy:(UIButton *)sender
{
    if (_actionBlock) {
        
        _actionBlock(ACTIONTYPE_NAVIGATION);
    }
}

//电话
- (void)clickToPhone:(UIButton *)sender
{
    if (_actionBlock) {
        
        _actionBlock(ACTIONTYPE_PHONE);
    }
}

//私聊
- (void)clickToPrivateChat:(UIButton *)sender
{
    if (_actionBlock) {
        
        _actionBlock(ACTIONTYPE_CHAT);
    }
}

@end
