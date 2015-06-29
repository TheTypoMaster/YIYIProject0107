//
//  GbuyClothTableViewCell.m
//  YiYiProject
//
//  Created by gaomeng on 15/6/27.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GbuyClothTableViewCell.h"
#import "GTimeSwitch.h"

@implementation GbuyClothTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)loadCustomCellWithModel:(GBuyClothLogModel*)theModel{
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 50, 20)];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
//    timeLabel.backgroundColor = [UIColor orangeColor];
    self.timeLabel.attributedText = [GTimeSwitch timechangeWithDayAndMonth:theModel.buy_time];
    NSLog(@"哈哈%@",self.timeLabel.text);
    [self.contentView addSubview:self.timeLabel];
    
    UIView *yuan = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+2, 0, 14, 14)];
    yuan.layer.cornerRadius = 7;
    yuan.layer.borderWidth = 1;
    yuan.layer.borderColor = [RGBCOLOR(219, 220, 222)CGColor];
    yuan.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:yuan];
    
    UIView *yuan2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    yuan2.layer.cornerRadius = 5;
    yuan2.backgroundColor = RGBCOLOR(174, 174, 175);
    yuan2.center = yuan.center;
    [self.contentView addSubview:yuan2];
    
    UIView *shuxian = [[UIView alloc]initWithFrame:CGRectMake(yuan.center.x, CGRectGetMaxY(yuan.frame), 0.5, 146)];
    NSLog(@"哈哈%f",shuxian.frame.size.height);
    NSLog(@"哈哈%@",NSStringFromCGRect(shuxian.frame));
    shuxian.backgroundColor = RGBCOLOR(173, 174, 175);
    [self.contentView addSubview:shuxian];
    
    
    //图片信息view
    
    //图片
    UIView *picInfoView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(yuan.frame)+7, 5, DEVICE_WIDTH-CGRectGetMaxX(yuan.frame)-7, 150)];
    picInfoView.layer.borderWidth = 0.5;
    picInfoView.layer.borderColor = [RGBCOLOR(220, 221, 223)CGColor];
    picInfoView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:picInfoView];
    UIImageView *picImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    [picImv sd_setImageWithURL:[NSURL URLWithString:theModel.pic] placeholderImage:nil];
    [picInfoView addSubview:picImv];
    
    UIView *sx = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(picImv.frame),0 , 0.5, picImv.frame.size.height)];
    sx.backgroundColor = RGBCOLOR(220, 221, 223);
    [picInfoView addSubview:sx];
    
    //文字信息
    //品牌
    UILabel *pinpaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(picImv.frame), 9, picInfoView.frame.size.width-160, 33)];
//    pinpaiLabel.backgroundColor = [UIColor orangeColor];
    pinpaiLabel.text = theModel.brand;
    pinpaiLabel.textAlignment = NSTextAlignmentRight;
    pinpaiLabel.font = [UIFont systemFontOfSize:12];
    [picInfoView addSubview:pinpaiLabel];
    //产品描述
    UILabel *pinMingLabel = [[UILabel alloc]initWithFrame:CGRectMake(pinpaiLabel.frame.origin.x, CGRectGetMaxY(pinpaiLabel.frame), pinpaiLabel.frame.size.width, pinpaiLabel.frame.size.height)];
//    pinMingLabel.backgroundColor  = [UIColor purpleColor];
    pinMingLabel.font = [UIFont systemFontOfSize:12];
    pinMingLabel.textAlignment = NSTextAlignmentRight;
    pinMingLabel.numberOfLines = 2;
    pinMingLabel.text = theModel.desc;
    [picInfoView addSubview:pinMingLabel];
    //价钱
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(pinpaiLabel.frame.origin.x, CGRectGetMaxY(pinMingLabel.frame), pinpaiLabel.frame.size.width, pinpaiLabel.frame.size.height)];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont systemFontOfSize:12];
//    priceLabel.backgroundColor = [UIColor redColor];
    priceLabel.text = [NSString stringWithFormat:@"￥%@",theModel.price];
    [picInfoView addSubview:priceLabel];
    //购买地点
    UILabel *adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(pinMingLabel.frame.origin.x, CGRectGetMaxY(priceLabel.frame), pinpaiLabel.frame.size.width, pinpaiLabel.frame.size.height)];
//    adressLabel.backgroundColor = [UIColor blackColor];
    adressLabel.font = [UIFont systemFontOfSize:12];
    adressLabel.numberOfLines = 2;
    adressLabel.textAlignment = NSTextAlignmentRight;
    adressLabel.text = theModel.buy_place;
    [picInfoView addSubview:adressLabel];
    
}

@end
