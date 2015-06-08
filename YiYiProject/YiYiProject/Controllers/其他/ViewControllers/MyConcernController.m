//
//  MyConcernController.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyConcernController.h"
#import "RefreshTableView.h"

#import "LWaterflowView.h"

#import "ShopViewCell.h"
#import "BrandViewCell.h"
#import "TPlatCell.h"

#import "GpinpaiDetailViewController.h"
#import "GnearbyStoreViewController.h"

#import "GStorePinpaiViewController.h"

#import "NSDictionary+GJson.h"

#import "ProductDetailController.h"//单品详情页

#define TAGINCREM_PRODUCT 10000 //单品tag增量
#define TAGINCREM_TTAI 20000 //t台
#define TAGINCREM_STROE 30000 //商家
#define TAGINCREM_BRAND 40000 //品牌

@interface MyConcernController ()<RefreshDelegate,UITableViewDataSource,UIScrollViewDelegate,WaterFlowDelegate,TMQuiltViewDataSource>
{
    UIButton *heartButton;
    UIView *indicator;
    UIScrollView *bgScroll;
    
    LWaterflowView *waterFlow;//单品
    LWaterflowView *waterFlow_t;//T台
    RefreshTableView *shopTable;//店铺table
    RefreshTableView *brandTable;//品牌table
    
    BOOL isEditing;//是否处于编辑状态
    
    LTools *tool_shop;
    LTools *tool_brand;
    
    BOOL cancel_mail_notification;//是否发送取消通知
    BOOL cancel_brand_notification;//是否发送取消通知
    
    
    SORT_SEX_TYPE sex_type;
    SORT_Discount_TYPE discount_type;
    
    LTools *tool_collection_list;//收藏列表单品
    LTools *tool_Ttai_list;//收藏列表T台

    
    NSString *_latitude;//维度
    NSString *_longtitud;//经度
    
}

@property(nonatomic,assign)BOOL isReloadProduct;//是否刷新单品收藏

@property(nonatomic,assign)BOOL isReloadTTai;//是否刷新T台收藏

@property(nonatomic,assign)BOOL isRePrepareNetData_shop;//是否重新请求关注商家信息

@property(nonatomic,assign)BOOL isRePrepareNetData_pinpai;//是否重新请求关注品牌信息

@end

@implementation MyConcernController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden=NO;
    
    if (self.isRePrepareNetData_pinpai) {//从新加载关注品牌
        
        brandTable.isReloadData = YES;

        [self getBrand];
    }else if (self.isRePrepareNetData_shop){//从新加载关注商家
        
        shopTable.isReloadData = YES;
        [self getShop];
    }
    
    if (self.isReloadProduct) {
        
        [waterFlow showRefreshHeader:YES];
        _isReloadProduct = NO;
    }
    
    //在此无效
//    if (self.isReloadTTai) {
//        
//        [waterFlow_t showRefreshHeader:YES];
//        _isReloadTTai = NO;
//    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)dealloc
{
    [tool_shop cancelRequest];
    [tool_brand cancelRequest];
    
    waterFlow.waterDelegate = nil;
    waterFlow = nil;
    [tool_collection_list cancelRequest];
    
    waterFlow_t.waterDelegate = nil;
    waterFlow_t = nil;
    [tool_Ttai_list cancelRequest];
    
    heartButton = nil;
    indicator = nil;
    shopTable.dataSource = nil;
    shopTable.refreshDelegate = nil;
    shopTable = nil;
    
    brandTable.dataSource = nil;
    brandTable.refreshDelegate = nil;
    brandTable = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    [self createSegButton];
    [self createViews];
    
    __weak typeof(self)weakSelf = self;
    [[GMAPI appDeledate]startDingweiWithBlock:^(NSDictionary *dic) {
        
        [weakSelf theLocationDictionary:dic];
    }];
    
    [self getTTaiCollect];//T台收藏
    [self getBrand];//品牌
    [self getShop];//商家
    
    //是自己的话需要编辑按钮
    if (([self.uid isKindOfClass:[NSString class]] && [self.uid isEqualToString:[GMAPI getUid]]) || self.uid.length == 0)
    {
        
        self.myTitleLabel.text = @"我的收藏";
        
        [self createNavigationbarTools];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTheRefreshTypeOfShop) name:NOTIFICATION_GUANZHU_STORE_QUXIAO object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTheRefreshTypeOfPinpai) name:NOTIFICATION_GUANZHU_PINPAI object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTheRefreshTypeOfPinpai) name:NOTIFICATION_GUANZHU_PINPAI_QUXIAO object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRefreshProduct:) name:NOTIFICATION_GUANZHU_PRODUCT object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRefreshTTai:) name:NOTIFICATION_GUANZHU_TTai object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTTai:) name:NOTIFICATION_TPLATDETAILCLOSE object:nil];
        
    }else{
        self.myTitleLabel.text = @"收藏";
    }
    
}

