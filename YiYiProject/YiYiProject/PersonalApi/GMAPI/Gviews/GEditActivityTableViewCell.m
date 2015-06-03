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
    UIImageView *picImv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 50)];
    [picImv sd_setImageWithURL:[NSURL URLWithString:aModel.cover_pic] placeholderImage:[UIImage imageNamed:@"activity_defaultCover"]];
    [self.contentView addSubview:picImv];
    
    //标题
    CGFloat left = picImv.right + 5;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(left, picImv.frame.origin.y, DEVICE_WIDTH - left - 65, picImv.frame.size.height*0.5)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = aModel.activity_title;
    [self.contentView addSubview:titleLabel];
    
    //附加信息
    
    NSString *timeString = [NSString stringWithFormat:@"活动时间:%@ - %@",[LTools timeString:aModel.start_time withFormat:@"YYYY.MM.dd"],[LTools timeString:aModel.end_time withFormat:@"YYYY.MM.dd"]];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame), titleLabel.frame.size.width, titleLabel.frame.size.height)];
    detailLabel.text = timeString;
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.numberOfLines = 2;
    [self.contentView addSubview:detailLabel];
    
    
    //按钮
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [editBtn setTitle:@"修改" forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"gdanpinxiugai.png"] forState:UIControlStateNormal];
    
    editBtn.titleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:editBtn];
    editBtn.tag = theIndexPath.row+10;
    [editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setFrame:CGRectMake(DEVICE_WIDTH-60, 0, 60, 90)];
    [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:editBtn];
    
    editBtn.center = CGPointMake(editBtn.centerX, picImv.center.y);
}




-(void)editBtnClicked:(UIButton *)sender{
    [self.delegate editBtnClickedWithTag:sender.tag];
}





@end
