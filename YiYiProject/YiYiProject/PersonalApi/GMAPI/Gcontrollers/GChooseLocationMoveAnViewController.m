//
//  GChooseLocationMoveAnViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GChooseLocationMoveAnViewController.h"
#import "BMapKit.h"
#import "ShenQingDianPuViewController.h"
#import "GMAPI.h"
#import "NSDictionary+GJson.h"

@interface GChooseLocationMoveAnViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,GgetllocationDelegate>
{
    BMKMapView* _mapView;//地图
    BMKPointAnnotation* _pointAnnotation;
    BMKAnnotationView* _newAnnotation;
    CGFloat _location_x;
    CGFloat _location_y;
    BMKGeoCodeSearch* _geocodesearch;
    
    UIButton *_button_right;
    
}

@end

@implementation GChooseLocationMoveAnViewController

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
    
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    //导航栏
    UIView *daohangView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 64)];
    daohangView.backgroundColor = [UIColor whiteColor];
    UIImageView *naviImv = [[UIImageView alloc]initWithFrame:daohangView.bounds];
    [naviImv setImage:[UIImage imageNamed:@"navigationBarBackground.png"]];
    
    [self.view addSubview:daohangView];
    
    //标题
    UILabel *_myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/2.0-100,20,200,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = @"选择地址";
    _myTitleLabel.textColor = RGBCOLOR(252, 76, 139);
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    [daohangView addSubview:_myTitleLabel];
    
    
    //返回按钮
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(20,20,40,44)];
    [button_back addTarget:self action:@selector(leftButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [button_back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [daohangView addSubview:button_back];
    
    //确定按钮
    
    _button_right= [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_right setFrame:CGRectMake(DEVICE_WIDTH-10-10-40,20,40,44)];
    [_button_right addTarget:self action:@selector(rightQuedingBtn) forControlEvents:UIControlEventTouchUpInside];
    [_button_right setTitle:@"确定" forState:UIControlStateNormal];
    [_button_right setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    _button_right.userInteractionEnabled = NO;
    [_button_right setTitleColor:RGBCOLOR(252, 76, 139) forState:(UIControlStateNormal)];
    _button_right.titleLabel.font = [UIFont systemFontOfSize:17];
    [daohangView addSubview:_button_right];
    
    //初始化地图
    [self setGMap];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    
    //获取用户当前经纬度
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


-(void)rightQuedingBtn{
    
    
    NSLog(@"%f,%f",_newAnnotation.annotation.coordinate.latitude,_newAnnotation.annotation.coordinate.longitude);
    
    _location_y = _newAnnotation.annotation.coordinate.latitude;
    _location_x = _newAnnotation.annotation.coordinate.longitude;
    
    [self onClickReverseGeocode];
    
    
}


-(void)leftButtonTap{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - 初始化地图
-(void)setGMap{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
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
    _pointAnnotation.title = @"提示";
    _pointAnnotation.subtitle = @"此标注可拖拽!";
    _mapView.centerCoordinate = coor;
    [_mapView addAnnotation:_pointAnnotation];
    _button_right.userInteractionEnabled = YES;
    
    
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
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        myAlertView.delegate = self;
        [myAlertView show];
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
    }else if (buttonIndex == 1){
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