#pragma mark - 通知处理

//是否刷新
-(void)changeTheRefreshTypeOfShop{//关注的商家
    self.isRePrepareNetData_shop = YES;
}
-(void)changeTheRefreshTypeOfPinpai{//关注的品牌
    self.isRePrepareNetData_pinpai = YES;
}

- (void)changeRefreshProduct:(NSNotification *)notify
{
    self.isReloadProduct = YES;
}

- (void)refreshTTai:(NSNotification *)notify
{
    if (self.isReloadTTai) {
        
        [waterFlow_t showRefreshHeader:YES];
        _isReloadTTai = NO;
    }
}

- (void)changeRefreshTTai:(NSNotification *)notify
{
    self.isReloadTTai = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftButtonTap:(UIButton *)sender
{
    if (cancel_mail_notification) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE_QUXIAO object:nil];
        
    }
    
    if (cancel_brand_notification) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_PINPAI_QUXIAO object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络请求

/**
 *  取消关注 品牌
 */
- (void)cancelConcernBrand:(UIButton *)sender
{
    
    cancel_brand_notification = YES;
    
    int index = (int)sender.tag - TAGINCREM_BRAND;
    BrandModel *aModel = brandTable.dataArray[index];
    
    __weak typeof(self)weakSelf = self;
    //测试
    NSString *authkey = [GMAPI getAuthkey];
    
    NSString *post = [NSString stringWithFormat:@"brand_id=%@&authcode=%@",aModel.id,authkey];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@&%@",MY_CONCERN_BRAND_CANCEL,post];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        [weakSelf refreshBrandList:index];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
    
}

/**
 *  取消关注 商家
 */
- (void)cancelConcernMail:(UIButton *)sender
{
    cancel_mail_notification = YES;
    
    int index = (int)sender.tag - TAGINCREM_STROE;
    MailModel *aModel = shopTable.dataArray[index];
    
    __weak typeof(self)weakSelf = self;
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //测试
    NSString *authkey = [GMAPI getAuthkey];
    NSString *post = @" ";
    NSString *url = @" ";
    if ([aModel.mall_type intValue] == 3) {//品牌店
        url = GQUXIAOGUANZHUPINPAIDIAN;
        post = [NSString stringWithFormat:@"shop_id=%@&authcode=%@",aModel.shop_id,authkey];
    }else if ([aModel.mall_type intValue] == 2){//精品店
        url = [NSString stringWithFormat:QUXIAOGUANZHU_SHANGCHANG];
        post = [NSString stringWithFormat:@"mall_id=%@&authcode=%@",aModel.mall_id,authkey];
    }else if ([aModel.mall_type intValue] == 1){//大商场
        url = [NSString stringWithFormat:QUXIAOGUANZHU_SHANGCHANG];
        post = [NSString stringWithFormat:@"mall_id=%@&authcode=%@",aModel.mall_id,authkey];
    }
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([[result stringValueForKey:@"errorcode"]intValue]==0) {
            [GMAPI showAutoHiddenMBProgressWithText:@"取消关注成功" addToView:self.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE_QUXIAO object:nil];
            //刷新数据
            [weakSelf refreshMailList:index];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}

/**
 *  获取品牌
 */
- (void)getBrand
{
    
    if (tool_brand) {
        
        [tool_brand cancelRequest];
    }
    NSString *userId = self.uid.length > 0 ? self.uid : [GMAPI getUid];

    NSString *url = [NSString stringWithFormat:MY_CONCERN_BRAND,[GMAPI getAuthkey],brandTable.pageNum,userId];
    tool_brand = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool_brand requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        NSArray *brand_data = result[@"brand_data"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *aDic in brand_data) {
            
            BrandModel *aModel = [[BrandModel alloc]initWithDictionary:aDic];
            [arr addObject:aModel];
        }
        
//        int count = [result[@"count"] intValue];
        
        BOOL isHaveMore = YES;
        
        if (arr.count < L_PAGE_SIZE) {
            
            isHaveMore = NO;
        }
        
        [brandTable reloadData:arr isHaveMore:isHaveMore];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
//        [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
        
        [brandTable loadFail];
    }];
}
/**
 *  获取商家
 */
