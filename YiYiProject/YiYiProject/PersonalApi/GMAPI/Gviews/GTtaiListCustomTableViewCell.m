//
//  GTtaiListCustomTableViewCell.m
//  YiYiProject
//
//  Created by gaomeng on 15/8/12.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GTtaiListCustomTableViewCell.h"
#import "AnchorPiontView.h"
#import "GTtaiListViewController.h"

@implementation GTtaiListCustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(CGFloat)loadCustomViewWithModel:(TPlatModel*)model index:(NSIndexPath*)indexPath{
    
    NSString *imageUrl = model.image[@"url"];
    CGFloat image_width = [model.image[@"width"]floatValue];
    CGFloat image_height = [model.image[@"height"]floatValue];
    
    //图片缩放
    float rate;
    if (image_width == 0.0 || image_height == 0.0) {
        image_width = image_height;
    }else
    {
        rate = image_height/image_width;
    }
    CGFloat imageHeight = (DEVICE_WIDTH-10) * rate;
    
    self.maodianImv = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, DEVICE_WIDTH-10, imageHeight)];
    self.maodianImv.userInteractionEnabled = YES;
    [self.maodianImv l_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:DEFAULT_YIJIAYI];
    [self.contentView addSubview:self.maodianImv];
    
    
    //图片下面view
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.maodianImv.frame), self.maodianImv.frame.size.width, 60)];
    [self.contentView addSubview:downView];
    
    //活动
    UILabel *huodongLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, downView.frame.size.width-10, downView.frame.size.height*0.5)];
    huodongLabel.font = [UIFont systemFontOfSize:12];
    huodongLabel.textColor = RGBCOLOR(36, 37, 38);
    
    if ([model.activity isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典");
        NSString *huodong_str = [model.activity stringValueForKey:@"activity_title"];
        huodongLabel.text = huodong_str;
        
    }else{
        NSLog(@"无数据");
        huodongLabel.text = @"暂无活动";
    }
    
    
    [downView addSubview:huodongLabel];
    
    //分割线
    UIView *midLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(huodongLabel.frame), downView.frame.size.width, 0.5)];
    midLine.backgroundColor = RGBCOLOR(220, 221, 223);
    [downView addSubview:midLine];
    
    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.5, downView.frame.size.height)];
    leftLine.backgroundColor = RGBCOLOR(220, 221, 223);
    [downView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(downView.frame.size.width-0.5, 0, 0.5, downView.frame.size.height)];
    rightLine.backgroundColor = RGBCOLOR(220, 221, 223);
    [downView addSubview:rightLine];
    
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, downView.frame.size.height-0.5, downView.frame.size.width, 0.5)];
    downLine.backgroundColor = RGBCOLOR(220, 221, 223);
    [downView addSubview:downLine];
    
    
    //距离 商场名称 赞
    CGFloat width = (DEVICE_WIDTH-10)/4.0;
    UIView *distanceView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(midLine.frame), width, huodongLabel.frame.size.height)];
    
    UIButton *distanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [distanceBtn setFrame:distanceView.bounds];
    
    NSString *distance = model.distance;
    NSInteger distance_int = [distance integerValue];
    NSString *distance_str;
    if (distance_int>=1000) {
        distance_str = [NSString stringWithFormat:@"%.1fkm",distance_int*0.001];
    }else{
        distance_str = [NSString stringWithFormat:@"%.1fm",distance_int*1.0];
    }
    
    distanceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [distanceBtn setImage:[UIImage imageNamed:@"activity_location.png"] forState:UIControlStateNormal];
    [distanceBtn setTitle:distance_str forState:UIControlStateNormal];
    [distanceBtn setTitleColor:RGBCOLOR(36, 37, 38) forState:UIControlStateNormal];
    [distanceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, width-30)];
    [distanceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [distanceView addSubview:distanceBtn];
    [downView addSubview:distanceView];
    
    
    
    UILabel *storeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(distanceView.frame), distanceView.frame.origin.y, 2*width, distanceView.frame.size.height)];
    storeNameLabel.textAlignment = NSTextAlignmentCenter;
    storeNameLabel.text = model.mall_name;
    storeNameLabel.font = [UIFont systemFontOfSize:12];
    storeNameLabel.textColor = RGBCOLOR(36, 37, 38);
    [downView addSubview:storeNameLabel];
    
    self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zanBtn setFrame:CGRectMake(CGRectGetMaxX(storeNameLabel.frame), distanceView.frame.origin.y, distanceView.frame.size.width, distanceView.frame.size.height)];
    self.zanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.zanBtn.titleLabel.textColor = RGBCOLOR(245, 104, 155);
    [self.zanBtn setImage:[UIImage imageNamed:@"Ttai_zan_normal.png"] forState:UIControlStateNormal];
    [self.zanBtn setImage:[UIImage imageNamed:@"Ttai_zan_selected.png"] forState:UIControlStateSelected];
    [self.zanBtn setTitle:model.tt_like_num forState:UIControlStateNormal];
    [self.zanBtn setTitleColor:RGBCOLOR(36, 37, 38) forState:UIControlStateNormal];
    [self.zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, width-35)];
    [self.zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    if (model.is_like) {
        self.zanBtn.selected = YES;
    }else{
        self.zanBtn.selected = NO;
    }
    
    
    
//    UILabel *zanLabel = [[UILabel alloc]initWithFrame:zanView.bounds];
//    zanLabel.textAlignment = NSTextAlignmentCenter;
//    zanLabel.font = [UIFont systemFontOfSize:12];
//    zanLabel.text = model.tt_like_num;
//    zanLabel.textColor = RGBCOLOR(245, 104, 155);
//    [zanView addSubview:zanLabel];
    
    [downView addSubview:self.zanBtn];
    
    
    
    //小分割线
    UIView *line_l = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(distanceView.frame), (downView.frame.size.height*1.5 - 12)*0.5, 0.5, 12)];
    line_l.backgroundColor = RGBCOLOR(220, 221, 223);
    [downView addSubview:line_l];
    UIView *line_r = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(storeNameLabel.frame), line_l.frame.origin.y, 0.5, 12)];
    line_r.backgroundColor = RGBCOLOR(220, 221, 223);
    [downView addSubview:line_r];
    
    
    
    
    
    
    
    
    CGFloat cell_height = CGRectGetMaxY(downView.frame);
    
    return cell_height;
    
}




@end
