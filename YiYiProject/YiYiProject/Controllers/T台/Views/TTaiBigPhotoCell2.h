//
//  TTaiBigPhotoCell2.h
//  YiYiProject
//
//  Created by lichaowei on 15/4/20.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyImageView.h"

#import "PulsingHaloLayer.h"//动画

@interface TTaiBigPhotoCell2 : UITableViewCell
@property (strong, nonatomic) IBOutlet PropertyImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIView *toolView;

@property (nonatomic,retain) UIView *maoDianView;//锚点view

@property (nonatomic, strong) PulsingHaloLayer *halo;//动画layer
@property (strong, nonatomic) IBOutlet UIButton *zanBtn;
@property (strong, nonatomic) IBOutlet UIView *zanBackView;


- (void)setCellWithModel:(id)aModel;

@end
