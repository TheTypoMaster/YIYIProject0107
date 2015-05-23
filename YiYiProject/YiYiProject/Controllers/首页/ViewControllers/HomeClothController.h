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




//跳转到附近的商场界面   type 2 精品店   type 1商场店
-(void)pushToNearbyStoreVCWithIdStr:(NSString *)theID theStoreName:(NSString *)nameStr theType:(NSString *)mallType;


@end
