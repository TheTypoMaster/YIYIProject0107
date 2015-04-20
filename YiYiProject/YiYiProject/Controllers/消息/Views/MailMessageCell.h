//
//  MailMessageCell.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

typedef enum{
    icon_Yes = 0,
    icon_No
}Cell_Type;//分有头像 和 无头像

/**
 *  商家消息
 */
@interface MailMessageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bigBackView;
@property (strong, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *centerImageView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIButton *clickButton;
@property (strong, nonatomic) IBOutlet UIView *userView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomBackView;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;


- (void)setCellWithModel:(id)aModel cellType:(Cell_Type)aType seeAll:(BOOL)seeAll;

+ (CGFloat)heightForModel:(id)aModel cellType:(Cell_Type)aType seeAll:(BOOL)seeAll;

@end
