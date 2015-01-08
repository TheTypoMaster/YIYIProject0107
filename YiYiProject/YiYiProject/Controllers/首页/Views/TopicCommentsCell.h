//
//  TopicCommentsCell.h
//  YiYiProject
//
//  Created by soulnear on 14-12-28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

/*
 话题评论cell
 */

#import <UIKit/UIKit.h>
#import "TopicCommentsModel.h"
#import "OHAttributedLabel.h"
#import "OHLableHelper.h"

typedef enum{
    TopicCommentsCellClickTypeUser=0,///到个人中心的
    TopicCommentsCellClickTypeComment///回复这个人的
}TopicCommentsCellClickType;


typedef void(^TopicCommentsCellBlock)(TopicCommentsCellClickType aType,NSString * userName,NSString * uid,NSString * reply_id);


///对回复进行回复view
@interface SecondForwardView : UIView<OHAttributedLabelDelegate>
{
    TopicCommentsCellBlock SecondForwardView_block;
    
    NSArray * comments_array;
}

-(CGFloat)setupWithArray:(NSMutableArray *)array;

-(void)setSeconForwardViewBlock:(TopicCommentsCellBlock)aBlock;

@end




@interface TopicCommentsCell : UITableViewCell
{
    TopicCommentsCellBlock TopicCommentsCell_block;
    
    TopicCommentsModel * aModel;
}

///头像
@property (strong, nonatomic) IBOutlet UIImageView *header_imageView;

///昵称
@property (strong, nonatomic) IBOutlet UILabel *userName_label;

///时间
@property (strong, nonatomic) IBOutlet UILabel *date_label;
///内容
@property (strong, nonatomic) IBOutlet UILabel *content_label;
///对评论进行回复的内容
@property(nonatomic,strong)SecondForwardView * second_view;


///填充数据
-(void)setInfoWithCommentsModel:(TopicCommentsModel *)model;

-(void)setTopicCommentsCellBlock:(TopicCommentsCellBlock)aBlock;

@end
















