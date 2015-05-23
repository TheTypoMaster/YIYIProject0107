//
//  TPlatCell.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "TMQuiltViewCell.h"
#import "TPlatModel.h"
/**
 *  T 台cell
 */
@interface TPlatCell : TMQuiltViewCell

@property(nonatomic,retain)UIView *backGroudView;//背景view

//用户信息部分
@property(nonatomic,retain)UIView *headBgView;//用户信息view
@property (nonatomic, retain) UIImageView *iconImageView;//头像
@property (nonatomic, retain) UILabel *userNameLabel;//用户名
@property (nonatomic, retain) UILabel *timeLabel;//时间

//图片部分
@property (nonatomic, retain) UIImageView *photoView;//大图

//评论喜欢 背景view
@property(nonatomic,retain)UIView *infoView;//评论 和 喜欢按钮

@property(nonatomic,retain)UIButton *comment_btn;//评论标识
@property(nonatomic,retain)UILabel *comment_label;//评论数量
@property(nonatomic,retain)UIButton *like_btn;//喜欢标识
@property(nonatomic,retain)UILabel *like_label;//喜欢数量

@property (nonatomic,assign)BOOL needIconImage;//是否需要显示头像

- (void)setCellWithModel:(TPlatModel *)aModel;


@end
