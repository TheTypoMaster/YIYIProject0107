//
//  GmyMainViewController.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//


//我的主页 别人的主页

#import <UIKit/UIKit.h>

typedef enum{
    GDEFAUL = 0,
    GMYSELF,
    GSOMEONE
}GMAINVIEWTYPE;


@interface GmyMainViewController : MyViewController


@property(nonatomic,assign)GMAINVIEWTYPE theType;//类型  自己的 别人的

@end
