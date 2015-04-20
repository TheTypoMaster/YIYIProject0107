//
//  TTaiBigPhotoCell2.h
//  YiYiProject
//
//  Created by lichaowei on 15/4/20.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyImageView.h"

@interface TTaiBigPhotoCell2 : UITableViewCell
@property (strong, nonatomic) IBOutlet PropertyImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIView *toolView;

- (void)setCellWithModel:(id)aModel;

@end
