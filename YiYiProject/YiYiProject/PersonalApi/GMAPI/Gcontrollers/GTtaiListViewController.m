//
//  GTtaiListViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/8/12.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GTtaiListViewController.h"
#import "LoginViewController.h"

#import "GTTPublishViewController.h" //t台发布

#import "RefreshTableView.h"

#import "TTaiBigPhotoCell.h" //t台样式一

#import "TTaiBigPhotoCell2.h"//t台样式二

#import "TPlatModel.h"
#import "DataManager.h"
#import "LPhotoBrowser.h"
#import "MJPhoto.h"

#import "TDetailModel.h"
#import "AnchorPiontView.h"//锚点view

#import "GStorePinpaiViewController.h"

#import "CycleScrollView.h"
#import "CycleScrollView1.h"
#import "GTtaiListCustomTableViewCell.h"

#import "GTtaiDetailViewController.h"

#import "GTtaiNearActivViewController.h"//T台列表附近的活动
#import "ActivityModel.h"//活动model
#import "GTtaiNearActOneView.h"//自定义附近活动view

#import "GwebViewController.h"//webview
#import "MessageDetailController.h"//跳转活动详情

@interface GTtaiListViewController ()<RefreshDelegate,UITableViewDataSource,GgetllocationDelegate>
{
    RefreshTableView *_table;
    LPhotoBrowser *browser;
    BOOL isFirst;
    
    CGFloat lastContenOffsetY;
    
    
    GTtaiListCustomTableViewCell *_tmpCell;
    
    CycleScrollView *_topScrollView;
    CycleScrollView1 *_topScrollView1;
    
    LTools *_tool_detail;
    
    NSMutableArray *_upScrollViewData;
    
    UILabel *_dizhiLabel;
    UIImageView *_dingweiImage;//定位图标
    
    UIImageView *_g02;
    UIImageView *_g01;
    
    UIView *_redPoint;
}

@property (nonatomic ,strong) UIView *topView;
@property(nonatomic,strong)NSMutableArray *huodongArray;

@end

@implementation GTtaiListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (_table.reloading) {
        [_table loadFail];
    }
    
//
    
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTitleLabel.text = @"T台";
    [self createNavigationbarTools];
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,DEVICE_HEIGHT - 64) showLoadMore:NO];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    if (!self.topView) {
        self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_WIDTH/750.0*250 + DEVICE_WIDTH/710.0*120 +35 +5)];
        self.topView.backgroundColor = [UIColor whiteColor];
        
        
        _g01 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_WIDTH/750.0*250)];
        [_g01 setImage:[UIImage imageNamed:@"g01.png"]];
        
        [self.topView addSubview:_g01];
        
        
        if (!_topScrollView) {
            _topScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_WIDTH/750.0*250) animationDuration:3];
            [self.topView addSubview:_topScrollView];
        }
        
        UIView *vvv = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(_topScrollView.frame), DEVICE_WIDTH-10, 32)];
        [self.topView addSubview:vvv];
        
        UILabel *fujinhuodongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 35)];
        fujinhuodongLabel.font = [UIFont systemFontOfSize:12];
        fujinhuodongLabel.text = @"附近活动";
        [vvv addSubview:fujinhuodongLabel];
        
        _dizhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fujinhuodongLabel.frame), 0, DEVICE_WIDTH - 5 - 60 - 5, 32)];
        _dizhiLabel.textAlignment = NSTextAlignmentRight;
        _dizhiLabel.font = [UIFont systemFontOfSize:12];
        _dizhiLabel.textColor = RGBCOLOR(81, 82, 83);
        [vvv addSubview:_dizhiLabel];
        
        _dingweiImage = [[UIImageView alloc]initWithFrame:CGRectMake(_dizhiLabel.left - 14 - 2, 0, 14, 13)];
        _dingweiImage.image = [UIImage imageNamed:@"Ttai_dingwei"];
        [vvv addSubview:_dingweiImage];
        _dingweiImage.centerY = _dizhiLabel.centerY;
        
        [self updateCurrentAddress:@"正在定位···"];
        
        
        _g02 = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(vvv.frame), DEVICE_WIDTH-10, DEVICE_WIDTH/710.0*120)];
        [_g02 setImage:[UIImage imageNamed:@"g02.png"]];
        [self.topView addSubview:_g02];
        
        
        if (!_topScrollView1) {
            _topScrollView1 = [[CycleScrollView1 alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(vvv.frame), DEVICE_WIDTH - 10, DEVICE_WIDTH/710.0*120) animationDuration:2];
            [self.topView addSubview:_topScrollView1];
        }
        
    }
    
    _table.tableHeaderView = self.topView;
    [self.view addSubview:_table];
    
    
    [self prepareTopScrollViewNetData];//获取顶部活动图
    
    NSDictionary *dic = [DataManager getCacheDataForType:Cache_TPlat];//获取T台缓存数据
    if (dic) {
        [self parseDataWithResult:dic];
    }
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];//获取网络T台数据
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTTai:) name:NOTIFICATION_LOGIN object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTTai:) name:NOTIFICATION_LOGOUT object:nil];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTTai:) name:NOTIFICATION_TTAI_PUBLISE_SUCCESS object:nil];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiverNotify2:) name:NOTIFICATION_TPLATDETAIL_SHOW object:nil];
    
    
    //添加滑动到顶部按钮
    [self addScroll:_table topButtonPoint:CGPointMake(DEVICE_WIDTH - 40 - 10, DEVICE_HEIGHT - 10 - 40 - 49 - 64)];
}



