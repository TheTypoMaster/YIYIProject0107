//
//  GnearbyStoreTableViewCell.m
//  YiYiProject
//
//  Created by gaomeng on 15/5/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GnearbyStoreTableViewCell.h"
#import "NSDictionary+GJson.h"

@implementation GnearbyStoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)loadCustomViewWithModel:(NSDictionary *)theModel{
    
    
    CGFloat customheight = DEVICE_WIDTH*375.0/621;
    
//    [imv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[theModel stringValueForKey:@"mall_pic"]]] placeholderImage:nil];
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, customheight-1)];
    [self.contentView addSubview:imv];
    
    [imv l_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[theModel stringValueForKey:@"mall_pic"]]] placeholderImage:DEFAULT_YIJIAYI];
    
    
    
    
    UIImageView *backImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, customheight-100, DEVICE_WIDTH, 100)];
    [backImv setImage:[UIImage imageNamed:@"shouye_bg@2x.png"]];
    [self.contentView addSubview:backImv];
    
    
    UIImageView *lineImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, customheight-1, DEVICE_WIDTH, 1)];
    [lineImv setImage:[UIImage imageNamed:@"shouye_line.png"]];
    [self.contentView addSubview:lineImv];
    
    
    //文字信息view
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, customheight-50, DEVICE_WIDTH, 50)];
    contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:contentView];
    //活动名
    UILabel *huodong = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 15)];
    huodong.text = [theModel stringValueForKey:@"activity_title"];
    huodong.font = [UIFont systemFontOfSize:15];
    huodong.textAlignment = NSTextAlignmentCenter;
    huodong.textColor = [UIColor whiteColor];
    [contentView addSubview:huodong];
    //商场名
    UILabel *storeName = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, DEVICE_WIDTH, 15)];
    NSString *distance = [GMAPI changeDistanceWithStr:[theModel stringValueForKey:@"distance"]];
    storeName.text = [NSString stringWithFormat:@"%@   %@",[theModel stringValueForKey:@"mall_name"],distance];
    storeName.textColor = [UIColor whiteColor];
    storeName.textAlignment = NSTextAlignmentCenter;
    storeName.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:storeName];
    
    
}

@end
