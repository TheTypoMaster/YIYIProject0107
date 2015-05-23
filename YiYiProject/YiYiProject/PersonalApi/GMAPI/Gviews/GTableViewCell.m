//
//  GTableViewCell.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/13.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GTableViewCell.h"

@implementation GTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)creatCustomViewWithGcellType:(GCELLTYPE)theType indexPath:(NSIndexPath*)theIndexPath customObject:(id)theInfo{
    if (theType == GPERSON) {//个人中心
        
        //logo图
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(16, (56-20)*0.5, 20, 20)];
        [imv setImage:[theInfo objectForKey:@"titleLogo"][theIndexPath.row]];
        imv.layer.cornerRadius = 17;
        [self.contentView addSubview:imv];
        
        //文字描述
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imv.frame)+19, (56-24)*0.5, 200*GscreenRatio_320, 24)];
        titleLabel.text = [theInfo objectForKey:@"titleArray"][theIndexPath.row];
        [self.contentView addSubview:titleLabel];
        
        //箭头
        UIImageView *jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - 28, titleLabel.frame.origin.y+5, 7, 12)];
        [jiantou setImage:[UIImage imageNamed:@"my_jiantou.png"]];
        [self.contentView addSubview:jiantou];
        
        
        
        
        
        
    }
}


@end
