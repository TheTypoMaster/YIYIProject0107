//
//  GrefreshTableFooterView.h
//  GRefreTableView
//
//  Created by gaomeng on 15/3/23.
//  Copyright (c) 2015年 gaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GRefreshTableHeaderView.h"
#import "GmPrepareNetData.h"
@class SCGIFImageView;

@interface GrefreshTableFooterView : UIView
{
    GPullRefreshState _state;
    UILabel *_lastUpdatedLabel;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;
    SCGIFImageView  *loadingView;
    
}


@property(nonatomic,assign) NSObject <GRefreshTableDelegate> *delegate;
- (void)GrefreshLastUpdatedDate;
- (void)GRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)GRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)GRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;


@end
