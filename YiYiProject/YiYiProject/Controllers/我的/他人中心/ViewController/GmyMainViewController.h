//
//  GmyMainViewController.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//


//我的主页 别人的主页

#import <UIKit/UIKit.h>

typedef enum{
    G_Default = 0, //自己
    G_Other = 1, //他人
}GmainViewType;

#import "WaterF.h"
#import "ParallaxHeaderView.h"

@interface GmyMainViewController : MyViewController<UIScrollViewDelegate>


@property(nonatomic,assign)GmainViewType userType;//类型  自己的 别人的

@property(nonatomic,retain)NSString *userId;//用户id

@property (nonatomic,strong) NSString *bannerUrl;
@property (nonatomic,strong) NSString *headImageUrl;
@end
