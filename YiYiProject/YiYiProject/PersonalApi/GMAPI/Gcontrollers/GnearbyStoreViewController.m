//
//  GnearbyStoreViewController.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GnearbyStoreViewController.h"

#import "NSDictionary+GJson.h"
#import "GLeadBuyMapViewController.h"
//#import "UIViewAdditions.h"

#import "GtopScrollView.h"
#import "GRootScrollView.h"
#import "GStorePinpaiViewController.h"

#import "LoginViewController.h"

#import "MessageDetailController.h"
#import "LTools.h"

#import "GrootScrollViewFloorTableViewCell.h"
#import "GRTabView.h"

#import "BottomToolsView.h"


@interface GnearbyStoreViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *_upStoreInfoView;//顶部信息view
    UIScrollView *_mainScrollView;//底部scrollview
    UILabel *_huodongLabel;//活动
    UILabel *_adressLabel;//地址
    
    UIScrollView *_floorScrollView;//楼层滚动view
    
    UIScrollView *_downScrollView;
    
    
    
    
    UIButton *_my_right_button;
    UIBarButtonItem *_spaceButton;
    
    
    UILabel *_huodongTitleLabel;//活动title
    
    UILabel *_dizhiTitleLabel;//地址title
    
    UIButton *_dainimaiBtn;//带你去买
    
    
    UIView *_floorView;//楼层信息view
//    GRootScrollView *_rootScrollView;//品牌楼层view
    GRTabView *_tabelView;//品牌楼层view
    NSMutableArray *_data_2Array;//数据源
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
        
        url = [NSString stringWithFormat:@"%@&mall_id=%@&authcode=%@",LIULAN_NUM_STORE,self.storeIdStr,[GMAPI getAuthkey]];
        
    }else{
        url = [NSString stringWithFormat:@"%@&mall_id=%@",LIULAN_NUM_STORE,self.storeIdStr];
    }
    LTools *ccc = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    _my_right_button.frame = CGRectMake(0,0,60,44);
    _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_my_right_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    _my_right_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
    _my_right_button.userInteractionEnabled = NO;
    
    
    //请求网络数据
    [self prepareNetData];
    
    
    
    
    
    self.myTitleLabel.textColor = [UIColor blackColor];
    self.myTitle = self.storeNameStr;
    
    NSLog(@"哪个vc %s",__FUNCTION__);
    
    
    
}


#pragma mark - MyMethod

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
        LTools *ccc = [[LTools alloc]initWithUrl:api isPost:NO postData:nil];
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
        LTools *ccc = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"收藏成功" addToView:self.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE object:nil];
            [_my_right_button setTitle:@"已收藏" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            self.guanzhu = @"1";
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }else if ([self.guanzhu intValue] == 1){
        NSString *post = [NSString stringWithFormat:@"&mall_id=%@&authcode=%@",self.mall_id,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:QUXIAOGUANZHU_SHANGCHANG];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        LTools *ccc = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"取消收藏成功" addToView:self.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE_QUXIAO object:nil];
            [_my_right_button setTitle:@"收藏" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            self.guanzhu = @"0";
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
        imgNameStr = result[@"activity"][@"cover_pic"];
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
            _downLine.backgroundColor = RGBCOLOR(255, 100, 154);
            [_upStoreInfoView addSubview:_downLine];
            
            _huodongFlag = [[UILabel alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-82, CGRectGetMaxY(_huodongLabel.frame), 70, 15)];
            _huodongFlag.font = [UIFont systemFontOfSize:11];
            _huodongFlag.text = @"活动";
            _huodongFlag.textColor = RGBCOLOR(255, 100, 154);
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
    UIView *downDanghangView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT-46-64, DEVICE_WIDTH, 46)];
    downDanghangView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    [self.view addSubview:downDanghangView];
    //导航按钮
    UIButton *navigationBtn = [[UIButton alloc]initWithframe:CGRectMake(0, 0, 46, 46) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"productDetail_nav"] selectedImage:nil target:self action:@selector(leadYouBuy)];
    [downDanghangView addSubview:navigationBtn];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(navigationBtn.right,11.5, 1, downDanghangView.frame.size.height/2.f)];
    line.image = [UIImage imageNamed:@"productDetail_line"];
    [downDanghangView addSubview:line];
    
    //地址
    NSString *address = [NSString stringWithFormat:@"地址: %@",[result stringValueForKey:@"address"]];
    
    CGFloat left = line.right + 10;
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(left, 0, DEVICE_WIDTH - left-12, downDanghangView.frame.size.height) title:address font:14 align:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
    [downDanghangView addSubview:addressLabel];
    
    

    
    
    
    
    
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
    self.height_oneSection = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0;i<floorArray.count;i++) {
        NSArray *arr = floorArray[i];
        if (arr.count!=0) {
            [floorArray_new addObject:arr];
            NSString *height = [NSString stringWithFormat:@"%u",arr.count*90+20];
            [self.height_oneSection addObject:height];
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
    _data_2Array = [NSMutableArray arrayWithArray:floorArray_new];
    
    
    if (_data_2Array.count == 0) {
        [GMAPI showAutoHiddenMBProgressWithText:@"该商场暂无楼层信息" addToView:self.view];
        return;
    }
    
    //楼层信息view
    _floorView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_upStoreInfoView.frame), DEVICE_WIDTH, DEVICE_HEIGHT-_upStoreInfoView.frame.size.height-46-64)];
    _floorView.backgroundColor = RGBCOLOR(236, 237, 239);
    [self.view addSubview:_floorView];
    
    _tabelView = [[GRTabView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tabelView.showsVerticalScrollIndicator = NO;
    
    //楼层按钮
    _topScrollView = [[GtopScrollView alloc]initWithFrame:CGRectMake(0, 12, 70, _floorView.frame.size.height-12)];
    _topScrollView.myRootScrollView = _tabelView;
    _topScrollView.nameArray = (NSArray*)floorsNameArray;
    [_topScrollView initWithNameButtons];
    [_floorView addSubview:_topScrollView];
    
    //楼层详情
    [_tabelView setFrame:CGRectMake(70, 12, DEVICE_WIDTH - 70 - 12, _topScrollView.frame.size.height)];
    _tabelView.dataArray = _data_2Array;
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.myTopScrollView = _topScrollView;
    [_floorView addSubview:_tabelView];
    
    
    
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //请求地址
    NSString *api = nil;
    
    //判断是否登录
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
        api = [NSString stringWithFormat:@"%@&mall_id=%@",HOME_CLOTH_NEARBYSTORE_DETAIL,self.storeIdStr];
    }else{
        api = [NSString stringWithFormat:@"%@&mall_id=%@&authcode=%@",HOME_CLOTH_NEARBYSTORE_DETAIL,self.storeIdStr,[GMAPI getAuthkey]];
    }
    
    NSLog(@"请求的接口:%@",api);

    
    LTools *cc = [[LTools alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
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
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
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
        [_floorView setFrame:CGRectMake(0, CGRectGetMaxY(_upStoreInfoView.frame), DEVICE_WIDTH, DEVICE_HEIGHT-_upStoreInfoView.frame.size.height-46-64)];
        [_topScrollView setFrame:CGRectMake(0, 12, 70, _floorView.frame.size.height-12)];
        [_tabelView setFrame:CGRectMake(70, 12, DEVICE_WIDTH - 70 - 12, _topScrollView.frame.size.height)];
        
    
        
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
        [_floorView setFrame:CGRectMake(0, CGRectGetMaxY(_upStoreInfoView.frame), DEVICE_WIDTH, DEVICE_HEIGHT-_upStoreInfoView.frame.size.height-46-64)];
        [_topScrollView setFrame:CGRectMake(0, 12, 70, _floorView.frame.size.height-12)];
        [_tabelView setFrame:CGRectMake(70, 12, DEVICE_WIDTH - 70 - 12, _topScrollView.frame.size.height)];
    }];
    
}



