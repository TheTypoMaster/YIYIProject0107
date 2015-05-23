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
#import "MessageDetailController.h"
#import "GLeadBuyMapViewController.h"
#import "GAddTtaiImageLinkViewController.h"

@interface GStorePinpaiViewController ()<GCustomSegmentViewDelegate,TMQuiltViewDataSource,WaterFlowDelegate,UIScrollViewDelegate>
{
    
    
    int _per_page;//每一页请求多少数据
    
    //瀑布流视图
    LWaterflowView *_waterFlow;//一个瀑布流
    
    
    int _paixuIndex;//新品折扣热销btn标识
    
    
    UIView *_menu_view;//按钮底层view
    NSMutableArray *_btnArray;//按钮数组
    
    
    
    //收藏相关
    UIButton *_my_right_button;
    UIBarButtonItem *_spaceButton;
    
    
    //瀑布流下层view
    UIView *_backView_water;
    
    
    //主scrollview
    UIScrollView *_mainScrollview;
    
    UILabel *_huodongTime_title;
    UILabel *_huodongTime_content;
    
}



@end

@implementation GStorePinpaiViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    
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
//    _mainScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, self.view.height - 35)];

    [self.view addSubview:_mainScrollview];
    
    
    _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    _my_right_button.frame = CGRectMake(0,0,60,44);
    _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_my_right_button setTitleColor:RGBCOLOR(253, 104, 157) forState:UIControlStateNormal];
    [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
    
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    
    

    
    
    
    //初始化
    _btnArray = [NSMutableArray arrayWithCapacity:1];
    _per_page = 10;
    _paixuIndex = 0;

    
    //获取店铺详情
    
    NSLog(@"品牌名称 %@",self.pinpaiNameStr);
    NSLog(@"商家名称 %@",self.storeNameStr);
    NSLog(@"商家id %@",self.storeIdStr);
    NSLog(@"品牌id %@",self.pinpaiId);
    NSLog(@"收藏类型 %@",self.guanzhuleixing);
    
    
    
    

    [self prepareDianpuInfo];//获取店铺信息
    
    
}



//店铺浏览量加1
-(void)dianpuLiulan{
    
    if (![self.guanzhuleixing isEqualToString:@"精品店"]) {
        self.shopId = self.storeIdStr;
    }
    
    //判断是否登录
    NSString *url = @" ";
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == YES) {
        NSString *aaa = [LTools cacheForKey:USER_SHOP_ID];
        if ([aaa isEqualToString:self.shopId] ) {
            return;
        }
        url = [NSString stringWithFormat:@"%@&shop_id=%@&authcode=%@",LIULAN_NUM_SHOP,self.shopId,[GMAPI getAuthkey]];
        
    }else{
        url = [NSString stringWithFormat:@"%@&shop_id=%@",LIULAN_NUM_SHOP,self.shopId];
    }
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
}