#pragma mark - MyMethod

/**
 *  更新当前位置信息
 *
 *  @param text
 */
- (void)updateCurrentAddress:(NSString *)text
{
    //max -60 - 10
    CGFloat max = DEVICE_WIDTH - 60 - 10 - _dingweiImage.width - 2;
    CGFloat aWidth = [LTools widthForText:text font:12];
    aWidth = aWidth > max ? max : aWidth;
    _dizhiLabel.width = aWidth;
    _dizhiLabel.left = DEVICE_WIDTH - aWidth - 10;
    _dingweiImage.left = _dizhiLabel.left - 2 - 14;
    _dizhiLabel.text = text;
}

/**
 *  获取附近活动
 */
-(void)prepareNearActity{
    GMAPI *gmapi = [GMAPI sharedManager];
    NSDictionary *locationDic = gmapi.theLocationDic;
    NSString *longStr = [locationDic stringValueForKey:@"long"];
    NSString *latStr = [locationDic stringValueForKey:@"lat"];
    
    NSString *url = [NSString stringWithFormat:@"%@&page=1&per_page=5&long=%@&lat=%@",HOME_TTAI_ACTIVITY,longStr,latStr];
    _tool_detail = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [_tool_detail requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSArray *arr = [result arrayValueForKey:@"list"];
        NSMutableArray *viewsArray1 = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dic in arr) {
            
            ActivityModel *amodel = [[ActivityModel alloc]initWithDictionary:dic];
            GTtaiNearActOneView *view = [[GTtaiNearActOneView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH - 10, DEVICE_WIDTH/710.0*120) huodongModel:amodel type:nil];
//            view.backgroundColor = RGBCOLOR(239, 239, 239);
//            view.backgroundColor = [UIColor redColor];
            [viewsArray1 addObject:view];
        }
        
        UIView *l1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topScrollView.frame)+5, DEVICE_WIDTH, 0.5)];
        l1.backgroundColor = RGBCOLOR(220, 221, 223);
        [self.topView addSubview:l1];
        
        UIView *vvv = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(_topScrollView.frame), DEVICE_WIDTH-10, 32)];
