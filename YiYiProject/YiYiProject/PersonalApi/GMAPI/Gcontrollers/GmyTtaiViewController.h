//
//  GmyTtaiViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/5/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//我的T台

#import "MyViewController.h"

@interface GmyTtaiViewController : MyViewController

@property(nonatomic,assign)BOOL isTTaiDetailTagPush;//是否是从T台详情页的标签点击过来的
@property(nonatomic,strong)NSString *tagId;//标签id
@property(nonatomic,strong)NSString *tagName;//标签名称

@end
