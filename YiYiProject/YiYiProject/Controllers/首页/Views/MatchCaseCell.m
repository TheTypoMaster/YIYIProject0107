//
//  MatchCaseCell.m
//  YiYiProject
//
//  Created by soulnear on 14-12-21.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "MatchCaseCell.h"



@implementation MatchCaseCell

- (void)awakeFromNib {
    // Initialization code
    
}



-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        ///用户头像
        _header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,35,35)];
        _header_imageView.layer.masksToBounds = YES;
        _header_imageView.layer.cornerRadius = _header_imageView.width/2.0f;
        [self addSubview:_header_imageView];
        
        _userName_label = [[UILabel alloc] initWithFrame:CGRectMake(56,10,100,35)];
        _userName_label.textAlignment = NSTextAlignmentLeft;
        _userName_label.textColor = [UIColor blackColor];
        _userName_label.font = [UIFont systemFontOfSize:17];
        [self addSubview:_userName_label];
        
        _pic_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,50,PIC_WIDTH,0)];
        [self addSubview:_pic_imageView];
    }
    
    return self;
}



-(void)setContentWithModel:(MatchCaseModel *)model
{
    [_header_imageView sd_setImageWithURL:[NSURL URLWithString:model.u_photo] placeholderImage:nil];
    _userName_label.text = model.name;
    
    
//    _pic_imageView.height = PIC_WIDTH*([model.tt_img_height floatValue])/[model.tt_img_width floatValue];
    _pic_imageView.height = [model.tt_img_height floatValue]/2.0;
    [_pic_imageView sd_setImageWithURL:[NSURL URLWithString:model.t_img] placeholderImage:nil];
}


@end
