//
//  BrandViewCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ShopViewCell.h"

@implementation ShopViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithModel:(MailModel *)aModel
{
    self.cancelButton.layer.cornerRadius = 3.f;
    self.cancelButton.layer.borderColor = [UIColor colorWithHexString:@"ef7186"].CGColor;
    self.cancelButton.layer.borderWidth = 1.f;
    self.nameLabel.text = aModel.mall_name;
    
    
    //处理活动信息

    //根据 activity 是否有数据判断是否有活动

    if (aModel.activity && [aModel.activity isKindOfClass:[NSDictionary class]]) {
        
        NSString *endtime = aModel.activityModel.end_time;//活动结束时间
        NSString *nowTime = [LTools timechangeToDateline];//当前时间
        
        NSLog(@"活动结束时间 %@",[LTools timeString:endtime withFormat:@"yyyy-MM-DD HH:mm:ss"]);
        
        //活动未结束
        if ([nowTime compare:endtime] == NSOrderedAscending) {
            
            self.addressLabel.text = aModel.activityModel.activity_title;
            self.addressLabel.textColor = [UIColor colorWithHexString:@"fe2725"];
        }else
        {
            self.addressLabel.text = @"活动已结束";
            self.addressLabel.textColor = [UIColor colorWithHexString:@"b4b4b4"];
        }
    
    }else
    {
        self.addressLabel.text = @"该商家暂无活动";
        self.addressLabel.textColor = [UIColor colorWithHexString:@"b4b4b4"];
    }
    
    NSString *distanceStr = [LTools distanceString:aModel.distance];
    
    CGFloat aWidth = [LTools widthForText:distanceStr font:13];
    
    self.distanceLabel.text = distanceStr;
    self.distanceLabel.width = aWidth;
    self.distanceLabel.left = self.locationImageView.right + 2;
    
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:aModel.mall_pic] placeholderImage:DEFAULT_YIJIAYI];
}

@end
