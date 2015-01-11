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

@interface HomeClothController ()<GCycleScrollViewDatasource,GCycleScrollViewDelegate,UIScrollViewDelegate>
{
    
    //第一行
    GCycleScrollView *_gscrollView;//上方循环滚动的scrollview
    NSMutableArray *_topScrollviewImvInfoArray;//顶部广告scrollview图片数组
    
    //第二行
    UIView *_nearbyView;//附近的view
    GScrollView *_scrollview_nearbyView;//附近的view上面的scrollview
    NSMutableArray *_nearByStoreDataArray;//附近的商城数据数组
    
    //第三行
    UIView *_pinpaiView;//品牌的view
    GScrollView *_scrollView_pinpai;//品牌的scrollview
    NSMutableArray *_pinpaiScrollViewModelInfoArray;//品牌信息数组
    
    
    //四个按钮
    UIButton *_nearbyBtn;//附近的商场
    UIButton *_guanzhuBtn_Store;//我关注的商场
    UIButton *_pinpaiBtn;//附近的品牌
    UIButton *_guanzhuBtn_pinpai;//我关注的品牌
    
    

}
@end

@implementation HomeClothController

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
//    {
//        self.navigationController.navigationBar.translucent = NO;
//    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT -  64 - 44)];
    scrollView.delegate = self;
    scrollView.backgroundColor = RGBCOLOR(242, 242, 242);
    scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, 180+218+155);
    
    [scrollView addSubview:[self creatGscrollView]];//循环滚动幻灯片
    
    [scrollView addSubview:[self creatNearbyView]];//附近的商场
    
    [scrollView addSubview:[self creatPinpaiView]];//品牌
    
    [self.view addSubview:scrollView];
    
    //网络请求
    //请求顶部滚动广告栏
    [self prepareTopScrollViewIms];
    //请求附近的品牌
    [self prepareNearbyPinpai];
    //请求附近的商店
    [self prepareNearbyStore];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//请求顶部scrollview一组图片
