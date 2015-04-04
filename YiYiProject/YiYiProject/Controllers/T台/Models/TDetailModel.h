//
//  TDetailModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/6.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"

/**
 *  t台详情model
 */
@interface TDetailModel : BaseModel

@property(nonatomic,retain)NSString *tt_id;
@property(nonatomic,retain)NSString *img_url;
@property(nonatomic,retain)NSString *tt_content;
@property(nonatomic,retain)NSString *uid;
@property(nonatomic,retain)NSString *add_time;
@property(nonatomic,retain)NSArray *tt_detail;//t台详情 数组
@property(nonatomic,retain)NSString *tt_like_num;
@property(nonatomic,retain)NSString *tt_share_num;
@property(nonatomic,retain)NSString *tt_comment_num;
@property(nonatomic,retain)NSDictionary *image;//图片字典
@property(nonatomic,retain)NSDictionary *uinfo;//用户信息
@property(nonatomic,assign)int is_like;

//史忠坤修改
@property(nonatomic,assign)int have_detail;

@property(nonatomic,strong)NSArray *img_detail;
//end

@end
