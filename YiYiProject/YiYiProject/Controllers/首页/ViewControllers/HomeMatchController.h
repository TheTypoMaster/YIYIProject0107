//
//  HomeMatchController.h
//  YiYiProject
//
//  Created by lichaowei on 14/12/12.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  搭配师
 */


typedef enum{
    HomeMatchRequestTypeMy = 0,
    HomeMatchRequestTypeHot
}HomeMatchRequestType;

typedef enum{
    MatchSelectedTypeTopic = 0,
    MatchSelectedTypeMatch
}MatchSelectedType;

@interface HomeMatchController : UIViewController
{
    MatchSelectedType selected_type;
}

@property(nonatomic,assign)UIViewController *rootViewController;

@end
