//
//  GmyshopErweimaViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/16.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GmyshopErweimaViewController.h"

#import "GMapShowMyshopViewController.h"

@interface GmyshopErweimaViewController ()
{
    UIView *_upErweimaView;//最上面的二维码界面
    UIView *_shopInfoView;//店铺信息view
}
@end

@implementation GmyshopErweimaViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:self.lastPageNavigationHidden animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myTitleLabel.text = @"店铺二维码";
    self.myTitleLabel.textColor = RGBCOLOR(252, 76, 139);
    
    
    [self prepareNetData];
}



//请求网络数据
-(void)prepareNetData{
    NSString *url = [NSString stringWithFormat:@"%@&authcode=%@&shop_id=%@",GMYSHOPERWEIMA,[GMAPI getAuthkey],self.shop_id];
    
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"%@",result);
        [self creatCustomViewWithResult:result];
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
}



//创建信息view
-(void)creatCustomViewWithResult:(NSDictionary *)result{
    
    //二维码
    _upErweimaView = [[UIView alloc]initWithFrame:CGRectMake(75, 15, DEVICE_WIDTH-150, DEVICE_WIDTH-150)];
    _upErweimaView.backgroundColor = [UIColor grayColor];
    UIImageView *imv = [[UIImageView alloc]initWithFrame:_upErweimaView.bounds];
    [_upErweimaView addSubview:imv];
    [imv sd_setImageWithURL:[NSURL URLWithString:result[@"qrcode_img"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [self.view addSubview:_upErweimaView];
    
    
    UILabel *tishiLable = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_upErweimaView.frame)+10, DEVICE_WIDTH-24, 20)];
    tishiLable.font = [UIFont systemFontOfSize:15];
    tishiLable.textColor = [UIColor grayColor];
    tishiLable.textAlignment = NSTextAlignmentCenter;
    tishiLable.text = @"扫描二维码关注我的店铺";
    [self.view addSubview:tishiLable];
    
    //店铺信息
    _shopInfoView = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(tishiLable.frame)+15, DEVICE_WIDTH-24, 200)];
    _shopInfoView.backgroundColor = [UIColor blackColor];
    _shopInfoView.layer.cornerRadius = 10;
    _shopInfoView.alpha = 0.3f;
    [self.view addSubview:_shopInfoView];
    
    //店铺名
    UILabel *shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, _shopInfoView.frame.size.width-12, 50)];
    self.shop_Name = self.mallInfo.shop_name;
//    NSString *mall_name = result[@"mall_name"];
    if (self.mallInfo.mall_name.length>0) {
        self.shop_Name = [NSString stringWithFormat:@"%@.%@",self.mallInfo.shop_name,self.mallInfo.mall_name];
    }
    shopNameLabel.text = [NSString stringWithFormat:@"店铺名：%@",self.shop_Name];
    shopNameLabel.font = [UIFont systemFontOfSize:15];
    shopNameLabel.textColor = [UIColor whiteColor];
    shopNameLabel.numberOfLines = 2;
    [shopNameLabel sizeToFit];
    [_shopInfoView addSubview:shopNameLabel];
    
    //地址
    UILabel *adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(shopNameLabel.frame)+10, _shopInfoView.frame.size.width-12, 50)];
    UITapGestureRecognizer *adressLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adressLabelClicked)];
    [adressLabel addGestureRecognizer:adressLabelTap];
    adressLabel.userInteractionEnabled = YES;
    adressLabel.font = [UIFont systemFontOfSize:15];
    adressLabel.textColor = [UIColor whiteColor];
    adressLabel.numberOfLines = 2;
    adressLabel.text = [NSString stringWithFormat:@"地址：%@",self.mallInfo.address];
    [adressLabel sizeToFit];
    [_shopInfoView addSubview:adressLabel];
    
    //门牌号
    UILabel *doorNum = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(adressLabel.frame)+10, _shopInfoView.frame.size.width-12, 50)];
    doorNum.textColor = [UIColor whiteColor];
    doorNum.text = [NSString stringWithFormat:@"门牌号：%@",self.mallInfo.doorno];
    doorNum.font = [UIFont systemFontOfSize:15];
    doorNum.numberOfLines = 2;
    [doorNum sizeToFit];
    [_shopInfoView addSubview:doorNum];
    
    
    //调整_shopInfoView高度
    CGRect r = _shopInfoView.frame;
    r.size.height = shopNameLabel.frame.size.height + adressLabel.frame.size.height + doorNum.frame.size.height + 30 +12;
    _shopInfoView.frame = r;
    
    
    
}


//跳转地图
-(void)adressLabelClicked{
    GMapShowMyshopViewController *ccc = [[GMapShowMyshopViewController alloc]init];
    ccc.storeName = self.shop_Name;
    ccc.coordinate_store = CLLocationCoordinate2DMake([self.mallInfo.latitude floatValue], [self.mallInfo.longitude floatValue]);
    [self presentViewController:ccc animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
