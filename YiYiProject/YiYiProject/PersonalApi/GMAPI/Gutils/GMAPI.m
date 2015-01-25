//
//  GMAPI.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/13.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GMAPI.h"
#import "DataBase.h"
#import "FBCity.h"

//RBG color
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HUDBACKGOUNDCOLOR  RGBA(0, 0, 0, 0.6)
#define HUDFOREGROUNDCOLOR  RGBA(255, 255, 255, 1)
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


+ (NSString *)getDocumentFolderPath{
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

+ (GMAPI *)sharedManager
{
    static GMAPI *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (void)GgetCllocation:(void(^)(CLLocation *theLocation))completionBlock{
    _theLocationDic = nil;
    [self startLocation];
    if (_theLocationDic) {
        gcllocationBlock(_theLocationDic);
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
        _theLocationDic = @{
                            @"lat":[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude],
                            @"long":[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude]
                            };
        [self stopLocation];
    }
    
}



+ (void)showAutoHiddenMBProgressWithText:(NSString *)text addToView:(UIView *)aView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}


+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 0.0f;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}





#pragma mark--------------------------------提示层

#pragma mark - HUD Metod  提示层

+(void)showProgressHasMask:(BOOL)ismask
{
    [SVProgressHUD setBackgroundColor:HUDBACKGOUNDCOLOR];
    [SVProgressHUD setForegroundColor:HUDFOREGROUNDCOLOR];
    [SVProgressHUD setDefaultMaskType:(ismask==YES?SVProgressHUDMaskTypeClear:SVProgressHUDMaskTypeNone)];
    [SVProgressHUD show];
}

+(void)showProgressWithText:(NSString *)string hasMask:(BOOL)ismask
{
    [SVProgressHUD setBackgroundColor:HUDBACKGOUNDCOLOR];
    [SVProgressHUD setForegroundColor:HUDFOREGROUNDCOLOR];
    [SVProgressHUD setDefaultMaskType:(ismask==YES?SVProgressHUDMaskTypeClear:SVProgressHUDMaskTypeNone)];
    [SVProgressHUD showWithStatus:string];
}

+(void)showProgressText:(NSString *)string hasMask:(BOOL)ismask
{
    [SVProgressHUD setBackgroundColor:HUDBACKGOUNDCOLOR];
    [SVProgressHUD setForegroundColor:HUDFOREGROUNDCOLOR];
    [SVProgressHUD setDefaultMaskType:(ismask==YES?SVProgressHUDMaskTypeClear:SVProgressHUDMaskTypeNone)];
    [SVProgressHUD showImage:nil status:string];
}

+(void)showSuccessProgessWithText:(NSString *)string hasMask:(BOOL)ismask
{
    [SVProgressHUD setBackgroundColor:HUDBACKGOUNDCOLOR];
    [SVProgressHUD setForegroundColor:HUDFOREGROUNDCOLOR];
    [SVProgressHUD setDefaultMaskType:(ismask==YES?SVProgressHUDMaskTypeClear:SVProgressHUDMaskTypeNone)];
    [SVProgressHUD showSuccessWithStatus:string];
}

+(void)showFailProgessWithText:(NSString *)string hasMask:(BOOL)ismask
{
    [SVProgressHUD setBackgroundColor:HUDBACKGOUNDCOLOR];
    [SVProgressHUD setForegroundColor:HUDFOREGROUNDCOLOR];
    [SVProgressHUD setDefaultMaskType:(ismask==YES?SVProgressHUDMaskTypeClear:SVProgressHUDMaskTypeNone)];
    [SVProgressHUD showErrorWithStatus:string];
}

+(void)showCustomProgessWithImage:(UIImage *)image andText:(NSString *)string hasMask:(BOOL)ismask
{
    [SVProgressHUD setBackgroundColor:HUDBACKGOUNDCOLOR];
    [SVProgressHUD setForegroundColor:HUDFOREGROUNDCOLOR];
    [SVProgressHUD setDefaultMaskType:(ismask==YES?SVProgressHUDMaskTypeClear:SVProgressHUDMaskTypeNone)];
    [SVProgressHUD showImage:image status:string];
}

+(void)hiddenProgress
{
    [SVProgressHUD dismiss];
}
//地区相关
+ (NSArray *)getSubCityWithProvinceId:(int)privinceId
{
    //打开数据库
    sqlite3 *db = [DataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from area where provinceId = ? and isProvince = 0", -1, &stmt, nil);
    NSLog(@"All subcities result = %d",result);
    NSMutableArray *subCityArray = [NSMutableArray arrayWithCapacity:1];
    if (result == SQLITE_OK) {
        
        sqlite3_bind_int(stmt, 1, privinceId);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *cityName = sqlite3_column_text(stmt, 0);
            int cityId = sqlite3_column_int(stmt, 1);
            int provinceId = sqlite3_column_int(stmt, 3);
            
            FBCity *province = [[FBCity alloc]initSubcityWithName:[NSString stringWithUTF8String:(const char *)cityName] cityId:cityId provinceId:provinceId];
            [subCityArray addObject:province];
        }
    }
    sqlite3_finalize(stmt);
    return subCityArray;
    
}


+ (NSArray *)getAllProvince
{
    //打开数据库
    sqlite3 *db = [DataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from area where isProvince = 1", -1, &stmt, nil);
    NSLog(@"All subcities result = %d",result);
    NSMutableArray *subCityArray = [NSMutableArray arrayWithCapacity:1];
    if (result == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *cityName = sqlite3_column_text(stmt, 0);
            int cityId = sqlite3_column_int(stmt, 1);
            FBCity *province = [[FBCity alloc]initProvinceWithName:[NSString stringWithUTF8String:(const char *)cityName] provinceId:cityId];
            [subCityArray addObject:province];
        }
    }
    sqlite3_finalize(stmt);
    return subCityArray;
    
}

+ (NSString *)cityNameForId:(int)cityId
{
    //打开数据库
    sqlite3 *db = [DataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from area where id = ?", -1, &stmt, nil);
    
    NSLog(@"All subcities result = %d %d",result,cityId);
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_int(stmt, 1, cityId);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            
            const unsigned char *cityName = sqlite3_column_text(stmt, 0);
            
            return [NSString stringWithUTF8String:(const char *)cityName];
        }
    }
    sqlite3_finalize(stmt);
    return @"";
}

+ (int)cityIdForName:(NSString *)cityName//根据城市名获取id
{
    //打开数据库
    sqlite3 *db = [DataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from area where name = ?", -1, &stmt, nil);
    
    NSLog(@"All subcities result = %d %@",result,cityName);
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [cityName UTF8String], -1, nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            
            int cityId = sqlite3_column_int(stmt, 1);
            
            return cityId;
        }
    }
    sqlite3_finalize(stmt);
    return 0;
}



+(NSString*)getTimeWithDate:(NSDate*)theDate{
    //获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *theTime = [formatter stringFromDate:theDate];
    return theTime;
}




@end
