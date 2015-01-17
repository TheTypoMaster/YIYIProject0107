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

@end

