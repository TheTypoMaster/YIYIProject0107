//
//  ShopFilterView.h
//  YiYiProject
//
//  Created by lichaowei on 15/6/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  店铺 筛选
 */

typedef void(^FilterBlock)(int filterIndex);

//1=>'上衣', 2=>'裤子', 3=>'裙子 ', 4=>'内衣 ', 5=>'配饰', 0=>'其它'

@interface ShopFilterView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_bgView;
    
    FilterBlock filterBlock;
    
    NSArray *_filterArray;//
}

+ (id)shareInstance;

- (void)showFilterBlock:(FilterBlock)aBlock;


@end
