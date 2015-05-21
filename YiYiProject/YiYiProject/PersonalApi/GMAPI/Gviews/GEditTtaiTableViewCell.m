//
//  GEditTtaiTableViewCell.m
//  YiYiProject
//
//  Created by gaomeng on 15/5/19.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GEditTtaiTableViewCell.h"
#import "GEditMyTtaiViewController.h"
#import "NSDictionary+GJson.h"

@implementation GEditTtaiTableViewCell
{
    NSIndexPath *_flagIndex;
    UIButton *_chooseBtn;
    int _theType;//0正常 1上下架  2删除
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




-(void)loadCustomViewWithData:(TPlatModel*)aModel indexpath:(NSIndexPath*)theIndexPath withType:(int)thetype{
    
    _flagIndex = theIndexPath;
    _theType = thetype;
    
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 90)];
    [self.contentView addSubview:backView];
    
    
    if (thetype == 0) {//正常状态
        
    }else if (thetype == 1 || thetype == 2){//上下架  删除
        [backView setFrame:CGRectMake(60, 0, DEVICE_WIDTH, 90)];
        
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn setFrame:CGRectMake(0, 0, 60, 90)];
        _chooseBtn.backgroundColor = [UIColor whiteColor];
        
        [_chooseBtn setImage:[UIImage imageNamed:@"xuanze_up_44_44.png"] forState:UIControlStateNormal];
        for (NSIndexPath *ip in self.delegate.indexes) {
            if (ip.row == theIndexPath.row && ip.section == theIndexPath.section) {
                [_chooseBtn setImage:[UIImage imageNamed:@"xuanze_down_44_44.png"] forState:UIControlStateNormal];
            }
        }
        [_chooseBtn addTarget:self action:@selector(chooseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_chooseBtn];
    }
    
    
    
    //图片
    UIImageView *picImv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 70)];
    NSString *imageName = [aModel.image stringValueForKey:@"url"];
    [picImv sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
    [backView addSubview:picImv];
    
    //发表时间
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(picImv.frame)+5, picImv.frame.origin.y, DEVICE_WIDTH-10-60-10, picImv.frame.size.height*0.5)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = [NSString stringWithFormat:@"发布时间：%@",[GMAPI timechangeAll:aModel.add_time]];
    [backView addSubview:titleLabel];
    
    //附加信息 锚点个数
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame), titleLabel.frame.size.width, titleLabel.frame.size.height)];
    NSArray *maodianArray = [aModel.image arrayValueForKey:@"img_detail"];
    detailLabel.text = [NSString stringWithFormat:@"链接个数：%lu",(unsigned long)maodianArray.count];
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.font = [UIFont systemFontOfSize:13];
    detailLabel.numberOfLines = 2;
    [backView addSubview:detailLabel];
    
    
    //按钮
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"gdanpinxiugai.png"] forState:UIControlStateNormal];
    [backView addSubview:editBtn];
    editBtn.tag = theIndexPath.row+10;
    [editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setFrame:CGRectMake(DEVICE_WIDTH-60, 0, 60, 90)];
    [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:editBtn];
    
    
}

-(void)chooseBtnClicked{
    BOOL isHave = NO;
    for (NSIndexPath *ip in self.delegate.indexes) {
        if (ip.row == _flagIndex.row && ip.section == _flagIndex.section) {
            [self.delegate.indexes removeObject:ip];
            [_chooseBtn setImage:[UIImage imageNamed:@"xuanze_up_44_44.png"] forState:UIControlStateNormal];
            isHave = YES;
            break;
        }
    }
    
    if (!isHave) {
        [self.delegate.indexes addObject:_flagIndex];
        [_chooseBtn setImage:[UIImage imageNamed:@"xuanze_down_44_44.png"] forState:UIControlStateNormal];
    }
    
    
    NSInteger count = self.delegate.indexes.count;
    self.delegate.numLabel.text = [NSString stringWithFormat:@"确认删除(%ld)",count];
    
}

-(void)editBtnClicked:(UIButton *)sender{
    
    [self.delegate editTtaiWithTag:sender.tag];
}



@end