//获取店铺详情
-(void)prepareDianpuInfo{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //收藏精品店===========这里显示的是精品店
    if ([self.guanzhuleixing isEqualToString:@"精品店"]) {
        NSString *api = [NSString stringWithFormat:@"%@&mall_id=%@&authcode=%@",HOME_CLOTH_NEARBYSTORE_DETAIL,self.storeIdStr,[GMAPI getAuthkey]];
        GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
        [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
            self.storeNameStr = [result stringValueForKey:@"mall_name"];
            [self setJingpindianTitleName];//设置精品店标题名称
            
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
            
            self.guanzhu = [result stringValueForKey:@"following"];
            
            [self creatDianpuInfoViewWithResult:result];

            
            
            [self createMemuView];
            
            
            if ([[result stringValueForKey:@"following"]intValue]==1) {//已收藏
                [_my_right_button setTitle:@"已收藏" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            }else if ([[result stringValueForKey:@"following"]intValue]==0){//未收藏
                [_my_right_button setTitle:@"收藏" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
            }
            
            if (self.isChooseProductLink) {
                [_my_right_button setTitle:@"选择" forState:UIControlStateNormal];
            }
            
            self.coordinate_store = CLLocationCoordinate2DMake([[result stringValueForKey:@"latitude"]floatValue], [[result stringValueForKey:@"longitude"]floatValue]);
            
            
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
            
            
            
            [self dianpuLiulan];
            
            
            
            
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"加载失败" addToView:self.view];
            
        }];
        
        
        return;
    }
    
    
    
    
    //收藏的是品牌店==========这里显示品牌店
    NSString *api = [NSString stringWithFormat:@"%@&shop_id=%@&authcode=%@",GET_MAIL_DETAIL_INFO,self.storeIdStr,[GMAPI getAuthkey]];//品牌店
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [self creatDianpuInfoViewWithResult:result];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSLog(@"品牌店信息 %@",result);
        
        self.pinpaiNameStr =  [result stringValueForKey:@"shop_name"];
        self.storeNameStr = [result stringValueForKey:@"mall_name"];
        [self setPinpaidianTitleName];//设置品牌店标题
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
            self.activityId = [dic stringValueForKey:@"activity_id"];
        }
        
        
        _huodongLabel.text = huodongStr;
        
        self.coordinate_store = CLLocationCoordinate2DMake([[result stringValueForKey:@"latitude"]floatValue], [[result stringValueForKey:@"longitude"]floatValue]);
        
        
        [self createMemuView];
        [self getGuanzhuYesOrNoForPinpaiDianWithDic:result];
//        [self getGuanzhuYesOrNoForPinpai];
        
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [GMAPI showAutoHiddenMBProgressWithText:@"加载失败" addToView:self.view];
    }];
}


//设置精品店标题
-(void)setJingpindianTitleName{
    self.myTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.myTitleLabel.text = self.storeNameStr;
}


//设置品牌店标题
-(void)setPinpaidianTitleName{
    NSString *aaa = [NSString stringWithFormat:@"%@.%@",self.pinpaiNameStr,self.storeNameStr];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:aaa];
    NSInteger pinpaiNameLength = self.pinpaiNameStr.length;
    NSInteger storeNameLength = self.storeNameStr.length;
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,pinpaiNameLength+1)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17*GscreenRatio_320] range:NSMakeRange(0,pinpaiNameLength)];
    
    [title addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(240, 173, 184) range:NSMakeRange(pinpaiNameLength+1, storeNameLength)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13*GscreenRatio_320] range:NSMakeRange(pinpaiNameLength+1, storeNameLength)];
    self.myTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.myTitleLabel.attributedText = title;
}




