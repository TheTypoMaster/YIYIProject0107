//
//  FilterView.h
//  YiYiProject
//
//  Created by lichaowei on 14/12/21.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  值得买筛选view
 */

typedef enum {
    FilterStyle_Default = 0,//默认全部条件
    FilterStyle_NoSort, //没有排序选择
    FilterStyle_NoSexAndSort //没有性别选择和排序选择
}FilterStyle;

typedef void(^FilterBlcok)(SORT_SEX_TYPE sextType,
                           SORT_Discount_TYPE discountType,
                           NSString *lowPrice,
                           NSString *hightPrice,
                           int fenleiIndex);

@interface FilterView : UIView<UIScrollViewDelegate>
{
    UIScrollView *bgView;
    
    SORT_SEX_TYPE sex_type;
    SORT_Discount_TYPE discount_type;
    
    FilterBlcok filterBlock;
    
    UITextField *_lowPrice;//低价格
    UITextField *_highPrice;//高价格
    int _fenleiIndex;//分类
    
    int _tempSexTag;//暂存性别
    int _tempSortTag;//暂存排序
    int _tempPriceTag;//暂存价格
    NSString *_tempLowprice;
    NSString *_tempHighPrice;
    
    int _tempFenleiTag;//暂存分类
    
    BOOL _isLastReset;//记录最后一次操作是否是重置,如果是,当点击取消时恢复重置之前状态
}

+ (id)shareInstance;

- (void)showFilterBlock:(FilterBlcok)aBlock;

- (instancetype)initWithStyle:(FilterStyle)style;

@end
