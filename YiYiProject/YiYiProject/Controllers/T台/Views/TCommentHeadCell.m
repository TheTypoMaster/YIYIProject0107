//
//  TCommentHeadCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/5/7.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "TCommentHeadCell.h"
#import "TPlatModel.h"
#import "ZanUserModel.h"
#import "ProductModel.h"

@implementation TCommentHeadCell

- (void)awakeFromNib {
    // Initialization code
    
    self.iconImageView.layer.cornerRadius = 33/2.f;
    self.iconImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithModel:(id)aModel
{
    NSString *iconUrl = @"";
    NSString *userName = @"";
    NSString *desString = @"";//描述
    NSString *addtime = @"";
    
    if([aModel isKindOfClass:[TPlatModel class]]){
        
        TPlatModel *model = (TPlatModel *)aModel;
        desString = model.tt_content;//描述
        addtime = model.add_time;
//        if ([model.uinfo isKindOfClass:[NSDictionary class]]) {
        
            iconUrl = model.brand_logo;
            userName = model.brand_name;
            userName = [LTools isEmpty:userName] ? @"衣加衣-穿衣管家" : userName;
//        }
        
    }else if ([aModel isKindOfClass:[ProductModel class]])
    {
        
        ProductModel *model = (ProductModel *)aModel;
        desString = model.product_name;
        addtime = model.product_add_time;
        
        if ([model.brand_info isKindOfClass:[NSDictionary class]]) {
            
            iconUrl = model.brand_info[@"brand_logo"];
            userName = model.brand_info[@"brand_name"];
        }
    }
    
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:DEFAULT_HEADIMAGE];
    self.nameLabel.text = userName;
    
    self.timeLabel.text = [LTools timeString:addtime withFormat:@"MM月dd日 HH:mm"];
    
    //描述
    
    CGFloat aWidth = DEVICE_WIDTH - 10 - 50;//左侧距离50,右侧间距10
    CGFloat aHeight = [LTools heightForText:desString width:aWidth font:14];
    self.descriptionLabel.height = aHeight;
    self.descriptionLabel.text = desString;
    
    //隐藏评论和赞toolsView
    self.toolsView.hidden = YES;
    
    desString = [LTools stringHeadNoSpace:desString];
    if (desString.length == 0) {

        self.zanUserView.top = _iconImageView.bottom + 10;
        
    }else
    {
        self.zanUserView.top = _descriptionLabel.bottom + 10;
    }
    
//    //评论
//    
//    NSString *commentString = [NSString stringWithFormat:@"评论 %d",[aModel.tt_comment_num intValue]];
//    
//    aWidth = [LTools widthForText:commentString font:12.f];
//    
//    self.commentLabel.left = DEVICE_WIDTH - 10 - aWidth;
//    self.commentLabel.width = aWidth;
//    self.commentLabel.text = commentString;
//    self.commentButton.left = _commentLabel.left - _commentButton.width;
//    
//    //赞
//    NSString *zanString = [NSString stringWithFormat:@"赞 %@",aModel.tt_like_num];
//    aWidth = [LTools widthForText:zanString font:12];
//    self.zanLabel.width = aWidth;
//    self.zanLabel.left = _commentButton.left - 10 - _zanLabel.width;
//    self.zanButton.left = _zanLabel.left - _zanButton.width;
//    self.zanLabel.text = zanString;
    
}

+ (CGFloat)cellHeightForString:(NSString *)string
{
    CGFloat aWidth = DEVICE_WIDTH - 10 - 50;//左侧距离50,右侧间距10
    
    CGFloat aHeight = [LTools heightForText:string width:aWidth font:14];
    
    //描述文字以上高 52 底部toolsView 和 放置赞人员view 高 40
    
    string = [LTools stringHeadNoSpace:string];
    if (string.length == 0) {
        
        return 52 + 40;
    }
    
    return 52 + aHeight + 40 + 10;
}

- (void)addZanList:(NSArray *)zanList total:(int)total
{
    if (self.zanMiddleView) {
        [self.zanMiddleView removeFromSuperview];
        self.zanMiddleView = nil;
    }
    
    self.zanMiddleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _zanUserView.width - 20, _zanUserView.height - 1)];
    _zanMiddleView.backgroundColor = [UIColor clearColor];
    _zanMiddleView.userInteractionEnabled = NO;
    [_zanUserView addSubview:_zanMiddleView];
    
    NSString *likeStr = [NSString stringWithFormat:@"%d人觉得很赞",total];
    CGFloat aWidth = [LTools widthForText:likeStr font:12];

    UILabel *likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - 10 - aWidth - 15, 0, aWidth, _zanUserView.height)];
    likeLabel.textColor = [UIColor colorWithHexString:@"656565"];
    likeLabel.font = [UIFont systemFontOfSize:12];
    likeLabel.text = likeStr;
    [_zanMiddleView addSubview:likeLabel];
    
    for (int i = 0; i < zanList.count;i ++) {
        
        ZanUserModel *user  = [zanList objectAtIndex:i];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10 + (5 + 25) * i, 0, 25, 25)];
        icon.center = CGPointMake(icon.center.x, self.zanUserView.height/2.f);
        
        [_zanMiddleView addSubview:icon];
        
        [icon sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:DEFAULT_HEADIMAGE];
        [icon addRoundCorner];
        
        //不满足停止
        if (likeLabel.left - icon.right - 10 < 25 + 5) {
            
            break;
        }
        
    }
}

@end