//创建店铺信息view
-(void)creatDianpuInfoViewWithResult:(NSDictionary*)result{
    
    _upStoreInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 188*GscreenRatio_320)];
    [_mainScrollview addSubview:_upStoreInfoView];
    
    //活动图片
    UIImageView *activeImv = [[UIImageView alloc]initWithFrame:_upStoreInfoView.bounds];
    activeImv.backgroundColor = [UIColor whiteColor];
    NSString *imgNameStr = @" ";
    if ([result[@"activity"] isKindOfClass:[NSDictionary class]]) {
        imgNameStr = result[@"activity"][@"activity_pic"];
    }
    [activeImv sd_setImageWithURL:[NSURL URLWithString:imgNameStr] placeholderImage:nil];
    [_upStoreInfoView addSubview:activeImv];
    activeImv.userInteractionEnabled = YES;
    UITapGestureRecognizer *sss = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huodongLabelClicked)];
    [activeImv addGestureRecognizer:sss];
    
    //活动
    _huodongLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, DEVICE_WIDTH-15-15, 32)];
    _huodongLabel.textColor = [UIColor purpleColor];
    _huodongLabel.numberOfLines = 2;
    _huodongLabel.font = [UIFont systemFontOfSize:15];
    if ([result[@"activity"] isKindOfClass:[NSDictionary class]]) {
        _huodongLabel.text = [NSString stringWithFormat:@"活动：%@",result[@"activity"][@"activity_title"]];
    }
    
    NSLog(@"%lu",(unsigned long)_huodongLabel.text.length);
    
    
    
    
    if (imgNameStr.length>2) {//有图
        
        UIImageView *activity_backImv = [[UIImageView alloc]initWithFrame:activeImv.bounds];
        [activity_backImv setImage:[UIImage imageNamed:@"gactivityback.png"]];
        [activeImv addSubview:activity_backImv];
        
        
        
        _huodongTime_title = [[UILabel alloc]initWithFrame:CGRectMake(12, activeImv.frame.size.height-50, 60, 17)];
        _huodongTime_title.textColor = [UIColor whiteColor];
        _huodongTime_title.layer.shadowColor = [UIColor grayColor].CGColor;
        _huodongTime_title.layer.shadowOpacity = 1.0;
        _huodongTime_title.layer.shadowRadius = 3.0;
        _huodongTime_title.layer.shadowOffset = CGSizeMake(0, 2);
        _huodongTime_title.font = [UIFont systemFontOfSize:15];
        [activeImv addSubview:_huodongTime_title];
        _huodongTime_title.text = @"活动时间";
        
        
        
        _huodongTime_content = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_huodongTime_title.frame)+5, activeImv.frame.size.width-24, 17)];
        
        NSString *startTime = result[@"activity"][@"start_time"];
        NSString *endTime = result[@"activity"][@"end_time"];
        startTime = [LTools timechangeMMDD:startTime];
        endTime = [LTools timechangeMMDD:endTime];
        _huodongTime_content.text = [NSString stringWithFormat:@"%@  --  %@",startTime,endTime];
        _huodongTime_content.font = [UIFont systemFontOfSize:15];
        _huodongTime_content.textColor = [UIColor whiteColor];
        
        [activeImv addSubview:_huodongTime_content];
    }else{//没图
        if (_huodongLabel.text.length>3) {//有文字
            [_upStoreInfoView addSubview:_huodongLabel];
            _huodongLabel.numberOfLines = 1;
            UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_huodongLabel.frame)+15, DEVICE_WIDTH, 0.5)];
            downLine.backgroundColor = RGBCOLOR(255, 100, 154);
            
            UILabel *huodongFlag = [[UILabel alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-80, CGRectGetMaxY(_huodongLabel.frame), 70, 15)];
            huodongFlag.font = [UIFont systemFontOfSize:11];
            huodongFlag.text = @"活动";
            huodongFlag.textColor = RGBCOLOR(255, 100, 154);
            huodongFlag.textAlignment = NSTextAlignmentRight;
            
            [_upStoreInfoView addSubview:huodongFlag];
            
            [_upStoreInfoView addSubview:downLine];
            [_upStoreInfoView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, 60)];
        }else{
            [_upStoreInfoView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
        }
    }
    
    
    _huodongLabel.userInteractionEnabled = YES;
    _huodongLabel.textColor = RGBCOLOR(68, 99, 160);