-(void)prepareTopScrollViewIms{
    NSString *api = HOME_CLOTH_TOPSCROLLVIEW;
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%@",result);
        _topScrollviewImvInfoArray = [result objectForKey:@"advertisements_data"];
        [_gscrollView reloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
    
}


//请求附近的商店
-(void)prepareNearbyStore{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *api = [NSString stringWithFormat:@"%@&page=1&count=100",HOME_CLOTH_NEARBYSTORE];
    GmPrepareNetData *dd = [[GmPrepareNetData alloc]initWithUrl:api isPost:YES postData:nil];
    [dd requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",result);
        
        _nearByStoreDataArray = [result objectForKey:@"list"];
        _scrollview_nearbyView.dataArray = _nearByStoreDataArray;
        if (_nearByStoreDataArray.count == 0) {
            [GMAPI showAutoHiddenMBProgressWithText:@"附近没有符合条件的商场" addToView:self.view];
        }
        [_scrollview_nearbyView gReloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

//请求我关注的商店
-(void)prepareGuanzhuStore{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:HOME_CLOTH_GUANZHUSTORE_MINE,[GMAPI getAuthkey]];
    GmPrepareNetData *dd = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:nil];
    [dd requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",result);
        
        _nearByStoreDataArray = [result objectForKey:@"list"];
        _scrollview_nearbyView.dataArray = _nearByStoreDataArray;
        if (_nearByStoreDataArray.count == 0) {
            [GMAPI showAutoHiddenMBProgressWithText:@"您还没有关注任何商场" addToView:self.view];
        }
        
        [_scrollview_nearbyView gReloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}



//请求附近的品牌
-(void)prepareNearbyPinpai{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *api = HOME_CLOTH_NEARBYPINPAI;
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",result);
        _pinpaiScrollViewModelInfoArray = [result objectForKey:@"brand_data"];
        _scrollView_pinpai.dataArray = _pinpaiScrollViewModelInfoArray;
        if (_pinpaiScrollViewModelInfoArray.count == 0) {
            [GMAPI showAutoHiddenMBProgressWithText:@"附近没有符合条件的品牌" addToView:self.view];
        }
        [_scrollView_pinpai gReloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


//请求我关注的品牌
-(void)prepareGuanzhuPinpai{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:HOME_CLOTH_GUANZHUPINPAI_MINE,[GMAPI getAuthkey],1];
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:url isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",result);
        _pinpaiScrollViewModelInfoArray = [result objectForKey:@"brand_data"];
        _scrollView_pinpai.dataArray = _pinpaiScrollViewModelInfoArray;
        if (_pinpaiScrollViewModelInfoArray.count == 0) {
            [GMAPI showAutoHiddenMBProgressWithText:@"您还没有关注任何品牌" addToView:self.view];
        }
        [_scrollView_pinpai gReloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}




///创建循环滚动的scrollview
-(UIView*)creatGscrollView{
    _gscrollView = [[GCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 180)];
    _gscrollView.theGcycelScrollViewType = GCYCELNORMORL;
    [_gscrollView loadGcycleScrollView];
    _gscrollView.tag = 200;
    _gscrollView.backgroundColor = [UIColor orangeColor];
    _gscrollView.delegate = self;
    _gscrollView.datasource = self;
    return _gscrollView;
}

//创建附近的商城view
-(UIView*)creatNearbyView{
    
    
    _nearbyView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_gscrollView.frame), DEVICE_WIDTH, 218)];
    _nearbyView.backgroundColor = [UIColor whiteColor];
    
    
    
    
    //标题
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 30, 15)];
//    titleLabel.font = [UIFont systemFontOfSize:15];
//    titleLabel.text = @"附近";
//    [_nearbyView addSubview:titleLabel];
    _nearbyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nearbyBtn setTitle:@"附近" forState:UIControlStateNormal];
    [_nearbyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nearbyBtn setFrame:CGRectMake(15, 12, 30, 15)];
    _nearbyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _nearbyBtn.tag = 62;
    [_nearbyBtn addTarget:self action:@selector(nearOrGuanzhuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_nearbyView addSubview:_nearbyBtn];
    
    _guanzhuBtn_Store = [UIButton buttonWithType:UIButtonTypeCustom];
    [_guanzhuBtn_Store setTitle:@"我关注的商家" forState:UIControlStateNormal];
    [_guanzhuBtn_Store setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_guanzhuBtn_Store setFrame:CGRectMake(CGRectGetMaxX(_nearbyBtn.frame)+10, 12, 100, 15)];
    _guanzhuBtn_Store.titleLabel.font = [UIFont systemFontOfSize:15];
    _guanzhuBtn_Store.tag = 63;
    [_guanzhuBtn_Store addTarget:self action:@selector(nearOrGuanzhuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_nearbyView addSubview:_guanzhuBtn_Store];
    
    
    //背景图
    UIView *graypngBackview = [[UIView alloc]initWithFrame:CGRectMake(15, 30+60, DEVICE_WIDTH-15-15, 218-30-14-60)];
    [_nearbyView addSubview:graypngBackview];
    if (DEVICE_WIDTH>320) {
        
        
        for (int i = 0; i<4; i++) {
            UIImageView *imv1_back = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*120, 0, 120, 218-30-14-60)];
            [imv1_back setImage:[UIImage imageNamed:@"gimv1_back.png"]];
            [graypngBackview addSubview:imv1_back];
        }
    }else{
        for (int i = 0; i<3; i++) {
            UIImageView *imv1_back = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*120, 0, 120, 218-30-14-60)];
            [imv1_back setImage:[UIImage imageNamed:@"gimv1_back.png"]];
            [graypngBackview addSubview:imv1_back];
        }
    }
    
    //遮挡view
    UIView *zview = [[UIView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-15, graypngBackview.frame.origin.y, 15, graypngBackview.frame.size.height)];
    zview.backgroundColor = [UIColor whiteColor];
    [_nearbyView addSubview:zview];
    
    
    
    
    //滚动界面

    _scrollview_nearbyView = [[GScrollView alloc]initWithFrame:CGRectMake(15, 30, DEVICE_WIDTH-15-15, 218-30-14)];
    _scrollview_nearbyView.tag = 10;
    _scrollview_nearbyView.gtype = 10;
    _scrollview_nearbyView.delegate = self;
    _scrollview_nearbyView.showsHorizontalScrollIndicator = NO;
    _scrollview_nearbyView.delegate1 = self;
