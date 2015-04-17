//
//  GCustomNearByView.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/7.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GCustomNearByView.h"
#import "NSDictionary+GJson.h"

@implementation GCustomNearByView




-(void)loadCustomView{
    if (self.theType == GjiaoyaTypeDown) {//脚丫在下面
        //小红点
        self.xiaohongdian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 37, 10, 10)];
        [self.xiaohongdian setImage:[UIImage imageNamed:@"gyuanshixin.png"]];
        [self addSubview:self.xiaohongdian];
        //店铺名
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.xiaohongdian.frame)+2, 30, 60, 35)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.text = [self.dataDic stringValueForKey:@"mall_name"];
        self.shopType = [self.dataDic stringValueForKey:@"mall_type"];
        [self addSubview:self.titleLabel];
        //脚丫
        self.jiaoya = [[UIImageView alloc]initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, CGRectGetMaxY(self.titleLabel.frame)+15, 52, 37)];
        [self.jiaoya setImage:[UIImage imageNamed:@"gjiaoyaup.png"]];
        [self addSubview:self.jiaoya];
        
        
        //距离
        self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 17, 35, 12)];
        self.distanceLabel.font = [UIFont systemFontOfSize:10];
        self.distanceLabel.textColor = [UIColor whiteColor];
        NSString *distance_str = [self.dataDic stringValueForKey:@"distance"];
        CGFloat distance_float = [distance_str floatValue];
        if (distance_float>=1000) {
            distance_float = distance_float*0.001;
            distance_str = [NSString stringWithFormat:@"%.1fkm",distance_float];
        }else{
            distance_str = [NSString stringWithFormat:@"%@m",distance_str];
        }
        self.distanceLabel.text = distance_str;
        [self.jiaoya addSubview:self.distanceLabel];
        
    }else if (self.theType == GjiaoyaTypeUp){//脚丫在上面
        //小红点
        self.xiaohongdian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, 10, 10)];
        [self.xiaohongdian setImage:[UIImage imageNamed:@"gyuanquankong.png"]];
        [self addSubview:self.xiaohongdian];
        //脚丫
        self.jiaoya = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.xiaohongdian.frame)+2, 15, 52, 37)];
        [self.jiaoya setImage:[UIImage imageNamed:@"gjiaoyadown.png"]];
        [self addSubview:self.jiaoya];
        
        //店铺名
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.jiaoya.frame.origin.x, CGRectGetMaxY(self.jiaoya.frame)+15, 60, 35)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.text = [self.dataDic stringValueForKey:@"mall_name"];
        self.shopType = [self.dataDic stringValueForKey:@"mall_type"];
        [self addSubview:self.titleLabel];
        
        //距离
        self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 4, 35, 12)];
        self.distanceLabel.font = [UIFont systemFontOfSize:10];
        self.distanceLabel.textColor = [UIColor whiteColor];
        NSString *distance_str = [self.dataDic stringValueForKey:@"distance"];
        CGFloat distance_float = [distance_str floatValue];
        if (distance_float>=1000) {
            distance_float = distance_float*0.001;
            distance_str = [NSString stringWithFormat:@"%.1fkm",distance_float];
        }else{
            distance_str = [NSString stringWithFormat:@"%@m",distance_str];
        }
        self.distanceLabel.text = distance_str;
        [self.jiaoya addSubview:self.distanceLabel];
        
    }
    
    
    
}





@end
