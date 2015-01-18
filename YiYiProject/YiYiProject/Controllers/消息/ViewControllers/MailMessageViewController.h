//
//  MailMessageViewController.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyViewController.h"
/**
 *  商家消息列表
 */
//action= yy(衣加衣) shop（商家） dynamic（动态）

typedef enum{
    Message_Yy = 0,
    Message_Shop,
    Message_Dynamic
}Message_Type;

@interface MailMessageViewController : MyViewController

@property(nonatomic,assign)Message_Type aType;

@end
    