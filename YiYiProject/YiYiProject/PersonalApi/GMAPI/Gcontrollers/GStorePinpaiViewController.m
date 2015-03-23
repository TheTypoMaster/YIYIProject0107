//
//  GStorePinpaiViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/10.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GStorePinpaiViewController.h"
#import "GtopScrollView.h"
#import "GRootScrollView.h"
#import "GCustomSegmentView.h"
#import "LwaterFlowView.h"
#import "ProductDetailController.h"
#import "LoginViewController.h"
#import "NSDictionary+GJson.h"


@interface GStorePinpaiViewController ()<GCustomSegmentViewDelegate,TMQuiltViewDataSource,WaterFlowDelegate,UIScrollViewDelegate>
{
    
    
    int _per_page;//每一页请求多少数据
    
    //瀑布流视图
    LWaterflowView *_waterFlow;//一个瀑布流
    
    
    int _paixuIndex;//新品折扣热销btn标识
    
    
    UIView *_menu_view;//按钮底层view
    NSMutableArray *_btnArray;//按钮数组
    
    
    
    //关注相关
    UIButton *_my_right_button;
    UIBarButtonItem *_spaceButton;
    
    
    //瀑布流下层view
    UIView *_backView_water;
    
    
    //主scrollview
    UIScrollView *_mainScrollview;
    
}



@end

@implementation GStorePinpaiViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
}


-(void)dealloc{
    
    _waterFlow.waterDelegate = nil;
    _waterFlow.quitView.dataSource = nil;
    _waterFlow = nil;
    
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    _spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    
    _mainScrollview = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_mainScrollview];
    
    
    _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
//    _my_right_button.backgroundColor = [UIColor orangeColor];
    _my_right_button.frame = CGRectMake(0,0,60,44);
    _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_my_right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
    
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    
    if ([self.guanzhuleixing isEqualToString:@"精品店"]) {
        self.myTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.myTitleLabel.text = self.storeNameStr;
    }else{
        NSString *aaa = [NSString stringWithFormat:@"%@.%@",self.pinpaiNameStr,self.storeNameStr];
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:aaa];
        NSInteger pinpaiNameLength = self.pinpaiNameStr.length;
        NSInteger storeNameLength = self.storeNameStr.length;
        [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,pinpaiNameLength+1)];
        [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17*GscreenRatio_320] range:NSMakeRange(0,pinpaiNameLength)];
        
        [title addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(240, 173, 184) range:NSMakeRange(pinpaiNameLength+1, storeNameLength)];
        [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13*GscreenRatio_320] range:NSMakeRange(pinpaiNameLength+1, storeNameLength)];
        self.myTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.myTitleLabel.attributedText = title;
    }
    
    

    
    
    
    //初始化
    _btnArray = [NSMutableArray arrayWithCapacity:1];
    _per_page = 10;
    _paixuIndex = 0;
//    _page_xinpin = 1;
//    _page_zhekou = 1;
//    _page_rexiao = 1;
    
    //测试
//    self.storeIdStr = @"2653";
    
    
    
    
    

    
    
    //获取店铺详情
    
    NSLog(@"品牌名称 %@",self.pinpaiNameStr);
    NSLog(@"商家名称 %@",self.storeNameStr);
    NSLog(@"商家id %@",self.storeIdStr);
    NSLog(@"品牌id %@",self.pinpaiId);
    NSLog(@"关注类型 %@",self.guanzhuleixing);
    
    
    
    

    [self prepareDianpuInfo];//获取店铺信息
    
    
}







