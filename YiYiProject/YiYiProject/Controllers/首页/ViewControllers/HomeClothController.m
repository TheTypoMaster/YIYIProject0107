//
//  HomeClothViewController.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/12.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "HomeClothController.h"
#import "GCycleScrollView.h"
#import "GnearbyStoreViewController.h"
#import "GmPrepareNetData.h"
#import "NSDictionary+GJson.h"
#import "GScrollView.h"
#import "GpinpaiDetailViewController.h"
#import "GnearbyStoreViewController.h"
#import "GClothWaveCustomView.h"
#import "LoginViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "GStorePinpaiViewController.h"
#import "GwebViewController.h"
#import "MessageDetailController.h"
#import "GsearchViewController.h"
#import "ProductDetailController.h"

@interface HomeClothController ()<GCycleScrollViewDatasource,GCycleScrollViewDelegate,UIScrollViewDelegate,EGORefreshTableDelegate,GgetllocationDelegate,UISearchBarDelegate>
{
    
//    //第零行
//    UIView *_searchView;//搜索框
    
    //第一行
    GCycleScrollView *_gscrollView;//上方循环滚动的scrollview
    NSMutableArray *_topScrollviewImvInfoArray;//顶部广告scrollview图片数组
//    NSMutableArray *_topScrollviewImvInfoArray_cache;//顶部广告scrollview图片数组缓存
    
    //第二行
    UIView *_nearbyView;//附近的view
    GScrollView *_scrollview_nearbyView;//附近的view上面的scrollview
    NSMutableArray *_nearByStoreDataArray;//附近的商城数据数组
    NSMutableArray *_guanzhuStoreDataArray;//我关注的商家数据数组
    
    //第三行
    UIView *_pinpaiView;//品牌的view
    GScrollView *_scrollView_pinpai;//品牌的scrollview
    NSMutableArray *_pinpaiScrollViewModelInfoArray;//品牌信息数组
    NSMutableArray *_guanzhuPinpaiDataArray;//我关注的品牌数组
    
    
    //四个按钮
    UIButton *_nearbyBtn;//附近的商场
    UIButton *_guanzhuBtn_Store;//我关注的商场
    UIButton *_pinpaiBtn;//附近的品牌
    UIButton *_guanzhuBtn_pinpai;//我关注的品牌
    
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    
    //滑动视图
    UIScrollView *_mainScrollView;//主滚动视图
    
    
    //加载数据是否完成
    BOOL _isLoadUpPicSuccess;
    BOOL _isLoadNearbyStoreSuccess;
    BOOL _isLoadNearPinpaiSuccess;
    
    
    
    //定位相关
    NSDictionary *_locationDic;
    

}
@end

@implementation HomeClothController

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT -  64 - 44)];
    _mainScrollView.delegate = self;
    _mainScrollView.tag = 10000;

    
    NSLog(@"devh===%f",DEVICE_HEIGHT);
    
    //下拉刷新
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0-_mainScrollView.bounds.size.height, DEVICE_WIDTH, _mainScrollView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_mainScrollView addSubview:_refreshHeaderView];
    
    
    [_mainScrollView addSubview:[self creatGscrollView]];//循环滚动幻灯片
    
    [_mainScrollView addSubview:[self creatNearbyStoreView]];//附近的商场
    
    [_mainScrollView addSubview:[self creatNearbyPinpaiView]];//品牌
    
    [self.view addSubview:_mainScrollView];
    
    
    
    
