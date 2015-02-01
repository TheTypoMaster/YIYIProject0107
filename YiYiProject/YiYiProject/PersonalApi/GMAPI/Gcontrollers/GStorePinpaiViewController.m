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
#import "CustomSegmentView.h"
#import "LwaterFlowView.h"
#import "ProductDetailController.h"
#import "LoginViewController.h"
#import "NSDictionary+GJson.h"

@interface GStorePinpaiViewController ()<CustomSegmentViewDelegate,TMQuiltViewDataSource,WaterFlowDelegate>
{
    
    int _page;
    int _per_page;
    
    LWaterflowView *_waterFlow;
    
    int _paixuIndex;
    
    
    UIView *_menu_view;//按钮底层view
    NSMutableArray *_btnArray;//按钮数组
    
    
    //网络数据
    NSMutableArray *_netDataArray;//网络数据数组
    NSMutableArray *_dataArray_xinpin;//新品数组
    NSMutableArray *_dataArray_zhekou;//折扣数组
    NSMutableArray *_dataArray_rexiao;//热销数组
    
    
    //关注相关
    UIButton *_my_right_button;
    UIBarButtonItem *_spaceButton;
    
    
    //瀑布流下层view
    UIView *_backView_water;
    
    
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
    
    
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    _spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
//    _my_right_button.backgroundColor = [UIColor orangeColor];
    _my_right_button.frame = CGRectMake(0,0,60,44);
    _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_my_right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
    
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    
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
    

    
    
    
    //初始化
    _btnArray = [NSMutableArray arrayWithCapacity:1];
    
    //创建3个选项
    [self createMemuView];
    
    
    
    
    _page = 1;
    _per_page = 10;
    _paixuIndex = 0;
    
    
    _backView_water = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_menu_view.frame)+12, ALL_FRAME_WIDTH-24, ALL_FRAME_HEIGHT - _menu_view.frame.size.height - 12-12-64)];
    _backView_water.backgroundColor = RGBCOLOR(240, 230, 235);
    [self.view addSubview:_backView_water];
    
    
    _waterFlow = [[LWaterflowView alloc]initWithFrame:_backView_water.bounds waterDelegate:self waterDataSource:self];
    _waterFlow.backgroundColor = RGBCOLOR(240, 230, 235);
    [_backView_water addSubview:_waterFlow];
    
    
    [self getGuanzhuYesOrNo];
    
    
}



//获取是否关注
-(void)getGuanzhuYesOrNo{
    
    NSString *api = [NSString stringWithFormat:@"%@&brand_id=%@&authcode=%@",GUANZHUPINPAI_ISORNO,self.pinpaiId,[GMAPI getAuthkey]];
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
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
    
    
    NSLog(@"self.guanzhu:%@",self.guanzhu);
    
    if ([self.guanzhu intValue] == 0) {//未关注
        NSString *post = [NSString stringWithFormat:@"&brand_id=%@&authcode=%@",self.pinpaiId,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:GUANZHUPINPAI];
        
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            
            if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
                [GMAPI showAutoHiddenMBProgressWithText:@"关注成功" addToView:self.view];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_PINPAI object:nil];
                [_my_right_button setTitle:@"已关注" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
                self.guanzhu = @"1";
            }
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [GMAPI showAutoHiddenMBProgressWithText:@"关注失败" addToView:self.view];
        }];
    }else if ([self.guanzhu intValue] == 1){
        NSString *post = [NSString stringWithFormat:@"&brand_id=%@&authcode=%@",self.storeIdStr,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:QUXIAOGUANZHUPINPAI];
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            
            
            if ([[result stringValueForKey:@"errorcode"]intValue]==0) {
                [GMAPI showAutoHiddenMBProgressWithText:@"取消关注成功" addToView:self.view];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_PINPAI_QUXIAO object:nil];
                [_my_right_button setTitle:@"关注" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
                self.guanzhu = @"0";
            }
            
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [GMAPI showAutoHiddenMBProgressWithText:@"取消关注失败" addToView:self.view];
        }];
    }

    
}




- (void)createMemuView
{
    
    CGFloat aWidth = (ALL_FRAME_WIDTH - 24)/ 3.f;
    _menu_view = [[UIView alloc]initWithFrame:CGRectMake(12, 12, aWidth * 3, 30)];
    _menu_view.clipsToBounds = YES;
    _menu_view.layer.cornerRadius = 15.f;
    _menu_view.backgroundColor = RGBCOLOR(212, 59, 85);
    
//    self.navigationItem.titleView = menu_view;
    [self.view addSubview:_menu_view];
    NSLog(@"%@",NSStringFromCGRect(_menu_view.frame));
    
    NSArray *titles = @[@"新品",@"折扣",@"热销"];
    
    for (int i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(aWidth * i + 0.5 * i, 0, aWidth, 30);
        
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
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
    [_waterFlow showRefreshHeader:YES];
}




#pragma mark - _waterFlowDelegate

- (void)waterLoadNewData
{
    
    
    //初始化
    _waterFlow.pageNum = 1;
    _waterFlow.dataArray = [NSMutableArray arrayWithCapacity:1];
    
    //请求网络数据
    NSString *api = nil;
    
    
    NSLog(@"customSegmentIndex:%d",_paixuIndex);
    
    
    if (_paixuIndex == 0) {//新品
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"by_time",self.storeIdStr,_waterFlow.pageNum,_per_page];
    }else if (_paixuIndex == 1){//折扣
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"by_discount",self.storeIdStr,_waterFlow.pageNum,_per_page];
    }else if (_paixuIndex == 2){//热销
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"by_hot",self.storeIdStr,_waterFlow.pageNum,_per_page];
    }
    
    NSLog(@"请求的接口%@",api);
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result : %@",result);
        
        
        
        NSMutableArray *arr;
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *list = result[@"list"];
            
            
            if (list.count == 0) {
//                [GMAPI showAutoHiddenMBProgressWithText:@"暂无" addToView:self.view];
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
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"by_time",self.storeIdStr,_waterFlow.pageNum,_per_page];
    }else if (_paixuIndex == 1){//折扣
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"by_discount",self.storeIdStr,_waterFlow.pageNum,_per_page];
    }else if (_paixuIndex == 2){//热销
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"by_hot",self.storeIdStr,_waterFlow.pageNum,_per_page];
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
    [cell setCellWithModel:aMode];
    
    
    return cell;
}




#pragma mark - CustomSegmentViewDelegate
-(void)buttonClick:(int)buttonSelected{
    NSLog(@"buttonSelect:%d",buttonSelected);
    
    
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
