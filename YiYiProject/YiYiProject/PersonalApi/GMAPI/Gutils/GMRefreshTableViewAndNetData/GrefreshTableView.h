//
//  GrefreshTableView.h
//  GRefreTableView
//
//  Created by gaomeng on 15/3/23.
//  Copyright (c) 2015年 gaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrefreshTableHeaderView.h"
#import "GrefreshTableFooterView.h"


@protocol GrefreshDelegate <NSObject>

- (void)loadNewData;
- (void)loadMoreData;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath;

@end

@interface GrefreshTableView : UITableView<GRefreshTableDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)GrefreshTableHeaderView * refreshHeaderView;

@property (nonatomic,assign)id<GrefreshDelegate>GrefreshDelegate;
@property (nonatomic,assign)BOOL                        isReloadData;      //是否是下拉刷新数据
@property (nonatomic,assign)BOOL                        reloading;         //是否正在loading
@property (nonatomic,assign)BOOL                        isLoadMoreData;    //是否是载入更多
@property (nonatomic,assign)BOOL                        isHaveMoreData;    //是否还有更多数据,决定是否有更多view

@property(nonatomic,retain)UIActivityIndicatorView *loadingIndicator;
@property(nonatomic,retain)UILabel *normalLabel;
@property(nonatomic,retain)UILabel *loadingLabel;

-(void)createHeaderView;
-(void)removeHeaderView;

-(void)beginToReloadData:(GRefreshPos)aRefreshPos;
-(void)showRefreshHeader:(BOOL)animated;//代码触发刷新
- (void)finishReloadigData;



- (NSDate*)GRefreshTableDataSourceLastUpdated:(UIView*)view;

@end