- (void)getShop
{
    
    if (tool_shop) {
        [tool_shop cancelRequest];
    }
    
    NSString *longtitud = _longtitud ? _longtitud : @"116.42111721";
    NSString *latitude = _latitude ? _latitude : @"39.90304099";
    
    NSString *userId = self.uid.length > 0 ? self.uid : [GMAPI getUid];
    
    NSString *url = [NSString stringWithFormat:MY_CONCERN_SHOP,[GMAPI getAuthkey],shopTable.pageNum,L_PAGE_SIZE,userId,latitude,longtitud];
    
    tool_shop = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool_shop requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        id list = result[@"list"];
        NSArray *temp_arr;
        if ([list isKindOfClass:[NSArray class]]) {
            
            temp_arr = [NSArray arrayWithArray:list];
        }else if([list isKindOfClass:[NSDictionary class]]){
            
            temp_arr = [NSArray arrayWithArray:((NSDictionary *)list).allValues];
        }
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:temp_arr.count];
        for (NSDictionary *aDic in temp_arr) {
            
            MailModel *aModel = [[MailModel alloc]initWithDictionary:aDic];
            [arr addObject:aModel];
        }

        BOOL isHaveMore = YES;
        
        if (arr.count < L_PAGE_SIZE) {
            
            isHaveMore = NO;
        }
        
        [shopTable reloadData:arr isHaveMore:isHaveMore];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
//        [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
        
        [shopTable loadFail];
    }];
}

/**
 *  我的收藏
 */
- (void)getMyCollection
{
    if (tool_collection_list) {
        [tool_collection_list cancelRequest];
    }
    
    NSString *longtitud = _longtitud ? _longtitud : @"116.42111721";
    NSString *latitude = _latitude ? _latitude : @"39.90304099";
    
    NSString *userId = self.uid.length > 0 ? self.uid : [GMAPI getUid];
    
    NSString *url = [NSString stringWithFormat:GET_MY_CILLECTION,longtitud,latitude,waterFlow.pageNum,L_PAGE_SIZE,[GMAPI getAuthkey],userId];
    tool_collection_list = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool_collection_list requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSMutableArray *arr;
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *list = result[@"list"];
            arr = [NSMutableArray arrayWithCapacity:list.count];
            if ([list isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *aDic in list) {
                    
                    ProductModel *aModel = [[ProductModel alloc]initWithDictionary:aDic];
                    
                    [arr addObject:aModel];
                }
                
            }
            
            [waterFlow reloadData:arr pageSize:L_PAGE_SIZE];
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);

        [waterFlow loadFail];
        
    }];
}

//获取T台收藏
- (void)getTTaiCollect
{
    
    if (tool_Ttai_list) {
        
        [tool_Ttai_list cancelRequest];
        tool_Ttai_list = nil;
    }
    
    NSString *userId = self.uid.length > 0 ? self.uid : [GMAPI getUid];
//    http://www.alayy.com/index.php?d=api&c=tplat&m=get_favor_list&page=%d&per_page=%d&authcode=%@&uid=
    //请求网络数据
    NSString *api = [NSString stringWithFormat:TTAI_COLLECT_LIST,waterFlow_t.pageNum,L_PAGE_SIZE,[GMAPI getAuthkey],userId];
    NSLog(@"请求我的收藏T台的接口%@",api);
    
    tool_Ttai_list = [[LTools alloc]initWithUrl:api isPost:NO postData:nil];
    [tool_Ttai_list requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result : %@",result);
        NSMutableArray *arr;
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *list = result[@"list"];
            arr = [NSMutableArray arrayWithCapacity:list.count];
            if ([list isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *aDic in list) {
                    
                    NSDictionary *ttinfo = aDic[@"tt_info"];
                    
                    if ([LTools isDictinary:ttinfo]) {
                        
                        TPlatModel *aModel = [[TPlatModel alloc]initWithDictionary:ttinfo];
                        aModel.is_favor = 1;
                        [arr addObject:aModel];
                    }
                }
                
            }
        }
        
        [waterFlow_t reloadData:arr pageSize:L_PAGE_SIZE];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [waterFlow_t loadFail];
    }];
    
}

