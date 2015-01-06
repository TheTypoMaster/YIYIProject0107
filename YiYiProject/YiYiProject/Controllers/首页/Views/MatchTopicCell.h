//
//  MatchTopicCell.h
//  YiYiProject
//
//  Created by soulnear on 14-12-20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//
/*
 搭配师界面，话题自定义cell
 */

#import <UIKit/UIKit.h>
#import "MatchTopicModel.h"

@interface MatchTopicCell : UITableViewCell

///分割线
@property (strong, nonatomic) IBOutlet UILabel *line_view;
///头像
@property (strong, nonatomic) IBOutlet UIImageView *header_imageView;
///昵称
@property (strong, nonatomic) IBOutlet UILabel *user_name_label;
///时间图片
@property (strong, nonatomic) IBOutlet UIImageView *date_imageView;
///时间
@property (strong, nonatomic) IBOutlet UILabel *date_label;
///评论图片
@property (strong, nonatomic) IBOutlet UIImageView *pinglun_imageView;

///评论数
@property (strong, nonatomic) IBOutlet UILabel *pinglun_label;
///标题
@property (strong, nonatomic) IBOutlet UILabel *title_label;

@property (strong, nonatomic) IBOutlet UIImageView *jiantou_imageView;



-(void)setInfoWith:(MatchTopicModel *)model;




@end