//    _huodongLabel.layer.shadowColor = [UIColor grayColor].CGColor;
//    _huodongLabel.layer.shadowOpacity = 1.0;
//    _huodongLabel.layer.shadowRadius = 3.0;
//    _huodongLabel.layer.shadowOffset = CGSizeMake(0, 2);
    _huodongLabel.clipsToBounds = NO;
    
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(huodongLabelClicked)];
    [_huodongLabel addGestureRecognizer:tap];
    
    
    
    
    
    
    //导航
    UIView *downDanghangView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT-35-64, DEVICE_WIDTH, 35)];
    NSLog(@"%@",NSStringFromCGRect(downDanghangView.frame));
    downDanghangView.backgroundColor = RGBCOLOR(74, 74, 74);
    [self.view addSubview:downDanghangView];
    
    UIButton *daohangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [daohangBtn setFrame:CGRectMake(12, 4, 62, 28)];
    [daohangBtn setImage:[UIImage imageNamed:@"gdaohang_product.png"] forState:UIControlStateNormal];
    [downDanghangView addSubview:daohangBtn];
    [daohangBtn addTarget:self action:@selector(leadYouBuy) forControlEvents:UIControlEventTouchUpInside];
    
    //地址
    UILabel *adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(daohangBtn.frame)+8, 0, DEVICE_WIDTH-CGRectGetMaxX(daohangBtn.frame)-58, downDanghangView.frame.size.height)];
    self.adressLabelStr = [result stringValueForKey:@"address"];
    adressLabel.text = [NSString stringWithFormat:@"地址：%@",[result stringValueForKey:@"address"]];
    adressLabel.font = [UIFont systemFontOfSize:13];
    adressLabel.numberOfLines = 2;
    adressLabel.textColor = RGBCOLOR(181, 181, 181);
    [downDanghangView addSubview:adressLabel];
    
    
    
    
    self.phoneNumber = result[@"shop_phone"];
    
    
    //电话
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn setImage:[UIImage imageNamed:@"gphone_up.png"] forState:UIControlStateNormal];
    [phoneBtn setImage:[UIImage imageNamed:@"gphone_down.png"] forState:UIControlStateHighlighted];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    phoneBtn.layer.cornerRadius = 5;
    phoneBtn.layer.masksToBounds = YES;
    [phoneBtn setFrame:CGRectMake(CGRectGetMaxX(adressLabel.frame), adressLabel.frame.origin.y+2, 47, adressLabel.frame.size.height-2)];
    phoneBtn.backgroundColor = RGBCOLOR(12, 62, 3);
    [phoneBtn addTarget:self action:@selector(takeThePhone) forControlEvents:UIControlEventTouchUpInside];
    [downDanghangView addSubview:phoneBtn];
    
    
    if ([self.phoneNumber intValue] == 0) {
        phoneBtn.hidden = YES;
    }
    
    
}



