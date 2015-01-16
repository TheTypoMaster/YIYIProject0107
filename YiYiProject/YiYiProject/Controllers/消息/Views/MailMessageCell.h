//
//  MailMessageCell.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  商家消息
 */
@interface MailMessageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *numbeLabel;

@property (strong, nonatomic) IBOutlet UIView *bottomLine;

@end