//T台赞 或 取消

- (void)zanTTaiDetail:(UIButton *)zan_btn
{
    if (![LTools isLogin:self]) {
        return;
    }
    
    [LTools animationToBigger:zan_btn duration:0.2 scacle:1.5];
    
    
    NSString *authkey = [GMAPI getAuthkey];
    
    
    TPlatCell *cell = (TPlatCell *)[waterFlow_t.quitView cellAtIndexPath:[NSIndexPath indexPathForRow:zan_btn.tag - TAGINCREM_TTAI inSection:0]];
    
    TPlatModel *detail_model = waterFlow_t.dataArray[zan_btn.tag - TAGINCREM_TTAI];
    NSString *t_id = detail_model.tt_id;
    NSString *post = [NSString stringWithFormat:@"tt_id=%@&authcode=%@",t_id,authkey];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url;
    
    BOOL zan = zan_btn.selected ? NO : YES;
    
    
    if (zan) {
        url = TTAI_ZAN;
    }else
    {
        url = TTAI_ZAN_CANCEL;
    }
    
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        zan_btn.selected = !zan_btn.selected;
        
        int like_num = [detail_model.tt_like_num intValue];
        detail_model.tt_like_num = [NSString stringWithFormat:@"%d",zan ? like_num + 1 : like_num - 1];
        detail_model.is_like = zan ? 1 : 0;
        cell.like_label.text = detail_model.tt_like_num;
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        
        
    }];
}

/**
 *  赞 取消赞 收藏 取消收藏
 */

- (void)zanProduct:(UIButton *)sender
{
    if (![LTools isLogin:self]) {
        
        return;
    }
    //直接变状态
    //更新数据
    
    [LTools animationToBigger:sender duration:0.2 scacle:1.5];
    
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[waterFlow.quitView cellAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - TAGINCREM_PRODUCT inSection:0]];
    //    cell.like_label.text = @"";
    
    ProductModel *aMode = waterFlow.dataArray[sender.tag - TAGINCREM_PRODUCT];
    
    NSString *productId = aMode.product_id;
    
//    __weak typeof(self)weakSelf = self;
    
    __block BOOL isZan = !sender.selected;
    
    NSString *api = sender.selected ? HOME_PRODUCT_ZAN_Cancel : HOME_PRODUCT_ZAN_ADD;
    
    NSString *post = [NSString stringWithFormat:@"product_id=%@&authcode=%@",productId,[GMAPI getAuthkey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url = api;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        sender.selected = isZan;
        aMode.is_like = isZan ? 1 : 0;
        aMode.product_like_num = NSStringFromInt([aMode.product_like_num intValue] + (isZan ? 1 : -1));
        cell.like_label.text = aMode.product_like_num;
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
        aMode.product_like_num = NSStringFromInt([aMode.product_like_num intValue]);
        cell.like_label.text = aMode.product_like_num;
    }];
}


#pragma mark - 创建视图

- (void)createNavigationbarTools
{
    UIButton *rightView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightView.backgroundColor=[UIColor clearColor];
    
        
        heartButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [heartButton addTarget:self action:@selector(clickToEdit:) forControlEvents:UIControlEventTouchUpInside];
        [heartButton setTitleColor:RGBCOLOR(252, 76, 139) forState:UIControlStateNormal];
        [heartButton setTitle:@"编辑" forState:UIControlStateNormal];
        [heartButton  setTitle:@"完成" forState:UIControlStateSelected];
        heartButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [heartButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [rightView addSubview:heartButton];
        
        heartButton.hidden = YES;
        
        UIBarButtonItem *comment_item=[[UIBarButtonItem alloc]initWithCustomView:rightView];
        self.navigationItem.rightBarButtonItem = comment_item;
    
}

- (void)createSegButton
{
    UIView *segView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 45)];
    segView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:segView];
    
    NSArray *titles = @[@"单品",@"T台",@"商家",@"品牌"];
    for (int i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.frame = CGRectMake(DEVICE_WIDTH/4.f * i, 0, DEVICE_WIDTH/4.f, 45);
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [segView addSubview:btn];
        
        [btn addTarget:self action:@selector(clickToSwap:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            btn.selected = YES;
        }
    }
    
    indicator = [[UIView alloc]initWithFrame:CGRectMake(0, 43, DEVICE_WIDTH/4.f, 2)];
    indicator.backgroundColor = [UIColor colorWithHexString:@"ea5670"];
    [segView addSubview:indicator];
}

