//
//  TTPublishViewController.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyViewController.h"
/**
 *  T台发布
 */
@interface TTPublishViewController : MyViewController
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentTF;
@property (strong, nonatomic) IBOutlet UIButton *addImageButton;
@property (strong, nonatomic) IBOutlet UITextField *brandTF;
@property (strong, nonatomic) IBOutlet UITextField *modelTF;
@property (strong, nonatomic) IBOutlet UITextField *priceTF;

@property (nonatomic,retain)UIImage *publishImage;//发布图片

@end
