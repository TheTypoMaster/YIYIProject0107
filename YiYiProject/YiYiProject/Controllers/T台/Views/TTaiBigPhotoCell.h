//
//  TTaiBigPhotoCell.h
//  YiYiProject
//
//  Created by lichaowei on 15/4/20.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyImageView.h"

@interface TTaiBigPhotoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet PropertyImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UIView *toolsView;

@property (strong, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *zanNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *zanButton;

- (void)setCellWithModel:(id)aModel;

@end
