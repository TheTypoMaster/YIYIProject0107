//
//  ProductCell.h
//  YiYiProject
//
//  Created by lichaowei on 15/8/18.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

/**
 *  最新版单品cell
 */
#import "PSCollectionViewCell.h"

@interface ProductCell : PSCollectionViewCell

@property(nonatomic,retain)UIView *backGroudView;//背景view

@property (nonatomic, retain) UIImageView *photoView;
@property (nonatomic, retain) UILabel *titleLabel;

@property(nonatomic,retain)UILabel *dianPuName_Label;//店铺名

@property(nonatomic,retain)UIView *infoView;//存放 价格 打折 收藏

@property(nonatomic,retain)UILabel *price_label;//价格
@property(nonatomic,retain)UILabel *discount_label;//打折
@property(nonatomic,retain)UILabel *distance_label;//距离

@property(nonatomic,retain)UIButton *likeBackBtn;//喜欢的背景大button
@property(nonatomic,retain)UIButton *like_btn;//喜欢标识
@property(nonatomic,retain)UILabel *like_label;//喜欢数量

@property(nonatomic,retain)UIView *lineHeng;//店铺名底部横线
@property(nonatomic,retain)UIView *lineShuLeft;//第一个竖线
@property(nonatomic,retain)UIView *lineShuRight;//第二个竖线

@property(nonatomic,assign)CELLSTYLE cellStyle;//cell样式

- (void)setCellWithModel:(ProductModel *)aModel;
- (void)setCellWithModel222:(ProductModel *)aModel;//数据结构不一样


@end