//        vvv.backgroundColor = [UIColor grayColor];
        [self.topView addSubview:vvv];
        
        if (_topScrollView1) {
            [_topScrollView1 removeFromSuperview];
            _topScrollView1 = nil;
            _topScrollView1 = [[CycleScrollView1 alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(vvv.frame), DEVICE_WIDTH - 10, DEVICE_WIDTH/710.0*120) animationDuration:2];
            [self.topView addSubview:_topScrollView1];
        }
        
        [_g02 removeFromSuperview];
        _topScrollView1.backgroundColor = [UIColor purpleColor];
        _topScrollView1.isPageControlHidden = YES;
        _topScrollView1.scrollView.showsHorizontalScrollIndicator = FALSE;
        
        _topScrollView1.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray1[pageIndex];
        };
        
        NSInteger count1 = viewsArray1.count;
        _topScrollView1.totalPagesCount = ^NSInteger(void){
            return count1;
        };
        
        __weak typeof (self)bself = self;
        _topScrollView1.TapActionBlock = ^(NSInteger pageIndex){
            [bself cycleScrollDidClickedWithIndex1:pageIndex];
        };
        
        
        UIView *l2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topScrollView1.frame)+6, DEVICE_WIDTH, 0.5)];
        l2.backgroundColor = RGBCOLOR(220, 221, 223);
        [self.topView addSubview:l2];
        
        
        _table.tableHeaderView = self.topView;
        [_table reloadData];
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
    }];
}


/**
 *  获取顶部广告图
 */
-(void)prepareTopScrollViewNetData{
    NSString *url = [NSString stringWithFormat:@"%@",HOME_TTAI_TOPSCROLLVIEW];
    _tool_detail = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [_tool_detail requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSArray *arr = [result arrayValueForKey:@"advertisements_data"];
        NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:1];
        _upScrollViewData = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dic in arr) {
            
            ActivityModel *amodel = [[ActivityModel alloc]initWithDictionary:dic];
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 125)];
            [imv l_setImageWithURL:[NSURL URLWithString:amodel.img_url] placeholderImage:DEFAULT_YIJIAYI];
            [viewsArray addObject:imv];
            [_upScrollViewData addObject:amodel];
        }
        
        
        //测试只有一条数据的时候
//        for (int i = 0; i<1;i++) {
//            NSDictionary *dic = arr[i];
//            ActivityModel *amodel = [[ActivityModel alloc]initWithDictionary:dic];
//            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 125)];
//            [imv l_setImageWithURL:[NSURL URLWithString:amodel.img_url] placeholderImage:nil];
//            [viewsArray addObject:imv];
//            
//        }
        
        
        if (_topScrollView) {
            [_topScrollView removeFromSuperview];
            _topScrollView = nil;
            _topScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_WIDTH/750.0*250) animationDuration:3];
            [self.topView addSubview:_topScrollView];
            
        }
        
        
        _topScrollView.scrollView.showsHorizontalScrollIndicator = FALSE;
        
        _topScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        
        NSInteger count = viewsArray.count;
        _topScrollView.totalPagesCount = ^NSInteger(void){
            return count;
        };
        
        __weak typeof (self)bself = self;
        _topScrollView.TapActionBlock = ^(NSInteger pageIndex){
            
            [bself cycleScrollDidClickedWithIndex:pageIndex];
        };
        
        if (_upScrollViewData.count == 0) {
            [_topScrollView removeFromSuperview];
        }
        
        
        [_table reloadData];
       
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
    }];
}





//创建scrollview
-(void)creatUpscrollView{
    
//    
//    
//    _topScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 125) animationDuration:2];
}



-(void)cycleScrollDidClickedWithIndex:(NSInteger)index{
    NSLog(@"%ld",index);
    
    if (_upScrollViewData.count == 0) {
        
        return;
    }
    ActivityModel *amodel = _upScrollViewData[index];
    
    if ([amodel.redirect_type intValue] == 1) {//外链
        GwebViewController *ccc = [[GwebViewController alloc]init];
        ccc.urlstring = amodel.theme_id;
        ccc.isSaoyisao = YES;
        ccc.hidesBottomBarWhenPushed = YES;
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:ccc];
        [self presentViewController:navc animated:YES completion:^{
            
        }];
    }else if ([amodel.redirect_type intValue] == 0){//应用内
        if ([amodel.adv_type_val intValue] == 2 || [amodel.adv_type_val intValue] == 3){//2商场活动 3店铺活动
            NSString *activityId = amodel.theme_id;
            MessageDetailController *detail = [[MessageDetailController alloc]init];
            detail.isActivity = YES;
            detail.msg_id = activityId;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }else if ([amodel.adv_type_val intValue] == 4){//单品
            
            [MiddleTools pushToProductDetailWithId:amodel.theme_id fromViewController:self lastNavigationHidden:NO hiddenBottom:YES];
        }
    }
    
}


