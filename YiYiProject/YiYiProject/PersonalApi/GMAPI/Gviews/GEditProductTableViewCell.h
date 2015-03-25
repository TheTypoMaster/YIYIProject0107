//
//  GEditProductTableViewCell.h
//  YiYiProject
//
//  Created by gaomeng on 15/3/25.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@class GmyproductsListViewController;

@interface GEditProductTableViewCell : UITableViewCell


@property(nonatomic,assign)GmyproductsListViewController *delegate;

-(void)loadCustomViewWithData:(ProductModel*)aModel indexpath:(NSIndexPath*)theIndexPath withType:(int)thetype;



@end
