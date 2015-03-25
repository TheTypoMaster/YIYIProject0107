//
//  GEditActivityTableViewCell.m
//  YiYiProject
//
//  Created by gaomeng on 15/3/25.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GEditActivityTableViewCell.h"

#import "GmyActivetiesViewController.h"

@implementation GEditActivityTableViewCell
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



-(void)loadCustomViewWithData:(ActivityModel*)aModel indexpath:(NSIndexPath*)theIndexPath{
    //图片
    UIImageView *picImv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 70)];
    [picImv sd_setImageWithURL:[NSURL URLWithString:aModel.pic] placeholderImage:nil];
    [self.contentView addSubview:picImv];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(picImv.frame)+5, picImv.frame.origin.y, DEVICE_WIDTH-65-65, picImv.frame.size.height*0.5)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = aModel.activity_title;
    [self.contentView addSubview:titleLabel];
    
    //附加信息
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame), titleLabel.frame.size.width, titleLabel.frame.size.height)];
    detailLabel.text = aModel.activity_info;
    detailLabel.font = [UIFont systemFontOfSize:14];
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.numberOfLines = 2;
    [self.contentView addSubview:detailLabel];
    
    
    //按钮
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitle:@"修改" forState:UIControlStateNormal];
    editBtn.titleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:editBtn];
    editBtn.tag = theIndexPath.row+10;
    [editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setFrame:CGRectMake(DEVICE_WIDTH-60, 0, 60, 90)];
    [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:editBtn];
}




-(void)editBtnClicked:(UIButton *)sender{
    [self.delegate editBtnClickedWithTag:sender.tag];
}





@end
