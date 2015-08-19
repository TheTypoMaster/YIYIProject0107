//
//  GTtaiListViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/8/12.
//  Copyright (c) 2015年 lcw. All rights reserved.
//



//首页T台列表

#import "MyViewController.h"

@interface GTtaiListViewController : MyViewController



@property(nonatomic,strong)NSDictionary *locationDic;//定位信息dic


#pragma mark---锚点的点击方法
//到商场的
-(void)turnToShangChangInfoId:(NSString *)infoId
                     infoName:(NSString *)infoName
                     shopType:(ShopType)shopType;
//到单品的
-(void)turnToDanPinInfoId:(NSString *)infoId
                 infoName:(NSString *)infoName;


@end
