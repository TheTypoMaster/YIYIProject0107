//
//  GchooseAdressViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/24.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GchooseAdressViewController.h"
#import "BMapKit.h"
#import "ShenQingDianPuViewController.h"
#import "GMAPI.h"
#import "NSDictionary+GJson.h"

@interface GchooseAdressViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,GgetllocationDelegate>
{
    BMKMapView* _mapView;//地图
    BMKPointAnnotation* _pointAnnotation;
    BMKAnnotationView* _newAnnotation;
    CGFloat _location_x;
    CGFloat _location_y;
    BMKGeoCodeSearch* _geocodesearch;

}
@end

@implementation GchooseAdressViewController




-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}



- (void)dealloc {
    
    if (_mapView) {
        _mapView = nil;
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    
    self.myTitle=@"选择地址";
    self.rightString = @"确定";
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    
    
    
    
    //初始化地图
    [self setGMap];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    
    //获取用户当前经纬度
//    GMAPI *aaa =[GMAPI sharedManager];
//    aaa.delegate = self;
//    [aaa startDingwei];
    
    __weak typeof(self)weakSelf = self;
    
    [[GMAPI appDeledate] startDingweiWithBlock:^(NSDictionary *dic) {
        
        [weakSelf addPointAnnotationWithDic:dic];
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"位置" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(100, 100, 100, 100)];
    [btn addTarget:self action:@selector(onClickReverseGeocode) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}



- (void)theLocationDictionary:(NSDictionary *)dic{
    [self addPointAnnotationWithDic:dic];
}


-(void)rightButtonTap:(UIButton *) sender{
    
    
    NSLog(@"%f,%f",_newAnnotation.annotation.coordinate.latitude,_newAnnotation.annotation.coordinate.longitude);
    
    _location_y = _newAnnotation.annotation.coordinate.latitude;
    _location_x = _newAnnotation.annotation.coordinate.longitude;
    
    [self onClickReverseGeocode];
    
    
}


#pragma mark - 初始化地图
-(void)setGMap{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 18;
    [self.view addSubview:_mapView];

    
    
    NSLog(@"%f,%f",_newAnnotation.annotation.coordinate.latitude,_newAnnotation.annotation.coordinate.longitude);
}



//添加标注
- (void)addPointAnnotationWithDic:(NSDictionary *)dic
{
    _pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = [[dic stringValueForKey:@"lat"]floatValue];
    coor.longitude = [[dic stringValueForKey:@"long"]floatValue];
    _pointAnnotation.coordinate = coor;
    _pointAnnotation.title = @"test";
    _pointAnnotation.subtitle = @"此Annotation可拖拽!";
    _mapView.centerCoordinate = coor;
    [_mapView addAnnotation:_pointAnnotation];
    
    
}




#pragma mark -
#pragma mark implement BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    if (_newAnnotation == nil) {
        _newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        ((BMKPinAnnotationView*)_newAnnotation).pinColor = BMKPinAnnotationColorPurple;
//        // 从天上掉下效果
//        ((BMKPinAnnotationView*)_newAnnotation).animatesDrop = YES;
        // 设置可拖拽
        ((BMKPinAnnotationView*)_newAnnotation).draggable = YES;
    }
    
    return _newAnnotation;
    
}




-(void)onClickReverseGeocode
{
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (_location_x && _location_y) {
        pt = (CLLocationCoordinate2D){_location_y, _location_x };
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    
    [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
}


- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    
    NSLog(@"%@",result);
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    
    if (error == 0) {
        CLLocationCoordinate2D ccc = result.location;
        NSString* titleStr = @"地址";
        NSString* showmeg = result.address;
        self.delegate3.text = @"已选择";
        self.delegate.text = showmeg;
        self.delegate2.location_jingpindian = ccc;
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        myAlertView.delegate = self;
        [myAlertView show];
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
