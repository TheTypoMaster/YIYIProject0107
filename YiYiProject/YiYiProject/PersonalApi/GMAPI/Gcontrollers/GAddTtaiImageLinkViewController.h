//
//  GAddTtaiImageLinkViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/4/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//添加T台商品链接

#import <UIKit/UIKit.h>
#import "TPlatModel.h"
@class GTTPublishViewController;

@interface GAddTtaiImageLinkViewController : MyViewController

@property(nonatomic,strong)UIImage *theImage;//需要显示的图片
@property(nonatomic,assign)BOOL editStyle;//添加锚点编辑状态 为no的时候才能再次添加锚点

@property(nonatomic,strong)NSMutableArray *maodianArray;//锚点数组

//上传相关
@property(nonatomic,strong)NSDictionary *maodianDic;//锚点信息dic
@property(nonatomic,assign)GTTPublishViewController *delegate;


//编辑T台相关
@property(nonatomic,strong)TPlatModel *theTtaiModel;//判断是否为编辑T台
@property(nonatomic,assign)BOOL isFirst;//是编辑T台进来先把锚点加上


//判断是否添加完锚点后再次进入
@property(nonatomic,assign)BOOL isAgainIn;




//设置锚点的商品id和shopid
-(void)setGmoveImvProductId:(NSString *)productId shopid:(NSString*)theShopId productName:(NSString *)theProductName shopName:(NSString *)theShopName price:(NSString *)thePrice type:(NSString *)theType;


@end
