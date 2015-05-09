//
//  TPlatCommentCell.h
//  YiYiProject
//
//  Created by lichaowei on 15/5/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicCommentsModel.h"
#import "OHAttributedLabel.h"
#import "OHLableHelper.h"

typedef enum{
    TPlatCommentCellClickType_UserCenter = 0, ///到个人中心的
    TPlatCommentCellClickType_Comment ///回复这个人的
}TPlatCommentCellClickType;

typedef void(^TPlatCommentCellBlock)(TPlatCommentCellClickType aType,NSString * userName,NSString * uid,NSString * reply_id);


///对回复进行回复view
@interface TPlatSecondForwardView : UIView<OHAttributedLabelDelegate>
{
    TPlatCommentCellBlock SecondForwardView_block;
    
    NSArray * comments_array;
}

-(CGFloat)setupWithArray:(NSMutableArray *)array;

-(void)setSeconForwardViewBlock:(TPlatCommentCellBlock)aBlock;

@end



//############################# cell



@interface TPlatCommentCell : UITableViewCell<OHAttributedLabelDelegate>

{
    TPlatCommentCellBlock TopicCommentsCell_block;
    
    TopicCommentsModel * aModel;
}

///头像
@property (strong, nonatomic) IBOutlet UIImageView *header_imageView;

///内容
@property (strong, nonatomic) IBOutlet UILabel *content_label;

///对评论进行回复的内容
@property(nonatomic,strong)TPlatSecondForwardView * second_view;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;


///填充数据
-(void)setInfoWithCommentsModel:(TopicCommentsModel *)model;

-(void)setTopicCommentsCellBlock:(TPlatCommentCellBlock)aBlock;

//计算高度
+ (CGFloat)heightForCellWithModel:(TopicCommentsModel *)model;

@end
