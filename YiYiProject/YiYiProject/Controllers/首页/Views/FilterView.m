//
//  FilterView.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/21.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView

+ (id)shareInstance
{
    static dispatch_once_t once_t;
    static FilterView *dataBlock;
    
    dispatch_once(&once_t, ^{
        dataBlock = [[FilterView alloc]init];
    });
    
    return dataBlock;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([FilterView class]) owner:self options:nil]lastObject];
        
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(22, 258 / 2.f, self.width - 22 * 2, 394/2.f)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5.f;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        
        bgView.center = CGPointMake(bgView.center.x, DEVICE_HEIGHT/2.f);

        //性别选择
        
        UILabel *titleLabel = [LTools createLabelFrame:CGRectMake(24, 15, 100, 13) title:@"想看到的衣服" font:13 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"999999"]];
        [bgView addSubview:titleLabel];
        
        UIView *sexView = [[UIView alloc]initWithFrame:CGRectMake(18, titleLabel.bottom + 10, bgView.width - 18 * 2, 31)];
        sexView.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        sexView.layer.cornerRadius = 5.f;
        sexView.layer.borderWidth = 1.f;
        sexView.layer.borderColor = [UIColor colorWithHexString:@"e2e2e2"].CGColor;
        sexView.clipsToBounds = YES;
        [bgView addSubview:sexView];
        
        
        NSArray *sex_titles = @[@"全部",@"  女",@"  男"];
        
        
        CGFloat sexWidth = (sexView.width - 2) / 3.f;
    
        for (int i = 0; i < 3; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((sexWidth + 1) * i, 0, sexWidth, sexView.height);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn setTitle:sex_titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"dc4c63"] forState:UIControlStateSelected];
            [sexView addSubview:btn];
            
            if (i == 1) {
                
                [btn setImage:[UIImage imageNamed:@"shaixuan_girl"] forState:UIControlStateNormal];
            }
            
            if (i == 2) {
                
                [btn setImage:[UIImage imageNamed:@"shaixuan_boy"] forState:UIControlStateNormal];
            }
            
            [btn addTarget:self action:@selector(selectSex:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.tag = 1000 + i;
        }
        
        
        //排序选择
        
        UILabel *sortLabel = [LTools createLabelFrame:CGRectMake(24, sexView.bottom + 15, 100, 13) title:@"排序选项" font:13 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"999999"]];
        [bgView addSubview:sortLabel];
        
        UIView *sortView = [[UIView alloc]initWithFrame:CGRectMake(18, sortLabel.bottom + 10, bgView.width - 18 * 2, 31)];
        sortView.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        sortView.layer.cornerRadius = 5.f;
        sortView.layer.borderWidth = 1.f;
        sortView.layer.borderColor = [UIColor colorWithHexString:@"e2e2e2"].CGColor;
        sortView.clipsToBounds = YES;
        [bgView addSubview:sortView];
        
        NSArray *sort_titles = @[@"距离优先",@"折扣优先"];
        CGFloat sortWidth = (sortView.width - 2) / 2.f;
        for (int i = 0; i < 2; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((sortWidth + 1) * i, 0, sortWidth, sortView.height);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn setTitle:sort_titles[i] forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"dc4c63"] forState:UIControlStateSelected];
            
            [sortView addSubview:btn];
            
            [btn addTarget:self action:@selector(selectSort:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 1005 + i;
        }
        
        
        //确定 取消
        
        UIView *line_hor = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.height - 44 - 0.5, bgView.width, 0.5)];
        line_hor.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        [bgView addSubview:line_hor];
        
        CGFloat aWidth = (bgView.width - 1) / 2.f;
        UIButton *cancel_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, line_hor.bottom, aWidth, 44) normalTitle:@"取消" image:nil backgroudImage:nil superView:bgView target:self action:@selector(clickToCancel:)];
        [cancel_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel_btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        UIView *line_ver = [[UIView alloc]initWithFrame:CGRectMake(cancel_btn.right, bgView.height - 44 - 0.5, 0.5, 44)];
        line_ver.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        [bgView addSubview:line_ver];
        
        UIButton *sure_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(cancel_btn.right + 0.5, line_hor.bottom, aWidth, 44) normalTitle:@"确定" image:nil backgroudImage:nil superView:bgView target:self action:@selector(clickToSure:)];
        [sure_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sure_btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        /**
         *  初始设置
         */
        [self selectSex:[self buttonForTag:1000]];
        [self selectSort:[self buttonForTag:1005]];
        
    }
    return self;
}

