//
//  AppDelegate.h
//  YiYiProject
//
//  Created by lichaowei on 14/12/10.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LocationBlock)(NSDictionary *dic);//获取坐标block

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign)UITabBarController *rootViewController;

@property(nonatomic,retain)NSDictionary *remote_message;//推送消息

#pragma mark - 获取坐标

- (void)startDingweiWithBlock:(LocationBlock)location;

/**
 *  根据坐标获取位置详细信息
 */
- (void)getAddressDetailWithLontitud:(CGFloat)longtitude
                            latitude:(CGFloat)latitude
                        addressBlock:(LocationBlock)addressBlock;


//登录融云
- (void)loginToRongCloud;

@end

