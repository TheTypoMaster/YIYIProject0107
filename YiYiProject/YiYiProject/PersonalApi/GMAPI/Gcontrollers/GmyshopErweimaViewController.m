//
//  GmyshopErweimaViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/16.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GmyshopErweimaViewController.h"

#import "GMapShowMyshopViewController.h"

#import "NSDictionary+GJson.h"

@interface GmyshopErweimaViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_upErweimaView;//最上面的二维码界面
    UIView *_shopInfoView;//店铺信息view
    
    UITableView *_tableView;//主tableview
    NSDictionary *_result;//数据源
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
    
    self.myTitleLabel.text = @"店铺资料";
    self.myTitleLabel.textColor = RGBCOLOR(252, 76, 139);
    
    
    [self creatTableView];
    
    [self prepareNetData];
}



-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
}



//请求网络数据
-(void)prepareNetData{
    NSString *url = [NSString stringWithFormat:@"%@&authcode=%@&shop_id=%@",GMYSHOPERWEIMA,[GMAPI getAuthkey],self.shop_id];
    
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"%@",result);
        _result = result;
        [_tableView reloadData];
        _tableView.hidden = NO;
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0f;
    if (indexPath.row == 0) {
        height = 92;
    }else if (indexPath.row == 3){
        height = 210;
    }else{
        height = 55;
    }
    
    return height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"aaa";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.row == 0) {
        //logo
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 64, 64)];
        imv.layer.cornerRadius = 32;
        imv.layer.borderWidth = 0.5;
        imv.layer.borderColor = [RGBCOLOR(200, 200, 200)CGColor];
        imv.layer.masksToBounds = YES;
        [imv sd_setImageWithURL:[NSURL URLWithString:[_result stringValueForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"grzx150_150.png"]];
        [cell.contentView addSubview:imv];
        
        //店铺名
        UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imv.frame)+6, 25, DEVICE_WIDTH-105, 20)];
        shopName.textColor = [UIColor blackColor];
        shopName.font = [UIFont boldSystemFontOfSize:16];
        int mall_type = [[_result stringValueForKey:@"mall_type"]intValue];
        if (mall_type == 2) {//精品店
            self.shop_Name = [NSString stringWithFormat:@"%@",[_result stringValueForKey:@"mall_name"]];
        }else if (mall_type == 3){//品牌店
            self.shop_Name = [NSString stringWithFormat:@"%@.%@",[_result stringValueForKey:@"brand_name"],[_result stringValueForKey:@"mall_name"]];
        }
        shopName.text = [NSString stringWithFormat:@"店铺名：%@",self.shop_Name];
        [cell.contentView addSubview:shopName];
        
        //门牌号
        UILabel *menpaihao = [[UILabel alloc]initWithFrame:CGRectMake(shopName.frame.origin.x, CGRectGetMaxY(shopName.frame)+8, shopName.frame.size.width, 15)];
        menpaihao.font = [UIFont systemFontOfSize:14];
        menpaihao.textColor = RGBCOLOR(81, 82, 83);
        menpaihao.text = [NSString stringWithFormat:@"门牌号：%@",[_result stringValueForKey:@"doorno"]];
        [cell.contentView addSubview:menpaihao];
        
    }else if (indexPath.row == 1){//手机号
        UILabel *tt = [[UILabel alloc]initWithFrame:CGRectMake(7, 0, 60, cell.contentView.frame.size.height)];
        tt.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:tt];
        tt.text = @"手机号:";
        tt.textAlignment = NSTextAlignmentCenter;
        
        [cell.contentView addSubview:tt];
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tt.frame), 0, DEVICE_WIDTH-tt.frame.size.width - 30, cell.contentView.frame.size.height)];
        content.font = [UIFont systemFontOfSize:14];
        content.numberOfLines = 2;
        content.text = [_result stringValueForKey:@"shop_mobile"];
        [cell.contentView addSubview:content];
        
    }else if (indexPath.row == 2){//地址
        
        UILabel *tt = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, cell.contentView.frame.size.height)];
        tt.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:tt];
        tt.text = @"地址:";
        tt.textAlignment = NSTextAlignmentCenter;

        [cell.contentView addSubview:tt];
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tt.frame), 0, DEVICE_WIDTH-tt.frame.size.width - 30, cell.contentView.frame.size.height)];
        content.font = [UIFont systemFontOfSize:14];
        content.numberOfLines = 2;
        content.text = [_result stringValueForKey:@"address"];
        [content sizeToFit];
        [content setFrame:CGRectMake(CGRectGetMaxX(tt.frame), 0, content.frame.size.width, cell.contentView.frame.size.height)];
        [cell.contentView addSubview:content];
        
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(content.frame)+3, cell.contentView.frame.size.height*0.5-10, 17, 17)];
        [imv setImage:[UIImage imageNamed:@"gdpnav.png"]];
        [cell.contentView addSubview:imv];
        
        
    }else if (indexPath.row == 3){//二维码
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(75, 20, 166, 166)];
        [imv sd_setImageWithURL:[NSURL URLWithString:_result[@"qrcode_img"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        imv.center = CGPointMake(cell.contentView.center.x, cell.contentView.center.y-15);
        
        [cell.contentView addSubview:imv];
        
        UILabel *tt = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imv.frame)+10, cell.contentView.frame.size.width, 20)];
        tt.font = [UIFont systemFontOfSize:14];
        tt.textAlignment = NSTextAlignmentCenter;
        tt.textColor = RGBCOLOR(79, 80, 81);
        tt.text = @"扫一扫上面的二维码关注店铺";
        [cell.contentView addSubview:tt];
        
        
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {//地址
        GMapShowMyshopViewController *ccc = [[GMapShowMyshopViewController alloc]init];
        ccc.storeName = self.shop_Name;
        ccc.coordinate_store = CLLocationCoordinate2DMake([self.mallInfo.latitude floatValue], [self.mallInfo.longitude floatValue]);
        [self presentViewController:ccc animated:YES completion:^{
            
        }];
    }
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
    int mall_type = [[result stringValueForKey:@"mall_type"]intValue];
    if (mall_type == 2) {//精品店
        self.shop_Name = [NSString stringWithFormat:@"%@",[result stringValueForKey:@"mall_name"]];
    }else if (mall_type == 3){//品牌店
        self.shop_Name = [NSString stringWithFormat:@"%@.%@",[result stringValueForKey:@"brand_name"],[result stringValueForKey:@"mall_name"]];
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
    adressLabel.text = [NSString stringWithFormat:@"地址：%@",[result stringValueForKey:@"address"]];
    [adressLabel sizeToFit];
    [_shopInfoView addSubview:adressLabel];
    
    //门牌号
    UILabel *doorNum = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(adressLabel.frame)+10, _shopInfoView.frame.size.width-12, 50)];
    doorNum.textColor = [UIColor whiteColor];
    doorNum.text = [NSString stringWithFormat:@"门牌号：%@",[result stringValueForKey:@"doorno"]];
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
