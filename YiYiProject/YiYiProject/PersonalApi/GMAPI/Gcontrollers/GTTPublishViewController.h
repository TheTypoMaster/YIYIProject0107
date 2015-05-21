//
//  GTTPublishViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/4/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//T台发布

#import <UIKit/UIKit.h>
#import "TPlatModel.h"
@class GHolderTextView;
@class GAddTtaiImageLinkViewController;

@interface GTTPublishViewController : MyViewController

@property (strong, nonatomic) UILabel  *placeHolderLabel;
@property (strong, nonatomic) UITextView *contentTV;
@property(nonatomic,strong)UILabel *placeHolderTf;
@property (strong, nonatomic) UIButton *addImageButton;


@property (nonatomic,strong)UIImage *publishImage;//发布图片
@property (strong, nonatomic) UIScrollView *mainScrollview;
@property (strong, nonatomic) UIView *brandModelPriceView;

//锚点数据
@property(nonatomic,strong)NSDictionary *maodianDic;
@property(nonatomic,strong)NSMutableArray *GimvArray;//选择锚点之后的可以拖动的图片数组



//编辑T台
@property(nonatomic,strong)TPlatModel *theTtaiModel;//此处用于判断是否为编辑T台



@end
