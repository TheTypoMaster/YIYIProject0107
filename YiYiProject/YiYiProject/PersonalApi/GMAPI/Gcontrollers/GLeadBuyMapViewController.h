//
//  GLeadBuyMapViewController.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

typedef enum{
    LEADYOUTYPE_STORE = 0,
    LEADYOUTYPE_CHANPIN,
}LEADYOUTYPE;


@interface GLeadBuyMapViewController : MyViewController


//地图上标注的信息字典
@property(nonatomic,strong)NSDictionary *dataDic;

//商城相关
@property(nonatomic,strong)NSString *storeName;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate_store;


//产品相关
@property(nonatomic,strong)NSString *chanpinName;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate_chanpin;



//产品model,包含坐标、name等所有信息
@property(nonatomic,retain)ProductModel *aModel;

@property(nonatomic,assign)LEADYOUTYPE theType;





@end
