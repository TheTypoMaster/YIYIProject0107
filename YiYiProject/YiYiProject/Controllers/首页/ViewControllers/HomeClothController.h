//
//  HomeClothViewController.h
//  YiYiProject
//
//  Created by lichaowei on 14/12/12.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  衣 + 衣
 */
@interface HomeClothController : UIViewController

@property(nonatomic,assign)UIViewController *rootViewController;


//跳转到品牌详细界面
-(void)pushToPinpaiDetailVCWithIdStr:(NSString *)theID pinpaiName:(NSString *)theName;


//跳转到附近的商场界面
-(void)pushToNearbyStoreVCWithIdStr:(NSString *)theID theStoreName:(NSString *)nameStr;


@end