//打电话
-(void)takeThePhone{
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"拨号" message:self.phoneNumber delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [al show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //0取消    1确定
    if (buttonIndex == 1) {
        NSString *strPhone = [NSString stringWithFormat:@"tel://%@",self.phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];
    }
}


//跳转地图导航页面
-(void)leadYouBuy{
    GLeadBuyMapViewController *cc = [[GLeadBuyMapViewController alloc]init];
    cc.theType = LEADYOUTYPE_STORE;
    cc.storeName = [NSString stringWithFormat:@"%@",self.storeNameStr];
    cc.coordinate_store = self.coordinate_store;
    
    
    [self presentViewController:cc animated:YES completion:^{
        
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


//获取是否收藏 品牌
-(void)getGuanzhuYesOrNoForPinpai{
    
    NSString *api = [NSString stringWithFormat:@"%@&brand_id=%@&authcode=%@",GUANZHUPINPAI_ISORNO,self.pinpaiId,[GMAPI getAuthkey]];
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",result);
        self.guanzhu = [result stringValueForKey:@"relation"];
        if ([self.guanzhu intValue]==0) {//未收藏
            [_my_right_button setTitle:@"收藏" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        }else if ([self.guanzhu intValue] == 1){//已收藏
            [_my_right_button setTitle:@"已收藏" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        }
        
        if (self.isChooseProductLink) {
            [_my_right_button setTitle:@"选择" forState:UIControlStateNormal];
        }
        
        [_waterFlow showRefreshHeader:YES];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


//获取是否收藏品牌店
-(void)getGuanzhuYesOrNoForPinpaiDianWithDic:(NSDictionary *)dic{
   
        self.guanzhu = [dic stringValueForKey:@"following"];
        if ([self.guanzhu intValue]==0) {//未收藏
            [_my_right_button setTitle:@"收藏" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        }else if ([self.guanzhu intValue] == 1){//已收藏
            [_my_right_button setTitle:@"已收藏" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        }
        
        if (self.isChooseProductLink) {
            [_my_right_button setTitle:@"选择" forState:UIControlStateNormal];
        }
        
        [_waterFlow showRefreshHeader:YES];
        
    
}




-(void)leftButtonTap:(UIButton *)sender
{
    if (self.isPresent) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
        
    }
    
    
    
    if (self.isChooseProductLink) {
        GAddTtaiImageLinkViewController *rrr = self.navigationController.viewControllers[0];
        if ([self.guanzhuleixing isEqualToString:@"精品店"]) {
            [rrr setGmoveImvProductId:@"0" shopid:self.shopId productName:@" " shopName:self.storeNameStr price:self.adressLabelStr type:@"店铺"];
            
        }else if ([self.guanzhuleixing isEqualToString:@"品牌店"]){
            NSString *aaa = [NSString stringWithFormat:@"%@.%@",self.pinpaiNameStr,self.storeNameStr];
            [rrr setGmoveImvProductId:@"0" shopid:self.shopId productName:@" " shopName:aaa price:self.adressLabelStr type:@"店铺"];
            
        }
        [self.navigationController popToViewController:rrr animated:YES];
        return;
    }
    
    
    //判断是否为精品店
    if ([self.guanzhuleixing isEqualToString:@"精品店"]) {
        if ([self.guanzhu intValue] == 0) {//未收藏
            NSString *post = [NSString stringWithFormat:@"&mall_id=%@&authcode=%@",self.storeIdStr,[GMAPI getAuthkey]];
            NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSString *url = [NSString stringWithFormat:GUANZHUSHANGCHANG];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
            [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
                    [GMAPI showAutoHiddenMBProgressWithText:@"收藏成功" addToView:self.view];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE object:nil];
                    [_my_right_button setTitle:@"已收藏" forState:UIControlStateNormal];
                    self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
                    self.guanzhu = @"1";
                }else{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if ([[result stringValueForKey:@"errorcode"]intValue] > 2000) {
                        [GMAPI showAutoHiddenMBProgressWithText:[result stringValueForKey:@"msg"] addToView:self.view];
                    }else{
                        [GMAPI showAutoHiddenMBProgressWithText:@"收藏失败" addToView:self.view];
                    }
                }
            } failBlock:^(NSDictionary *failDic, NSError *erro) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [GMAPI showAutoHiddenMBProgressWithText:@"收藏失败" addToView:self.view];
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
                    [GMAPI showAutoHiddenMBProgressWithText:@"取消收藏成功" addToView:self.view];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE_QUXIAO object:nil];
                    [_my_right_button setTitle:@"收藏" forState:UIControlStateNormal];
                    self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
                    self.guanzhu = @"0";
                }else{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if ([[result stringValueForKey:@"errorcode"]intValue] > 2000) {
                        [GMAPI showAutoHiddenMBProgressWithText:[result stringValueForKey:@"msg"] addToView:self.view];
                    }else{
                        [GMAPI showAutoHiddenMBProgressWithText:@"取消收藏失败" addToView:self.view];
                    }
                }
                
                
            } failBlock:^(NSDictionary *failDic, NSError *erro) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [GMAPI showAutoHiddenMBProgressWithText:@"取消收藏失败" addToView:self.view];
            }];
        }
        
        
        return;
        
    }else if ([self.guanzhuleixing isEqualToString:@"品牌店"]){
        
        if ([self.guanzhu intValue] == 0) {//未收藏
            
            NSString *url = GGUANZHUPINPAIDIAN;
            NSString *post = [NSString stringWithFormat:@"&shop_id=%@&authcode=%@",self.shopId,[GMAPI getAuthkey]];
            NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
            [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
                    [GMAPI showAutoHiddenMBProgressWithText:@"收藏成功" addToView:self.view];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE object:nil];
                    [_my_right_button setTitle:@"已收藏" forState:UIControlStateNormal];
                    self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
                    self.guanzhu = @"1";
                }else{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    if ([[result stringValueForKey:@"errorcode"]intValue] > 2000) {
                        [GMAPI showAutoHiddenMBProgressWithText:[result stringValueForKey:@"msg"] addToView:self.view];
                    }else{
                        [GMAPI showAutoHiddenMBProgressWithText:@"收藏失败" addToView:self.view];
                    }
                    
                    
                }
            } failBlock:^(NSDictionary *failDic, NSError *erro) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [GMAPI showAutoHiddenMBProgressWithText:@"收藏失败" addToView:self.view];
            }];
        }else if ([self.guanzhu intValue] == 1){//已收藏
            
            NSString *url = GQUXIAOGUANZHUPINPAIDIAN;
            NSString *post = [NSString stringWithFormat:@"&shop_id=%@&authcode=%@",self.shopId,[GMAPI getAuthkey]];
            NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
            [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
                if ([[result stringValueForKey:@"errorcode"]intValue]==0) {
                    [GMAPI showAutoHiddenMBProgressWithText:@"取消收藏成功" addToView:self.view];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE_QUXIAO object:nil];
                    [_my_right_button setTitle:@"收藏" forState:UIControlStateNormal];
                    self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
                    self.guanzhu = @"0";
                }else{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if ([[result stringValueForKey:@"errorcode"]intValue] > 2000) {
                        [GMAPI showAutoHiddenMBProgressWithText:[result stringValueForKey:@"msg"] addToView:self.view];
                    }else{
                        [GMAPI showAutoHiddenMBProgressWithText:@"取消收藏失败" addToView:self.view];
                    }
                    
                }
            } failBlock:^(NSDictionary *failDic, NSError *erro) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [GMAPI showAutoHiddenMBProgressWithText:@"取消收藏失败" addToView:self.view];
            }];
            
        }
        
    }
    

    
}