//获取店铺详情
-(void)prepareDianpuInfo{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //关注精品店===========
    
    if ([self.guanzhuleixing isEqualToString:@"精品店"]) {
        NSString *api = [NSString stringWithFormat:@"%@&mall_id=%@&authcode=%@",HOME_CLOTH_NEARBYSTORE_DETAIL,self.storeIdStr,[GMAPI getAuthkey]];
        GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
        [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSLog(@"精品店信息%@",result);
            NSArray *brand = [result arrayValueForKey:@"brand"];
            NSArray *brand1 = nil;
            NSDictionary *brand2 = nil;
            if (brand && brand.count>0) {
                brand1= brand[0];
                if (brand1 && brand1.count>0) {
                    brand2 = brand1[0];
                }
            }
            
            if ([brand2 isKindOfClass:[NSDictionary class]]) {
                self.shopId = [brand2 stringValueForKey:@"shop_id"];
            }
            
            NSString *mallName = [result stringValueForKey:@"mall_name"];
            NSString *dizhi = [result stringValueForKey:@"address"];
            self.guanzhu = [result stringValueForKey:@"following"];
            
            [self creatDianpuInfoView];
            _mallNameLabel.text = mallName;
            //活动
            NSDictionary *dic = [result dictionaryValueForKey:@"activity"];
            NSString *huodongStr = nil;
            if (dic) {
                huodongStr = [dic stringValueForKey:@"activity_title"];
                if (huodongStr.length==0) {
                    huodongStr = @"";
                }
            }
            _huodongLabel.text = huodongStr;
            
            //根据内容调整活动和地址的高度=================start
            if (_huodongLabel.text.length == 0) {
                _huodongTitleLabel.hidden = YES;
                _huodongLabel.hidden = YES;
                [_dizhiTitleLabel setFrame:_huodongTitleLabel.frame];
                [_adressLabel setFrame:_huodongLabel.frame];
                
            }else{
                _huodongLabel.numberOfLines = 0;
                [_huodongLabel sizeToFit];
                
            }
            _adressLabel.text = dizhi;
            _adressLabel.numberOfLines = 0;
            [_adressLabel sizeToFit];
            //根据内容调整活动和地址的高度=================end
            
            [_upStoreInfoView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGRectGetMaxY(_adressLabel.frame)+10)];
            
            
            [self createMemuView];
            
            
            if ([[result stringValueForKey:@"following"]intValue]==1) {//已关注
                [_my_right_button setTitle:@"已关注" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            }else if ([[result stringValueForKey:@"following"]intValue]==0){//未关注
                [_my_right_button setTitle:@"关注" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            }
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"加载失败" addToView:self.view];
            
        }];
        
        
        return;
    }
    
    
    
    
    //关注品牌==========
    NSString *api = [NSString stringWithFormat:GET_MAIL_DETAIL_INFO,self.storeIdStr];//商场店
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [self creatDianpuInfoView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSLog(@"商场店信息 %@",result);
        NSString *dizhi = [result stringValueForKey:@"address"];
        self.pinpaiId = [result stringValueForKey:@"brand_id"];
        NSLog(@"self.pinpaiId %@",self.pinpaiId);
        //活动
        NSDictionary *dic = [result dictionaryValueForKey:@"activity"];
        NSString *huodongStr = nil;
        if (dic) {
            huodongStr = [dic stringValueForKey:@"activity_title"];
            if (huodongStr.length==0) {
                huodongStr = @"";
            }
        }
        
        _huodongLabel.text = huodongStr;
        
        //根据内容调整活动和地址的高度=================start
        if (_huodongLabel.text.length == 0) {
            _huodongTitleLabel.hidden = YES;
            _huodongLabel.hidden = YES;
            [_dizhiTitleLabel setFrame:_huodongTitleLabel.frame];
            [_adressLabel setFrame:_huodongLabel.frame];
            
        }else{
            _huodongLabel.numberOfLines = 0;
            [_huodongLabel sizeToFit];
            
        }
        _adressLabel.text = dizhi;
        _adressLabel.numberOfLines = 0;
        [_adressLabel sizeToFit];
        //根据内容调整活动和地址的高度=================end
        
        [_upStoreInfoView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGRectGetMaxY(_adressLabel.frame)+10)];
        
        
        [self createMemuView];
        [self getGuanzhuYesOrNoForPinpai];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [GMAPI showAutoHiddenMBProgressWithText:@"加载失败" addToView:self.view];
    }];
}

//创建店铺信息view
-(void)creatDianpuInfoView{
    _upStoreInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 100)];
