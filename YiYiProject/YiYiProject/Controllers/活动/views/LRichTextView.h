//
//  LRichTextView.h
//  YiYiProject
//
//  Created by lichaowei on 15/6/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface LRichTextView : UIView<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *height_arr;//存储高度
    
    NSDictionary *firstResponder_dic;//第一响应textView 相关信息
    
    UIImageView *replaceImageView;//替换图片的imageView
    BOOL isReplaceImage;//是否在替换图片
    
    UITapGestureRecognizer *tap;//隐藏键盘的手势
    
    UITextView *calculate_textView;//计算高度
    
    UIViewController *rootViewController;//
    
    CGFloat originalHeight;//原始高度
    
    UITextView *firstTextView;
    
    UIView *toolsView;//工具条
    
    CGFloat keyboard_y;//键盘 y
}

@property(nonatomic,retain)UITableView *tableView;

@property(nonatomic,retain)UITextField *titleTextField;//放标题

-(instancetype)initWithFrame:(CGRect)frame rootViewController:(UIViewController *)rootVc;

- (void)clickToAddAlbum:(id)sender;//插入图片

- (void)setFirstResponder;

- (NSArray *)content;

- (NSString *)editorTitle;//标题

- (void)hiddenKeyboard;//隐藏键盘

@end