-(void)cycleScrollDidClickedWithIndex1:(NSInteger)index{
    NSLog(@"%ld",index);
    
    GTtaiNearActivViewController *cc = [[GTtaiNearActivViewController alloc]init];
    cc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cc animated:YES];
}




- (void)receiverNotify:(NSNotification *)notify
{
    NSLog(@"隐藏");
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)receiverNotify2:(NSNotification *)notify
{
    NSLog(@"显示");
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)loadData
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusRestricted == status) {
        NSLog(@"kCLAuthorizationStatusRestricted 开启定位失败");
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"开启定位失败,请允许衣加衣使用定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        return;
    }else if (kCLAuthorizationStatusDenied == status){
        NSLog(@"请允许衣加衣使用定位服务");
//        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请允许衣加衣使用定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [al show];
        return;
    }

    [_table showRefreshHeader:YES];
}

- (void)createNavigationbarTools
{
    UIButton *rightView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightView.backgroundColor=[UIColor clearColor];
    
    UIButton *heartButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [heartButton addTarget:self action:@selector(clickToGift:) forControlEvents:UIControlEventTouchUpInside];
    [heartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [heartButton setImage:[UIImage imageNamed:@"Ttai_present"] forState:UIControlStateNormal];
    [heartButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightView addSubview:heartButton];
    
    _redPoint = [[UIView alloc]initWithFrame:CGRectMake(heartButton.width - 4, heartButton.height/2.f - 12, 8, 8)];
    [heartButton addSubview:_redPoint];
    _redPoint.backgroundColor = [UIColor redColor];
    [_redPoint addRoundCorner];
    _redPoint.hidden = YES;
    
    UIBarButtonItem *comment_item=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = comment_item;
}

#pragma mark 数据解析

- (void)parseDataWithResult:(NSDictionary *)result
{
    NSMutableArray *arr;
    int total;
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSArray *list = result[@"list"];
        
        total = [result[@"total"]intValue];
        arr = [NSMutableArray arrayWithCapacity:list.count];
        if ([list isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *aDic in list) {
                
                TPlatModel *aModel = [[TPlatModel alloc]initWithDictionary:aDic];
                
                [arr addObject:aModel];
            }
            
        }
        
        [_table reloadData:arr pageSize:L_PAGE_SIZE];
        
    }
}

- (void)animation
{
    
    _table.contentOffset = CGPointMake(0, DEVICE_HEIGHT * 3);
    
    
    [UIView animateWithDuration:2.f animations:^{
        
        _table.hidden = NO;
        
        
    } completion:^(BOOL finished) {
        _table.contentOffset = CGPointMake(0, 0);
        
        
    }];
    
}

#pragma mark 网络请求


//T台赞 或 取消

- (void)zanTTaiDetail:(UIButton *)zan_btn
{
    if (![LTools isLogin:self]) {
        return;
    }
    
    [LTools animationToBigger:zan_btn duration:0.2 scacle:1.5];
    
    
    NSString *authkey = [GMAPI getAuthkey];
    
    TPlatModel *detail_model = _table.dataArray[zan_btn.tag - 100];
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
        [zan_btn setTitle:detail_model.tt_like_num forState:UIControlStateNormal];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        if ([failDic[RESULT_CODE] intValue] == -11 || [failDic[RESULT_CODE] intValue] == 2003) {
            [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
        }
        
    }];
}


- (void)getTTaiData
{
    
    GMAPI *gmapi = [GMAPI sharedManager];
    NSDictionary *locationDic = gmapi.theLocationDic;
    NSString *longStr = [locationDic stringValueForKey:@"long"];
    NSString *latStr = [locationDic stringValueForKey:@"lat"];
    
    __weak typeof(self)weakSelf = self;
    
    __weak typeof(RefreshTableView)*weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:@"%@&page=%d&count=%d&authcode=%@&longitude=%@&latitude=%@",HOME_TTAI_LIST,_table.pageNum,L_PAGE_SIZE,[GMAPI getAuthkey],longStr,latStr];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        
        [weakSelf parseDataWithResult:result];
        
        if (_table.pageNum == 1) {
            
            [DataManager cacheDataType:Cache_TPlat content:result];
            
        }
        
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
        [weakTable loadFail];
        
    }];
}