//        _upStoreInfoView.backgroundColor = [UIColor orangeColor];
    
    //商城名称
    _mallNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, DEVICE_WIDTH-15-15, 18)];
    _mallNameLabel.text = [NSString stringWithFormat:@"%@ %@",self.pinpaiNameStr,self.storeNameStr];
    
    //活动
    _huodongTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_mallNameLabel.frame.origin.x, CGRectGetMaxY(_mallNameLabel.frame)+13, 45, 15)];
    _huodongTitleLabel.font = [UIFont systemFontOfSize:15];
    _huodongTitleLabel.text = @"活动：";
    _huodongLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_huodongTitleLabel.frame)+10, CGRectGetMaxY(_mallNameLabel.frame)+13, DEVICE_WIDTH -15-15-10-_huodongTitleLabel.frame.size.width, 15)];
    _huodongLabel.font = [UIFont systemFontOfSize:15];
    
    //地址
    _dizhiTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_mallNameLabel.frame.origin.x, CGRectGetMaxY(_huodongTitleLabel.frame)+8, 45, 15)];
    _dizhiTitleLabel.text = @"地址：";
    _dizhiTitleLabel.font = [UIFont systemFontOfSize:15];
    _adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_dizhiTitleLabel.frame)+10, CGRectGetMaxY(_huodongLabel.frame)+8, DEVICE_WIDTH -15-15-10-_huodongTitleLabel.frame.size.width, 15)];
    _adressLabel.font = [UIFont systemFontOfSize:15];
    
    
    
    [_upStoreInfoView addSubview:_mallNameLabel];
    [_upStoreInfoView addSubview:_huodongTitleLabel];
    [_upStoreInfoView addSubview:_huodongLabel];
    [_upStoreInfoView addSubview:_dizhiTitleLabel];
    [_upStoreInfoView addSubview:_adressLabel];
    
    [_mainScrollview addSubview:_upStoreInfoView];
}



//获取是否关注 品牌
-(void)getGuanzhuYesOrNoForPinpai{
    
    NSString *api = [NSString stringWithFormat:@"%@&brand_id=%@&authcode=%@",GUANZHUPINPAI_ISORNO,self.pinpaiId,[GMAPI getAuthkey]];
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",result);
        self.guanzhu = [result stringValueForKey:@"relation"];
        if ([self.guanzhu intValue]==0) {//未关注
            [_my_right_button setTitle:@"关注" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        }else if ([self.guanzhu intValue] == 1){//已关注
            [_my_right_button setTitle:@"已关注" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        }
        
        [_waterFlow showRefreshHeader:YES];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}









-(void)rightButtonTap:(UIButton *)sender
{
    
    NSLog(@"在这里添加关注");
    
    
    //判断是否登录
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
        
        LoginViewController *login = [[LoginViewController alloc]init];
        
        UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
        
        [self presentViewController:unVc animated:YES completion:nil];
        
        
        return;
        
    }else{
        
    }
    
    
    
    //判断是否为精品店
    if ([self.guanzhuleixing isEqualToString:@"精品店"]) {
        if ([self.guanzhu intValue] == 0) {//未关注
            NSString *post = [NSString stringWithFormat:@"&mall_id=%@&authcode=%@",self.storeIdStr,[GMAPI getAuthkey]];
            NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSString *url = [NSString stringWithFormat:GUANZHUSHANGCHANG];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
            [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
                    [GMAPI showAutoHiddenMBProgressWithText:@"关注成功" addToView:self.view];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE object:nil];
                    [_my_right_button setTitle:@"已关注" forState:UIControlStateNormal];
                    self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
                    self.guanzhu = @"1";
                }
            } failBlock:^(NSDictionary *failDic, NSError *erro) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [GMAPI showAutoHiddenMBProgressWithText:@"关注失败" addToView:self.view];
            }];
        }else if ([self.guanzhu intValue] == 1){
            NSString *post = [NSString stringWithFormat:@"&mall_id=%@&authcode=%@",self.storeIdStr,[GMAPI getAuthkey]];
            NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSString *url = [NSString stringWithFormat:QUXIAOGUANZHU_SHANGCHANG];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
            [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                if ([[result stringValueForKey:@"errorcode"]intValue]==0) {
                    [GMAPI showAutoHiddenMBProgressWithText:@"取消关注成功" addToView:self.view];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE_QUXIAO object:nil];
                    [_my_right_button setTitle:@"关注" forState:UIControlStateNormal];
                    self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
                    self.guanzhu = @"0";
                }
                
                
            } failBlock:^(NSDictionary *failDic, NSError *erro) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [GMAPI showAutoHiddenMBProgressWithText:@"取消关注失败" addToView:self.view];
            }];
        }
        
        
        return;
        
    }
    
    
    
    //判断是否关注品牌
    NSLog(@"self.guanzhu:%@",self.guanzhu);
    
    if ([self.guanzhu intValue] == 0) {//未关注
        NSString *post = [NSString stringWithFormat:@"&brand_id=%@&authcode=%@",self.pinpaiId,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:GUANZHUPINPAI];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
                [GMAPI showAutoHiddenMBProgressWithText:@"关注成功" addToView:self.view];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_PINPAI object:nil];
                [_my_right_button setTitle:@"已关注" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
                self.guanzhu = @"1";
            }
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"关注失败" addToView:self.view];
        }];
    }else if ([self.guanzhu intValue] == 1){
        NSString *post = [NSString stringWithFormat:@"&brand_id=%@&authcode=%@",self.pinpaiId,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:QUXIAOGUANZHUPINPAI];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if ([[result stringValueForKey:@"errorcode"]intValue]==0) {
                [GMAPI showAutoHiddenMBProgressWithText:@"取消关注成功" addToView:self.view];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_PINPAI_QUXIAO object:nil];
                [_my_right_button setTitle:@"关注" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
                self.guanzhu = @"0";
            }
            
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"取消关注失败" addToView:self.view];
        }];
    }

    
}




