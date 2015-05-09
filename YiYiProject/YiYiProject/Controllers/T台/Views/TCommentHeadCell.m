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

- (void)setCellWithModel:(TPlatModel *)aModel
{
    NSString *iconUrl = @"";
    NSString *userName = @"";
    if ([aModel.uinfo isKindOfClass:[NSDictionary class]]) {
        
        iconUrl = aModel.uinfo[@"photo"];
        userName = aModel.uinfo[@"user_name"];
    }
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:DEFAULT_HEADIMAGE];
    self.nameLabel.text = userName;
    
//    @"YYYY-MM-dd HH:mm:ss"
    self.timeLabel.text = [LTools timeString:aModel.add_time withFormat:@"MM月dd日 HH:mm"];
    
    //描述
    
    CGFloat aWidth = DEVICE_WIDTH - 10 - 50;//左侧距离50,右侧间距10
    NSString *desString = aModel.tt_content;
    
    CGFloat aHeight = [LTools heightForText:desString width:aWidth font:14];
    self.descriptionLabel.height = aHeight;
    
    self.descriptionLabel.text = desString;
    
    //隐藏评论和赞toolsView
    self.toolsView.hidden = YES;
    
    desString = [LTools stringHeadNoSpace:desString];
    if (desString.length == 0) {
        
//        self.toolsView.top = _iconImageView.bottom + 10;
        
        self.zanUserView.top = _iconImageView.bottom + 10;
        
    }else
    {
//        self.toolsView.top = _descriptionLabel.bottom;
        self.zanUserView.top = _descriptionLabel.bottom + 10;
    }
    
    //工具
    
    //放置赞人员view
    
//    self.zanUserView.top = _toolsView.bottom;
    
    //评论
    
    NSString *commentString = [NSString stringWithFormat:@"评论 %d",[aModel.tt_comment_num intValue]];
    
    aWidth = [LTools widthForText:commentString font:12.f];
    
    self.commentLabel.left = DEVICE_WIDTH - 10 - aWidth;
    self.commentLabel.width = aWidth;
    self.commentLabel.text = commentString;
    
    self.commentButton.left = _commentLabel.left - _commentButton.width;

    
    //赞
    NSString *zanString = [NSString stringWithFormat:@"赞 %@",aModel.tt_like_num];
    aWidth = [LTools widthForText:zanString font:12];
    self.zanLabel.width = aWidth;
    
    self.zanLabel.left = _commentButton.left - 10 - _zanLabel.width;

    
    self.zanButton.left = _zanLabel.left - _zanButton.width;
    
    self.zanLabel.text = zanString;
    
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
    NSString *likeStr = [NSString stringWithFormat:@"%d人觉得很赞",total];
    CGFloat aWidth = [LTools widthForText:likeStr font:12];

    UILabel *likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - 10 - aWidth - 15, 0, aWidth, _zanUserView.height)];
    likeLabel.textColor = [UIColor colorWithHexString:@"656565"];
    likeLabel.font = [UIFont systemFontOfSize:12];
    likeLabel.text = likeStr;
    [_zanUserView addSubview:likeLabel];
    
    for (int i = 0; i < zanList.count;i ++) {
        
        ZanUserModel *user  = [zanList objectAtIndex:i];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10 + (5 + 25) * i, 0, 25, 25)];
        icon.center = CGPointMake(icon.center.x, self.zanUserView.height/2.f);
        
        [_zanUserView addSubview:icon];
        
        [icon sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:DEFAULT_HEADIMAGE];
        [icon addRoundCorner];
        
        //不满足停止
        if (likeLabel.left - icon.right - 10 < 25 + 5) {
            
            break;
        }
        
    }
}

@end
