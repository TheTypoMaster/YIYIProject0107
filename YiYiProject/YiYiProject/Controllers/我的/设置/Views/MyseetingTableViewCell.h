//
//  MyseetingTableViewCell.h
//  YiYiProject
//
//  Created by 王龙 on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyseetingTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;  //内容

@property (strong, nonatomic) IBOutlet UILabel *secondLabel;  //显示缓存大小的
@property (strong, nonatomic) IBOutlet UIImageView *haveNewVersionView; //显示是否有新版本
@end