//    _scrollview_nearbyView.bounces = NO;
    
    [_nearbyView addSubview:_scrollview_nearbyView];
    
    
    //标题下面的分割线
    UIView *downTitleLine = [[UIView alloc]initWithFrame:CGRectMake(_nearbyBtn.frame.origin.x, CGRectGetMaxY(_nearbyBtn.frame)+3, DEVICE_WIDTH-30, 1)];
    downTitleLine.backgroundColor = RGBCOLOR(213, 213, 213);
    [_nearbyView addSubview:downTitleLine];
    
    return _nearbyView;
}


//品牌
-(UIView *)creatPinpaiView{
    
    _pinpaiView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nearbyView.frame), DEVICE_HEIGHT, 155)];
    _pinpaiView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    
    //标题
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 30, 15)];
//    titleLabel.font = [UIFont systemFontOfSize:15];
//    titleLabel.text = @"品牌";
//    [_pinpaiView addSubview:titleLabel];
    
    _pinpaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pinpaiBtn setTitle:@"品牌" forState:UIControlStateNormal];
    [_pinpaiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pinpaiBtn setFrame:CGRectMake(15, 12, 30, 15)];
    _pinpaiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _pinpaiBtn.tag = 60;
    [_pinpaiBtn addTarget:self action:@selector(nearOrGuanzhuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_pinpaiView addSubview:_pinpaiBtn];
    
    UIButton *guanzhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [guanzhuBtn setTitle:@"我关注的品牌" forState:UIControlStateNormal];
    [guanzhuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [guanzhuBtn setFrame:CGRectMake(CGRectGetMaxX(_pinpaiBtn.frame)+10, 12, 100, 15)];
    guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    guanzhuBtn.tag = 61;
    [guanzhuBtn addTarget:self action:@selector(nearOrGuanzhuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_pinpaiView addSubview:guanzhuBtn];
    
    
    //滚动界面
    _scrollView_pinpai = [[GScrollView alloc]initWithFrame:CGRectMake(15, 30, DEVICE_WIDTH-15-15, 155-30-14)];
    _scrollView_pinpai.backgroundColor = RGBCOLOR(242, 242, 242);
    _scrollView_pinpai.contentSize = CGSizeMake(1000, 155-30-14);
    _scrollView_pinpai.tag = 11;
    _scrollView_pinpai.gtype = 11;
    _scrollView_pinpai.delegate = self;
    _scrollView_pinpai.delegate1 = self;
    [_pinpaiView addSubview:_scrollView_pinpai];
    
    
    for (int i = 0; i<_scrollView_pinpai.dataArray.count; i++) {
        UIView *pinpaiView = [[UIView alloc]initWithFrame:CGRectMake(0+i*77, 0, 70, 120)];
        pinpaiView.backgroundColor = [UIColor orangeColor];
        
        
        UIView *yuan = [[UIView alloc]initWithFrame:CGRectMake(2, 15, 66, 66)];
        yuan.layer.cornerRadius = 33;
        yuan.backgroundColor = [UIColor whiteColor];
        yuan.layer.borderWidth = 1;
        yuan.layer.borderColor = RGBCOLOR(212, 212, 212).CGColor;
        [pinpaiView addSubview:yuan];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(yuan.frame)+10, 70, 13)];
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.text = @"ONLY";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = RGBCOLOR(114, 114, 114);
        [pinpaiView addSubview:nameLabel];
        
        
        
        [_scrollView_pinpai addSubview:pinpaiView];
        
    }
    
    
    
    
    
    
    
    //标题下面的分割线
    UIView *downTitleLine = [[UIView alloc]initWithFrame:CGRectMake(_pinpaiBtn.frame.origin.x, CGRectGetMaxY(_pinpaiBtn.frame)+3, DEVICE_WIDTH-30, 1)];
    downTitleLine.backgroundColor = RGBCOLOR(213, 213, 213);
    [_pinpaiView addSubview:downTitleLine];
    
    
    
    
    //向左按钮btn
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(15, CGRectGetMaxY(downTitleLine.frame)+40, 22, 22)];
    leftBtn.layer.cornerRadius = 4;
    [leftBtn setImage:[UIImage imageNamed:@"gjiantouleft.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(pinpaiGoleft) forControlEvents:UIControlEventTouchUpInside];
//    [_pinpaiView addSubview:leftBtn];
    
    
    //向右按钮btn
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(DEVICE_WIDTH-37, CGRectGetMaxY(downTitleLine.frame)+40, 22, 22)];
    rightBtn.layer.cornerRadius = 4;
    [rightBtn setImage:[UIImage imageNamed:@"gjiantouright.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pinpaiGoRight) forControlEvents:UIControlEventTouchUpInside];
//    [_pinpaiView addSubview:rightBtn];
    
    
    return _pinpaiView;
    
}



-(void)goNearbyStoreVC{
    
    GnearbyStoreViewController *nn = [[GnearbyStoreViewController alloc]init];
    nn.hidesBottomBarWhenPushed = YES;
    [self.rootViewController.navigationController pushViewController:nn animated:YES];
    
}



-(void)nearOrGuanzhuBtnClicked:(UIButton*)sender{
    
    NSLog(@"点击的是%ld",(long)sender.tag);
    //判断是否登录
    if ([LTools cacheBoolForKey:USER_LONGIN] == NO) {
        LoginViewController *login = [[LoginViewController alloc]init];
        UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
//        [self presentViewController:unVc animated:YES completion:nil];
        [self.rootViewController presentViewController:unVc animated:YES completion:^{
            
        }];
        return;
    }
    
    
    if (sender.tag == 60) {//附近的品牌
        [self prepareNearbyPinpai];
    }else if (sender.tag == 61){//我关注的品牌
        [self prepareGuanzhuPinpai];
    }else if (sender.tag == 62){//附近的商家
        [self prepareNearbyStore];
    }else if (sender.tag == 63){//我关注的商家
        [self prepareGuanzhuStore];
        
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
    }else if (theGCycleScrollView.tag == 201){
        num = _nearByStoreDataArray.count/4+1;
    }
    return num;
    
}

//每一页
- (UIView *)pageAtIndex:(NSInteger)index ScrollView:(GCycleScrollView *)theGCycleScrollView
{
    
    
    if (theGCycleScrollView.tag == 200) {
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 180)];
        imv.userInteractionEnabled = YES;
        
        NSDictionary *dic = _topScrollviewImvInfoArray[index];
        NSString *str = nil;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            str = [dic stringValueForKey:@"img_url"];
        }
        
        [imv sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
        return imv;
    }else if (theGCycleScrollView.tag == 201){
        GClothWaveCustomView *view = [[GClothWaveCustomView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH-30, 180)];
        [view loadCustomViewWithDataArray:_nearByStoreDataArray pageIndex:index];
        return view;
    }
    
    return [UIView new];
    
}

