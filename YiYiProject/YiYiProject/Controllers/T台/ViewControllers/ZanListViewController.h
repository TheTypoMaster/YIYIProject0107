//
//  ZanListViewController.h
//  YiYiProject
//
//  Created by lichaowei on 15/5/5.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyViewController.h"
#import "TPlatModel.h"
/**
 *  赞列表人员
 */

typedef enum {
    User_TPlatZanList = 0, //t台赞人员列表
    User_ShopMember = 1, //店铺会员有列表
    User_ConcernList = 2 //关注人员列表
}UserListType;

@interface ZanListViewController : MyViewController

@property(nonatomic,assign)TPlatModel *t_model;

@property(nonatomic,assign)UserListType listType;

@end