//    _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH,DEVICE_HEIGHT<568?100+ 567 *DEVICE_HEIGHT/568.0f:(DEVICE_HEIGHT<736? 567 *DEVICE_HEIGHT/568.0f:567 *DEVICE_HEIGHT/568.0f-85));
    
    
    if ((_gscrollView.frame.size.height+_nearbyView.frame.size.height+_pinpaiView.frame.size.height)>DEVICE_HEIGHT-64-44) {
        _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, _gscrollView.frame.size.height+_nearbyView.frame.size.height+_pinpaiView.frame.size.height);
    }else{
        _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT-64-44+10);
    }
    
    
    
    
    //退出登录通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationOfLogOut) name:NOTIFICATION_LOGOUT object:nil];
    
    //关注通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationGuanzhupinpai) name:NOTIFICATION_GUANZHU_PINPAI object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationGuanzhustore) name:NOTIFICATION_GUANZHU_STORE object:nil];
    //取消关注通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationquxiaoguanzhupinpai) name:NOTIFICATION_GUANZHU_PINPAI_QUXIAO object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationquxiaoguanzhustore) name:NOTIFICATION_GUANZHU_STORE_QUXIAO object:nil];
    
    
    
    
    //先走缓存
    [self cacheData];
    
    
    [self performSelector:@selector(prepareNetData) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
    
    
    
    
    
    
    
}
//请求网络数据
-(void)prepareNetData{
    //获取经纬度
    [self getjingweidu];
    //网络请求
    //请求顶部滚动广告栏
    [self prepareTopScrollViewIms];
}




//走缓存数据
-(void)cacheData{
    //附近商店
    NSDictionary *storeDic = [GMAPI getHomeClothCacheOfNearStore];//商城
    _scrollview_nearbyView.dataArray = [storeDic objectForKey:@"list"];
    [_scrollview_nearbyView gReloadData];
    
    //附近的品牌
    NSDictionary *pinpaiDic = [GMAPI getHomeClothCacheOfNearPinpai];//品牌
    _scrollView_pinpai.dataArray = [pinpaiDic objectForKey:@"brand_data"];
    [_scrollView_pinpai gReloadData];
    
    //广告图
    NSDictionary *topImageDic = [GMAPI getHomeClothCacheOfTopimage];//图片
    _topScrollviewImvInfoArray = [topImageDic objectForKey:@"advertisements_data"];
    [_gscrollView reloadData];
    
}

//关注
-(void)notificationGuanzhupinpai{//品牌
    _guanzhuPinpaiDataArray = nil;
    [self prepareGuanzhuPinpai];
}

-(void)notificationGuanzhustore{//商场
    _guanzhuStoreDataArray = nil;
    [self prepareGuanzhuStore];
}


//取消关注
-(void)notificationquxiaoguanzhustore{//商场
    _guanzhuStoreDataArray = nil;
    [self prepareGuanzhuStore];
}
-(void)notificationquxiaoguanzhupinpai{//品牌
    _guanzhuPinpaiDataArray = nil;
    [self prepareGuanzhuPinpai];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getjingweidu{
    

    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusRestricted == status) {
        NSLog(@"kCLAuthorizationStatusRestricted 开启定位失败");
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"开启定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        return;
    }else if (kCLAuthorizationStatusDenied == status){
        NSLog(@"请允许衣加衣使用定位服务");
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请允许衣加衣使用定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    
    [[GMAPI appDeledate]startDingweiWithBlock:^(NSDictionary *dic) {
       
        [weakSelf theLocationDictionary:dic];
    }];

}


- (void)theLocationDictionary:(NSDictionary *)dic{
    
    NSLog(@"%@",dic);
    _locationDic = dic;
    
    
    if (dic) {
        //请求附近的品牌
        [self prepareNearbyPinpai];
        //请求附近的商店
        [self prepareNearbyStore];
        
    }
    
    
}


//退出登录后清空我关注的商家 和 我关注的品牌 数据数组
-(void)notificationOfLogOut{
    //附近的商场
    _guanzhuStoreDataArray = nil;
    _nearbyBtn.selected = YES;
    _guanzhuBtn_Store.selected = NO;
    _scrollview_nearbyView.dataArray = _nearByStoreDataArray;
    [_scrollview_nearbyView gReloadData];
    
    //附近的品牌
    _guanzhuPinpaiDataArray = nil;
    _pinpaiBtn.selected = YES;
    _guanzhuBtn_pinpai.selected = NO;
    _scrollView_pinpai.dataArray = _pinpaiScrollViewModelInfoArray;
    [_scrollView_pinpai gReloadData];
    
    
}




//请求顶部scrollview一组图片
-(void)prepareTopScrollViewIms{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *api = HOME_CLOTH_TOPSCROLLVIEW;
    
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        //缓存
        [GMAPI setHomeClothCacheOfTopImage:result];
        
        NSLog(@"%@",result);
        _topScrollviewImvInfoArray = [result objectForKey:@"advertisements_data"];
        [_gscrollView reloadData];
        
        _isLoadUpPicSuccess = YES;
        
//        if (_isLoadUpPicSuccess && _isLoadNearbyStoreSuccess && _isLoadNearPinpaiSuccess) {
            [self doneLoadingTableViewData];
//        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        _isLoadUpPicSuccess = NO;
    }];
    
}


