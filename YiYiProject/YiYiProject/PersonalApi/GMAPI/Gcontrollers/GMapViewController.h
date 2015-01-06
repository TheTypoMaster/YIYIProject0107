//
//  GMapViewController.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/13.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface GMapViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView* _mapView;//地图
    BMKLocationService* _locService;//定位服务
    UIButton* _startBtn;//开始按钮
    UIButton* _stopBtn;//结束按钮
    UIButton* _followingBtn;//跟随模式
    UIButton* _followHeadBtn;//罗盘模式
    
}

///开始定位
-(void)startLocation:(UIButton*)sender;

///停止定位
-(void)stopLocation:(UIButton*)sender;

///跟随模式
-(void)startFollowing:(UIButton*)sender;

///罗盘模式
-(void)startFollowHeading:(UIButton*)sender;


@end
