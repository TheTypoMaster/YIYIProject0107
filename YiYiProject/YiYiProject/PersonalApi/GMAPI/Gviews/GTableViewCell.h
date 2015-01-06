//
//  GTableViewCell.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/13.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMAPI.h"

typedef enum{
    GPERSON= 0,//个人中心
}GCELLTYPE;

@interface GTableViewCell : UITableViewCell


-(void)creatCustomViewWithGcellType:(GCELLTYPE)theType indexPath:(NSIndexPath*)theIndexPath customObject:(id)theInfo;


@end
