//
//  LWaterflowView.m
//  Waterflow
//
//  Created by lichaowei on 14/12/13.
//  Copyright (c) 2014年 yangjw . All rights reserved.
//

#import "LWaterflowView.h"

#define NORMAL_TEXT @"上拉加载更多"
#define NOMORE_TEXT @"没有更多数据"

#define TABLEFOOTER_HEIGHT 50.f

@implementation LWaterflowView

- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
    qtmquitView.delegate = nil;
    qtmquitView.dataSource = nil;
    _refreshFooterView = nil;
    _refreshHeaderView = nil;
}

- (void)reloadData
{
    [qtmquitView reloadData];
}

-(instancetype)initWithFrame:(CGRect)frame
               waterDelegate:(id<WaterFlowDelegate>)waterDelegate
             waterDataSource:(id<TMQuiltViewDataSource>)waterDatasource
              noHeadeRefresh:(BOOL)noHeaderRefresh
              noFooterRefresh:(BOOL)noFooterRefresh

{
    self = [super initWithFrame:frame];
    if (self) {
        self.pageNum = 1;
        self.dataArray = [NSMutableArray array];
        
        qtmquitView = [[TMQuiltView alloc] initWithFrame:frame];
        qtmquitView.delegate = self;
        qtmquitView.dataSource = waterDatasource;
        self.waterDelegate = waterDelegate;
        
        self.quitView = qtmquitView;
        
        [self addSubview:qtmquitView];
        
        if (noHeaderRefresh == NO) {
            
            [self createHeaderView];
        }
        
        _noloadView = noFooterRefresh;

        
        if (noFooterRefresh == NO) {
            
//            [self createFooterView];
        }
        
        //        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    }
    return self;
}



-(instancetype)initWithFrame:(CGRect)frame
               waterDelegate:(id<WaterFlowDelegate>)waterDelegate
             waterDataSource:(id<TMQuiltViewDataSource>)waterDatasource noloadView:(BOOL)noloadView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pageNum = 1;
        self.dataArray = [NSMutableArray array];
        
        qtmquitView = [[TMQuiltView alloc] initWithFrame:frame];
        qtmquitView.delegate = self;
        qtmquitView.dataSource = waterDatasource;
        self.waterDelegate = waterDelegate;
        
        self.quitView = qtmquitView;
        
        [self addSubview:qtmquitView];
        
        _noloadView = noloadView;

        
        if (noloadView == NO) {
            
            
            [self createHeaderView];
            [self createFooterView];
        }
    
        //        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame
               waterDelegate:(id<WaterFlowDelegate>)waterDelegate
             waterDataSource:(id<TMQuiltViewDataSource>)waterDatasource
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pageNum = 1;
        self.dataArray = [NSMutableArray array];
        
        qtmquitView = [[TMQuiltView alloc] initWithFrame:frame];
        qtmquitView.delegate = self;
        qtmquitView.dataSource = waterDatasource;
        self.waterDelegate = waterDelegate;
        
        self.quitView = qtmquitView;
        
        [self addSubview:qtmquitView];
                
        [self createHeaderView];
//        [self createFooterView];
//        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    }
    return self;
}


//成功加载
- (void)reloadData:(NSArray *)data pageSize:(int)pageSize
{
    self.isHaveMoreData = (data.count >= pageSize ? YES : NO);
    
    if (self.isReloadData) {
        
        [self.dataArray removeAllObjects];
        
    }
    [self.dataArray addObjectsFromArray:data];
    
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0];
}


//成功加载
- (void)reloadData:(NSArray *)data isHaveMore:(BOOL)isHaveMore
{
    self.isHaveMoreData = isHaveMore;
    
    if (self.isReloadData) {
        
        [self.dataArray removeAllObjects];
        
    }
    [self.dataArray addObjectsFromArray:data];
    
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0];
}

//成功加载
- (void)reloadData:(NSArray *)data total:(int)totalPage
{
    if (self.pageNum < totalPage) {
        
        self.isHaveMoreData = YES;
    }else
    {
        self.isHaveMoreData = NO;
    }
    
    if (self.isReloadData) {
        
        [self.dataArray removeAllObjects];
        
    }
    [self.dataArray addObjectsFromArray:data];
    
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0];
}

//请求数据失败

- (void)loadFail
{
    if (self.isLoadMoreData) {
        self.pageNum --;
    }
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0];
    
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma - mark 初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

-(void)setHeaderView:(UIView *)headerView
{
    [self.quitView addSubview:headerView];
    
    _headerView = headerView;
}

