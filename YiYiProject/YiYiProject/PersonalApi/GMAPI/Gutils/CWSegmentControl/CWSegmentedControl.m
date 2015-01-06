//
//  CWSegmentedControl.m
//  TestSegmentControl
//
//  Created by Lichaowei on 14-3-12.
//  Copyright (c) 2014年 Chaowei LI. All rights reserved.
//

#import "CWSegmentedControl.h"
#define LEFT 10
#define RIGHT 10
#define DIS 10
#define FONT [UIFont systemFontOfSize:16]
#define SPACEWIDTH 10 //空格宽度
#define SEGHEIGHT 44 //固定高度
#define PAGEWIDTH 320 //固定宽320

@implementation CWSegmentedControl

- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        CGRect aFrame = frame;
//        aFrame.size.height = SEGHEIGHT;
        [self createSegmentScrollWithTitles:titleArr];//创建滚动scrollView
    }
    return self;
}

/* 获取总长度 */

- (CGFloat)sumLenghtOfTitles:(NSArray *)tiltesArr
{
    CGFloat sumLength = ([tiltesArr count] + 1)* 10;//所有空格(+1个最后)
    for (NSString *aTitle in tiltesArr) {
        CGFloat aWidth = 10 + [aTitle sizeWithFont:FONT].width;
        sumLength += aWidth;
    }
    return sumLength;
}
/* 创建 */
- (void)createSegmentScrollWithTitles:(NSArray *)titlesArr
{
    self.titlesArray = titlesArr;
    
    segmentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, SEGHEIGHT)];
    segmentScroll.backgroundColor = [UIColor clearColor];
    segmentScroll.pagingEnabled = NO;
    segmentScroll.scrollEnabled=YES;
    segmentScroll.bounces = NO;
    segmentScroll.showsHorizontalScrollIndicator = NO;
    segmentScroll.showsVerticalScrollIndicator = NO;
    segmentScroll.contentSize = CGSizeMake([self sumLenghtOfTitles:titlesArr], SEGHEIGHT) ;
    [self addSubview:segmentScroll];
    
    indicatorImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, SEGHEIGHT)];
    indicatorImage.image = [UIImage imageNamed:@"red_background.png"];
    [segmentScroll addSubview:indicatorImage];
    
    CGFloat left = LEFT;
    for (int i = 0; i < [titlesArr count]; i ++) {
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aButton.backgroundColor = [UIColor clearColor];
        [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGFloat aWidth = 10 + [[titlesArr objectAtIndex:i] sizeWithFont:FONT].width;
        aButton.frame = CGRectMake(left, 5, aWidth, SEGHEIGHT - 5);
        [aButton setTitle:[titlesArr objectAtIndex:i] forState:UIControlStateNormal];
        aButton.tag = 100 + i;
        [aButton addTarget:self action:@selector(selectAtIndexButton:) forControlEvents:UIControlEventTouchUpInside];
        [segmentScroll addSubview:aButton];
        left += LEFT + aWidth;
    }
    
    [self moveIndicatorAtIndex:_initIndex];
}
/* 通过 index 移动指示器 */

- (void)moveIndicatorAtIndex:(NSInteger)index
{
    UIButton * aButton = (UIButton*)[segmentScroll viewWithTag:(100 + index)];
    indicatorImage.frame = CGRectMake(indicatorImage.left, 0, aButton.width + SPACEWIDTH, indicatorImage.height);
    indicatorImage.center = CGPointMake(aButton.centerX, indicatorImage.centerY);
    
    //选中
    if (self.segmentDelegate && [self.segmentDelegate respondsToSelector:@selector(didSelectIndex:)]) {
        [self.segmentDelegate didSelectIndex:index];
    }
}

/* 选择选项第几个 */

