//
//  GnearbyStoreViewController.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GnearbyStoreViewController.h"
#import "GmPrepareNetData.h"
#import "NSDictionary+GJson.h"
#import "GLeadBuyMapViewController.h"
//#import "UIViewAdditions.h"

#import "GtopScrollView.h"
#import "GRootScrollView.h"
#import "GStorePinpaiViewController.h"

#import "LoginViewController.h"

#import "MessageDetailController.h"
#import "LTools.h"


@interface GnearbyStoreViewController ()<UIScrollViewDelegate>
{
    UIView *_upStoreInfoView;//顶部信息view
    UIScrollView *_mainScrollView;//底部scrollview
    UILabel *_huodongLabel;//活动
    UILabel *_adressLabel;//地址
    
    UIScrollView *_floorScrollView;//楼层滚动view
    
    UIScrollView *_downScrollView;
    
    UITableView *_tabelView;
    
    
    UIButton *_my_right_button;
    UIBarButtonItem *_spaceButton;
    
    
    UILabel *_huodongTitleLabel;//活动title
    
    UILabel *_dizhiTitleLabel;//地址title
    
    UIButton *_dainimaiBtn;//带你去买
    
    
    UIView *_floorView;//楼层信息view
    GRootScrollView *_rootScrollView;//品牌楼层view
    GtopScrollView *_topScrollView;//楼层选择view
    
    UIImageView *_activeImv;//活动图片
    
    
    UILabel *_huodongTime_title;//活动图片上的活动时间title
    UILabel *_huodongTime_content;//活动图片上的活动时间内容title
    UIImageView *_activity_backImv;//活动上带黑底的透明图
    
    
    UILabel *_huodongFlag;//活动标示
    UIView *_downLine;//分割线
}

@end

@implementation GnearbyStoreViewController



-(void)dealloc{
    
    NSLog(@"%s",__FUNCTION__);
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    
    //判断是否登录
    NSString *url = @" ";
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == YES) {
        
        url = [NSString stringWithFormat:@"%@&mall_id=%@&authcode=%@",LIULAN_NUM_STORE,self.mall_id,[GMAPI getAuthkey]];
        
    }else{
        url = [NSString stringWithFormat:@"%@&mall_id=%@",LIULAN_NUM_STORE,self.mall_id];
    }
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    _spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    _my_right_button.frame = CGRectMake(0,0,60,44);
    _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_my_right_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
    _my_right_button.userInteractionEnabled = NO;
    
    
    
    
    
    //请求网络数据
    [self prepareNetData];
    
    
    
    
    
    self.myTitleLabel.textColor = [UIColor blackColor];
    self.myTitle = self.storeNameStr;
    
    NSLog(@"哪个vc %s",__FUNCTION__);
    
    self.view.backgroundColor = RGBCOLOR(248, 248, 248);
    
    
}


-(void)rightButtonTap:(UIButton *)sender
{
    
    NSLog(@"在这里添加收藏");
    
    
    //判断是否登录
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
        
        LoginViewController *login = [[LoginViewController alloc]init];
        
        UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
        
        [self presentViewController:unVc animated:YES completion:nil];
        
        
        return;
        
    }else{
        NSString *api = [NSString stringWithFormat:@"%@&mall_id=%@&authcode=%@",HOME_CLOTH_NEARBYSTORE_DETAIL,self.storeIdStr,[GMAPI getAuthkey]];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             NSLog(@"%@",result);
            self.guanzhu = [result stringValueForKey:@"following"];
            if ([self.guanzhu intValue]==0) {//未收藏
                [_my_right_button setTitle:@"收藏" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            }else if ([self.guanzhu intValue] == 1){//已收藏
                [_my_right_button setTitle:@"已收藏" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            }
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
    
    if ([self.guanzhu intValue] == 0) {//未收藏
        NSString *post = [NSString stringWithFormat:@"&mall_id=%@&authcode=%@",self.mall_id,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:GUANZHUSHANGCHANG];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"收藏成功" addToView:self.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE object:nil];
            [_my_right_button setTitle:@"已收藏" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            self.guanzhu = @"1";
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"收藏失败" addToView:self.view];
        }];
    }else if ([self.guanzhu intValue] == 1){
        NSString *post = [NSString stringWithFormat:@"&mall_id=%@&authcode=%@",self.mall_id,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:QUXIAOGUANZHU_SHANGCHANG];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"取消收藏成功" addToView:self.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE_QUXIAO object:nil];
            [_my_right_button setTitle:@"收藏" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            self.guanzhu = @"0";
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"取消收藏失败" addToView:self.view];
        }];
    }
    
    
    
    
    
}


