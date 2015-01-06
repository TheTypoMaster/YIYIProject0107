//
//  ShopViewCell.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandModel.h"
/**
 *  品牌 -- cell
 */
@interface BrandViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

- (void)setCellWithModel:(BrandModel *)aModel;

@end
