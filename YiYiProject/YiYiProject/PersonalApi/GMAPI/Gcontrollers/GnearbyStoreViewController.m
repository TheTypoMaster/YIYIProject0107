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
#import "CWSegmentedControl.h"
#import "UIViewAdditions.h"

#import "GtopScrollView.h"
#import "GRootScrollView.h"
#import "GStorePinpaiViewController.h"

#import "LoginViewController.h"

#import "MessageDetailController.h"


@interface GnearbyStoreViewController ()<CWSegmentDelegate,UIScrollViewDelegate>
{
    UIView *_upStoreInfoView;//顶部信息view
    UIScrollView *_mainScrollView;//底部scrollview
    UILabel *_mallNameLabel;//商城名称
    UILabel *_huodongLabel;//活动
    UILabel *_adressLabel;//地址
    
    UIScrollView *_floorScrollView;//楼层滚动view
    
    CWSegmentedControl *_segment;
    UIScrollView *_downScrollView;
    
    UITableView *_tabelView;
    
    
    UIButton *_my_right_button;
    UIBarButtonItem *_spaceButton;
    
    
    UILabel *_huodongTitleLabel;//活动title
    
    UILabel *_dizhiTitleLabel;//地址title
    
    UIButton *_dainimaiBtn;//带你去买
    
}

@end

@implementation GnearbyStoreViewController



-(void)dealloc{
    
    NSLog(@"%s",__FUNCTION__);
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    
    //黑色navigation
//    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
//    {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7DAOHANGLANBEIJING_PUSH2] forBarMetrics: UIBarMetricsDefault];
//    }
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    
    
    
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
    [_my_right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
    
    
    
    
    
    //请求网络数据
    [self prepareNetData];
    
    
    
    
    
    self.myTitleLabel.textColor = [UIColor whiteColor];
    self.myTitle = self.storeNameStr;
    
    NSLog(@"哪个vc %s",__FUNCTION__);
    
    self.view.backgroundColor = RGBCOLOR(248, 248, 248);
    
    
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
        NSString *api = [NSString stringWithFormat:@"%@&mall_id=%@&authcode=%@",HOME_CLOTH_NEARBYSTORE_DETAIL,self.storeIdStr,[GMAPI getAuthkey]];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             NSLog(@"%@",result);
            self.guanzhu = [result stringValueForKey:@"following"];
            if ([self.guanzhu intValue]==0) {//未关注
                [_my_right_button setTitle:@"关注" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            }else if ([self.guanzhu intValue] == 1){//已关注
                [_my_right_button setTitle:@"已关注" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            }
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
    
    if ([self.guanzhu intValue] == 0) {//未关注
        NSString *post = [NSString stringWithFormat:@"&mall_id=%@&authcode=%@",self.mall_id,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:GUANZHUSHANGCHANG];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"关注成功" addToView:self.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE object:nil];
            [_my_right_button setTitle:@"已关注" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            self.guanzhu = @"1";
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"关注失败" addToView:self.view];
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
            [GMAPI showAutoHiddenMBProgressWithText:@"取消关注成功" addToView:self.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE_QUXIAO object:nil];
            [_my_right_button setTitle:@"关注" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            self.guanzhu = @"0";
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"取消关注失败" addToView:self.view];
        }];
    }
    
    
    
    
    
}


//创建商家顶部信息view
-(void)creatUpStoreInfoView{
    
    _upStoreInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 140)];
//    _upStoreInfoView.backgroundColor = [UIColor orangeColor];
    
    //商城名称
    _mallNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, DEVICE_WIDTH-15-15, 19)];
    _mallNameLabel.font = [UIFont systemFontOfSize:17];
    
    //活动
    _huodongTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_mallNameLabel.frame.origin.x, CGRectGetMaxY(_mallNameLabel.frame)+13, 45, 15)];
    _huodongTitleLabel.font = [UIFont systemFontOfSize:15];
//    _huodongTitleLabel.backgroundColor = [UIColor orangeColor];
    _huodongTitleLabel.text = @"活动：";
    _huodongLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_huodongTitleLabel.frame)+10, CGRectGetMaxY(_mallNameLabel.frame)+13, DEVICE_WIDTH -15-15-10-_huodongTitleLabel.frame.size.width, 15)];
//    _huodongLabel.backgroundColor = [UIColor purpleColor];
    _huodongLabel.textColor = RGBCOLOR(56, 80, 122);
    _huodongLabel.font = [UIFont systemFontOfSize:15];
    _huodongLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(huodongLabelClicked)];
    [_huodongLabel addGestureRecognizer:tap];
    
    //地址
    _dizhiTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_mallNameLabel.frame.origin.x, CGRectGetMaxY(_huodongTitleLabel.frame)+8, 45, 15)];
//    _dizhiTitleLabel.backgroundColor = [UIColor orangeColor];
    _dizhiTitleLabel.text = @"地址：";
    _dizhiTitleLabel.font = [UIFont systemFontOfSize:15];
    _adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_dizhiTitleLabel.frame)+10, CGRectGetMaxY(_huodongLabel.frame)+8, DEVICE_WIDTH -15-15-10-_huodongTitleLabel.frame.size.width, 15)];
