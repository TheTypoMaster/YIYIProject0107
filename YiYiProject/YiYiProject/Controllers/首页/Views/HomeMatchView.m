//
//  HomeMatchView.m
//  YiYiProject
//
//  Created by soulnear on 14-12-16.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "HomeMatchView.h"
#import "GShowStarsView.h"

@implementation HomeMatchView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    
    return self;
}

-(void)setupWithArray:(NSMutableArray *)array WithTitle:(NSString *)aTitle WithShowApplyView:(BOOL)show WithMyBlock:(HomeMatchViewBlock)aBlock
{
    home_match_view_block = aBlock;
    
    UIScrollView * myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,self.height)];
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.contentSize = CGSizeMake(20+(80+13)*array.count,0);
    [self addSubview:myScrollView];
    
    for (int i = 0;i< array.count;i++)
    {
        HomeMatchModel * model = [array objectAtIndex:i];
        
        UIView * content_view = [[UIView alloc] initWithFrame:CGRectMake(10+(80+13)*i,50,80,140)];
        [myScrollView addSubview:content_view];
        
        UIImageView * header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,0,70,70)];
        header_imageView.backgroundColor = [UIColor grayColor];
        header_imageView.layer.masksToBounds = YES;
        header_imageView.layer.cornerRadius = 35;
        header_imageView.userInteractionEnabled = YES;
        header_imageView.tag = 100 + i + 1;
        [header_imageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil];
        [content_view addSubview:header_imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [header_imageView addGestureRecognizer:tap];
        
        UILabel * user_name_label = [[UILabel alloc] initWithFrame:CGRectMake(5,header_imageView.height+7,70,18)];
        user_name_label.text = model.name;
        user_name_label.textAlignment = NSTextAlignmentCenter;
        user_name_label.textColor = [UIColor blackColor];
        user_name_label.font = [UIFont systemFontOfSize:14];
        [content_view addSubview:user_name_label];
        
        GShowStarsView * show_stars_view = [[GShowStarsView alloc] initWithStartNum:5 Frame:CGRectMake(5,header_imageView.height+28,70,12) starBackName:@"stars_unselected_image.png" starWidth:12];
        show_stars_view.startNum = [model.grade intValue];
        show_stars_view.starNameStr = @"stars_selected_image.png";
        show_stars_view.star_halfNameStr = @"stars_half_image.png";
        [content_view addSubview:show_stars_view];
        ///重置星星
        [show_stars_view updateStartNum];
    }
    
    
    if ([aTitle isEqualToString:@"我的搭配师"] && array.count == 0)
    {
        UILabel * tishi_label = [[UILabel alloc] initWithFrame:CGRectMake(10,100,DEVICE_WIDTH-20,40)];
        tishi_label.text = @"关注搭配师，即可成为我的搭配师";
        tishi_label.textColor = [UIColor blackColor];
        tishi_label.textAlignment = NSTextAlignmentCenter;
        tishi_label.font = [UIFont systemFontOfSize:18];
        [self addSubview:tishi_label];
    }
    
    
    ///红色的竖线
    UIView * ver_view = [[UIView alloc] initWithFrame:CGRectMake(20,17,3,20)];
    ver_view.backgroundColor = RGBCOLOR(235,77,104);
    ver_view.layer.masksToBounds = YES;
    ver_view.layer.cornerRadius = 1;
    [self addSubview:ver_view];
    
    
    UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(30,17,150,20)];
    title_label.text = aTitle;
    title_label.textAlignment = NSTextAlignmentLeft;
    title_label.textColor = RGBCOLOR(66,66,66);
    title_label.font = [UIFont systemFontOfSize:17];
    [self addSubview:title_label];
    
    
    if (show) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(DEVICE_WIDTH-85-15,12,85.0,30);
        [button setTitle:@"申请搭配师" forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(235,77,104) forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 8;
        button.layer.borderColor = RGBCOLOR(235,77,104).CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.borderWidth = 1;
        [button addTarget:self action:@selector(applyMatchTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)applyMatchTap:(UIButton *)button
{
    home_match_view_block(0);
}

-(void)doTap:(UITapGestureRecognizer *)sender
{
    home_match_view_block((int)(sender.view.tag - 100));
}



@end