- (void)selectAtIndexButton:(UIButton *)button
{
    NSInteger index = button.tag - 100;
    [UIView beginAnimations:@"offset" context:Nil];
    [UIView setAnimationDuration:0.2];
    
    [self moveIndicatorAtIndex:index];
    [UIView commitAnimations];
    
    CGFloat aWidth = segmentScroll.contentSize.width;
    if (aWidth > segmentScroll.width) {
        UIButton * aButton = (UIButton*)[segmentScroll viewWithTag:100+index];
        CGFloat aButtonMid = aButton.center.x;
        CGFloat offsetX = 0.0f;
        CGFloat aPageWidth = segmentScroll.width;
        CGFloat aHalfPage = aPageWidth/2.f;
        if (aButtonMid < aHalfPage) //判断前半页
        {
            offsetX = 0.f;
            
        }else if(aButtonMid > aHalfPage && (aWidth - aButtonMid) > aHalfPage)
        {
            offsetX = aButtonMid - aHalfPage;
        }
        if (aWidth - aButtonMid < aHalfPage)
        {
            offsetX = aWidth - aPageWidth;
        }
        segmentScroll.contentOffset = CGPointMake(offsetX, 0);
        
        
    }
}

/**
 *  外部控制选中index
 *
 *  @param index 选项下标
 */
- (void)scrollToIndex:(NSInteger)index
{
    index = index + 100;
    UIButton *scrollToButton = (UIButton *)[self viewWithTag:index];
    [self selectAtIndexButton:scrollToButton];
}

/*获取对应 indicator frame */

- (CGRect)rectForCurrentPage:(NSInteger)currentIndex
{
    UIButton * aButton = (UIButton*)[segmentScroll viewWithTag:100 + currentIndex];
    CGRect aFrame = aButton.frame;
    aFrame.origin.x = aButton.frame.origin.x - SPACEWIDTH;
    aFrame.size.width = aButton.width + SPACEWIDTH;
    return aFrame;
}

/**
 *  通过偏移量移动指示器
 */
- (void)moveIndicatorOffSet:(CGPoint)offset;
{
    CGFloat offsetX = offset.x;
    
    //根据当前的坐标与页宽计算当前页码
    NSUInteger currentPage = floor((offsetX - PAGEWIDTH / 2) / PAGEWIDTH) + 1;
    if (currentPage > self.titlesArray.count - 1)
        currentPage = self.titlesArray.count - 1;
    
    CGFloat oldX = currentPage * PAGEWIDTH;
    if (oldX != offsetX) {
        BOOL scrollingTowards = (offsetX > oldX);
        NSInteger targetIndex = (scrollingTowards) ? currentPage + 1 : currentPage - 1;
        if (targetIndex >= 0 && targetIndex < self.titlesArray.count) {
            CGFloat ratio = (offsetX - oldX) /PAGEWIDTH;
            CGRect previousIndicatorRect = [self rectForCurrentPage: currentPage];
            CGRect nextIndicatorRect = [self rectForCurrentPage:targetIndex];
            CGFloat previousIndicatorX = previousIndicatorRect.origin.x;
            CGFloat nextIndicatorX = nextIndicatorRect.origin.x;
            
            CGRect indicatorViewFrame = indicatorImage.frame;
            
            if (scrollingTowards) {
                indicatorViewFrame.size.width = CGRectGetWidth(previousIndicatorRect) + (CGRectGetWidth(nextIndicatorRect) - CGRectGetWidth(previousIndicatorRect)) * ratio;
                indicatorViewFrame.origin.x = previousIndicatorX + (nextIndicatorX - previousIndicatorX) * ratio + SPACEWIDTH/2.0;
            } else {
                indicatorViewFrame.size.width = CGRectGetWidth(previousIndicatorRect) - (CGRectGetWidth(nextIndicatorRect) - CGRectGetWidth(previousIndicatorRect)) * ratio;
                indicatorViewFrame.origin.x = previousIndicatorX - (nextIndicatorX - previousIndicatorX) * ratio + SPACEWIDTH/2.0;
            }
            
            indicatorImage.frame = indicatorViewFrame;
        }
    }
}

//选项滑动到指定偏移位置

- (void)moveScrollOffset:(CGPoint)offset
{
    NSUInteger currentPage = floor((offset.x - PAGEWIDTH / 2) / PAGEWIDTH) + 1;
    UIButton * aButton = (UIButton*)[segmentScroll viewWithTag:(100 + currentPage)];
    [self selectAtIndexButton:aButton];
}
/**
 *  重新加载数据
 */
- (void)reloadData:(NSArray *)reloadArray
{
    [segmentScroll removeFromSuperview];
    segmentScroll = Nil;
    [self createSegmentScrollWithTitles:reloadArray];
}

@end