#pragma mark 事件处理

/**
 *  点击去抽奖
 *
 *  @param sender
 */
- (void)clickToGift:(UIButton *)sender
{
    
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    
    PropertyImageView *aImageView = (PropertyImageView *)tap.view;
    
    [MiddleTools showTPlatDetailFromPropertyImageView:aImageView withController:self.tabBarController cancelSingleTap:YES];
}


- (void)tapCell:(UITableViewCell *)cell
{
    
    PropertyImageView *aImageView = ((GTtaiListCustomTableViewCell *)cell).maodianImv;
    
    [MiddleTools showTPlatDetailFromPropertyImageView:aImageView withController:self.tabBarController cancelSingleTap:YES];
}


- (void)updateTTai:(NSNotification *)noti
{
    [_table showRefreshHeader:YES];
}

/**
 *  发布 T 台
 *
 *  @param sender <#sender description#>
 */
- (void)clickToPhoto:(UIButton *)sender
{
    
    //判断是否登录
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
        
        LoginViewController *login = [[LoginViewController alloc]init];
        
        UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
        
        [self presentViewController:unVc animated:YES completion:nil];
        
        return;
    }
    
    GTTPublishViewController *publishT = [[GTTPublishViewController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:publishT];
    [self presentViewController:navc animated:YES completion:^{
        
    }];
}



/**
 *  添加锚点
 */
- (void)addMaoDian:(TPlatModel *)aModel imageView:(UIView *)imageView
{
    //史忠坤修改
    
    int image_have_detail=0;
    
    NSArray *img_detail=[NSArray array];
    
    if ([aModel.image isKindOfClass:[NSDictionary class]]) {
        
        image_have_detail=[aModel.image[@"have_detail"]intValue ];
        
        img_detail=aModel.image[@"img_detail"];
        
    }
    if (image_have_detail>0) {
        //代表有锚点，0代表没有锚点
        
        for (int i=0; i<img_detail.count; i++) {
            
            /*{
             dateline = 1427958416;
             "img_x" = "0.2000";
             "img_y" = "0.4000";
             "product_id" = 100;
             "shop_id" = 2654;
             "tt_id" = 26;
             "tt_img_id" = 0;
             "tt_img_info_id" = 1;
             },*/
            NSDictionary *maodian_detail=(NSDictionary *)[img_detail objectAtIndex:i];
            
            [self createbuttonWithModel:maodian_detail imageView:imageView model:aModel];
            
        }
    }
    
}

//等到加载完图片之后再加载图片上的三个button

-(void)createbuttonWithModel:(NSDictionary*)maodian_detail imageView:(UIView *)imageView model:(TPlatModel*)theMofel{
    
    NSString *productId = maodian_detail[@"product_id"];
    
    NSInteger product_id = [productId integerValue];
    
    float dx=[maodian_detail[@"img_x"] floatValue];
    float dy=[maodian_detail[@"img_y"] floatValue];
    
    
    __weak typeof(self)weakSelf = self;
    if (product_id>0) {
        //说明是单品
        
//        NSString *title = maodian_detail[@"product_name"];
        NSString *title = theMofel.brand_name;
        CGPoint point = CGPointMake(dx * imageView.width, dy * imageView.height);
        AnchorPiontView *pointView = [[AnchorPiontView alloc]initWithAnchorPoint:point title:title price:[maodian_detail stringValueForKey:@"product_price"]];
        [imageView addSubview:pointView];
        pointView.infoId = productId;
        pointView.infoName = title;
        
        [pointView setAnchorBlock:^(NSString *infoId,NSString *infoName,ShopType shopType){
            
            [weakSelf turnToDanPinInfoId:infoId infoName:infoName];
        }];
        
        //        NSLog(@"单品--title %@",title);
        
    }
    
}

