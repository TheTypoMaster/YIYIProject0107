//
//  GEditProductTableViewCell.m
//  YiYiProject
//
//  Created by gaomeng on 15/3/25.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GEditProductTableViewCell.h"
#import "GmyproductsListViewController.h"

@implementation GEditProductTableViewCell
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



-(void)loadCustomViewWithData:(ProductModel*)aModel indexpath:(NSIndexPath*)theIndexPath withType:(int)thetype{
    
    _flagIndex = theIndexPath;
    _theType = thetype;
    NSArray *imageArray = aModel.imagelist;
    
    
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
    [backView addSubview:picImv];
    if (imageArray.count>0) {
        NSDictionary *imageDic = imageArray[0];
        NSDictionary *nameDic = imageDic[@"540Middle"];
        NSString *imageName = nameDic[@"src"];
        [picImv sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
    }
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(picImv.frame)+5, picImv.frame.origin.y, DEVICE_WIDTH-10-60-10, picImv.frame.size.height*0.5)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = aModel.product_name;
    [backView addSubview:titleLabel];
    
    //附加信息
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame), titleLabel.frame.size.width, titleLabel.frame.size.height)];
    detailLabel.text = [NSString stringWithFormat:@"%@ %@",aModel.product_price,aModel.product_tag];
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.numberOfLines = 2;
    [backView addSubview:detailLabel];
    
    
    //按钮
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitle:@"修改" forState:UIControlStateNormal];
    editBtn.titleLabel.textColor = [UIColor grayColor];
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
    
    if (_theType == 1) {//上下架
        if (self.delegate.selectIndex == 100) {//线上产品
            self.delegate.numLabel.text = [NSString stringWithFormat:@"确认下架(%ld)",count];
        }else if (self.delegate.selectIndex == 101){//仓库产品
            self.delegate.numLabel.text = [NSString stringWithFormat:@"确认上架(%ld)",count];
        }
        
    }else if (_theType == 2){//删除
        self.delegate.numLabel.text = [NSString stringWithFormat:@"确认删除(%ld)",count];
    }
    
}

-(void)editBtnClicked:(UIButton *)sender{
    [self.delegate editProductWithTag:sender.tag];
}



@end
