//
//  GMAPI.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/13.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>
//是否上传本地用户banner 头像
#define ISUPUSERBANNER @"gIsUpBanner"
#define ISUPUSERFACE @"gIsUpFace"
//代码屏幕适配（设计图为320*568）
#define GscreenRatio_320 DEVICE_WIDTH/320.00
#import "BMapKit.h"

typedef void(^ GCllocationBlock)(CLLocation *theLocation);


@interface GMAPI : NSObject<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKLocationService* _locService;//定位服务
    CLLocation *_theCllocation;//经纬度
    GCllocationBlock gcllocationBlock;
}

+(NSString *)getUsername;


+(NSString *)getDeviceToken;

+(NSString *)getAuthkey;

+(NSString *)getUid;

+(NSString *)getUserPassWord;

+ (NSString *)getUerHeadImageUrl;//头像url


+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView;


//写数据=========================

//保存用户banner到本地
+(BOOL)setUserBannerImageWithData:(NSData *)data;

//保存用户头像到本地
+(BOOL)setUserFaceImageWithData:(NSData *)data;



//获取document路径
+ (NSString *)documentFolder;


//读数据=========================

//获取用户bannerImage
+(UIImage *)getUserBannerImage;

//获取用户头像Image
+(UIImage *)getUserFaceImage;


//获取document路径
+ (NSString *)documentFolder;

//清除banner和头像
+(BOOL)cleanUserFaceAndBanner;

//在userdefaul里设置是否上传banner标志位为yes
+(void)setUpUserBannerYes;
//在userdefaul里设置是否上传banner标志位为no
+(void)setUpUserBannerNo;
//在userdefaul里设置是否上传头像标志位为yes
+(void)setUpUserFaceYes;
//在userdefaul里设置是否上传头像标志位为no
+(void)setUpUserFaceNo;



//NSUserDefault 缓存
//存
+ (void)cache:(id)dataInfo ForKey:(NSString *)key;
//取
+ (id)cacheForKey:(NSString *)key;






//信息处理
+(NSString *)exchangeStringForDeleteNULL:(id)sender;



//地图相关
//获取经纬度
- (void)GgetCllocation:(void(^)(CLLocation *theLocation))completionBlock;





@end