- (void)createMemuView
{
    
    CGFloat aWidth = (ALL_FRAME_WIDTH - 24)/ 3.f;
    _menu_view = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_upStoreInfoView.frame)+12, aWidth * 3, 30)];
    _menu_view.clipsToBounds = YES;
    _menu_view.layer.cornerRadius = 15.f;
    _menu_view.backgroundColor = RGBCOLOR(212, 59, 85);
    
    [_mainScrollview addSubview:_menu_view];
    NSLog(@"%@",NSStringFromCGRect(_menu_view.frame));
    
    NSArray *titles = @[@"新品",@"折扣",@"热销"];
    
    for (int i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(aWidth * i + 0.5 * i, 0, aWidth, 30);
        
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setHighlighted:NO];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        btn.tag = 100 + i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"d7425c"] forState:UIControlStateSelected];
        
        [_menu_view addSubview:btn];
        [_btnArray addObject:btn];
        [btn addTarget:self action:@selector(GbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *btn = (UIButton *)[_menu_view viewWithTag:100];
    btn.backgroundColor = RGBCOLOR(240, 122, 142);
    
    
    //瀑布流相关
    _backView_water = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_menu_view.frame)+12, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - _menu_view.frame.size.height -64-_upStoreInfoView.frame.size.height)];
    _backView_water.backgroundColor = RGBCOLOR(240, 230, 235);
    [_mainScrollview addSubview:_backView_water];
    _waterFlow = [[LWaterflowView alloc]initWithFrame:_backView_water.bounds waterDelegate:self waterDataSource:self];
    _waterFlow.backgroundColor = RGBCOLOR(240, 230, 235);
    [_backView_water addSubview:_waterFlow];
    [_waterFlow showRefreshHeader:YES];
    
    
}


#pragma mark - 事件处理

- (void)GbtnClicked:(UIButton *)sender
{
    int tag = (int)sender.tag;
    
    //改变点击颜色
    for (UIButton *btn in _btnArray) {
        btn.backgroundColor = RGBCOLOR(212, 59, 85);
    }
    sender.backgroundColor = RGBCOLOR(240, 122, 142);
    
    //请求数据  _paixuIndex 0新品 1
    _paixuIndex = tag - 100;
    
    
    if (_paixuIndex == 0) {//新品
        
//        if (_dataArray_xinpin) {
//            _waterFlow.dataArray = _dataArray_xinpin;
//            [_waterFlow reloadData];
//        }else{
            [_waterFlow showRefreshHeader:YES];
//        }
        
        
    }else if (_paixuIndex == 1){//折扣
        
//        if (_dataArray_zhekou) {
//            _waterFlow.dataArray = _dataArray_zhekou;
//            [_waterFlow reloadData];
//        }else{
            [_waterFlow showRefreshHeader:YES];
//        }
        
    }else if (_paixuIndex == 2){//热销
        
//        if (_dataArray_rexiao) {
//            _waterFlow.dataArray = _dataArray_rexiao;
//            [_waterFlow reloadData];
//        }else{
            [_waterFlow showRefreshHeader:YES];
//        }
    }
}




#pragma mark - _waterFlowDelegate