//创建商家顶部信息view
-(void)creatUpStoreInfoViewWithResult:(NSDictionary *)result{
    
    NSLog(@"result : %@",result);
    
    _upStoreInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 188*GscreenRatio_320)];
    
    _activeImv = [[UIImageView alloc]initWithFrame:_upStoreInfoView.bounds];
    _activeImv.backgroundColor = [UIColor whiteColor];
    NSString *imgNameStr = @" ";
    if ([result[@"activity"] isKindOfClass:[NSDictionary class]]) {
        imgNameStr = result[@"activity"][@"activity_pic"];
    }
    
    [_activeImv sd_setImageWithURL:[NSURL URLWithString:imgNameStr] placeholderImage:nil];
    [_upStoreInfoView addSubview:_activeImv];
    _activeImv.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *sss = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huodongLabelClicked)];
    [_activeImv addGestureRecognizer:sss];
    
    
    
    
    //活动
    _huodongLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, DEVICE_WIDTH-15-15, 35)];
    _huodongLabel.textColor = [UIColor whiteColor];
    _huodongLabel.numberOfLines = 2;
    _huodongLabel.font = [UIFont systemFontOfSize:15];
    if ([result[@"activity"] isKindOfClass:[NSDictionary class]]) {
        _huodongLabel.text = [NSString stringWithFormat:@"活动：%@",result[@"activity"][@"activity_title"]];
    }
    
    NSLog(@"%lu",(unsigned long)_huodongLabel.text.length);
    
    
    
    
    if (imgNameStr.length>2) {//有图
        
        _activity_backImv = [[UIImageView alloc]initWithFrame:_activeImv.bounds];
        [_activity_backImv setImage:[UIImage imageNamed:@"gactivityback.png"]];
        [_activeImv addSubview:_activity_backImv];
        
        
        _huodongTime_title = [[UILabel alloc]initWithFrame:CGRectMake(12, _activeImv.frame.size.height-50, 60, 17)];
        _huodongTime_title.textColor = [UIColor whiteColor];
        _huodongTime_title.font = [UIFont systemFontOfSize:15];
        [_activeImv addSubview:_huodongTime_title];
        _huodongTime_title.text = @"活动时间";
        
        
        
        
        _huodongTime_content = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_huodongTime_title.frame)+5, _activeImv.frame.size.width-24, 17)];
        _huodongTime_content.font = [UIFont systemFontOfSize:15];
        _huodongTime_content.textColor = [UIColor whiteColor];
        NSString *startTime = result[@"activity"][@"start_time"];
        NSString *endTime = result[@"activity"][@"end_time"];
        startTime = [LTools timechangeMMDD:startTime];
        endTime = [LTools timechangeMMDD:endTime];
        _huodongTime_content.text = [NSString stringWithFormat:@"%@  --  %@",startTime,endTime];
        [_activeImv addSubview:_huodongTime_content];
        
        
    }else{//没图
        if (_huodongLabel.text.length>3) {//有文字
            [_upStoreInfoView addSubview:_huodongLabel];
            [_upStoreInfoView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, 65)];
            _downLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_huodongLabel.frame)+15, DEVICE_WIDTH, 0.5)];
            _downLine.backgroundColor = RGBCOLOR(255, 72, 135);
            [_upStoreInfoView addSubview:_downLine];
            
            _huodongFlag = [[UILabel alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-82, CGRectGetMaxY(_huodongLabel.frame), 70, 15)];
            _huodongFlag.font = [UIFont systemFontOfSize:11];
            _huodongFlag.text = @"活动";
            _huodongFlag.textColor = RGBCOLOR(252, 74, 139);
            _huodongFlag.textAlignment = NSTextAlignmentRight;
            [_upStoreInfoView addSubview:_huodongFlag];
        }else{
            [_upStoreInfoView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
            
        }
    }
    
    self.upinfoview_height = _upStoreInfoView.frame.size.height;
    
    _huodongLabel.userInteractionEnabled = YES;
    _huodongLabel.textColor = RGBCOLOR(68, 99, 160);
    
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(huodongLabelClicked)];
    [_huodongLabel addGestureRecognizer:tap];
    
    [self.view addSubview:_upStoreInfoView];
    
    
    
    //导航 地址
    UIView *downDanghangView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT-35-64, DEVICE_WIDTH, 35)];
    NSLog(@"%@",NSStringFromCGRect(downDanghangView.frame));
    downDanghangView.backgroundColor = RGBCOLOR(74, 74, 74);
    [self.view addSubview:downDanghangView];
    
    UIButton *daohangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [daohangBtn setFrame:CGRectMake(12, 4, 62, 28)];
    [daohangBtn setImage:[UIImage imageNamed:@"gdaohang_product.png"] forState:UIControlStateNormal];
    [downDanghangView addSubview:daohangBtn];
    [daohangBtn addTarget:self action:@selector(leadYouBuy) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(daohangBtn.frame)+8, 0, DEVICE_WIDTH-CGRectGetMaxX(daohangBtn.frame)-8, downDanghangView.frame.size.height)];
    adressLabel.text = [NSString stringWithFormat:@"地址：%@",[result stringValueForKey:@"address"]];
    adressLabel.font = [UIFont systemFontOfSize:13];
    adressLabel.numberOfLines = 2;
    adressLabel.textColor = RGBCOLOR(181, 181, 181);
    [downDanghangView addSubview:adressLabel];
    
    
    
}



