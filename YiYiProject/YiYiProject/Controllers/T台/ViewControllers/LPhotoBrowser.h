//
//  LPhotoBrowser.h
//  YiYiProject
//
//  Created by lichaowei on 15/4/20.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MJPhotoBrowser.h"
#import "TPlatModel.h"

///图片浏览器,继承自 MJPhotoBrowser
@interface LPhotoBrowser : MJPhotoBrowser

@property(nonatomic,retain)NSString *tt_id;//t台信息id

@property(nonatomic,retain)TPlatModel *t_model;

@property(nonatomic,assign)UIImageView *showImageView;

//@property(nonatomic,retain)NSArray *anchorViews;//锚点

//@property(nonatomic,assign)UIViewController *lastViewController;

@property(nonatomic,strong)UIView *clearView;//透明view,上面放锚点

@property(nonatomic,assign)BOOL isPresent;//是否是模态

@end
