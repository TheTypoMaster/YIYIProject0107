//
//  GTtaiNearActOneView.m
//  YiYiProject
//
//  Created by gaomeng on 15/8/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GTtaiNearActOneView.h"

@implementation GTtaiNearActOneView

-(id)initWithFrame:(CGRect)frame huodongModel:(ActivityModel*)model type:(NSString *)theType{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.activity_Id = model.activity_id;
        
        
        self.backgroundColor = RGBCOLOR(241, 242, 244);
        
        if ([theType isEqualToString:@"活动列表"]) {
            self.backgroundColor = [UIColor whiteColor];
        }
        
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/3.0, frame.size.height)];
//        imv.backgroundColor = [UIColor purpleColor];
//        [imv sd_setImageWithURL:[NSURL URLWithString:model.cover_pic] placeholderImage:nil];
        [imv l_setImageWithURL:[NSURL URLWithString:model.cover_pic] placeholderImage:DEFAULT_YIJIAYI];
        [self addSubview:imv];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imv.frame)+5, 0, frame.size.width - imv.frame.size.width - 10, imv.frame.size.height *2.0/3.0)];
//        titleLabel.backgroundColor = [UIColor orangeColor];
        titleLabel.text = model.activity_title;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.numberOfLines = 2;
        [self addSubview:titleLabel];
        
        UILabel *juliLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame), titleLabel.frame.size.width /3.0, titleLabel.frame.size.height *0.5)];
//        juliLabel.backgroundColor = [UIColor redColor];
        juliLabel.text = @"500m";
        juliLabel.font = [UIFont systemFontOfSize:11];
        juliLabel.textColor = RGBCOLOR(79, 80, 81);
        [self addSubview:juliLabel];
        
        
        UILabel *adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(juliLabel.frame), juliLabel.frame.origin.y, juliLabel.frame.size.width*2, juliLabel.frame.size.height)];
//        adressLabel.backgroundColor = [UIColor blueColor];
        adressLabel.textAlignment = NSTextAlignmentRight;
        adressLabel.text = model.mall_name;
        adressLabel.font = [UIFont systemFontOfSize:11];
        adressLabel.textColor = RGBCOLOR(79, 80, 81);
        [self addSubview:adressLabel];
        
    }
    
    return self;
}

@end
