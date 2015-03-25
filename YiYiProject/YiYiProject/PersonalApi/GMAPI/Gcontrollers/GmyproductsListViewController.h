//
//  GmyproductsListViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/3/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//管理产品
#import <UIKit/UIKit.h>
#import "GrefreshTableView.h"
#import "UserInfo.h"
#import "ProductModel.h"
#import "MailInfoModel.h"
@class GEditProductTableViewCell;

typedef enum{
    PILIANGTYPE_NONE = 0,
    PILIANGTYPE_UPDOWN,
    PILIANGTYPE_DELETE
}PILIANGTYPE;

@interface GmyproductsListViewController : MyViewController

@property(nonatomic,retain)UserInfo *userInfo;
@property(nonatomic,strong)MailInfoModel *mallInfo;//店铺信息

@property(nonatomic,assign)NSInteger selectIndex;//100线上产品  101仓库产品


@property(nonatomic,strong)UILabel *numLabel;//记录批量操作时选中了多少个
@property(nonatomic,strong)NSMutableArray *indexes;//记录点击要批量操作的单元格index数组

@property(nonatomic,assign)PILIANGTYPE piliangType;//批量操作的类型

-(void)setDataArrayWithArray:(NSArray *)array;


//cell的回调
-(void)editProductWithTag:(NSInteger)theTag;


@end
