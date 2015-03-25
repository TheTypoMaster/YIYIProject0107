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
#import "MailInfoModel.h"
#import "ProductModel.h"

typedef enum{
    GUPCLOTH = 0,
    GEDITCLOTH
}GUPCLOTHTYPE;

@interface GupClothesViewController : MyViewController
{
    UIScrollView *_mainScrollView;//主scrollview
    
}


@property(nonatomic,strong)UserInfo *userInfo;//用户信息
@property(nonatomic,strong)MailInfoModel *mallInfo;//店铺信息


//选择图片相关
@property (nonatomic, strong) NSMutableArray   *assetsArray;
@property(nonatomic,strong)NSMutableArray *uploadImageArray;

//修改衣服
@property(nonatomic,assign)GUPCLOTHTYPE thetype;
@property(nonatomic,strong)ProductModel *theEditProduct;
@property(nonatomic,strong)NSMutableArray *oldImageArray;


-(id)initWithType:(GUPCLOTHTYPE)theType editProduct:(ProductModel*)theModel;

@end
