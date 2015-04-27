//
//  WaterFCell.h
//  CollectionView
//
//  Created by d2space on 14-2-26.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPlatModel.h"
@interface WaterFCell : UICollectionViewCell


@property(nonatomic,retain)UIView *backGroudView;//背景view


//图片部分
@property (nonatomic, retain) UIImageView *photoView;//大图
@property(nonatomic,retain)UIView *timeView;//存放 店铺名、距离
@property(nonatomic,retain)UILabel *timeLabel;//存放 店铺名、距离

//评论喜欢 背景view
@property(nonatomic,retain)UIView *infoView;//评论 和 喜欢按钮

@property(nonatomic,retain)UIButton *comment_btn;//评论标识
@property(nonatomic,retain)UILabel *comment_label;//评论数量
@property(nonatomic,retain)UIButton *like_btn;//喜欢标识
@property(nonatomic,retain)UILabel *like_label;//喜欢数量

- (void)setCellWithModel:(TPlatModel *)aModel;






@end
