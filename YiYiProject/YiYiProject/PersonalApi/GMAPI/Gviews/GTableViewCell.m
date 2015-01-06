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
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(16, 15, 34, 34)];
        imv.backgroundColor = RGBCOLOR_ONE;
        imv.layer.cornerRadius = 17;
        [self.contentView addSubview:imv];
        
        //文字描述
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imv.frame)+19, imv.frame.origin.y+4, 200*GscreenRatio_320, 24*GscreenRatio_320)];
        titleLabel.text = theInfo;
        [self.contentView addSubview:titleLabel];
        
        //箭头
        UIImageView *jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - 28, titleLabel.frame.origin.y+5, 7, 12)];
        jiantou.backgroundColor = RGBCOLOR_ONE;
        [self.contentView addSubview:jiantou];
    }
}


@end
