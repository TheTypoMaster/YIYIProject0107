//
//  GupClothesViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/1/18.
//  Copyright (c) 2015年 lcw. All rights reserved.
//




//店主上传衣服

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface GupClothesViewController : MyViewController
{
    UIScrollView *_mainScrollView;//主scrollview
    
}


@property(nonatomic,strong)UserInfo *userInfo;


@end