//创建楼层滚动view
-(void)creatFloorScrollViewWithDic:(NSDictionary *)dic{

    id brandArray = nil;
    if (dic) {
        brandArray = [dic objectForKey:@"brand"];
    }
    
    //取出brand字段中的信息
    NSArray *floorArray = nil;
    if ([brandArray isKindOfClass:[NSArray class]]) {
        floorArray = brandArray;
    }else{
        return;
    }
    NSMutableArray *floorArray_new = [NSMutableArray array];
    for (NSArray *arr in floorArray) {
        if (arr.count!=0) {
            [floorArray_new addObject:arr];
        }
    }
    
    
    
    //楼层数
    NSMutableArray *floorsNameArray = [NSMutableArray arrayWithCapacity:1];
    for (NSArray *arr in floorArray_new) {
        NSDictionary *dic = arr[0];
        NSString *str = [dic stringValueForKey:@"floor_name"];
        [floorsNameArray addObject:[NSString stringWithFormat:@"%@",str]];
    }
    
    //每层的数据的二维数组
    NSMutableArray *data_2Array = [NSMutableArray arrayWithCapacity:1];
    data_2Array = [NSMutableArray arrayWithArray:floorArray_new];
    
    _floorView = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_upStoreInfoView.frame)+12, DEVICE_WIDTH-24, DEVICE_HEIGHT-_upStoreInfoView.frame.size.height-12-35-64)];
    
    _topScrollView = [[GtopScrollView alloc]initWithFrame:CGRectMake(0, 0, _floorView.frame.size.width, 28)];
    _rootScrollView = [[GRootScrollView alloc]initWithFrame:CGRectMake(0, 28, _topScrollView.frame.size.width, _floorView.frame.size.height-_topScrollView.frame.size.height)];
    _rootScrollView.nearbyStoreVC = self;
    _rootScrollView.backgroundColor = RGBCOLOR(248, 248, 248);
    _topScrollView.myRootScrollView = _rootScrollView;
    _rootScrollView.myTopScrollView = _topScrollView;
    
    _topScrollView.nameArray = (NSArray*)floorsNameArray;
    _rootScrollView.viewNameArray =_topScrollView.nameArray;
    
    //数据源二维数组
    _rootScrollView.dataArray = data_2Array;

    //初始化视图
    [_topScrollView initWithNameButtons];
    [_rootScrollView initWithViews];
    
    
    //设置跳转block
    __weak typeof (self)bself = self;
    
    [_rootScrollView setThePinpaiBlock:^(NSString *pinpaiId, NSString *pinpaiName) {
        [bself rootScrollViewPushVcWithPinpaiId:pinpaiId pinpaiName:pinpaiName];
    }];
    
    
    
    //添加视图
    [_floorView addSubview:_topScrollView];
    [_floorView addSubview:_rootScrollView];
    [self.view addSubview:_floorView];
    
}


-(void)rootScrollViewPushVcWithPinpaiId:(NSString *)theId pinpaiName:(NSString *)thePinpaiName{
    GStorePinpaiViewController *cc = [[GStorePinpaiViewController alloc]init];
    cc.guanzhuleixing = @"品牌店";
    cc.storeIdStr = theId;
    cc.storeNameStr = self.mallName;
    cc.pinpaiNameStr = thePinpaiName;
    if (self.isChooseProductLink) {
        cc.isChooseProductLink = YES;
    }
    [self.navigationController pushViewController:cc animated:YES];
}


