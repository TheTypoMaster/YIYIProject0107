//
//  TTaiCommentViewController.h
//  YiYiProject
//
//  Created by lichaowei on 15/4/21.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyViewController.h"
#import "TPlatModel.h"
#import "ProductModel.h"
typedef enum
{
    COMMENTTYPE_TPlat = 0, //t台评论
    COMMENTTYPE_Product = 1 //单品评论
    
}COMMENTTYPE;
@interface TTaiCommentViewController : MyViewController

@property(nonatomic,retain)NSString *tt_id;//t台信息id
@property(nonatomic,assign)COMMENTTYPE commentType;//评论类型

@property(nonatomic,assign)TPlatModel *t_model;//上一页model
@property(nonatomic,assign)ProductModel *aProduct;//单品评论时传单品model

@end
