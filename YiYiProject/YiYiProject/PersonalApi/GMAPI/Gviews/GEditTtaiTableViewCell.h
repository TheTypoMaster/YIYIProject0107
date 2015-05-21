//
//  GEditTtaiTableViewCell.h
//  YiYiProject
//
//  Created by gaomeng on 15/5/19.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//编辑T台自定义cell

#import <UIKit/UIKit.h>
#import "TPlatModel.h"
@class GEditMyTtaiViewController;

@interface GEditTtaiTableViewCell : UITableViewCell

@property(nonatomic,assign)GEditMyTtaiViewController *delegate;

-(void)loadCustomViewWithData:(TPlatModel*)aModel indexpath:(NSIndexPath*)theIndexPath withType:(int)thetype;

@end
