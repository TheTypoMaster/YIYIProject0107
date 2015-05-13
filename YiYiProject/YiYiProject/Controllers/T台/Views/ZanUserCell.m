//
//  ZanUserCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/5/5.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ZanUserCell.h"
#import "ZanUserModel.h"

@implementation ZanUserCell

- (void)awakeFromNib {
    // Initialization code
    
    self.iconImageView.layer.cornerRadius = 25.f;
    self.iconImageView.clipsToBounds = YES;
    self.concernButton.layer.cornerRadius = 5.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithModel:(ZanUserModel *)aModel
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:aModel.photo] placeholderImage:DEFAULT_HEADIMAGE];
    self.nameLabel.text = aModel.user_name;
    
    //只有未关注的时候才显示关注按钮
    
    if (aModel.flag == relation_concern_no) {
        
//        self.concernButton.hidden = NO;
        [self.concernButton setBackgroundColor:[UIColor colorWithHexString:@"e87f92"]];
        self.concernButton.selected = NO;
        
    }else
    {
//        self.concernButton.hidden = YES;
        [self.concernButton setBackgroundColor:[UIColor lightGrayColor]];
        self.concernButton.selected = YES;


    }
    
    //自己的时候 不显示关注按钮
    if ([aModel.friend_uid isEqualToString:[GMAPI getUid]]) {
        
        self.concernButton.hidden = YES;
    }
}

@end