//请求附近的商店
-(void)prepareNearbyStore{
    
    
    if (_nearByStoreDataArray.count>0) {
        _scrollview_nearbyView.dataArray = _nearByStoreDataArray;
        [_scrollview_nearbyView gReloadData];
        return;
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSString *lon = [_locationDic stringValueForKey:@"long"];
    NSString *lat = [_locationDic stringValueForKey:@"lat"];
    NSString *api = [NSString stringWithFormat:@"%@&long=%@&lat=%@&page=1&count=100",HOME_CLOTH_NEARBYSTORE,lon,lat];
    
    GmPrepareNetData *dd = [[GmPrepareNetData alloc]initWithUrl:api isPost:YES postData:nil];
    [dd requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSLog(@"%@",result);
        
        //缓存
        [GMAPI setHomeClothCacheOfNearStoreWithDic:result];
        
        _nearByStoreDataArray = [result objectForKey:@"list"];
        _scrollview_nearbyView.dataArray = _nearByStoreDataArray;
        if (_nearByStoreDataArray.count == 0) {
            [GMAPI showAutoHiddenMBProgressWithText:@"附近没有符合条件的商场" addToView:self.view];
        }
        [_scrollview_nearbyView gReloadData];
        
        _isLoadNearbyStoreSuccess = YES;

        [self doneLoadingTableViewData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        _isLoadNearbyStoreSuccess = NO;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}

//请求我关注的商店
-(void)prepareGuanzhuStore{
    
    if (_guanzhuStoreDataArray.count>0) {
        _scrollview_nearbyView.dataArray = _guanzhuStoreDataArray;
        [_scrollview_nearbyView gReloadData];
        return;
    }
    
    [self prepareGuanzhuStoreWithLocation];
    
}


-(void)prepareGuanzhuStoreWithLocation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@&authcode=%@&page=1&count=100&long=%@&lat=%@",HOME_CLOTH_GUANZHUSTORE_MINE,[GMAPI getAuthkey],[_locationDic stringValueForKey:@"long"],[_locationDic stringValueForKey:@"lat"]];
    
    NSLog(@"我关注的商店:%@",url);
    
    GmPrepareNetData *dd = [[GmPrepareNetData alloc]initWithUrl:url isPost:NO postData:nil];
    [dd requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",result);
        
        _guanzhuStoreDataArray = [result objectForKey:@"list"];
        
        if (_guanzhuBtn_Store.selected == YES) {
            _scrollview_nearbyView.dataArray = _guanzhuStoreDataArray;
        }
        
        if (_guanzhuStoreDataArray.count == 0) {
            [GMAPI showAutoHiddenMidleQuicklyMBProgressWithText:@"您还没有关注任何商场" addToView:self.view];
        }
        
        [_scrollview_nearbyView gReloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        _guanzhuBtn_Store.selected = NO;
        _nearbyBtn.selected = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [GMAPI showAutoHiddenMidleQuicklyMBProgressWithText:@"加载失败，请检查网络" addToView:self.view];
    }];

}



//请求附近的品牌
-(void)prepareNearbyPinpai{

    
    
    if (_pinpaiScrollViewModelInfoArray.count>0) {
        _scrollView_pinpai.dataArray = _pinpaiScrollViewModelInfoArray;
        [_scrollView_pinpai gReloadData];
        return;
    }
    
    [self prepareNearPinpaiWithLocation];
    
    
}

-(void)prepareNearPinpaiWithLocation{
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSString *api = HOME_CLOTH_NEARBYPINPAI;
    NSString *lon = [_locationDic stringValueForKey:@"long"];
    NSString *lat = [_locationDic stringValueForKey:@"lat"];
    NSString *url = [NSString stringWithFormat:@"%@&long=%@&lat=%@",api,lon,lat];
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:url isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",result);
        
        //缓存
        [GMAPI setHomeClothCacheOfNearPinpai:result];
        
        _pinpaiScrollViewModelInfoArray = [result objectForKey:@"brand_data"];
        _scrollView_pinpai.dataArray = _pinpaiScrollViewModelInfoArray;
        if (_pinpaiScrollViewModelInfoArray.count == 0) {
            [GMAPI showAutoHiddenMBProgressWithText:@"附近没有符合条件的品牌" addToView:self.view];
        }
        [_scrollView_pinpai gReloadData];
        
        _isLoadNearPinpaiSuccess = YES;
        [self doneLoadingTableViewData];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        _isLoadNearPinpaiSuccess = NO;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}







//请求我关注的品牌
-(void)prepareGuanzhuPinpai{
    
    if (_guanzhuPinpaiDataArray.count>0) {
        _scrollView_pinpai.dataArray = _guanzhuPinpaiDataArray;
        [_scrollView_pinpai gReloadData];
        return;
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:HOME_CLOTH_GUANZHUPINPAI_MINE,[GMAPI getAuthkey],1,[_locationDic stringValueForKey:@"lat"],[_locationDic stringValueForKey:@"long"]];
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:url isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",result);
        _guanzhuPinpaiDataArray = [result objectForKey:@"brand_data"];
        if (_guanzhuBtn_pinpai.selected == YES) {
            _scrollView_pinpai.dataArray = _guanzhuPinpaiDataArray;
        }
        
        if (_guanzhuPinpaiDataArray.count == 0) {
            [GMAPI showAutoHiddenMidleQuicklyMBProgressWithText:@"您还没有关注任何品牌" addToView:self.view];
        }
        [_scrollView_pinpai gReloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        _pinpaiBtn.selected = YES;
        _guanzhuBtn_pinpai.selected = NO;
        [GMAPI showAutoHiddenMBProgressWithText:@"加载失败，请检查网络" addToView:self.view];
    }];
}





//创建循环滚动的scrollview
-(UIView*)creatGscrollView{
    _gscrollView = [[GCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 180*GscreenRatio_568)];
    _gscrollView.theGcycelScrollViewType = GCYCELNORMORL;
    [_gscrollView loadGcycleScrollView];
    _gscrollView.tag = 200;
    _gscrollView.delegate = self;
    _gscrollView.datasource = self;
    return _gscrollView;
}

//创建附近的商城view
-(UIView*)creatNearbyStoreView{
    
    
    
    
    _nearbyView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_gscrollView.frame), DEVICE_WIDTH, 175)];
    _nearbyView.backgroundColor = [UIColor whiteColor];
    UIView *fenge = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 6)];
    fenge.backgroundColor = RGBCOLOR(228, 228, 228);
    [_nearbyView addSubview:fenge];
    
    //标题
    _nearbyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nearbyBtn setTitle:@"商 家" forState:UIControlStateNormal];
    [_nearbyBtn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
    
    [_nearbyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nearbyBtn setFrame:CGRectMake(6, 0, 60, 33)];
    _nearbyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _nearbyBtn.tag = 62;
    [_nearbyBtn addTarget:self action:@selector(nearOrGuanzhuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_nearbyBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_nearbyBtn setBackgroundImage:[UIImage imageNamed:@"g_redline_down.png"] forState:UIControlStateSelected];
    _nearbyBtn.selected = YES;
    [_nearbyView addSubview:_nearbyBtn];
    
    _guanzhuBtn_Store = [UIButton buttonWithType:UIButtonTypeCustom];
    [_guanzhuBtn_Store setTitle:@"已关注" forState:UIControlStateNormal];
    [_guanzhuBtn_Store setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
    [_guanzhuBtn_Store setBackgroundImage:[UIImage imageNamed:@"g_redline_down.png"] forState:UIControlStateSelected];
    [_guanzhuBtn_Store setBackgroundImage:nil forState:UIControlStateNormal];
    [_guanzhuBtn_Store setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_guanzhuBtn_Store setFrame:CGRectMake(CGRectGetMaxX(_nearbyBtn.frame)+10, 0, 60, 33)];
    _guanzhuBtn_Store.titleLabel.font = [UIFont systemFontOfSize:15];
    _guanzhuBtn_Store.tag = 63;
    [_guanzhuBtn_Store addTarget:self action:@selector(nearOrGuanzhuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_nearbyView addSubview:_guanzhuBtn_Store];
    
    //滚动界面

    _scrollview_nearbyView = [[GScrollView alloc]initWithFrame:CGRectMake(6, 30, DEVICE_WIDTH-12, _nearbyView.frame.size.height-30-14)];
    _scrollview_nearbyView.tag = 10;
    _scrollview_nearbyView.gtype = GNEARBYSTORE;
    _scrollview_nearbyView.delegate = self;
    _scrollview_nearbyView.showsHorizontalScrollIndicator = NO;
    _scrollview_nearbyView.delegate1 = self;
    
    [_nearbyView addSubview:_scrollview_nearbyView];
    
    
    //标题下面的分割线
    UIView *downTitleLine = [[UIView alloc]initWithFrame:CGRectMake(_nearbyBtn.frame.origin.x, CGRectGetMaxY(_nearbyBtn.frame), DEVICE_WIDTH-6, 1)];
    downTitleLine.backgroundColor = RGBCOLOR(213, 213, 213);
    [_nearbyView addSubview:downTitleLine];
    
    return _nearbyView;
}





//附近的品牌
-(UIView *)creatNearbyPinpaiView{
    
    
    
    _pinpaiView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nearbyView.frame), DEVICE_WIDTH, 195)];
    
    UIView *fenge = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 6)];
    fenge.backgroundColor = RGBCOLOR(228, 228, 228);
    [_pinpaiView addSubview:fenge];
    
    //标题
    _pinpaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pinpaiBtn setTitle:@"品 牌" forState:UIControlStateNormal];
    [_pinpaiBtn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
    [_pinpaiBtn setBackgroundImage:[UIImage imageNamed:@"g_redline_down.png"] forState:UIControlStateSelected];
    [_pinpaiBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_pinpaiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pinpaiBtn setFrame:CGRectMake(6, 0, 60, 33)];
    _pinpaiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _pinpaiBtn.selected = YES;
    _pinpaiBtn.tag = 60;
    [_pinpaiBtn addTarget:self action:@selector(nearOrGuanzhuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_pinpaiView addSubview:_pinpaiBtn];
    
    _guanzhuBtn_pinpai = [UIButton buttonWithType:UIButtonTypeCustom];
    [_guanzhuBtn_pinpai setTitle:@"已关注" forState:UIControlStateNormal];
    [_guanzhuBtn_pinpai setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
    [_guanzhuBtn_pinpai setBackgroundImage:[UIImage imageNamed:@"g_redline_down.png"] forState:UIControlStateSelected];
    [_guanzhuBtn_pinpai setBackgroundImage:nil forState:UIControlStateNormal];
    [_guanzhuBtn_pinpai setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_guanzhuBtn_pinpai setFrame:CGRectMake(CGRectGetMaxX(_pinpaiBtn.frame)+10, 0, 60, 33)];
    _guanzhuBtn_pinpai.titleLabel.font = [UIFont systemFontOfSize:15];
    _guanzhuBtn_pinpai.tag = 61;
    [_guanzhuBtn_pinpai addTarget:self action:@selector(nearOrGuanzhuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_pinpaiView addSubview:_guanzhuBtn_pinpai];
    
    
    
    
    
    //滚动界面
    _scrollView_pinpai = [[GScrollView alloc]initWithFrame:CGRectMake(6, 33, DEVICE_WIDTH-12, 165)];
    _scrollView_pinpai.tag = 11;
    _scrollView_pinpai.gtype = GNEARBYPINPAI;
    _scrollView_pinpai.delegate = self;
    _scrollView_pinpai.delegate1 = self;
    [_pinpaiView addSubview:_scrollView_pinpai];
    
    
    
    //标题下面的分割线
    UIView *downTitleLine = [[UIView alloc]initWithFrame:CGRectMake(_pinpaiBtn.frame.origin.x, CGRectGetMaxY(_pinpaiBtn.frame), DEVICE_WIDTH-6, 1)];
    downTitleLine.backgroundColor = RGBCOLOR(213, 213, 213);
    [_pinpaiView addSubview:downTitleLine];
    
    
    return _pinpaiView;
    
}



-(void)goNearbyStoreVC{
    
    GnearbyStoreViewController *nn = [[GnearbyStoreViewController alloc]init];
    nn.hidesBottomBarWhenPushed = YES;
    [self.rootViewController.navigationController pushViewController:nn animated:YES];
    
}



-(void)nearOrGuanzhuBtnClicked:(UIButton*)sender{
    
    
    NSLog(@"点击的是%ld",(long)sender.tag);
    
    
    if (sender.tag == 60) {//附近的品牌
        _pinpaiBtn.selected = YES;
        _guanzhuBtn_pinpai.selected = NO;
        [self prepareNearbyPinpai];
    }else if (sender.tag == 61){//我关注的品牌
        
        
        //判断是否登录
        if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
            LoginViewController *login = [[LoginViewController alloc]init];
            UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
            [self.rootViewController presentViewController:unVc animated:YES completion:^{
                
            }];
            return;
        }else{
            _guanzhuBtn_pinpai.selected = YES;
            _pinpaiBtn.selected = NO;
            [self prepareGuanzhuPinpai];
        }
        
    }else if (sender.tag == 62){//附近的商家
        _nearbyBtn.selected = YES;
        _guanzhuBtn_Store.selected = NO;
        [self prepareNearbyStore];
    }else if (sender.tag == 63){//我关注的商家
        
        
        //判断是否登录
        if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
            LoginViewController *login = [[LoginViewController alloc]init];
            UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
            [self.rootViewController presentViewController:unVc animated:YES completion:^{
                
            }];
            return;
        }else{
            _guanzhuBtn_Store.selected = YES;
            _nearbyBtn.selected = NO;
            [self prepareGuanzhuStore];
        }
        
        
    }
    
    
    

}




-(void)pinpaiGoleft{
    
    CGFloat xx = _scrollView_pinpai.contentOffset.x;
    CGFloat yy = _scrollView_pinpai.contentOffset.y;
    xx-=100;
    if (xx<0) {
        xx = 0;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView_pinpai.contentOffset = CGPointMake(xx, yy);
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}


-(void)pinpaiGoRight{
    
    CGFloat xx = _scrollView_pinpai.contentOffset.x;
    CGFloat yy = _scrollView_pinpai.contentOffset.y;
    NSLog(@"%f",xx);
    xx+=100;
    if (xx>_scrollView_pinpai.contentSize.width*0.5) {
        xx = _scrollView_pinpai.contentSize.width*0.5;
    }
    
    
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView_pinpai.contentOffset = CGPointMake(xx, yy);
    } completion:^(BOOL finished) {
        
    }];
}





