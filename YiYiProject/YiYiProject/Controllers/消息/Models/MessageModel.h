//
//  MessageModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel

@property(nonatomic,retain)NSString *latest_msg_id;
@property(nonatomic,retain)NSString *latest_msg_title;
@property(nonatomic,retain)NSString *latest_msg_content;
@property(nonatomic,retain)NSString *latest_msg_time;
@property(nonatomic,assign)int unread_msg_num;


@end
