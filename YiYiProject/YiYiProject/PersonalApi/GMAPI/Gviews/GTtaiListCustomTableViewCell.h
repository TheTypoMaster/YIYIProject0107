//
//  GTtaiListCustomTableViewCell.h
//  YiYiProject
//
//  Created by gaomeng on 15/8/12.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//首页T台列表自定义cell
#import <UIKit/UIKit.h>
#import "TPlatModel.h"
#import "PropertyImageView.h"
#import "ButtonProperty.h"
@class GTtaiListViewController;

@interface GTtaiListCustomTableViewCell : UITableViewCell

@property (nonatomic, strong)UIButton *zanBtn;//点赞
@property(nonatomic,retain)ButtonProperty *likeBackBtn;//喜欢的背景大button
@property(nonatomic,retain)UIButton *like_btn;//喜欢标识
@property(nonatomic,retain)UILabel *like_label;//喜欢数量
@property(nonatomic,strong)TPlatModel *theModel;//数据model
@property(nonatomic,strong)PropertyImageView *maodianImv;


//加载自定义视图
-(CGFloat)loadCustomViewWithModel:(TPlatModel*)model index:(NSIndexPath*)indexPath;


@end
