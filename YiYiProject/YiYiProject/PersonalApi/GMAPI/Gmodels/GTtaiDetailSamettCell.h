//
//  GTtaiDetailSamettCell.h
//  YiYiProject
//
//  Created by gaomeng on 15/8/24.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "PSCollectionViewCell.h"
@class ButtonProperty;


//T台详情T台同款推荐

@interface GTtaiDetailSamettCell : PSCollectionViewCell


@property(nonatomic,retain)UIView *backGroudView;//背景view

@property (nonatomic, retain) UIImageView *photoView;

@property(nonatomic,retain)ButtonProperty *likeBackBtn;//喜欢的背景大button
@property(nonatomic,retain)UIButton *like_btn;//喜欢标识
@property(nonatomic,retain)UILabel *like_label;//喜欢数量



-(void)loadCustomViewWithModel:(id)theModel;

@end
