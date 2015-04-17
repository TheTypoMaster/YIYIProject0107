//
//  GMapShowMyshopViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GMapShowMyshopViewController.h"
#import "BMapKit.h"
#import "GLeadbuyTableViewCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NSDictionary+GJson.h"

@interface GMapShowMyshopViewController ()<BMKMapViewDelegate>
{
    BMKMapView* _mapView;//地图
    
}

@end

@implementation GMapShowMyshopViewController

- (void)dealloc {
    
    if (_mapView) {
        _mapView = nil;
    }
    
}



-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        //iOS 5 new UINavigationBar custom background
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7DAOHANGLANBEIJING_PUSH] forBarMetrics: UIBarMetricsDefault];
        
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    
    
    //代理置空
    _mapView.delegate = nil;
}


- (void)leftButtonTap:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    
    //导航栏
    UIView *daohangView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 64)];
    UIImageView *imv = [[UIImageView alloc]initWithFrame:daohangView.bounds];
    [imv setImage:[UIImage imageNamed:@"navigationBarBackground.png"]];
    [daohangView addSubview:imv];
    [self.view addSubview:daohangView];
    
    //标题
    UILabel *_myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/2.0-100,20,200,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = @"我的店铺";
    _myTitleLabel.textColor = RGBCOLOR(253, 106, 157);
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    [daohangView addSubview:_myTitleLabel];
    
    
    //返回按钮
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(16,20,40,44)];
    [button_back addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [button_back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [daohangView addSubview:button_back];
    
    
    
    
    //初始化地图
    [self setGMap];
    
    //加标注
    [self addMapAnnotationOfStore];
    
    
}



#pragma mark - 初始化地图
-(void)setGMap{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 17;
    [self.view addSubview:_mapView];
}



//添加地图标注 商场方向
-(void)addMapAnnotationOfStore{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = self.coordinate_store;
    item.title = self.storeName;
    [_mapView addAnnotation:item];//addAnnotation方法会掉BMKMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
    
    _mapView.centerCoordinate = self.coordinate_store;
    
}


@end
