//
//  MyMatchDetailViewController.h
//  YiYiProject
//
//  Created by unisedu on 15/1/10.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyViewController.h"
#import "LWaterflowView.h"
@interface MyMatchDetailViewController : MyViewController<TMQuiltViewDataSource,WaterFlowDelegate>
{
    LWaterflowView *waterFlow;
    
    @public
    NSDictionary *sourceDic;
}
@end