- (void)waterLoadNewData
{

    
    //请求网络数据
    NSString *api = nil;
    
    
    NSLog(@"customSegmentIndex:%d",_paixuIndex);
    
    
    if (![self.guanzhuleixing isEqualToString:@"精品店"]) {
        self.shopId = self.storeIdStr;
    }
    
    if (_paixuIndex == 0) {//新品
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"by_time",self.shopId,_waterFlow.pageNum,_per_page];
    }else if (_paixuIndex == 1){//折扣
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"by_discount",self.shopId,_waterFlow.pageNum,_per_page];
    }else if (_paixuIndex == 2){//热销
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"by_hot",self.shopId,_waterFlow.pageNum,_per_page];
    }
    
    NSLog(@"请求的接口%@",api);
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result : %@",result);
        
        
        
        NSMutableArray *arr;
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *list = result[@"list"];
            
            
            if (list.count == 0) {
                [_waterFlow loadFail];
                [GMAPI showAutoHiddenQuicklyMBProgressWithText:@"暂无" addToView:_backView_water];
            }
            
            arr = [NSMutableArray arrayWithCapacity:list.count];
            if ([list isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *aDic in list) {
                    
                    ProductModel *aModel = [[ProductModel alloc]initWithDictionary:aDic];
                    
                    [arr addObject:aModel];
                }
                
            }
            
        }
        
        
        [_waterFlow reloadData:arr pageSize:_per_page];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [_waterFlow loadFail];
    }];
    
}
- (void)waterLoadMoreData
{
    //加载更多
    //请求网络数据
    NSString *api = nil;
    NSLog(@"customSegmentIndex:%d",_paixuIndex);
    
    
    if (_paixuIndex == 0) {//新品
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"by_time",self.shopId,_waterFlow.pageNum,_per_page];
    }else if (_paixuIndex == 1){//折扣
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"by_discount",self.shopId,_waterFlow.pageNum,_per_page];
    }else if (_paixuIndex == 2){//热销
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"by_hot",self.shopId,_waterFlow.pageNum,_per_page];
    }
    
    NSLog(@"请求的接口%@",api);
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result : %@",result);
        
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
            
        }
        
        
        
        //重载瀑布流
        [_waterFlow reloadData:arr pageSize:_per_page];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [_waterFlow loadFail];
    }];
}

//点击方法
- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *aMode = _waterFlow.dataArray[indexPath.row];
    ProductDetailController *detail = [[ProductDetailController alloc]init];
    detail.product_id = aMode.product_id;
    detail.gShop_id = self.shopId;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    CGFloat aHeight = 0.f;
    ProductModel *aMode = _waterFlow.dataArray[indexPath.row];
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
    return [_waterFlow.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    
    cell.layer.cornerRadius = 3.f;
    
    ProductModel *aMode = _waterFlow.dataArray[indexPath.row];
    cell.titleView.hidden = YES;
    [cell setCellWithModel:aMode];
    
    
    
    
    return cell;
}




#pragma mark - CustomSegmentViewDelegate
-(void)buttonClick:(NSInteger)buttonSelected{
    NSLog(@"buttonSelect:%ld",(long)buttonSelected);
    
}



- (void)waterScrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"哈哈");
    NSLog(@"%f",scrollView.contentOffset.y);
    NSLog(@"-------------------------------------------%f",_backView_water.frame.size.height);
    if (scrollView.contentOffset.y>0) {
        CGFloat height = _upStoreInfoView.frame.size.height;
        if (_mainScrollview.contentOffset.y<height) {
            [_backView_water setFrame:CGRectMake(0, CGRectGetMaxY(_menu_view.frame)+12, DEVICE_WIDTH, DEVICE_HEIGHT - _menu_view.frame.size.height -64)];
            [_waterFlow setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - _menu_view.frame.size.height -64-15)];
            [_waterFlow.quitView setFrame:_waterFlow.frame];
            [_mainScrollview setContentOffset:CGPointMake(0, height)];
        }
        
    }else if (scrollView.contentOffset.y<0){
        CGFloat height = _upStoreInfoView.frame.size.height;
        if (_mainScrollview.contentOffset.y>=height) {
            [_backView_water setFrame:CGRectMake(0, CGRectGetMaxY(_menu_view.frame)+12, DEVICE_WIDTH, DEVICE_HEIGHT - _menu_view.frame.size.height -64-_upStoreInfoView.frame.size.height)];
            [_waterFlow setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - _menu_view.frame.size.height -64-_upStoreInfoView.frame.size.height-15)];
            [_waterFlow.quitView setFrame:_waterFlow.frame];
            [_mainScrollview setContentOffset:CGPointMake(0, 0)];
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
