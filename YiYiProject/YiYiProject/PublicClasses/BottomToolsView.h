//
//  BottomToolsView.h
//  YiYiProject
//
//  Created by lichaowei on 15/6/10.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  导航、私信、电话
 */

typedef enum {
    
    ACTIONTYPE_NAVIGATION = 1,//导航
    ACTIONTYPE_CHAT = 2,//私信
    ACTIONTYPE_PHONE = 3 //电话
    
}ACTIONTYPE;//时间类型

typedef void(^ACTIONBLOCK)(ACTIONTYPE aType);

@interface BottomToolsView : UIView
{
    ACTIONBLOCK _actionBlock;
}

-(instancetype)initWithSuperViewHeight:(CGFloat)superViewheight
                               address:(NSString *)addressString
                        isYYChatVcPush:(BOOL)isYYChatVcPush
                           actionBlock:(ACTIONBLOCK)actionBlock;

@end
