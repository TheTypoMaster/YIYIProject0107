//
//  GMAPI.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/13.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GMAPI.h"

@implementation GMAPI

//获取用户的devicetoken

+(NSString *)getDeviceToken{
    
    NSString *str_devicetoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_DEVICE_TOKEN]];
    return str_devicetoken;
    
    
}

//获取用户名
+(NSString *)getUsername{
    
    NSString *str_devicetoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_NAME]];
    if ([str_devicetoken isEqualToString:@"(null)"]) {
        str_devicetoken=@"";
    }
    return str_devicetoken;
    
    
}

//获取authkey
+(NSString *)getAuthkey{
    
    NSString *str_authkey=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]];

    if (str_authkey.length==0) {
        str_authkey=[NSString stringWithFormat:@"failtogetauthkey"];
    }
    

    
    if (str_authkey.length == 0 || [str_authkey isEqualToString:@"(null)"]) {
        return @"";
    }
    return str_authkey;
    
}


//获取用户id
+(NSString *)getUid{
    
    NSString *str_uid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_UID]];
    return str_uid;
    
}


//获取用户密码
+(NSString *)getUserPassWord{
    NSString *str_password = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_PWD]];
    return str_password;
}

//头像url
+ (NSString *)getUerHeadImageUrl
{
    NSString *url = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_HEAD_IMAGEURL]];
    return url;
}

#pragma mark - 弹出提示框
+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 0.0f;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}


//把用户bannerImage写到本地
+(BOOL)setUserBannerImageWithData:(NSData *)data{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathD = paths[0];
    
    NSString *userBannerName = @"/guserBannerImage.png";
    
    NSString *path = [pathD stringByAppendingString:userBannerName];
    
    NSLog(@"%@",path);
    
    
    BOOL is = [data writeToFile:path atomically:YES];
    
    NSLog(@"%d",is);
    
    if (is) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
        
    }
    
    return is;
}

//把用户头像image写到本地
+(BOOL)setUserFaceImageWithData:(NSData *)data{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathD = paths[0];
    
    NSString *userFaceName = @"/guserFaceImage.png";
    
    NSString *path = [pathD stringByAppendingString:userFaceName];
    
    NSLog(@"%@",path);
    
    BOOL is = [data writeToFile:path atomically:YES];
    NSLog(@"%d",is);
    
    if (is) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
    }
    
    
    return is;
}

//读数据=============================================


//获取banner
+(UIImage *)getUserBannerImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathD = paths[0];
    NSString *userBannerName = @"/guserBannerImage.png";
    NSString *path = [pathD stringByAppendingString:userBannerName];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

//获取faceImage
+(UIImage *)getUserFaceImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathD = paths[0];
    NSString *userFaceName = @"/guserFaceImage.png";
    NSString *path = [pathD stringByAppendingString:userFaceName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}



+(BOOL)cleanUserFaceAndBanner{
    //上传标志位
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"gIsUpBanner"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"gIsUpFace"];
    
    
    
    //document路径
    NSString *documentPathStr = [GMAPI documentFolder];
    NSString *userFace = @"/guserFaceImage.png";
    NSString *userBanner = @"/guserBannerImage.png";
    
    
    //文件管理器
    NSFileManager *fileM = [NSFileManager defaultManager];
    
    //清除 头像和 banner
    
    BOOL isCleanUserFaceSuccess = NO;
    BOOL isCleanUserBannerSuccess = NO;
    BOOL isSuccess = NO;
    isCleanUserFaceSuccess = [fileM removeItemAtPath:[documentPathStr stringByAppendingString:userFace] error:nil];
    isCleanUserBannerSuccess = [fileM removeItemAtPath:[documentPathStr stringByAppendingString:userBanner] error:nil];
    if (isCleanUserFaceSuccess && isCleanUserBannerSuccess) {
        isSuccess = YES;
    }
    
    return isSuccess;
}


+ (NSString *)documentFolder{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}


+(void)setUpUserBannerYes{
    NSString *str = @"yes";
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:ISUPUSERBANNER];
}

+(void)setUpUserBannerNo{
    NSString *str = @"no";
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:ISUPUSERBANNER];
}

+(void)setUpUserFaceYes{
    NSString *str = @"yes";
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:ISUPUSERFACE];
}
+(void)setUpUserFaceNo{
    NSString *str = @"no";
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:ISUPUSERFACE];
}


#pragma mark - NSUserDefault缓存
//存
+ (void)cache:(id)dataInfo ForKey:(NSString *)key
{
    NSLog(@"key===%@",key);
    @try {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dataInfo forKey:key];
        [defaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"exception %@",exception);
    }
    @finally {
    }
}

//取
+ (id)cacheForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}








//信息处理
+(NSString *)exchangeStringForDeleteNULL:(id)sender
{
    NSString * temp = [NSString stringWithFormat:@"%@",sender];
    
    if (temp.length == 0 || [temp isEqualToString:@"<null>"] || [temp isEqualToString:@"null"] || [temp isEqualToString:@"(null)"])
    {
        temp = @"暂无";
    }
    
    return temp;
}





//地图相关

- (void)GgetCllocation:(void(^)(CLLocation *theLocation))completionBlock{
    _theCllocation = nil;
    [self startLocation];
    if (_theCllocation) {
        gcllocationBlock(_theCllocation);
    }
}

///开始定位
-(void)startLocation{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
}

///停止定位
-(void)stopLocation{
    [_locService stopUserLocationService];
    if (_locService) {
        _locService = nil;
    }
}

//用户位置更新后，会调用此函数
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if (userLocation) {
        _theCllocation = userLocation.location;
        [self stopLocation];
    }
    
}





@end
