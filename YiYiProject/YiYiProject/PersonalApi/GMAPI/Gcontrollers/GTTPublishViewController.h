//
//  GTTPublishViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/4/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//T台发布

#import <UIKit/UIKit.h>
@class GHolderTextView;
@class GAddTtaiImageLinkViewController;

@interface GTTPublishViewController : MyViewController

@property (strong, nonatomic) UILabel  *placeHolderLabel;
@property (strong, nonatomic) GHolderTextView *contentTF;
@property (strong, nonatomic) UIButton *addImageButton;


@property (nonatomic,strong)UIImage *publishImage;//发布图片
@property (strong, nonatomic) UIScrollView *mainScrollview;
@property (strong, nonatomic) UIView *brandModelPriceView;

//锚点数据
@property(nonatomic,strong)NSDictionary *maodianDic;

@end
