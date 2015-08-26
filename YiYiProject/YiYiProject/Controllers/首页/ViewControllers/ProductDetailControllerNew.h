//
//  ProductDetailControllerNew.h
//  YiYiProject
//
//  Created by lichaowei on 15/8/11.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyViewController.h"

@class TMPhotoQuiltViewCell;
@class ProductModel;

typedef void(^ViewDidDisappearBlock)(BOOL success);//消失block

@interface ProductDetailControllerNew : MyViewController

@property(nonatomic,assign)ViewDidDisappearBlock disappearBlock;

@property (nonatomic,retain)NSString *product_id;//产品id
@property(nonatomic,strong)NSString *gShop_id;//商家id

@property(nonatomic,assign)BOOL isPresent;//是否是模态出来得

@property(nonatomic,assign)BOOL isYYChatVcPush;//是否从聊天界面push过来的

@property(nonatomic,assign)BOOL isChooseProductLink;//是否为发布T台商品链接

@property(nonatomic,assign)BOOL isTPlatPush;//是否是t台过来


//用于修改赞的状态

//从我的店铺页面跳转过来的时候这两个属性会有  取消赞之后返回上级页面更新界面数据
@property(nonatomic,retain)TMPhotoQuiltViewCell *theLastViewClickedCell;//上一个界面需要更改点赞状态的自定义cell
@property(nonatomic,retain)ProductModel *theLastViewProductModel;//上一个界面的数据源

@end
