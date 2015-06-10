//
//  GRTabView.h
//  YiYiProject
//
//  Created by gaomeng on 15/6/9.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GtopScrollView;
@interface GRTabView : UITableView

@property(nonatomic,strong)NSMutableArray *dataArray;//数据源

@property(nonatomic,strong)GtopScrollView *myTopScrollView;

@end
