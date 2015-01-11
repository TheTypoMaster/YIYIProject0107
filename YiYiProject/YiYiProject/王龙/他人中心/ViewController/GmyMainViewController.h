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

#import "WaterF.h"
#import "ParallaxHeaderView.h"

@interface GmyMainViewController : MyViewController<UIScrollViewDelegate,CollectionClickDelegate,UICollectionViewDelegate>
{
    ParallaxHeaderView *headerView;
}

@property(nonatomic,assign)GMAINVIEWTYPE theType;//类型  自己的 别人的
@property (nonatomic,strong) WaterF* waterfall;
@end
