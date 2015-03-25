//
//  GrefreshTableHeaderView.h
//  GRefreTableView
//
//  Created by gaomeng on 15/3/23.
//  Copyright (c) 2015年 gaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class SCGIFImageView;

typedef enum{
    GPullRefreshPulling = 0,
    GPullRefreshNormal,
    GPullRefreshLoading,
} GPullRefreshState;

typedef enum{
    GRefreshHeader = 0,
    GRefreshFooter
} GRefreshPos;


@protocol GRefreshTableDelegate
- (void)GRefreshTableDidTriggerRefresh:(GRefreshPos)aRefreshPos;
- (BOOL)GRefreshTableDataSourceIsLoading:(UIView*)view;
- (NSDate*)GRefreshTableDataSourceLastUpdated:(UIView*)view;
@end



@interface GrefreshTableHeaderView : UIView
{
    
    GPullRefreshState _state;
    
    UILabel *_lastUpdatedLabel;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) NSObject <GRefreshTableDelegate>* delegate;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

- (void)refreshLastUpdatedDate;
- (void)GRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)GRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)GRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)setState:(GPullRefreshState)aState;

@end