#pragma mark - 循环滚动的scrollView的代理方法

//滚动总共几页
- (NSInteger)numberOfPagesWithScrollView:(GCycleScrollView*)theGCycleScrollView
{
    
    NSInteger num = 0;
    if (theGCycleScrollView.tag == 200) {
        num = _topScrollviewImvInfoArray.count;
    }
    return num;
    
}

//每一页
- (UIView *)pageAtIndex:(NSInteger)index ScrollView:(GCycleScrollView *)theGCycleScrollView
{
    
    
    if (theGCycleScrollView.tag == 200) {
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 180*GscreenRatio_568)];
        imv.userInteractionEnabled = YES;
        
        NSDictionary *dic = _topScrollviewImvInfoArray[index];
        NSString *str = nil;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            str = [dic stringValueForKey:@"img_url"];
        }
        
        [imv sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
        return imv;
    }
    
    return [UIView new];
    
}

//点击的哪一页
- (void)didClickPage:(GCycleScrollView *)csView atIndex:(NSInteger)index
{
    
    
    NSDictionary *dic = _topScrollviewImvInfoArray[index];
    
    
    if ([[dic stringValueForKey:@"redirect_type"]intValue]==1) {//可以跳转
        
        NSString *adv_type_val = [dic stringValueForKey:@"adv_type_val"];
        if ([adv_type_val intValue]==1) {//广告类型
            GwebViewController *gwebvc = [[GwebViewController alloc]init];
            gwebvc.urlstring = [dic stringValueForKey:@"redirect_url"];
            gwebvc.hidesBottomBarWhenPushed = YES;
            [self.rootViewController.navigationController pushViewController:gwebvc animated:YES];
        }else if ([adv_type_val intValue]==2 || [adv_type_val intValue]==3){//2:跳转商场活动  3:跳转店铺活动
            NSString *theId = [dic stringValueForKey:@"theme_id"];
            MessageDetailController *detail = [[MessageDetailController alloc]init];
            detail.msg_id = theId;
            detail.isActivity = YES;
            detail.hidesBottomBarWhenPushed = YES;
            [self.rootViewController.navigationController pushViewController:detail animated:YES];
            
        }else if ([adv_type_val intValue]==4){//跳转单品页面
            NSString *theId = [dic stringValueForKey:@"theme_id"];
            ProductDetailController *ccc = [[ProductDetailController alloc]init];
            ccc.product_id = theId;
            ccc.hidesBottomBarWhenPushed = YES;
            [self.rootViewController.navigationController pushViewController:ccc animated:YES];
            
        }
        
        
        
    }
    

    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollView.contentOffset.y:%f",scrollView.contentOffset.y);
    
    
    if (scrollView.tag == 10) {
        NSLog(@"附近 x:%f,y:%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    }else if (scrollView.tag == 11){
        NSLog(@"品牌 x:%f,y:%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    }
    
    //下拉刷新
    if (scrollView == _mainScrollView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == _mainScrollView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
}




-(void)pushToPinpaiDetailVCWithIdStr:(NSString *)theID pinpaiName:(NSString *)theName{
    
    GpinpaiDetailViewController *cc = [[GpinpaiDetailViewController alloc]init];
    cc.hidesBottomBarWhenPushed = YES;
    cc.pinpaiIdStr = theID;
    cc.pinpaiName = theName;
    cc.locationDic = _locationDic;
    [self.rootViewController.navigationController pushViewController:cc animated:YES];
    
}



-(void)pushToNearbyStoreVCWithIdStr:(NSString *)theID theStoreName:(NSString *)nameStr theType:(NSString *)mallType{
    
    
    
    if ([mallType intValue]==2) {//精品店
        
        GStorePinpaiViewController *cc = [[GStorePinpaiViewController alloc]init];
        cc.storeIdStr = theID;
        cc.storeNameStr = nameStr;
        cc.guanzhuleixing = @"精品店";
        cc.hidesBottomBarWhenPushed = YES;
        [self.rootViewController.navigationController pushViewController:cc animated:YES];
        
        
    }else if ([mallType intValue] ==3){//品牌店
        GStorePinpaiViewController *cc = [[GStorePinpaiViewController alloc]init];
        cc.storeIdStr = theID;
        cc.storeNameStr = nameStr;
        cc.guanzhuleixing = @"品牌店";
        cc.hidesBottomBarWhenPushed = YES;
        [self.rootViewController.navigationController pushViewController:cc animated:YES];
    }else if ([mallType intValue] == 1){//商场
        GnearbyStoreViewController *dd = [[GnearbyStoreViewController alloc]init];
        dd.storeIdStr = theID;
        dd.storeNameStr = nameStr;
        NSLog(@"%@",mallType);
        dd.hidesBottomBarWhenPushed = YES;
        [self.rootViewController.navigationController pushViewController:dd animated:YES];
    }
    
}





#pragma mark -  下拉刷新代理
-(void)reloadTableViewDataSource{
    
    _reloading = YES;
}

-(void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_mainScrollView];
    
}


#pragma mark - EGORefreshTableDelegate

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _nearByStoreDataArray = nil;
    _guanzhuStoreDataArray = nil;
    _pinpaiScrollViewModelInfoArray = nil;
    _guanzhuPinpaiDataArray = nil;
    
    _pinpaiBtn.selected = YES;
    _guanzhuBtn_pinpai.selected = NO;
    
    _nearbyBtn.selected = YES;
    _guanzhuBtn_Store.selected = NO;
    
    //网络请求
    //请求顶部滚动广告栏
    [self prepareTopScrollViewIms];
    [self getjingweidu];
    
    
    
    
    
    
    
    
    
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view;{
    return _reloading;
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
    return [NSDate date];
}








@end
