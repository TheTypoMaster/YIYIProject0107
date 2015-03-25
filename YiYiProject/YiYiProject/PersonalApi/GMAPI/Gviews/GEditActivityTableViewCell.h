//
//  GEditActivityTableViewCell.h
//  YiYiProject
//
//  Created by gaomeng on 15/3/25.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActivityModel.h"

@class GmyActivetiesViewController;

@interface GEditActivityTableViewCell : UITableViewCell



@property(nonatomic,assign)GmyActivetiesViewController *delegate;

-(void)loadCustomViewWithData:(ActivityModel*)aModel indexpath:(NSIndexPath*)theIndexPath;


@end
