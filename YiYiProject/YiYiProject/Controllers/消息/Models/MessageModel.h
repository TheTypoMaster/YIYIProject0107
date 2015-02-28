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


//消息列表model
@property(nonatomic,retain)NSString *msg_id;
@property(nonatomic,retain)NSString *from_uid;
@property(nonatomic,retain)NSString *to_uid;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *pic;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *send_time;
@property(nonatomic,retain)NSString *is_read;
@property(nonatomic,retain)NSString *theme_id;
@property(nonatomic,retain)NSString *photo;
@property(nonatomic,retain)NSString *from_username;

@property(nonatomic,retain)NSString *pic_height;//图片高度（截图）
@property(nonatomic,retain)NSString *pic_width;//图片宽度

@property(nonatomic,retain)NSString *ori_height;//图片高度（原图）
@property(nonatomic,retain)NSString *ori_width;//图片宽度


//"": "11",
//"": "11",
//"": "消息标题",
//"":
//"": "哈哈第3条回复",
//"": "1",
//"": "1421464157",
//"": "1",
//"": "2",
//"": 
//"": "zaxzd"

@end
