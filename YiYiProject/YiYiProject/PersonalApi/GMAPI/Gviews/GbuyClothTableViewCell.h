//
//  GbuyClothTableViewCell.h
//  YiYiProject
//
//  Created by gaomeng on 15/6/27.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

/**
 *  买衣日志自定义cell
 */
#import <UIKit/UIKit.h>
#import "GBuyClothLogModel.h"
@interface GbuyClothTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *timeLabel;

-(void)loadCustomCellWithModel:(GBuyClothLogModel*)theModel;

@end
