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
    
    //用户定位数据
    BMKUserLocation *_userLocation;
    
    //导航按钮
    UIButton *_button_daohang;
    
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
    
    
    //导航栏
    UIView *daohangView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 64)];
    daohangView.backgroundColor = RGBCOLOR(235, 77, 104);
    [self.view addSubview:daohangView];
    
    //标题
    UILabel *_myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/2.0-100,20,200,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = self.storeName;
    _myTitleLabel.textColor = [UIColor whiteColor];
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    [daohangView addSubview:_myTitleLabel];

    
    //返回按钮
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(20,20,40,44)];
    [button_back addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [button_back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [daohangView addSubview:button_back];
    
    //导航按钮
    _button_daohang=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_myTitleLabel.frame)+10,20,40,44)];
    [_button_daohang addTarget:self action:@selector(gDaohang) forControlEvents:UIControlEventTouchUpInside];
    [_button_daohang setTitle:@"导航" forState:UIControlStateNormal];
    [_button_daohang setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    _button_daohang.userInteractionEnabled = NO;
    [daohangView addSubview:_button_daohang];
    
    
    
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
        self.mudidi = self.coordinate_store;
    }else if (self.theType == LEADYOUTYPE_CHANPIN){//产品
        [self addMapAnnotationOfChanpin];
        self.mudidi = self.coordinate_chanpin;
    }
    
    
}



//跳转百度地图应用
-(void)gDaohang{
    
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否跳转百度地图" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [al show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex == 1) {
        [self tiaozhuanBiduMap];
    }
}


-(void)tiaozhuanBiduMap{
//    CLLocationCoordinate2D coordinate_end;
//    
//    if (self.theType == LEADYOUTYPE_STORE) {//商店
//        coordinate_end = self.coordinate_store;
//    }else if (self.theType == LEADYOUTYPE_CHANPIN){//产品
//        coordinate_end = self.coordinate_chanpin;
//    }
    
    
    ///name:起始位置
    NSString * string = [NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=gaizhuang",_userLocation.location.coordinate.latitude,_userLocation.location.coordinate.longitude,self.mudidi.latitude,self.mudidi.longitude];
    
    NSLog(@"我我我我我我我我我我我我我我我我我我我哦我我我我我 ---  %@",string);
    
    UIApplication *app = [UIApplication sharedApplication];
    
    if ([app canOpenURL:[NSURL URLWithString:string]])
    {
        [_locService stopUserLocationService];
        [app openURL:[NSURL URLWithString:string]];
    }else
    {
        [GMAPI showAutoHiddenMBProgressWithText:@"您还没有安装百度地图" addToView:self.view];
    }
}


#pragma mark - 初始化地图
-(void)setGMap{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
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
    _mapView.zoomLevel = 13;
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
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    
    if (userLocation && !_button_daohang.userInteractionEnabled) {
        _button_daohang.userInteractionEnabled = YES;
        _userLocation = userLocation;
        
        //距离
//        CLLocation *mdd = [[CLLocation alloc]initWithLatitude:self.mudidi.latitude longitude:self.mudidi.longitude];
//        CLLocationDistance juli = [userLocation.location distanceFromLocation:mdd];
        
        
    }
    
    
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