//收藏品牌
-(void)guanzhupinpai{
    //判断是否收藏品牌
    NSLog(@"self.guanzhu:%@",self.guanzhu);
    
    if ([self.guanzhu intValue] == 0) {//未收藏
        NSString *post = [NSString stringWithFormat:@"&brand_id=%@&authcode=%@",self.pinpaiId,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:GUANZHUPINPAI];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
                [GMAPI showAutoHiddenMBProgressWithText:@"收藏成功" addToView:self.view];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_PINPAI object:nil];
                [_my_right_button setTitle:@"已收藏" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
                self.guanzhu = @"1";
            }
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"收藏失败" addToView:self.view];
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
                [GMAPI showAutoHiddenMBProgressWithText:@"取消收藏成功" addToView:self.view];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_PINPAI_QUXIAO object:nil];
                [_my_right_button setTitle:@"收藏" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItems = @[_spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
                self.guanzhu = @"0";
            }
            
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"取消收藏失败" addToView:self.view];
        }];
    }
}



- (void)createMemuView
{
    
    CGFloat aWidth = (ALL_FRAME_WIDTH - 24)/ 3.f;
    _menu_view = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_upStoreInfoView.frame)+5, aWidth * 3, 30)];
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
    _backView_water = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_menu_view.frame)+5, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - _menu_view.frame.size.height -64-_upStoreInfoView.frame.size.height-25)];
//    _backView_water.backgroundColor = RGBCOLOR(240, 230, 235);
    [_mainScrollview addSubview:_backView_water];
    _waterFlow = [[LWaterflowView alloc]initWithFrame:_backView_water.bounds waterDelegate:self waterDataSource:self];
    _waterFlow.backgroundColor = RGBCOLOR(235, 235, 235);
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
        [_waterFlow showRefreshHeader:YES];
    }else if (_paixuIndex == 1){//折扣
        [_waterFlow showRefreshHeader:YES];
    }else if (_paixuIndex == 2){//热销
        [_waterFlow showRefreshHeader:YES];
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
    
    
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == YES){//已经登录的情况下 传authecode 点赞
        api = [NSString stringWithFormat:@"%@&authcode=%@",api,[GMAPI getAuthkey]];
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
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell*)[_waterFlow.quitView cellAtIndexPath:indexPath];
    
    detail.theStorePinpaiProductCell = cell;
    detail.theStorePinpaiProductModel = aMode;
    
    if (self.isChooseProductLink) {
        detail.isChooseProductLink = YES;
    }
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
    
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO){//没登陆
//        [cell.like_btn addTarget:self action:@selector(zandenglu) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.like_btn.tag = 10000 + indexPath.row;
        [cell.like_btn addTarget:self action:@selector(clickToZan:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell setCellWithModel:aMode];
    
    
    
    
    return cell;
}





-(void)zandenglu{
    LoginViewController *login = [[LoginViewController alloc]init];
    
    UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
    
    [self presentViewController:unVc animated:YES completion:nil];
}





/**
 *  赞 取消赞 收藏 取消收藏
 */

- (void)clickToZan:(UIButton *)sender
{
    if (![LTools isLogin:self]) {
        
        return;
    }
    //直接变状态
    //更新数据
    
    [LTools animationToBigger:sender duration:0.2 scacle:1.5];
    
     TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[_waterFlow.quitView cellAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 10000 inSection:0]];
    //    cell.like_label.text = @"";
    
    ProductModel *aMode = _waterFlow.dataArray[sender.tag - 10000];
    NSString *productId = aMode.product_id;
    
    __weak typeof(self)weakSelf = self;
    
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
        [GMAPI showAutoHiddenMBProgressWithText:failDic[RESULT_INFO] addToView:weakSelf.view];
        if ([failDic[RESULT_CODE] intValue] == -11) {
            
            [LTools showMBProgressWithText:failDic[RESULT_INFO] addToView:weakSelf.view];
        }
        aMode.product_like_num = NSStringFromInt([aMode.product_like_num intValue]);
        cell.like_label.text = aMode.product_like_num;
    }];
}


