//
//  MySettingsViewController.h
//  YiYiProject
//
//  Created by 王龙 on 15/1/1.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyViewController.h"

@interface MySettingsViewController : MyViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataArray;  //数据源
    
    NSString *catchSize;   //缓存
    
}
@property (strong, nonatomic) IBOutlet UITableView *mTableVIew;
@end
