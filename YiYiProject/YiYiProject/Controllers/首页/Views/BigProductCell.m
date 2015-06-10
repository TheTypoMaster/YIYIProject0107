//
//  BigProductCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/6/9.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BigProductCell.h"
#import "ProductModel.h"

@implementation BigProductCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIButton *)zanButton
{
    if (!_zanButton) {
        
        self.zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _zanButton.frame = CGRectMake(DEVICE_WIDTH - 43 - 15, 25 * 2.5, 43, 43);
        [_zanButton addRoundCorner];
        [_zanButton setBorderWidth:1.f borderColor:[UIColor whiteColor]];
        _zanButton.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
        [self.bottomMaskView addSubview:_zanButton];
        
        //只是显示心形,不支持点击
//        21 18
        self.xinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xinButton setImage:[UIImage imageNamed:@"Ttai_zan_normal"] forState:UIControlStateNormal];
        [_xinButton setImage:[UIImage imageNamed:@"Ttai_zan_selected"] forState:UIControlStateSelected];
        _xinButton.frame = CGRectMake(0, 43 - 2 - 18, 21, 18);
        [_zanButton addSubview:_xinButton];
        _xinButton.center = CGPointMake(_zanButton.width/2.f, _xinButton.center.y);
        _xinButton.userInteractionEnabled = NO;
        
    }
    return _zanButton;
}

- (UILabel *)zanNumLable
{
    if (!_zanNumLable) {
        
        self.zanNumLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 43, 12)];
        _zanNumLable.font = [UIFont systemFontOfSize:11];
        _zanNumLable.textAlignment = NSTextAlignmentCenter;
        _zanNumLable.textColor = [UIColor whiteColor];
        [self.zanButton addSubview:_zanNumLable];
    }
    return _zanNumLable;
}

-(UIImageView *)discountImageView
{
    if (!_discountImageView) {
        
        self.discountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26, 13)];
        _discountImageView.image = [UIImage imageNamed:@"danpn_zhehou"];
        [self.bottomMaskView addSubview:_discountImageView];
    }
    return _discountImageView;
}

-(UIImageView *)bigImageView
{
    if (!_bigImageView) {
        
        self.bigImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_bigImageView];
    }
    return _bigImageView;
}

-(UIImageView *)bottomMaskImageView
{
    if (!_bottomMaskImageView) {
        
        self.bottomMaskImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"danpin_bg"]];
        [self.contentView addSubview:_bottomMaskImageView];
    }
    return _bottomMaskImageView;
}

-(UIView *)bottomMaskView
{
    if (!_bottomMaskView) {
        
        self.bottomMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 25 * 5)];
        [self.contentView addSubview:_bottomMaskView];
        
        NSArray *images = @[[UIImage imageNamed:@"danpin_pinpai"],[UIImage imageNamed:@"danpin_price"],[UIImage imageNamed:@"danpin_discount"],[UIImage imageNamed:@"danpin_distance"],[UIImage imageNamed:@"danpin_location"]];
        
        for (int i = 0; i < images.count; i ++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, (15 + 10) * i, 15, 15)];
            imageView.image = images[i];
            [_bottomMaskView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 10, imageView.top, DEVICE_WIDTH - imageView.right - 10 - 20, 15)];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            [_bottomMaskView addSubview:label];
            label.tag = 100 + i;
        }
    }
    return _bottomMaskView;
}

- (void)setCellWithModel:(ProductModel *)aModel
{
    NSString *imageurl;
    CGFloat imageH = 0.f;
    if (aModel.imagelist.count >= 1) {
        
        NSDictionary *imageDic = aModel.imagelist[0];
        NSDictionary *middleImage = imageDic[@"540Middle"];
        imageurl = middleImage[@"src"];
        float image_width = [middleImage[@"width"]floatValue];
        float image_height = [middleImage[@"height"]floatValue];
        
        imageH = [LTools heightForImageHeight:image_height imageWidth:image_width originalWidth:DEVICE_WIDTH];
    }
    [self.bigImageView setImageWithURL:[NSURL URLWithString:imageurl] placeHolderText:@"加载失败..." backgroundColor:[UIColor whiteColor] holderTextColor:[UIColor lightGrayColor]];
    
    self.bigImageView.frame = CGRectMake(0, 0, DEVICE_WIDTH, imageH);
    
    self.bottomMaskImageView.frame = CGRectMake(0, imageH - 194, DEVICE_WIDTH, 194);
    
    self.bottomMaskView.frame = CGRectMake(0, imageH - 25 * 5, DEVICE_WIDTH, 25 * 5);
    
    NSLog(@"zan %@",aModel.product_like_num);
    
    self.zanNumLable.text = [NSString stringWithFormat:@"%d",[aModel.product_like_num intValue]];
    
    self.xinButton.selected = aModel.is_like == 1 ? YES : NO;

    
    for (int i = 0; i < 5; i ++) {
        UILabel *label = (UILabel *)[self.bottomMaskView viewWithTag:100 + i];
        
        if (i == 0) {
            label.text = aModel.brand_info[@"brand_name"];
        }else if (i == 1){
            
            NSString *price = [NSString stringWithFormat:@"%@元",aModel.product_price];
            label.text = price;
            
            CGFloat width = [LTools widthForText:price font:14];
            label.width = width;
            
            if (aModel.discount_num == 1) {
                //无折扣
                self.discountImageView.hidden = YES;
            }else
            {
                self.discountImageView.hidden = NO;
                self.discountImageView.left = label.right;
                self.discountImageView.top = label.top - 2;
            }
            
        }else if (i == 2){
            NSString *discount = nil;
            if (aModel.discount_num == 1) {
                
                discount = @"暂无折扣";
                
            }else
            {
                discount = [NSString stringWithFormat:@"%.1f折",aModel.discount_num * 10];

            }
            label.text = discount;
            
            
        }else if (i == 3){
            NSString *distanceStr;
            
            double dis = [aModel.distance doubleValue];
            
            if (dis > 1000) {
                
                distanceStr = [NSString stringWithFormat:@"%.1fkm",dis/1000];
            }else
            {
                distanceStr = [NSString stringWithFormat:@"%@m",aModel.distance];
            }
            label.text = distanceStr;
        }else if (i == 4){
            NSString *address = aModel.mall_name;

            label.text = address;
        }
    }

}

@end