#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[LRefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.bounds.size.height,
                                     self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [qtmquitView addSubview:_refreshHeaderView];
    
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = Nil;
}

-(void)testFinishedLoadData{
    
    [self removeFooterView];
    [self finishReloadingData];
    
    //如果有更多数据，重新设置footerview  frame
    
    if (_noloadView == NO) {
        
        [self createFooterView];

    }
    
    if (self.isHaveMoreData)
    {
        [self stopLoading:1];
        
    }else {
        
        [self stopLoading:2];
    }
    
//    [self setFooterView];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:qtmquitView];
        
        self.isReloadData = NO;
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:qtmquitView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
    [qtmquitView reloadData];
}


-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(qtmquitView.contentSize.height, qtmquitView.frame.size.height + self.headerView.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              qtmquitView.frame.size.width,
                                              self.bounds.size.height);
    }else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         qtmquitView.frame.size.width, self.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [qtmquitView addSubview:_refreshFooterView];
    }
    
    _refreshFooterView.backgroundColor = [UIColor clearColor];
    
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
    
    
    if (tableFooterView && [tableFooterView superview]) {
        
        [tableFooterView removeFromSuperview];
    }
    
    tableFooterView = nil;
}

//代码触发刷新
-(void)showRefreshHeader:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        qtmquitView.contentInset = UIEdgeInsetsMake(65.0f, 0.0f, 0.0f, 0.0f);
        [qtmquitView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
    }
    else
    {
        qtmquitView.contentInset = UIEdgeInsetsMake(65.0f, 0.0f, 0.0f, 0.0f);
        [qtmquitView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
    }
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:qtmquitView];
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        _isReloadData = YES;
        self.pageNum = 1;
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.5];
        
    }else if(aRefreshPos == EGORefreshFooter)
    {
        self.pageNum ++;
        
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.5];
    }
    
    // overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
    if (_waterDelegate && [_waterDelegate respondsToSelector:@selector(waterLoadNewData)]) {
        [_waterDelegate waterLoadNewData];
    }
    
//    NSLog(@"刷新完成");
//    [self testFinishedLoadData];
    
}
//加载调用的方法
-(void)getNextPageView
{
    if (_waterDelegate && [_waterDelegate respondsToSelector:@selector(waterLoadMoreData)]) {
        [_waterDelegate waterLoadMoreData];
        
    }
    
//    [self testFinishedLoadData];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (_waterDelegate && [_waterDelegate respondsToSelector:@selector(waterScrollViewDidScroll:)]) {
        
        [_waterDelegate waterScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (_waterDelegate && [_waterDelegate respondsToSelector:@selector(waterScrollViewDidEndDragging:)]) {
        
        [_waterDelegate waterScrollViewDidEndDragging:scrollView];
    }
    
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    // 下拉到最底部时显示更多数据
    
    if(_isHaveMoreData && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height-40)))
    {
        if (_waterDelegate && [_waterDelegate respondsToSelector:@selector(waterLoadMoreData)]) {
            
            [self startLoading];
            
            _isLoadMoreData = YES;
            
            self.pageNum ++;
            [_waterDelegate performSelector:@selector(waterLoadMoreData)];
        }
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    
    [self beginToReloadData:aRefreshPos];
    
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
    
    return _reloading; // should return if data source model is reloading
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    
    return [NSDate date]; // should return date data source was last changed
    
}

- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
}



#pragma mark - WaterFlowDelegate

- (void)waterLoadNewData
{
//    [self deserveBuyForSex:sex_type discount:discount_type page:waterFlow.pageNum];
}
- (void)waterLoadMoreData
{
//    [self deserveBuyForSex:sex_type discount:discount_type page:waterFlow.pageNum];
}

- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    CGFloat aHeight = 0.f;
//    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
//    if (aMode.imagelist.count >= 1) {
//        
//        NSDictionary *imageDic = aMode.imagelist[0];
//        NSDictionary *middleImage = imageDic[@"540Middle"];
//        //        CGFloat aWidth = [middleImage[@"width"]floatValue];
//        aHeight = [middleImage[@"height"]floatValue];
//    }
    
    return aHeight / 2.f + 33;
}
- (CGFloat)waterViewNumberOfColumns
{
    
    return 2;
}

#pragma mark - TMQuiltViewDataSource

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    return cell;
}

#pragma mark - TMQuiltViewDelegate