//    _adressLabel.backgroundColor = [UIColor purpleColor];
    _adressLabel.textColor = RGBCOLOR(56, 80, 122);
    UITapGestureRecognizer *tt = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leadYouBuy)];
    _adressLabel.userInteractionEnabled = YES;
    [_adressLabel addGestureRecognizer:tt];
    _adressLabel.font = [UIFont systemFontOfSize:15];
    
    //带你买
    _dainimaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dainimaiBtn setTitle:@"带你去买" forState:UIControlStateNormal];
    _dainimaiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_dainimaiBtn setTitleColor:RGBCOLOR(114, 114, 114) forState:UIControlStateNormal];
    [_dainimaiBtn setFrame:CGRectMake(_mallNameLabel.frame.origin.x, CGRectGetMaxY(_adressLabel.frame)+15, 83, 37)];
    _dainimaiBtn.layer.borderWidth = 1;
    _dainimaiBtn.layer.cornerRadius = 7;
    _dainimaiBtn.layer.borderColor = [RGBCOLOR(114, 114, 114)CGColor];
    [_dainimaiBtn addTarget:self action:@selector(leadYouBuy) forControlEvents:UIControlEventTouchUpInside];
    
    [_upStoreInfoView addSubview:_mallNameLabel];
    [_upStoreInfoView addSubview:_huodongTitleLabel];
    [_upStoreInfoView addSubview:_huodongLabel];
    [_upStoreInfoView addSubview:_dizhiTitleLabel];
    [_upStoreInfoView addSubview:_adressLabel];
//    [_upStoreInfoView addSubview:_dainimaiBtn];
    
    
//    _upStoreInfoView.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:_upStoreInfoView];
    
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
    
    UIView *floorView = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_upStoreInfoView.frame), DEVICE_WIDTH-24, DEVICE_HEIGHT-_upStoreInfoView.frame.size.height)];
    
    GtopScrollView *topScrollView = [[GtopScrollView alloc]initWithFrame:CGRectMake(0, 0, floorView.frame.size.width, 28)];
    GRootScrollView *rootScrollView = [[GRootScrollView alloc]initWithFrame:CGRectMake(0, 28, topScrollView.frame.size.width, DEVICE_HEIGHT-_upStoreInfoView.frame.size.height-topScrollView.frame.size.height-64)];
    
    NSLog(@"%@",NSStringFromCGRect(rootScrollView.frame));
    rootScrollView.backgroundColor = RGBCOLOR(248, 248, 248);
    topScrollView.myRootScrollView = rootScrollView;
    rootScrollView.myTopScrollView = topScrollView;
    
    topScrollView.nameArray = (NSArray*)floorsNameArray;
    rootScrollView.viewNameArray =topScrollView.nameArray;
    
    //数据源二维数组
    rootScrollView.dataArray = data_2Array;

    //初始化视图
    [topScrollView initWithNameButtons];
    [rootScrollView initWithViews];
    
    
    //设置跳转block
    __weak typeof (self)bself = self;
    
    [rootScrollView setThePinpaiBlock:^(NSString *pinpaiId, NSString *pinpaiName) {
        [bself rootScrollViewPushVcWithPinpaiId:pinpaiId pinpaiName:pinpaiName];
    }];
    
    
    
    //添加视图
    [floorView addSubview:topScrollView];
    [floorView addSubview:rootScrollView];
    [self.view addSubview:floorView];
    
}


-(void)rootScrollViewPushVcWithPinpaiId:(NSString *)theId pinpaiName:(NSString *)thePinpaiName{
    GStorePinpaiViewController *cc = [[GStorePinpaiViewController alloc]init];
    cc.guanzhuleixing = @"品牌店";
    cc.storeIdStr = theId;
    cc.storeNameStr = _mallNameLabel.text;
    cc.pinpaiNameStr = thePinpaiName;
    [self.navigationController pushViewController:cc animated:YES];
}


-(void)leadYouBuy{
    GLeadBuyMapViewController *cc = [[GLeadBuyMapViewController alloc]init];
    cc.theType = LEADYOUTYPE_STORE;
    cc.storeName = _mallNameLabel.text;
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
        
        
        //添加商场信息view
        [self creatUpStoreInfoView];
        
        
        
        //活动
        NSDictionary *dic = [result dictionaryValueForKey:@"activity"];
        NSString *huodongStr = nil;
        if (dic) {
            huodongStr = [dic stringValueForKey:@"activity_title"];
            if (huodongStr.length==0) {
                huodongStr = @"";
            }
            
            self.activityId = [dic stringValueForKey:@"activity_id"];
        }

        _mallNameLabel.text = [NSString stringWithFormat:@"%@",[result stringValueForKey:@"mall_name"]];
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
        _adressLabel.text = [NSString stringWithFormat:@"%@",[result stringValueForKey:@"address"]];
        _adressLabel.numberOfLines = 0;
        [_adressLabel sizeToFit];
        [_dainimaiBtn setFrame:CGRectMake(_mallNameLabel.frame.origin.x, CGRectGetMaxY(_adressLabel.frame)+15, 83, 37)];
        //根据内容调整活动和地址的高度=================end
        
        self.mall_id = [result stringValueForKey:@"mall_id"];
        self.guanzhu = [result stringValueForKey:@"following"];
        if ([self.guanzhu intValue]==0) {//未关注
            [_my_right_button setTitle:@"关注" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        }else if ([self.guanzhu intValue] == 1){//已关注
            [_my_right_button setTitle:@"已关注" forState:UIControlStateNormal];
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


@end
