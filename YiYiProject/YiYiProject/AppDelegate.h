//
//  AppDelegate.h
//  YiYiProject
//
//  Created by lichaowei on 14/12/10.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign)UITabBarController *rootViewController;

@property(nonatomic,retain)NSDictionary *remote_message;//推送消息

- (void)rondCloudDefaultLogin;//融云登录

@end

