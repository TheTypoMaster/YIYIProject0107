//
//  BrandViewCell.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailModel.h"
/**
 *  商家 —— 商城 cell
 */
@interface  ShopViewCell: UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;

- (void)setCellWithModel:(MailModel *)aModel;

@end
