//
//  YichuListTableViewCell.m
//  YiYiProject
//
//  Created by szk on 14/12/28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "YichuListTableViewCell.h"

@implementation YichuListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setAllSubViews{
    
    self.backgroundColor=[UIColor orangeColor];
    
    UIView *centerWiteView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, DEVICE_WIDTH, 100)];
    centerWiteView.backgroundColor=[UIColor whiteColor];
    [self addSubview:centerWiteView];
    
    _mainiCarousel=[[iCarousel alloc]initWithFrame:CGRectMake(40, 10, DEVICE_WIDTH-40, 80)];
    _mainiCarousel.delegate=self;
    _mainiCarousel.dataSource=self;
    _mainiCarousel.type = iCarouselTypeCustom;

    [centerWiteView addSubview:_mainiCarousel];
    
    
    
}

-(void)setDic:(NSDictionary *)dateofDic{


}




#pragma mark-icarousDelegate

#pragma mark-icarousDatesource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{

    return 4;
    
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
//    //icarousel上的subview
    if (view==nil) {
        _witeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 86, 80)];
        _mainImageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _mainImageV.backgroundColor=[UIColor grayColor];
        _witeView.backgroundColor=[UIColor redColor];
        [_witeView addSubview:_mainImageV];
    }else{
    
        view=_witeView;
    
    }
    


    return _witeView;
    
    
    //create new view if no view is available for recycling
  


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
