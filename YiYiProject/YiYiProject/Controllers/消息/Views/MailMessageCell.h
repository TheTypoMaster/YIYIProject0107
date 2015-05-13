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

typedef enum {
   
    Time_StartAndEnd = 0,//开始时间和结束时间
    Time_AddTime = 1 //发布时间
    
}TimeType;

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

/**
 *  cell赋值
 *
 *  @param aModel 消息model
 *  @param aType  是否有头像
 *  @param seeAll 是否有 查看全文
 *  @param timeType 显示时间类型 开始和结束 发布时间
 */
- (void)setCellWithModel:(id)aModel
                cellType:(Cell_Type)aType
                  seeAll:(BOOL)seeAll
                timeType:(TimeType)timeType;

//- (void)setCellWithModel:(id)aModel cellType:(Cell_Type)aType seeAll:(BOOL)seeAll;

+ (CGFloat)heightForModel:(id)aModel cellType:(Cell_Type)aType seeAll:(BOOL)seeAll;

@end