- (void)createViews
{
    bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 45, DEVICE_WIDTH, DEVICE_HEIGHT - 46 - 20 - 44)];
    bgScroll.delegate = self;
    [self.view addSubview:bgScroll];
    bgScroll.pagingEnabled = YES;
    bgScroll.bounces = NO;
    bgScroll.contentSize = CGSizeMake(DEVICE_WIDTH * 4, bgScroll.height);
    
    //scrollView 和 系统手势冲突问题
    [bgScroll.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    //单品
    waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, bgScroll.height) waterDelegate:self waterDataSource:self];
    waterFlow.backgroundColor = RGBCOLOR(235, 235, 235);
    
    [bgScroll addSubview:waterFlow];
    
    
    //收藏T台
    
    waterFlow_t = [[LWaterflowView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, bgScroll.height) waterDelegate:self waterDataSource:self];
    waterFlow_t.backgroundColor = RGBCOLOR(235, 235, 235);
    [bgScroll addSubview:waterFlow_t];
    
    //店铺
    shopTable = [[RefreshTableView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH * 2, 0, DEVICE_WIDTH, bgScroll.height) showLoadMore:YES];
    shopTable.refreshDelegate = self;
    shopTable.dataSource = self;
    [bgScroll addSubview:shopTable];
    shopTable.backgroundColor = [UIColor clearColor];
    shopTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //品牌
    brandTable = [[RefreshTableView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH * 3, 0, DEVICE_WIDTH, bgScroll.height) showLoadMore:YES];
    brandTable.refreshDelegate = self;
    brandTable.dataSource = self;
    [bgScroll addSubview:brandTable];
    brandTable.backgroundColor = [UIColor clearColor];
    brandTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 事件处理

/**
 *  控制button的选中状态和indicator显示
 *
 *  @param page 当前第几个
 */
- (void)controllButtonSelectAtIndex:(int)page
{
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:100];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:102];
    UIButton *btn4 = (UIButton *)[self.view viewWithTag:103];
    
    if (page == 0 || page == 1) {
        
        heartButton.hidden = YES;
    }else
    {
        heartButton.hidden = NO;
    }
    
    if (page == 0) {
        
        btn1.selected = YES;
        btn2.selected = NO;
        btn3.selected = NO;
        btn4.selected = NO;
        indicator.left = 0;
    }else if (page == 1){
        
        btn1.selected = NO;
        btn2.selected = YES;
        btn3.selected = NO;
        btn4.selected = NO;
        indicator.left = DEVICE_WIDTH/4.f;
        
    }else if (page == 2){
        
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = YES;
        btn4.selected = NO;
        indicator.left = DEVICE_WIDTH/4.f * 2;
        
    }else
    {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
        btn4.selected = YES;
        indicator.left = DEVICE_WIDTH/4.f * 3;
    }
    
}

/**
 *  显示t台详情
 *
 *  @param cell
 */
- (void)tapCell:(TPlatCell *)cell
{
    
    PropertyImageView *aImageView = (PropertyImageView *)((TPlatCell *)cell).photoView;
    
    [MiddleTools showTPlatDetailFromPropertyImageView:aImageView withController:self.tabBarController cancelSingleTap:YES];
}

//品牌
-(void)pushToPinpaiDetailVCWithIdStr:(NSString *)theID pinpaiName:(NSString *)theName{
    
    GpinpaiDetailViewController *cc = [[GpinpaiDetailViewController alloc]init];
    cc.hidesBottomBarWhenPushed = YES;
    cc.pinpaiIdStr = theID;
    cc.pinpaiName = theName;
    [self.navigationController pushViewController:cc animated:YES];
    
}
//商场
-(void)pushToNearbyStoreVCWithIdStr:(NSString *)theID theStoreName:(NSString *)nameStr mailType:(NSString *)mailType{
    
    if ([mailType intValue]==2) {//精品店
        
        GStorePinpaiViewController *cc = [[GStorePinpaiViewController alloc]init];
        cc.storeIdStr = theID;
        cc.storeNameStr = nameStr;
        cc.guanzhuleixing = @"精品店";
        cc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cc animated:YES];
        
    }else if ([mailType intValue] == 1){//大商场
        GnearbyStoreViewController *dd = [[GnearbyStoreViewController alloc]init];
        dd.storeIdStr = theID;
        dd.storeNameStr = nameStr;
        NSLog(@"%@",mailType);
        dd.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dd animated:YES];
    }else if ([mailType intValue] == 3){//品牌店
        GStorePinpaiViewController *cc = [[GStorePinpaiViewController alloc]init];
        cc.storeIdStr = theID;
        cc.guanzhuleixing = @"品牌店";
        cc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cc animated:YES];
    }
}

