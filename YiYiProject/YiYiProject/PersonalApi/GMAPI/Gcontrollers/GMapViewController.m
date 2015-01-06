//
//  GMapViewController.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/13.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GMapViewController.h"
#import "BMapKit.h"

@interface GMapViewController ()

@end

@implementation GMapViewController



- (void)dealloc {
    
    if (_mapView) {
        _mapView = nil;
    }
    
    if (_locService) {
        _locService = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    
    //初始化按钮
    [self setForBtn];
    
    //初始化地图
    [self setGMap];
    
    //初始化定位服务
    [self setGLocationService];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    
    //停止定位
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
    
    //代理置空
    _mapView.delegate = nil;
    _locService.delegate = nil;
    
    
    
}



#pragma mark - 初始化地图
-(void)setGMap{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 44, DEVICE_WIDTH, DEVICE_HEIGHT-44)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
}

#pragma mark - 初始化定位服务
-(void)setGLocationService{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
}


#pragma mark - 按钮btn相关
-(void)setForBtn{
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.backgroundColor = RGBCOLOR_ONE;
    [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [_startBtn setFrame:CGRectMake(0, 0, DEVICE_WIDTH/4, 44)];
    [_startBtn addTarget:self action:@selector(startLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _followingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followingBtn.backgroundColor = RGBCOLOR_ONE;
    [_followingBtn setTitle:@"跟随定位" forState:UIControlStateNormal];
    [_followingBtn setFrame:CGRectMake(CGRectGetMaxX(_startBtn.frame), 0, DEVICE_WIDTH/4, 44)];
    [_followingBtn addTarget:self action:@selector(startFollowing:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _followHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followHeadBtn.backgroundColor = RGBCOLOR_ONE;
    [_followHeadBtn setTitle:@"罗盘定位" forState:UIControlStateNormal];
    [_followHeadBtn setFrame:CGRectMake(CGRectGetMaxX(_followingBtn.frame), 0, DEVICE_WIDTH/4, 44)];
    [_followHeadBtn addTarget:self action:@selector(startFollowHeading:) forControlEvents:UIControlEventTouchUpInside];
    
    _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _stopBtn.backgroundColor = RGBCOLOR_ONE;
    [_stopBtn setTitle:@"停止定位" forState:UIControlStateNormal];
    [_stopBtn setFrame:CGRectMake(CGRectGetMaxX(_followHeadBtn.frame), 0, DEVICE_WIDTH/4, 44)];
    [_stopBtn addTarget:self action:@selector(stopLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    [_followHeadBtn setEnabled:NO];
    [_followingBtn setAlpha:0.6];
    [_followingBtn setEnabled:NO];
    [_followHeadBtn setAlpha:0.6];
    [_stopBtn setEnabled:NO];
    [_stopBtn setAlpha:0.6];
    
    [self.view addSubview:_startBtn];
    [self.view addSubview:_followingBtn];
    [self.view addSubview:_followHeadBtn];
    [self.view addSubview:_stopBtn];
    
    
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



#pragma mark - 按钮点击方法

//普通态
-(void)startLocation:(UIButton*)sender
{
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    [_startBtn setEnabled:NO];
    [_startBtn setAlpha:0.6];
    [_stopBtn setEnabled:YES];
    [_stopBtn setAlpha:1.0];
    [_followHeadBtn setEnabled:YES];
    [_followHeadBtn setAlpha:1.0];
    [_followingBtn setEnabled:YES];
    [_followingBtn setAlpha:1.0];
}
//罗盘态
-(void)startFollowHeading:(UIButton*)sender
{
    NSLog(@"进入罗盘态");
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    _mapView.showsUserLocation = YES;
    
}
//跟随态
-(void)startFollowing:(UIButton*)sender
{
    NSLog(@"进入跟随态");
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
}
//停止定位
-(void)stopLocation:(UIButton*)sender
{
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
    [_stopBtn setEnabled:NO];
    [_stopBtn setAlpha:0.6];
    [_followHeadBtn setEnabled:NO];
    [_followHeadBtn setAlpha:0.6];
    [_followingBtn setEnabled:NO];
    [_followingBtn setAlpha:0.6];
    [_startBtn setEnabled:YES];
    [_startBtn setAlpha:1.0];
}









@end
