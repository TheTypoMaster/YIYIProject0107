//
//  ChooseImageViewController.h
//  YiYiProject
//
//  Created by unisedu on 15/1/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyViewController.h"
#import "LWaterflowView.h"
@interface ChooseImageViewController : MyViewController<TMQuiltViewDataSource,WaterFlowDelegate>
{
     LWaterflowView *waterFlow;
    @public
    NSDictionary *sourceDic;
    
}
@end
