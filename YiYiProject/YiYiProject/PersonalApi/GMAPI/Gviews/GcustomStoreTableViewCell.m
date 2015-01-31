//
//  GcustomStoreTableViewCell.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/11.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GcustomStoreTableViewCell.h"
#import "NSDictionary+GJson.h"

@implementation GcustomStoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(CGFloat)loadCustomCellWithDic:(NSDictionary *)dic{
    
    CGFloat cellHeight = 0.0f;
    
    //name
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 18, 0, 16)];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.text = [dic stringValueForKey:@"mall_name"];
    [nameLabel sizeToFit];
    cellHeight += nameLabel.frame.size.height;
    
    //距离
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+15, nameLabel.frame.origin.y+4, 0, nameLabel.frame.size.height)];
    distanceLabel.font = [UIFont systemFontOfSize:12];
    distanceLabel.textColor = RGBCOLOR(153, 153, 153);
    distanceLabel.text = [NSString stringWithFormat:@"%@m",[dic stringValueForKey:@"distance"]];
    [distanceLabel sizeToFit];

    
    //箭头
    UIImageView *jiantouImv = [[UIImageView alloc]initWithFrame:CGRectZero];
    [jiantouImv setImage:[UIImage imageNamed:@"gcustomstore.png"]];
    
    [self.contentView addSubview:jiantouImv];
    
    
    //活动
    UILabel *activeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+10, 0, 15)];
    activeLabel.font = [UIFont systemFontOfSize:14];
    activeLabel.textColor = RGBCOLOR(114, 114, 114);
    activeLabel.text = [dic stringValueForKey:@"activity_info"];
    [activeLabel sizeToFit];
    
    cellHeight += distanceLabel.frame.size.height+activeLabel.frame.size.height;
    
    cellHeight += 20;
    
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:distanceLabel];
    [self.contentView addSubview:activeLabel];
    
    
    [jiantouImv setFrame:CGRectMake(DEVICE_WIDTH - 20, cellHeight*0.5-6, 7, 12)];
    
    
    
    return cellHeight;
    
}









@end