/**
 *  刷新品牌列表
 *
 *  @param brandIndex 品牌下标
 */
- (void)refreshBrandList:(int)brandIndex
{
    [brandTable.dataArray removeObjectAtIndex:brandIndex];
    [brandTable reloadData];
}

/**
 *  刷新商家列表
 *
 *  @param mailIndex 商家下标
 */
- (void)refreshMailList:(int)mailIndex
{
    [shopTable.dataArray removeObjectAtIndex:mailIndex];
    [shopTable reloadData];
}

- (UIButton *)buttonForTag:(int)tag
{
    return (UIButton *)[self.view viewWithTag:tag];
}

- (void)clickToSwap:(UIButton *)sender
{
    int index = (int)sender.tag - 100;
    
    [self controllButtonSelectAtIndex:index];
    bgScroll.contentOffset = CGPointMake(DEVICE_WIDTH * index, 0);
}

- (void)clickToEdit:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    isEditing = sender.selected;
    
    [shopTable reloadData];
    [brandTable reloadData];
}

#pragma mark - 代理

#pragma - mark RefreshDelegate

- (void)loadNewData
{
    if ([self buttonForTag:102].selected) {
        
        [self getShop];
    }
    
    if ([self buttonForTag:103].selected) {
        
        [self getBrand];
    }
    
}
- (void)loadMoreData
{
    if ([self buttonForTag:102].selected) {
        
        [self getShop];
    }
    
    if ([self buttonForTag:103].selected) {
        
        [self getBrand];
    }
}

//新加
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if (tableView == brandTable) {
        BrandModel *aBrand = brandTable.dataArray[indexPath.row];
        [self pushToPinpaiDetailVCWithIdStr:aBrand.id pinpaiName:aBrand.brand_name];
        
    }else if (tableView == shopTable){
        MailModel *aModel = shopTable.dataArray[indexPath.row];
        if ([aModel.mall_type intValue] == 3 ) {//品牌店
            [self pushToNearbyStoreVCWithIdStr:aModel.shop_id theStoreName:aModel.mall_name mailType:aModel.mall_type];
        }else if ([aModel.mall_type intValue] == 1 || [aModel.mall_type intValue]==2){//大商场 精品店
            [self pushToNearbyStoreVCWithIdStr:aModel.mall_id theStoreName:aModel.mall_name mailType:aModel.mall_type];
        }
        
    }
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if (tableView == shopTable) {
        
        return 76;
    }
    return 90;
}

#pragma - mark UItableViewDataSource