//点击的哪一页
- (void)didClickPage:(GCycleScrollView *)csView atIndex:(NSInteger)index
{
    
    id obj=NSClassFromString(@"UIAlertController");
    if ( obj!=nil){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前点击第%ld个页面",index] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"当前点击第%ld个页面",index]
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
        [alert show];
    }
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 10) {
        NSLog(@"附近 x:%f,y:%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    }else if (scrollView.tag == 11){
        NSLog(@"品牌 x:%f,y:%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    }
    
    
}







-(void)pushToPinpaiDetailVCWithIdStr:(NSString *)theID pinpaiName:(NSString *)theName{
    
    GpinpaiDetailViewController *cc = [[GpinpaiDetailViewController alloc]init];
    cc.hidesBottomBarWhenPushed = YES;
    cc.pinpaiIdStr = theID;
    cc.pinpaiName = theName;
    [self.rootViewController.navigationController pushViewController:cc animated:YES];
    
}



-(void)pushToNearbyStoreVCWithIdStr:(NSString *)theID theStoreName:(NSString *)nameStr{
    GnearbyStoreViewController *dd = [[GnearbyStoreViewController alloc]init];
    dd.storeIdStr = theID;
    dd.storeNameStr = nameStr;
    dd.hidesBottomBarWhenPushed = YES;
    [self.rootViewController.navigationController pushViewController:dd animated:YES];
}





@end
