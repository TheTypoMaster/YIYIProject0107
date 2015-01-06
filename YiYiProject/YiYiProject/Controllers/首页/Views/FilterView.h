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

typedef void(^FilterBlcok)(SORT_SEX_TYPE sextType,SORT_Discount_TYPE discountType);

@interface FilterView : UIView
{
    UIView *bgView;
    
    SORT_SEX_TYPE sex_type;
    SORT_Discount_TYPE discount_type;
    
    FilterBlcok filterBlock;
}

+ (id)shareInstance;

- (void)showFilterBlock:(FilterBlcok)aBlock;

@end