- (void)showFilterBlock:(FilterBlcok)aBlock
{
    filterBlock = aBlock;
    
    UIView *root = [UIApplication sharedApplication].keyWindow;
    [root addSubview:self];
    
    [self shakeView:bgView];
}

/**
 *  抖动动画
 *
 *  @param viewToShake
 */
-(void)shakeView:(UIView*)viewToShake
{
//    CGFloat t =2.0;
//    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
//    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
//    
//    viewToShake.transform = translateLeft;
//    
//    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
//        [UIView setAnimationRepeatCount:2.0];
//        viewToShake.transform = translateRight;
//    } completion:^(BOOL finished){
//        if(finished){
//            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                viewToShake.transform =CGAffineTransformIdentity;
//            } completion:NULL];
//        }
//    }];
    
    //下边是嵌套使用,先变大再消失的动画效果.
    [UIView animateWithDuration:0.2 animations:^{
        CGAffineTransform newTransform = CGAffineTransformMakeScale(1.05, 1.05);
        [viewToShake setTransform:newTransform];
        
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.1 animations:^{
                             
                             [viewToShake setAlpha:1];
                             
                             [viewToShake setTransform:CGAffineTransformIdentity];
                             
                         } completion:^(BOOL finished){
                             
                             
                         }];
                     }];
    

    
}

- (void)hidden
{
    
//    [self removeFromSuperview];
    
    [self hiddenAnimation:bgView];
}


-(void)hiddenAnimation:(UIView*)viewToShake
{
    //下边是嵌套使用,先变大再消失的动画效果.
    [UIView animateWithDuration:0.2 animations:^{
        
//        self.alpha = 0.f;
        CGAffineTransform newTransform = CGAffineTransformMakeScale(0, 0);
        [viewToShake setTransform:newTransform];
    }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                    }];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *anyTouch = [touches anyObject];
    
    if (anyTouch.view == bgView) {
        return;
    }
    
    [self hidden];
}

#pragma mark 事件处理

- (UIButton *)buttonForTag:(int)tag
{
    return (UIButton *)[self viewWithTag:tag];
}

- (void)selectSex:(UIButton *)sender
{
    int tag = (int)sender.tag;
    
    for (int i = 0; i < 3; i ++) {
        
        if (tag == i + 1000) {
            
            [self buttonForTag:i + 1000].backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
            [self buttonForTag:i + 1000].selected = YES;
        }else
        {
           [self buttonForTag:i + 1000].backgroundColor = [UIColor whiteColor];
            [self buttonForTag:i + 1000].selected = NO;
        }
    }
    
    switch (tag - 1000) {
        case 0:
        {
            NSLog(@"全部");
            
            sex_type = Sort_Sex_No;
        }
            break;
        case 1:
        {
            NSLog(@"女");
            
            sex_type = Sort_Sex_Women;
        }
            break;
        case 2:
        {
            NSLog(@"男");
            
            sex_type = Sort_Sex_Man;
        }
            break;
            
        default:
            break;
    }
}

- (void)selectSort:(UIButton *)sender
{
    int tag = (int)sender.tag;
    
    discount_type = (tag == 1005) ? Sort_Discount_No : Sort_Discount_Yes;
    
    for (int i = 0; i < 2; i ++) {
        
        if (tag == i + 1005) {
            
            [self buttonForTag:i + 1005].backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
            [self buttonForTag:i + 1005].selected = YES;
        }else
        {
            [self buttonForTag:i + 1005].backgroundColor = [UIColor whiteColor];
            [self buttonForTag:i + 1005].selected = NO;
        }
    }
    
    switch (tag - 1005) {
        case 0:
        {
            NSLog(@"距离");
        }
            break;
        case 1:
        {
            NSLog(@"折扣");
        }
            break;
        default:
            break;
    }
}


- (void)clickToCancel:(UIButton *)sender
{
    [self hidden];
}

- (void)clickToSure:(UIButton *)sender
{
    if (filterBlock) {
        filterBlock(sex_type,discount_type);
    }
    [self hidden];
}

@end
