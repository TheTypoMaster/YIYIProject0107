//
//  YichuListTableViewCell.h
//  YiYiProject
//
//  Created by szk on 14/12/28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iCarousel.h"

@interface YichuListTableViewCell : UITableViewCell<iCarouselDataSource,iCarouselDelegate>

@property(nonatomic,strong)iCarousel *mainiCarousel;

@property(nonatomic,strong)UIImageView *mainImageV;//icarousel上的imageview

@property(nonatomic,strong)UIView *witeView;//icarousel上的view



-(void)setAllSubViews;

-(void)setDic:(NSDictionary *)dateofDic;

@end
