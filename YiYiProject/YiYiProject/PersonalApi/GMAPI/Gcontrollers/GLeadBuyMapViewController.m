//
//  GLeadBuyMapViewController.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GLeadBuyMapViewController.h"
#import "BMapKit.h"
#import "GLeadbuyTableViewCell.h"

@interface GLeadBuyMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKAnnotation,UIAlertViewDelegate>
{
    BMKMapView* _mapView;//地图
    BMKLocationService* _locService;//定位服务
    
    //信息字典
    NSMutableDictionary *_poiAnnotationDic;
    
}

@property(nonatomic,strong)BMKPoiInfo *tableViewCellDataModel;

//协议属性
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation GLeadBuyMapViewController


- (void)dealloc {
    
    if (_mapView) {
        _mapView = nil;
    }
    
    if (_locService) {
        _locService = nil;
    }
}



-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        //iOS 5 new UINavigationBar custom background
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:MY_MACRO_NAME?IOS7DAOHANGLANBEIJING_PUSH:IOS6DAOHANGLANBEIJING] forBarMetrics: UIBarMetricsDefault];
    }

    
//    LNavigationController *navigation = (LNavigationController *)self.navigationController;
//    
//    navigation.panGesture.enabled = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    
//    LNavigationController *navigation = (LNavigationController *)self.navigationController;
//    
//    navigation.panGesture.enabled = YES;
    
    //停止定位
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
    
    //代理置空
    _mapView.delegate = nil;
    _locService.delegate = nil;
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
    
    UILabel *_myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = self.storeName;
    _myTitleLabel.textColor = [UIColor whiteColor];
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = _myTitleLabel;
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(0,8,40,44)];
    [button_back addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    //        button_back.backgroundColor = [UIColor orangeColor];
    [button_back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    self.navigationItem.leftBarButtonItems=@[back_item];
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.myTitleLabel.textColor = [UIColor whiteColor];
    self.myTitle = self.storeName;
    
    //初始化地图
    [self setGMap];
    //初始化定位服务
    [self setGLocationService];
    
    //开启定位
    [self startFollowHeading];
    
    
    //初始化分配内存
    _poiAnnotationDic  = [[NSMutableDictionary alloc]init];
    
    
    
    //加标注
    if (self.theType == LEADYOUTYPE_STORE) {//商店
        [self addMapAnnotationOfStore];
    }else if (self.theType == LEADYOUTYPE_CHANPIN){//产品
        [self addMapAnnotationOfChanpin];
    }
    
    
}


#pragma mark - 初始化地图
-(void)setGMap{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-44)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
}

#pragma mark - 初始化定位服务
-(void)setGLocationService{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
}



#pragma mark - 开启定位罗盘态
// 罗盘态
-(void)startFollowHeading{
    NSLog(@"进入罗盘态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.zoomLevel = 17;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
}



#pragma mark - 定位相关

//在地图View将要启动定位时，会调用此函数
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

//用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
    
}

//用户位置更新后，会调用此函数
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView updateLocationData:userLocation];
}


//在地图View停止定位后，会调用此函数
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

//定位失败后，会调用此函数
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
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
    
    
}

//添加地图标注 产品方向
-(void)addMapAnnotationOfChanpin{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = self.coordinate_chanpin;
    item.title = self.chanpinName;
    
    
    [_mapView addAnnotation:item];//addAnnotation方法会掉BMKMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
}






#pragma mark - 地图view代理方法 BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    annotationView.image = [UIImage imageNamed:@"gpin.png"];
    
    annotationView.selected = YES;
    
    return annotationView;
}
#pragma mark - 点击标注执行的方法
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
    NSLog(@"%s",__FUNCTION__);
    
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}


- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}



#pragma mark - 弹出框点击代理方法
// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
