//
//  GsearchViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/3/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//搜索VC

#import <UIKit/UIKit.h>
@class GcustomSearchTableViewCell;
typedef enum{
    searNone = 0,
    searchStore,
    searchPinpai,
    searchproduct,
}SEARCHTYPE;

@interface GsearchViewController : MyViewController

@property(nonatomic,assign)SEARCHTYPE *searchType;

@end