//移除锚点
- (void)removeMaoDianForCell:(UITableViewCell *)cell
{
    PropertyImageView *imageView = ((TTaiBigPhotoCell2 *)cell).bigImageView;
    
    for (int i = 0; i < imageView.subviews.count; i ++) {
        
        UIView *aView = [[imageView subviews]objectAtIndex:i];
        [aView removeFromSuperview];
        aView = nil;
    }
    
}

#pragma mark---锚点的点击方法
//到商场的
-(void)turnToShangChangInfoId:(NSString *)infoId
                     infoName:(NSString *)infoName
                     shopType:(ShopType)shopType
{
    
    [MiddleTools pushToStoreDetailVcWithId:infoId shopType:shopType storeName:infoName brandName:@" " fromViewController:self lastNavigationHidden:NO hiddenBottom:YES isTPlatPush:NO];
    
}
//到单品的
-(void)turnToDanPinInfoId:(NSString *)infoId
                 infoName:(NSString *)infoName
{
    [MiddleTools pushToProductDetailWithId:infoId fromViewController:self lastNavigationHidden:NO hiddenBottom:YES];
}

#pragma mark - 位置定位

- (void)theLocationDictionary:(NSDictionary *)dic{
    
    NSLog(@"定位成功信息%@",dic);
    GMAPI *gmapi = [GMAPI sharedManager];
    self.locationDic = gmapi.theLocationDic;
    
    __weak typeof(self)weakSelf = self;
    //根据坐标获取当前位置
    [[GMAPI appDeledate]getAddressDetailWithLontitud:[[dic stringValueForKey:@"long"]floatValue] latitude:[[dic stringValueForKey:@"lat"]floatValue] addressBlock:^(NSDictionary *dic) {
       
        BOOL result = [dic[@"result"]boolValue];
        NSString *streetStr;
        if (result) {
            streetStr = [dic stringValueForKey:@"addressDetail"];
        }else
        {
            streetStr = @"无法获取当前位置";
        }
        [weakSelf updateCurrentAddress:streetStr];
    }];
    
    [self prepareNearActity];
    [self getTTaiData];
}


#pragma - mark RefreshDelegate

-(void)loadNewData
{
    __weak typeof(self)weakSelf = self;
    
    [[GMAPI appDeledate]startDingweiWithBlock:^(NSDictionary *dic) {
        
        [weakSelf theLocationDictionary:dic];
    }];
    
}

-(void)loadMoreData
{
    [self getTTaiData];
    [self prepareNearActity];

}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"---->%f",scrollView.contentOffset.y);
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    
    //调转至老版本 详情页
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self tapCell:[tableView cellForRowAtIndexPath:indexPath]];
    
    //新版
    GTtaiDetailViewController *ggg = [[GTtaiDetailViewController alloc]init];
    TPlatModel *amdol = _table.dataArray[indexPath.row];
    ggg.locationDic = self.locationDic;
    ggg.tPlat_id = amdol.tt_id;
    ggg.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ggg animated:YES];

}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    TPlatModel *aModel = (TPlatModel *)[_table.dataArray objectAtIndex:indexPath.row];
    
    static NSString *identifier = @"aaaaa";
    if (!_tmpCell) {
        _tmpCell = [[GTtaiListCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *view in _tmpCell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat height = [_tmpCell loadCustomViewWithModel:aModel index:indexPath];
    
    return height;
}
//将要显示
- (void)refreshTableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
    });
    
    
    
    
}


#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    GTtaiListCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GTtaiListCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    TPlatModel *aModel = nil;
    if (indexPath.row < _table.dataArray.count) {
        
        aModel  = (TPlatModel *)[_table.dataArray objectAtIndex:indexPath.row];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [cell loadCustomViewWithModel:aModel index:indexPath];
    
    [self addMaoDian:aModel imageView:cell.maodianImv];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    //赞按钮
    cell.zanBtn.tag = 100 + indexPath.row;
    [cell.contentView bringSubviewToFront:cell.zanBtn];
    [cell.zanBtn addTarget:self action:@selector(zanTTaiDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}










@end
