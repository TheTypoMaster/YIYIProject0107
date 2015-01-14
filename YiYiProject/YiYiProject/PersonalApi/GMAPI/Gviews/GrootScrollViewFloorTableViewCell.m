//
//  GrootScrollViewFloorTableViewCell.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GrootScrollViewFloorTableViewCell.h"
#import "NSDictionary+GJson.h"

@implementation GrootScrollViewFloorTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





-(void)loadCustomViewWithDicData:(NSDictionary *)dic{
    //logo
    UIImageView *logoImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 70, 70)];
    logoImv.layer.cornerRadius = 35;
    logoImv.layer.borderWidth = 1;
    logoImv.layer.masksToBounds = YES;
    logoImv.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    
    NSLog(@"%@",[dic objectForKey:@"brand_logo"]);
    [logoImv sd_setImageWithURL:[NSURL URLWithString:[dic stringValueForKey:@"brand_logo"]] placeholderImage:nil];
    
    //name
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImv.frame)+10, logoImv.frame.origin.y+17, self.bounds.size.width-logoImv.frame.size.width -17, 18)];
    //    nameLabel.backgroundColor = [UIColor orangeColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = [dic stringValueForKey:@"brand_name"];
    
    
    //号码 活动
    UILabel *activeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+7, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    activeLabel.text = @"B2016   满100减30";
    
    
    [self.contentView addSubview:logoImv];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:activeLabel];
    
    self.contentView.backgroundColor = RGBCOLOR(248, 248, 248);
}




@end
