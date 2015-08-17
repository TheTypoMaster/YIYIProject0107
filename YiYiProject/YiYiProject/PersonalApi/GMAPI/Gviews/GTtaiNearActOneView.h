//
//  GTtaiNearActOneView.h
//  YiYiProject
//
//  Created by gaomeng on 15/8/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface GTtaiNearActOneView : UIView

@property(nonatomic,strong)NSString *activity_Id;//活动id


-(id)initWithFrame:(CGRect)frame huodongModel:(ActivityModel*)model type:(NSString *)theType;


@end
