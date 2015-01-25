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
    
    
    //添加商场信息view
    [self creatUpStoreInfoView];
    
    
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
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
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
            
        }];
    }
    
    if ([self.guanzhu intValue] == 0) {//未关注
        NSString *post = [NSString stringWithFormat:@"&mall_id=%@&authcode=%@",self.mall_id,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:GUANZHUSHANGCHANG];
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            
            [GMAPI showAutoHiddenMBProgressWithText:@"关注成功" addToView:self.view];
            [_my_right_button setTitle:@"已关注" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            self.guanzhu = @"1";
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [GMAPI showAutoHiddenMBProgressWithText:@"关注失败" addToView:self.view];
        }];
    }else if ([self.guanzhu intValue] == 1){
        NSString *post = [NSString stringWithFormat:@"&mall_id=%@&authcode=%@",self.mall_id,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:QUXIAOGUANZHU_SHANGCHANG];
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            
            [GMAPI showAutoHiddenMBProgressWithText:@"取消关注成功" addToView:self.view];
            [_my_right_button setTitle:@"关注" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            self.guanzhu = @"0";
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [GMAPI showAutoHiddenMBProgressWithText:@"取消关注失败" addToView:self.view];
        }];
    }
    
    
    
    
    
}


//创建商家顶部信息view
-(void)creatUpStoreInfoView{
    
    _upStoreInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 185)];
//    _upStoreInfoView.backgroundColor = [UIColor orangeColor];
    
    //商城名称
    _mallNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, DEVICE_WIDTH-15-15, 18)];
    
    //活动
    _huodongLabel = [[UILabel alloc]initWithFrame:CGRectMake(_mallNameLabel.frame.origin.x, CGRectGetMaxY(_mallNameLabel.frame)+13, _mallNameLabel.frame.size.width, 15)];
    _huodongLabel.font = [UIFont systemFontOfSize:15];
    
    //地址
    _adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_mallNameLabel.frame.origin.x, CGRectGetMaxY(_huodongLabel.frame)+8, _mallNameLabel.frame.size.width, 15)];
    _adressLabel.font = [UIFont systemFontOfSize:15];
    
    //带你买
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"带你去买" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:RGBCOLOR(114, 114, 114) forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(_mallNameLabel.frame.origin.x, CGRectGetMaxY(_adressLabel.frame)+22, 83, 37)];
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 7;
    btn.layer.borderColor = [RGBCOLOR(114, 114, 114)CGColor];
    [btn addTarget:self action:@selector(leadYouBuy) forControlEvents:UIControlEventTouchUpInside];
    
    [_upStoreInfoView addSubview:_mallNameLabel];
    [_upStoreInfoView addSubview:_huodongLabel];
    [_upStoreInfoView addSubview:_adressLabel];
    [_upStoreInfoView addSubview:btn];
    
    [self.view addSubview:_upStoreInfoView];
    
}



//创建楼层滚动view
-(void)creatFloorScrollViewWithDic:(NSDictionary *)dic{

    id brandArray = nil;
    if (dic) {
        brandArray = [dic objectForKey:@"brand"];
    }
    
    //取出brand字段中所有的key
    NSArray *floorArray = nil;
    if ([brandArray isKindOfClass:[NSArray class]]) {
        floorArray = brandArray;
    }else{
        return;
    }
    //楼层数
    NSMutableArray *floorsNameArray = [NSMutableArray arrayWithCapacity:1];
    for (NSArray *arr in floorArray) {
        NSDictionary *dic = arr[0];
        NSString *str = [dic stringValueForKey:@"floor_name"];
        [floorsNameArray addObject:[NSString stringWithFormat:@"%@",str]];
    }
    
    //每层的数据的二维数组
    NSMutableArray *data_2Array = [NSMutableArray arrayWithCapacity:1];
    data_2Array = [NSMutableArray arrayWithArray:floorArray];
//    for (NSString *key in keys) {
//        [data_2Array addObject:[brandDic objectForKey:key]];
//    }
    
    
    UIView *floorView = [[UIView alloc]initWithFrame:CGRectMake(12, 185, DEVICE_WIDTH-24, DEVICE_HEIGHT-_upStoreInfoView.frame.size.height)];
    
    GtopScrollView *topScrollView = [[GtopScrollView alloc]initWithFrame:CGRectMake(0, 0, floorView.frame.size.width, 28)];
    GRootScrollView *rootScrollView = [[GRootScrollView alloc]initWithFrame:CGRectMake(0, 28, topScrollView.frame.size.width, DEVICE_HEIGHT-_upStoreInfoView.frame.size.height-topScrollView.frame.size.height-64)];
    
    NSLog(@"%@",NSStringFromCGRect(rootScrollView.frame));
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
    
    [self.navigationController pushViewController:cc animated:YES];
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

        _mallNameLabel.text = [NSString stringWithFormat:@"%@",[result stringValueForKey:@"mall_name"]];
        _huodongLabel.text = [NSString stringWithFormat:@"活动：%@",[result stringValueForKey:@"doorno"]];
        _adressLabel.text = [NSString stringWithFormat:@"地址：%@",[result stringValueForKey:@"address"]];
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











@end
