//
//  ShenQingDianPuViewController.h
//  YiYiProject
//
//  Created by szk on 15/1/5.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyCollectionController.h"

@interface ShenQingDianPuViewController : MyViewController<UITextFieldDelegate>

@property(nonatomic,strong)NSMutableArray *shuruTextFieldArray;//精品店数组
@property(nonatomic,strong)NSMutableArray *chooseLabelArray;//商场商店
@property(nonatomic,strong)NSMutableArray *chooseTextFieldArray;//商场店textfield

@property(nonatomic,strong)NSString *mallId;//商场id


@property(nonatomic,strong)NSString *floor;//楼层
@property(nonatomic,strong)NSString *pinpai;//品牌
@property(nonatomic,strong)NSString *pinpaiId;//品牌id



@property(nonatomic,assign)CLLocationCoordinate2D location_jingpindian;//精品店经纬度


@end