//- (void)clickToZan:(UIButton *)sender
//{
//    if (![LTools isLogin:self]) {
//        
//        return;
//    }
//    //直接变状态
//    //更新数据
//    
//    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[_waterFlow.quitView cellAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 10000 inSection:0]];
//    cell.like_label.text = @"";
//    
//    ProductModel *aMode = _waterFlow.dataArray[sender.tag - 10000];
//    
//    NSString *productId = aMode.product_id;
//    
//    //    __weak typeof(self)weakSelf = self;
//    
//    NSString *api = HOME_PRODUCT_ZAN_ADD;
//    
//    NSString *post = [NSString stringWithFormat:@"product_id=%@&authcode=%@",productId,[GMAPI getAuthkey]];
//    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    
//    NSString *url = api;
//    
//    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
//    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
//        
//        NSLog(@"result %@",result);
//        sender.selected = YES;
//        aMode.is_like = 1;
//        aMode.product_like_num = NSStringFromInt([aMode.product_like_num intValue] + 1);
//        cell.like_label.text = aMode.product_like_num;
//        
//    } failBlock:^(NSDictionary *failDic, NSError *erro) {
//        
//        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
//        cell.like_label.text = aMode.product_like_num;
//        
//        [GMAPI showAutoHiddenMBProgressWithText:failDic[RESULT_INFO] addToView:self.view];
//        
//        if ([failDic[RESULT_CODE] intValue] == -11) {
//            
//            [LTools showMBProgressWithText:failDic[RESULT_INFO] addToView:self.view];
//        }
//        
//    }];
//}


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
            
            [UIView animateWithDuration:0.3 animations:^{
                [_backView_water setFrame:CGRectMake(0, CGRectGetMaxY(_menu_view.frame)+5, DEVICE_WIDTH, DEVICE_HEIGHT - _menu_view.frame.size.height -64 - 35)];
                [_waterFlow setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - _menu_view.frame.size.height -64-15 - 35)];
                [_waterFlow.quitView setFrame:_waterFlow.frame];
                [_mainScrollview setContentOffset:CGPointMake(0, height)];
            }];
            
            
        }
        
    }else if (scrollView.contentOffset.y<0){
        CGFloat height = _upStoreInfoView.frame.size.height;
        if (_mainScrollview.contentOffset.y>=height) {
            
            if (_upStoreInfoView.frame.size.height == 0) {
                return;
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                [_backView_water setFrame:CGRectMake(0, CGRectGetMaxY(_menu_view.frame)+5, DEVICE_WIDTH, DEVICE_HEIGHT - _menu_view.frame.size.height -64-_upStoreInfoView.frame.size.height)];
                [_waterFlow setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - _menu_view.frame.size.height -64-_upStoreInfoView.frame.size.height-15)];
                [_waterFlow.quitView setFrame:_waterFlow.frame];
                [_mainScrollview setContentOffset:CGPointMake(0, 0)];
            }];
            
            
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