- (CGFloat)quiltViewMargin:(TMQuiltView *)quilView marginType:(TMQuiltViewMarginType)marginType
{
    if (marginType == TMQuiltViewCellMarginTop || marginType == TMQuiltViewCellMarginBottom) {
        

        
        return self.headerView ? self.headerView.height : 5;

    }
    
    return 5;
}

//列数

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    
    if (_waterDelegate && [_waterDelegate respondsToSelector:@selector(waterViewNumberOfColumns)]) {
        
        return [_waterDelegate waterViewNumberOfColumns];
    }
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
    {
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat aHeight = 0.f;
    if (_waterDelegate && [_waterDelegate respondsToSelector:@selector(waterHeightForCellIndexPath:)]) {
        
        aHeight = [_waterDelegate waterHeightForCellIndexPath:indexPath];
    }
    
    return aHeight;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index:%d",(int)indexPath.row);
    
    if (_waterDelegate && [_waterDelegate respondsToSelector:@selector(waterDidSelectRowAtIndexPath:)]) {
        
        [_waterDelegate waterDidSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark - 修改上拉部分

#pragma - mark 创建所需label 和 UIActivityIndicatorView

- (void)createFooterView
{
    CGFloat height = MAX(qtmquitView.contentSize.height, qtmquitView.frame.size.height);
    
    //没有数据的时候 需要显示没有更多数据
    if (self.dataArray.count == 0 && self.isHaveMoreData == NO) {
        
        height = 0.f;
    }
    
    if (tableFooterView && [tableFooterView superview]) {
        
        _refreshFooterView.frame = CGRectMake(0.0f,height,qtmquitView.frame.size.width,self.bounds.size.height);
    }else
    {
        tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, height, qtmquitView.width, TABLEFOOTER_HEIGHT)];
        
        [tableFooterView addSubview:self.loadingIndicator];
        [tableFooterView addSubview:self.loadingLabel];
        [tableFooterView addSubview:self.normalLabel];
        
        tableFooterView.backgroundColor = [UIColor clearColor];
        
        [qtmquitView addSubview:tableFooterView];
    }
}

- (UIActivityIndicatorView*)loadingIndicator
{
    if (!_loadingIndicator) {
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingIndicator.hidden = YES;
        _loadingIndicator.backgroundColor = [UIColor clearColor];
        _loadingIndicator.hidesWhenStopped = YES;
        _loadingIndicator.frame = CGRectMake(self.frame.size.width/2 - 70 ,6+2 + (TABLEFOOTER_HEIGHT - 40)/2.0, 24, 24);
    }
    return _loadingIndicator;
}

- (UILabel*)normalLabel
{
    if (!_normalLabel) {
        _normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8 + (TABLEFOOTER_HEIGHT - 40)/2.0, self.frame.size.width, 20)];
        _normalLabel.text = NSLocalizedString(NORMAL_TEXT, nil);
        _normalLabel.backgroundColor = [UIColor clearColor];
        [_normalLabel setFont:[UIFont systemFontOfSize:14]];
        _normalLabel.textAlignment = NSTextAlignmentCenter;
        [_normalLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    return _normalLabel;
    
}

- (UILabel*)loadingLabel
{
    if (!_loadingLabel) {
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(320.f/2-80,8 + (TABLEFOOTER_HEIGHT - 40)/2.0, self.frame.size.width/2+30, 20)];
        _loadingLabel.text = NSLocalizedString(@"加载中...", nil);
        _loadingLabel.backgroundColor = [UIColor clearColor];
        [_loadingLabel setFont:[UIFont systemFontOfSize:14]];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        [_loadingLabel setTextColor:[UIColor darkGrayColor]];
        [_loadingLabel setHidden:YES];
    }
    
    return _loadingLabel;
}


- (void)startLoading
{
    [self.loadingIndicator startAnimating];
    [self.loadingLabel setHidden:NO];
    [self.normalLabel setHidden:YES];
}

- (void)stopLoading:(int)loadingType
{
    _isLoadMoreData = NO;
    
    [self.loadingIndicator stopAnimating];
    switch (loadingType) {
        case 1:
            [self.normalLabel setHidden:NO];
            [self.normalLabel setText:NSLocalizedString(NORMAL_TEXT, nil)];
            [self.loadingLabel setHidden:YES];
            break;
        case 2:
            [self.normalLabel setHidden:NO];
            [self.normalLabel setText:NSLocalizedString(NOMORE_TEXT, nil)];
            [self.loadingLabel setHidden:YES];
            break;
        default:
            break;
    }
}


@end
