//
//  CWSegmentedControl.h
//  TestSegmentControl
//
//  Created by Lichaowei on 14-3-12.
//  Copyright (c) 2014年 Chaowei LI. All rights reserved.
//

/* 使用说明 */
/* 
 #pragma - mark  UIScrollViewDelegate <NSObject>
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
 [segment moveIndicatorOffSet:scrollView.contentOffset];//随时移动指示条
 }
 
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
 {
 [segment moveScrollOffset:scrollView.contentOffset];//最后控制移动到对应选项
 }
 
 */

#import <UIKit/UIKit.h>
#import "UIViewAdditions.h"

@protocol CWSegmentDelegate <NSObject>

@optional

- (void)didSelectIndex:(NSInteger)aIndex;//选中index

@end

@interface CWSegmentedControl : UIView
{
    UIScrollView *segmentScroll;//选项
    UIImageView *indicatorImage;//底部指示
}
@property (nonatomic,retain)NSArray *titlesArray;//显示内容array
@property (nonatomic,assign)id<CWSegmentDelegate>segmentDelegate;
@property (nonatomic,assign)NSInteger initIndex;//初始化选项

- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArr;//初始化
- (void)scrollToIndex:(NSInteger)index;//通过index来滚动

- (void)moveIndicatorOffSet:(CGPoint)offset;//滑动指示
- (void)moveScrollOffset:(CGPoint)offset;//通过offset来滚动(better)

- (void)reloadData:(NSArray *)reloadArray;//根据新的数据源进行刷新

@end
