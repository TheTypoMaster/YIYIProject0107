//
//  GcustomSearchTableViewCell.m
//  YiYiProject
//
//  Created by gaomeng on 15/3/29.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GcustomSearchTableViewCell.h"
#import "GsearchViewController.h"
#import "NSDictionary+GJson.h"

@implementation GcustomSearchTableViewCell

{
    NSIndexPath *_flagIndexPath;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(CGFloat)loadCustomViewWithData:(NSDictionary*)theData indexPath:(NSIndexPath*)theIndex{
    
    CGFloat height = 0.0f;
    if (self.theType == GSEARCHTYPE_PINPAI || self.theType == GSEARCHTYPE_SHANGPU) {//品牌 || 商铺
        height = [self loadCustomCellWithDic:theData];
    }else if (self.theType == GSEARCHTYPE_DANPIN){//单品
        [self loadCustomCellWithDicOfProduct:theData];
        height = 90;
    }
    
    
    return height;
    
}




//搜索品牌或商铺
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
    NSString *juli = [dic stringValueForKey:@"distance"];
    CGFloat juli_f = 0.0f;
    if ([juli intValue] >=1000) {
        juli_f = [juli floatValue]*0.001;
        distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",juli_f];
    }
    [distanceLabel sizeToFit];
    
    
    //箭头
    UIImageView *jiantouImv = [[UIImageView alloc]initWithFrame:CGRectZero];
    [jiantouImv setImage:[UIImage imageNamed:@"gcustomstore.png"]];
    
    [self.contentView addSubview:jiantouImv];
    
    
    //活动
    UILabel *activeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+10, DEVICE_WIDTH - 30 , 15)];
    activeLabel.font = [UIFont systemFontOfSize:14];
    activeLabel.textColor = RGBCOLOR(114, 114, 114);
    activeLabel.text = [dic stringValueForKey:@"activity_info"];
    activeLabel.numberOfLines = 4;
    [activeLabel sizeToFit];
    
    cellHeight += distanceLabel.frame.size.height+activeLabel.frame.size.height;
    
    cellHeight += 20;
    
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:distanceLabel];
    [self.contentView addSubview:activeLabel];
    
    
    [jiantouImv setFrame:CGRectMake(DEVICE_WIDTH - 20, cellHeight*0.5-6, 7, 12)];
    
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(15, cellHeight-0.5, DEVICE_WIDTH-15, 0.5)];
    downLine.backgroundColor = RGBCOLOR(226, 226, 228);
    [self.contentView addSubview:downLine];
    
    return cellHeight;
    
}



-(void)loadCustomCellWithDicOfProduct:(NSDictionary *)dic{
    //图片
    UIImageView *picImv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 70)];
    picImv.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:picImv];
    
    NSDictionary *images = [dic dictionaryValueForKey:@"images"];
    NSDictionary *middle = [images dictionaryValueForKey:@"540Middle"];
    NSString *imageUrl = [middle stringValueForKey:@"src"];
    [picImv sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(picImv.frame)+5, picImv.frame.origin.y, DEVICE_WIDTH-10-60-10, picImv.frame.size.height*0.5)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = [dic stringValueForKey:@"product_name"];
    [self.contentView addSubview:titleLabel];
    
    //附加信息
    
    NSString *distance = [dic stringValueForKey:@"distance"];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame), titleLabel.frame.size.width, titleLabel.frame.size.height)];
    detailLabel.text = [NSString stringWithFormat:@"%@   %@m",[dic stringValueForKey:@"product_price"],distance];
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.numberOfLines = 2;
    [self.contentView addSubview:detailLabel];
}


@end
