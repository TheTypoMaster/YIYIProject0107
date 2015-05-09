//
//  TCommentHeadCell.h
//  YiYiProject
//
//  Created by lichaowei on 15/5/7.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCommentHeadCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

//赞和评论
@property (strong, nonatomic) IBOutlet UIView *toolsView;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *zanButton;
@property (strong, nonatomic) IBOutlet UILabel *zanLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;

//放置赞人员头像
@property (strong, nonatomic) IBOutlet UIView *zanUserView;

- (void)setCellWithModel:(id)aModel;

+ (CGFloat)cellHeightForString:(NSString *)string;

//添加赞人员
- (void)addZanList:(NSArray *)zanList total:(int)total;

@end
