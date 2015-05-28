//
//  LContactView.h
//  YiYiProject
//
//  Created by lichaowei on 15/5/28.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    CONTACTTYPE_PHONE = 1,//电话
    CONTACTTYPE_PRIVATECHAT = 2 //私聊
}CONTACTTYPE;

typedef void(^CONTACT_BLOCK)(CONTACTTYPE contactType,int extra);

@interface LContactView : UIView

@property(nonatomic,copy)CONTACT_BLOCK contactBlock;

//@property(nonatomic,retain)UIView* backView;

+ (id)shareInstance;

- (void)hidden;

- (void)show;

//-(void)setContactBlock:(CONTACT_BLOCK)contactBlock;

@end
