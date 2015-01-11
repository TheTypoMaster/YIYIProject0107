//
//  GLeadBuyMapViewController.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface GLeadBuyMapViewController : MyViewController


//地图上标注的信息字典
@property(nonatomic,strong)NSDictionary *dataDic;

//商城名
@property(nonatomic,strong)NSString *storeName;


//产品model,包含坐标、name等所有信息
@property(nonatomic,retain)ProductModel *aModel;



@end
