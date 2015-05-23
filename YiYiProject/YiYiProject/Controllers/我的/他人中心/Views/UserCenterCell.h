//
//  UserCenterCell.h
//  YiYiProject
//
//  Created by lichaowei on 15/5/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) IBOutlet UIView *fansView;//粉丝背景view
@property (strong, nonatomic) IBOutlet UILabel *fansNumLabel;//粉丝数label

@property (strong, nonatomic) IBOutlet UIView *concernView;//关注背景view
@property (strong, nonatomic) IBOutlet UILabel *concernNumLabel;//关注数label

@property (strong, nonatomic) IBOutlet UIButton *tPlatButton;//t台
@property (strong, nonatomic) IBOutlet UIButton *collectionButton;//收藏
@property (strong, nonatomic) IBOutlet UIButton *shopButton;//商家
@property (strong, nonatomic) IBOutlet UIButton *concernButton;//关注按钮

@property (strong, nonatomic) IBOutlet UIButton *chatButton;//聊天按钮
@property (strong, nonatomic) IBOutlet UIImageView *jianTouImageView;
@property (strong, nonatomic) IBOutlet UIView *toolsView;
@property (strong, nonatomic) IBOutlet UIView *chatAndConcernView;




@end
