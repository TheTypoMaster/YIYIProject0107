//
//  ShopFilterView.m
//  YiYiProject
//
//  Created by lichaowei on 15/6/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ShopFilterView.h"

@implementation ShopFilterView

+ (id)shareInstance
{
    static dispatch_once_t once_t;
    static ShopFilterView *dataBlock;
    
    dispatch_once(&once_t, ^{
        dataBlock = [[ShopFilterView alloc]init];
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
        
        CGFloat aWidth = self.width / 2.f;
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(aWidth / 2.f, 258 / 2.f, self.width/2.f, 394/2.f)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5.f;
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
        
        _bgView.center = CGPointMake(_bgView.center.x, DEVICE_HEIGHT/2.f);
        
        _filterArray = @[@"上衣",@"裤子",@"裙子",@"内衣",@"配饰",@"其他"];
        UITableView *table = [[UITableView alloc]initWithFrame:_bgView.bounds style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        [_bgView addSubview:table];
        
        
        
    }
    return self;
}

- (void)showFilterBlock:(FilterBlock)aBlock
{
    filterBlock = aBlock;
    
    UIView *root = [UIApplication sharedApplication].keyWindow;
    [root addSubview:self];
    
    [self shakeView:_bgView];
}

/**
 *  抖动动画
 *
 *  @param viewToShake
 */
-(void)shakeView:(UIView*)viewToShake
{
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
    
    [self hiddenAnimation:_bgView];
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
    
    if (anyTouch.view == _bgView) {
        return;
    }
    
    [self hidden];
}

#pragma mark 事件处理

- (UIButton *)buttonForTag:(int)tag
{
    return (UIButton *)[self viewWithTag:tag];
}

- (void)clickToCancel:(UIButton *)sender
{
    [self hidden];
}

- (void)clickToSure:(UIButton *)sender
{
//    if (filterBlock) {
//        filterBlock(sex_type,discount_type);
//    }
    [self hidden];
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row + 1;
    if (indexPath.row == _filterArray.count - 1) {
        
        index = 0;
    }
    
    if (filterBlock) {
        filterBlock(index);
    }
    
    [self hidden];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.height / _filterArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"filterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _filterArray[indexPath.row];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}


@end