#pragma mark - UITableViewDataSource && UITableViewDelegate && UIScrollViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _data_2Array.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _data_2Array[section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"nearbypinpai";
    GrootScrollViewFloorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GrootScrollViewFloorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    //数据源
    NSArray *dataArray = _data_2Array[indexPath.section];
    NSDictionary *dic = dataArray[indexPath.row];
    //加载视图
    [cell loadCustomViewWithDicData:dic];
    
    cell.separatorInset = UIEdgeInsetsMake(6,6,0,0);//上左下右
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_tabelView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *dataArray = _data_2Array[indexPath.section];
    NSDictionary *dicInfo = dataArray[indexPath.row];
    NSString *storeIdStr = [dicInfo stringValueForKey:@"shop_id"];
    NSLog(@"商城id:%@",storeIdStr);
    NSDictionary *dic = dataArray[indexPath.row];
    NSString *pinpaiNameStr = [dic stringValueForKey:@"brand_name"];
    GStorePinpaiViewController *cc = [[GStorePinpaiViewController alloc]init];
    cc.guanzhuleixing = @"品牌店";
    cc.storeIdStr = storeIdStr;
    cc.storeNameStr = self.mallName;
    cc.pinpaiNameStr = pinpaiNameStr;
    if (self.isChooseProductLink) {
        cc.isChooseProductLink = YES;
    }
    [self.navigationController pushViewController:cc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tabelView.frame.size.width, 20)];
    UILabel *tlabel = [[UILabel alloc]initWithFrame:view.bounds];
    NSString *aaa = _topScrollView.nameArray[section];
    tlabel.text = [NSString stringWithFormat:@"--- %@ ---",aaa];
    tlabel.font = [UIFont systemFontOfSize:15];
    tlabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:tlabel];
    return view;
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    _topScrollView.userInteractionEnabled = NO;
    
    
    if (scrollView.contentOffset.y>0) {
        [self showTheUpDownViewFullView];
    }else if (scrollView.contentOffset.y<0){
        [self showTheUpDownViewHalfView];
    }
    
    
    if (scrollView == _tabelView && !_topScrollView.noChange) {
        //调整顶部滑条按钮状态
        [self changeTopScrollViewButton:scrollView];
    }
}


//scrollview手指滑动停止滚动时走
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%s",__FUNCTION__);
    _topScrollView.noChange = NO;
    _topScrollView.userInteractionEnabled = YES;
}


//手指滑动 手指停止时走 在DidEndDecelerating之前
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"%s",__FUNCTION__);
    _topScrollView.noChange = NO;
    _topScrollView.userInteractionEnabled = YES;
}

//代码控制setContentOffSet时候停止滚动
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"%s",__FUNCTION__);
    _topScrollView.noChange = NO;
    _topScrollView.userInteractionEnabled = YES;
}



//滚动后修改顶部滚动条
- (void)changeTopScrollViewButton:(UIScrollView *)scrollView
{
    
    int count = (int)_tabelView.dataArray.count;
    CGFloat yyy = 0;
    int position = 0;
    for (int i = 0; i<count; i++) {
        NSString *heightStr = self.height_oneSection[i];
        CGFloat height = [heightStr floatValue];
        yyy+=height;
        if (yyy>=scrollView.contentOffset.y) {
            position = i;
            break;
        }
    }
    int positionid = position;
    _topScrollView.userSelectedChannelID = positionid+100;
    [_topScrollView setButtonUnSelect];
    [_topScrollView setButtonSelect];
    [_topScrollView setScrollViewContentOffset];
    
    
}


@end
