//
//  MessageViewCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/13.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MessageViewCell.h"

@implementation MessageViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithModel:(MessageModel *)aModel
             placeHolder:(NSString *)placeHolder
{
    self.messageLabel.text = aModel.latest_msg_content.length > 0 ? aModel.latest_msg_content : placeHolder;
    self.unreadNumLabel.text = NSStringFromInt(aModel.unread_msg_num);
    if (aModel.unread_msg_num > 0) {
        
        NSLog(@"有未读消息");
        self.timeLabel.hidden = NO;
        self.timeLabel.text = [LTools showTimeWithTimestamp:aModel.latest_msg_time];
        NSLog(@"time %@",[LTools timechangeAll:aModel.latest_msg_time]);
        
        CGFloat aWidth = [LTools widthForText:NSStringFromInt(aModel.unread_msg_num) boldFont:15];
        
        if (aModel.unread_msg_num <= 9) {
            
            aWidth = 20;
            
        }else
        {
            aWidth = ((aWidth < 20) ? 20 : aWidth) + 10;
        }
        
        self.unreadNumLabel.width = aWidth;
        self.unreadNumLabel.hidden = NO;
        
    }else
    {
        NSLog(@"无未读消息");
        self.timeLabel.hidden = YES;
        self.messageLabel.text = placeHolder;
        self.unreadNumLabel.hidden = YES;
    }
    
    self.unreadNumLabel.shadowOffset = CGSizeMake(-10, 10);
}

@end