-(void)leadYouBuy{
    GLeadBuyMapViewController *cc = [[GLeadBuyMapViewController alloc]init];
    cc.theType = LEADYOUTYPE_STORE;
    cc.storeName = self.mallName;
    cc.coordinate_store = self.coordinate_store;
    
    
    [self presentViewController:cc animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//请求网络数据
-(void)prepareNetData{
    
    //请求地址
    NSString *api = nil;
    
    //判断是否登录
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
        api = [NSString stringWithFormat:@"%@&mall_id=%@",HOME_CLOTH_NEARBYSTORE_DETAIL,self.storeIdStr];
    }else{
        api = [NSString stringWithFormat:@"%@&mall_id=%@&authcode=%@",HOME_CLOTH_NEARBYSTORE_DETAIL,self.storeIdStr,[GMAPI getAuthkey]];
    }
    
    NSLog(@"请求的接口:%@",api);

    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%@",result);
        
        
        self.mallName = result[@"mall_name"];//商场名
        self.activityId = @" ";
        if ([result[@"activity"] isKindOfClass:[NSDictionary class]]) {
            self.activityId = result[@"activity"][@"activity_id"];
        }
        
        //添加商场信息view
        [self creatUpStoreInfoViewWithResult:result];
        
        
        self.mall_id = [result stringValueForKey:@"mall_id"];
        self.guanzhu = [result stringValueForKey:@"following"];
        _my_right_button.userInteractionEnabled = YES;
        
        if ([self.guanzhu intValue]==0) {//未收藏
            [_my_right_button setTitle:@"收藏" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        }else if ([self.guanzhu intValue] == 1){//已收藏
            [_my_right_button setTitle:@"已收藏" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        }
        
        
        self.coordinate_store = CLLocationCoordinate2DMake([[result stringValueForKey:@"latitude"]floatValue], [[result stringValueForKey:@"longitude"]floatValue]);
        
        
        [self creatFloorScrollViewWithDic:result];
        
        
        

    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
    
    
}




//点击跳转活动
-(void)huodongLabelClicked{
    NSLog(@"活动");
    
    MessageDetailController *detail = [[MessageDetailController alloc]init];
    detail.msg_id = self.activityId;
    detail.isActivity = YES;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}


//全屏显示楼层信息
-(void)showTheUpDownViewFullView{
    
    [UIView animateWithDuration:0.3 animations:^{
        [_upStoreInfoView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
        [_activeImv setFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
        [_activity_backImv setFrame:_activeImv.frame];
        [_huodongLabel setFrame:CGRectZero];
        [_huodongFlag setFrame:CGRectZero];
        [_downLine setFrame:CGRectZero];
        [_huodongTime_title setFrame:CGRectZero];
        [_huodongTime_content setFrame:CGRectZero];
        [_floorView setFrame:CGRectMake(12, CGRectGetMaxY(_upStoreInfoView.frame)+12, DEVICE_WIDTH-24, DEVICE_HEIGHT-_upStoreInfoView.frame.size.height-12-35-64)];
        [_rootScrollView setFrame:CGRectMake(0, 28, _topScrollView.frame.size.width, _floorView.frame.size.height-_topScrollView.frame.size.height)];
        
        for (int i = 0;i<_rootScrollView.tabelViewArray.count;i++) {
            UITableView *tab = _rootScrollView.tabelViewArray[i];
            [tab setFrame:CGRectMake(0+_rootScrollView.frame.size.width*i, 0, _rootScrollView.frame.size.width, _rootScrollView.frame.size.height)];
        }
    }];
    
    
    
    
}

//半屏显示楼层信息
-(void)showTheUpDownViewHalfView{
    
    [UIView animateWithDuration:0.3 animations:^{
        [_upStoreInfoView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, self.upinfoview_height)];
        [_activeImv setFrame:CGRectMake(0, 0, DEVICE_WIDTH, self.upinfoview_height)];
        [_activity_backImv setFrame:_activeImv.frame];
        [_huodongLabel setFrame:CGRectMake(15, 15, DEVICE_WIDTH-15-15, 35)];
        [_huodongFlag setFrame:CGRectMake(DEVICE_WIDTH-82, CGRectGetMaxY(_huodongLabel.frame), 70, 15)];
        [_downLine setFrame:CGRectMake(0, CGRectGetMaxY(_huodongLabel.frame)+15, DEVICE_WIDTH, 0.5)];
        [_huodongTime_title setFrame:CGRectMake(12, _activeImv.frame.size.height-50, 60, 17)];
        [_huodongTime_content setFrame:CGRectMake(12, CGRectGetMaxY(_huodongTime_title.frame)+5, _activeImv.frame.size.width-24, 17)];
        [_floorView setFrame:CGRectMake(12, CGRectGetMaxY(_upStoreInfoView.frame)+12, DEVICE_WIDTH-24, DEVICE_HEIGHT-_upStoreInfoView.frame.size.height-12-35-64)];
        [_rootScrollView setFrame:CGRectMake(0, 28, _topScrollView.frame.size.width, _floorView.frame.size.height-_topScrollView.frame.size.height)];
    }];
    
}



@end
