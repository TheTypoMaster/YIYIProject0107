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
    

    
}

@end

@implementation GnearbyStoreViewController



-(void)dealloc{
    
    NSLog(@"%s",__FUNCTION__);
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    
    //添加商场信息view
    [self creatUpStoreInfoView];
    
    
    //请求网络数据
    [self prepareNetData];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSLog(@"哪个vc %s",__FUNCTION__);
    
    self.view.backgroundColor = [UIColor whiteColor];
    

    
    
    
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

    id brandDic = nil;
    if (dic) {
        brandDic = [dic objectForKey:@"brand"];
    }
    

    //取出brand字段中所有的key


    NSArray *keys = nil;
    if ([brandDic isKindOfClass:[NSDictionary class]]) {
        keys = [brandDic allKeys];
    }else{
        return;
    }

    //楼层数


    NSMutableArray *floorsNameArray = [NSMutableArray arrayWithCapacity:1];
    for (NSString *str in keys) {
        [floorsNameArray addObject:[NSString stringWithFormat:@"F%@",str]];
    }

    
    //每层的数据的二维数组
    NSMutableArray *data_2Array = [NSMutableArray arrayWithCapacity:1];
    for (NSString *key in keys) {
        [data_2Array addObject:[brandDic objectForKey:key]];
    }
    

    
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


    
    [topScrollView initWithNameButtons];
    [rootScrollView initWithViews];
    
    
    [floorView addSubview:topScrollView];
    [floorView addSubview:rootScrollView];
    
    [self.view addSubview:floorView];
    
}



-(void)leadYouBuy{
    GLeadBuyMapViewController *cc = [[GLeadBuyMapViewController alloc]init];
    [self.navigationController pushViewController:cc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//请求网络数据
-(void)prepareNetData{
    //请求地址
    NSString *api = [NSString stringWithFormat:@"%@&mall_id=%@",HOME_CLOTH_NEARBYSTORE_DETAIL,self.storeIdStr];

    
    NSLog(@"请求的接口:%@",api);

    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%@",result);

        _mallNameLabel.text = [NSString stringWithFormat:@"%@",[result stringValueForKey:@"mall_name"]];
//        _huodongLabel.text = [result stringValueForKey:@""];
        _adressLabel.text = [NSString stringWithFormat:@"地址：%@",[result stringValueForKey:@"address"]];
        
        
        
        [self creatFloorScrollViewWithDic:result];
        
        
        

    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
    
    
}











@end
