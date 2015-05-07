//
//  LWaterflowView.h
//  Waterflow
//
//  Created by lichaowei on 14/12/13.
//  Copyright (c) 2014年 yangjw . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"

@protocol WaterFlowDelegate <NSObject>

@optional
- (void)waterLoadNewData;
- (void)waterLoadMoreData;
- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)waterViewNumberOfColumns;
- (void)waterScrollViewDidScroll:(UIScrollView *)scrollView;
//- (CGFloat)waterHeaderHeightquiltViewMargin:(TMQuiltView *)quilView marginType:(TMQuiltViewMarginType)marginType


@end

@interface LWaterflowView : UIView<EGORefreshTableDelegate,TMQuiltViewDataSource,TMQuiltViewDelegate>
{
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
    
    TMQuiltView *qtmquitView;
    
    UIView *tableFooterView;
    
    BOOL _noloadView;
}

@property (nonatomic,assign)id<WaterFlowDelegate>waterDelegate;
@property (nonatomic,assign)BOOL                        isReloadData;      //是否是下拉刷新数据
@property (nonatomic,assign)BOOL                        reloading;         //是否正在loading
@property (nonatomic,assign)BOOL                        isLoadMoreData;    //是否是载入更多
@property (nonatomic,assign)BOOL                        isHaveMoreData;    //是否还有更多数据,决定是否有更多view

@property (nonatomic,assign)int pageNum;//页数
@property (nonatomic,retain)NSMutableArray *dataArray;//数据源

@property(nonatomic,retain)UIActivityIndicatorView *loadingIndicator;
@property(nonatomic,retain)UILabel *normalLabel;
@property(nonatomic,retain)UILabel *loadingLabel;
@property(nonatomic,assign)BOOL hiddenLoadMore;//隐藏加载更多,默认隐藏

@property(nonatomic,assign)TMQuiltView *quitView;

@property(nonatomic,assign)CGFloat waterHeaderHeight;//头部高度

@property(nonatomic,retain)UIView *headerView;//头view

-(instancetype)initWithFrame:(CGRect)frame
               waterDelegate:(id<WaterFlowDelegate>)waterDelegate
             waterDataSource:(id<TMQuiltViewDataSource>)waterDatasource;

-(instancetype)initWithFrame:(CGRect)frame
               waterDelegate:(id<WaterFlowDelegate>)waterDelegate
             waterDataSource:(id<TMQuiltViewDataSource>)waterDatasource noloadView:(BOOL)noloadView;

/**
 *  灵活控制 刷新 header 和 footer的显示
 *  @param noHeaderRefresh 头部刷新
 *  @param noFooterRefresh 底部刷新
 */
-(instancetype)initWithFrame:(CGRect)frame
               waterDelegate:(id<WaterFlowDelegate>)waterDelegate
             waterDataSource:(id<TMQuiltViewDataSource>)waterDatasource
              noHeadeRefresh:(BOOL)noHeaderRefresh
             noFooterRefresh:(BOOL)noFooterRefresh;

- (void)reloadData;
-(void)showRefreshHeader:(BOOL)animated;

- (void)reloadData:(NSArray *)data pageSize:(int)pageSize;
//成功加载
- (void)reloadData:(NSArray *)data isHaveMore:(BOOL)isHaveMore;
- (void)reloadData:(NSArray *)data total:(int)totalPage;//更新数据 //根据总页数获取是否有更多
- (void)loadFail;//请求数据失败

-(void)removeHeaderView;


@end
