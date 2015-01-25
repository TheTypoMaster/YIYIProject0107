//
//  MessageViewController.h
//  YiYiProject
//
//  Created by lichaowei on 14/12/10.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "RCChatListViewController.h"

/**
 *  融云的会话列表
 */
@interface MessageViewController : RCChatListViewController

@property(nonatomic,assign)BOOL only_rongcloud;//是否只有融云的聊天会话

- (void)getMyMessage;

@end