- (UIView *)viewForHeaderInSection:(NSInteger)section tableView:(UITableView *)tableView
{
    return [UIView new];
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section tableView:(UITableView *)tableView
{
    return 5.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ShopViewCell";
    
    if (tableView == shopTable) {
        
        ShopViewCell *cell = (ShopViewCell *)[LTools cellForIdentify:identify cellName:identify forTable:tableView];
        
        MailModel *aModel = shopTable.dataArray[indexPath.row];
        
        [cell setCellWithModel:aModel];
        
        cell.cancelButton.tag = TAGINCREM_STROE + indexPath.row;
        
        [cell.cancelButton addTarget:self action:@selector(cancelConcernMail:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.cancelButton.hidden = !isEditing;
        
        cell.distanceView.hidden = isEditing;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    static NSString *identify2 = @"BrandViewCell";
    BrandViewCell *cell = (BrandViewCell *)[LTools cellForIdentify:identify2 cellName:identify2 forTable:brandTable];
    BrandModel *aBrand = brandTable.dataArray[indexPath.row];

    [cell setCellWithModel:aBrand];
    cell.cancelButton.hidden = !isEditing;
    cell.cancelButton.tag = TAGINCREM_BRAND + indexPath.row;
    
    [cell.cancelButton addTarget:self action:@selector(cancelConcernBrand:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == shopTable) {
        
        return shopTable.dataArray.count;
    }
    
    return brandTable.dataArray.count;
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == bgScroll) {
        
        int page = floor((scrollView.contentOffset.x - DEVICE_WIDTH / 2) / DEVICE_WIDTH) + 1;//只要大于半页就算下一页
        
        NSLog(@"page %d",page);
        
        [self controllButtonSelectAtIndex:page];
    }
    
}

#pragma - mark 地图坐标

- (void)theLocationDictionary:(NSDictionary *)dic{
    
    NSLog(@"当前坐标-->%@",dic);
    
    CGFloat lat = [dic[@"lat"]doubleValue];;
    CGFloat lon = [dic[@"long"]doubleValue];
    
    _latitude = NSStringFromFloat(lat);
    _longtitud = NSStringFromFloat(lon);
    
    [waterFlow showRefreshHeader:YES];
    
}


#pragma mark - WaterFlowDelegate

- (void)waterLoadNewData
{
    if ([self buttonForTag:100].selected) {
        
        [self getMyCollection];
    }
    
    if ([self buttonForTag:101].selected) {
        
        [self getTTaiCollect];
    }
    
}
- (void)waterLoadMoreData
{
    [self waterLoadNewData];
}

- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //单品
    if ([self buttonForTag:100].selected) {
        ProductModel *aMode = waterFlow.dataArray[indexPath.row];
        
        //    [LTools alertText:aMode.product_name];
        
        ProductDetailController *detail = [[ProductDetailController alloc]init];
        detail.product_id = aMode.product_id;
        detail.hidesBottomBarWhenPushed = YES;
        
        
        TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell*)[waterFlow.quitView cellAtIndexPath:indexPath];
        detail.theMyshoucangProductModel = aMode;
        detail.theMyshoucangProductCell = cell;
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    //T台
    if ([self buttonForTag:101].selected) {
        
        
        TPlatCell *cell = (TPlatCell*)[waterFlow_t.quitView cellAtIndexPath:indexPath];
        
        PropertyImageView *aImageView = (PropertyImageView *)((TPlatCell *)cell).photoView;
            
        [MiddleTools showTPlatDetailFromPropertyImageView:aImageView withController:self.tabBarController cancelSingleTap:YES];
        
    }
    
    
    
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath waterView:(TMQuiltView *)waterView
{
    if (waterFlow_t.quitView == waterView) {
        
        TPlatModel *aModel = waterFlow_t.dataArray[indexPath.row];
        CGFloat image_height = [aModel.image[@"height"]floatValue];
        CGFloat image_width = [aModel.image[@"width"]floatValue];
        
        if (image_width == 0.0) {
            image_width = image_height;
        }
        float rate = image_height/image_width;
        
        return (DEVICE_WIDTH-30)/2.0*rate + 36;
    }
    
    CGFloat aHeight = 0.f;
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    if (aMode.imagelist.count >= 1) {
        
        NSDictionary *imageDic = aMode.imagelist[0];
        NSDictionary *middleImage = imageDic[@"540Middle"];
        //        CGFloat aWidth = [middleImage[@"width"]floatValue];
        aHeight = [middleImage[@"height"]floatValue];
    }
    
    return aHeight / 2.f + 33;
}

- (CGFloat)waterViewNumberOfColumns
{
    
    return 2;
}

#pragma mark - TMQuiltViewDataSource

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    
    if (waterFlow_t.quitView == TMQuiltView) {
        
        return [waterFlow_t.dataArray count];
    }
    
    return [waterFlow.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (waterFlow_t.quitView == quiltView) {
        
        TPlatCell *cell = (TPlatCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"TPlatCell"];
        if (!cell) {
            cell = [[TPlatCell alloc] initWithReuseIdentifier:@"TPlatCell"];
        }
        
        cell.layer.cornerRadius = 3.f;
        
        cell.needIconImage = NO;
        
        TPlatModel *aMode = waterFlow_t.dataArray[indexPath.row];
        [cell setCellWithModel:aMode];
        
        [cell.like_btn addTarget:self action:@selector(zanTTaiDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *imageUrl = aMode.image[@"url"];
        
        [cell.photoView setImageUrls:@[imageUrl] infoId:aMode.tt_id aModel:aMode];
        
        cell.like_btn.tag = 20000 + indexPath.row;
        
        return cell;
    }
    
    
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    
    cell.layer.cornerRadius = 3.f;
    
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    [cell setCellWithModel:aMode];
    
    cell.like_btn.tag = 10000 + indexPath.row;
    [cell.like_btn addTarget:self action:@selector(zanProduct:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


@end
