//
//  BigProductCell.h
//  YiYiProject
//
//  Created by lichaowei on 15/6/9.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  单品大图
 */
@interface BigProductCell : UITableViewCell

@property(nonatomic,retain)UIImageView *bigImageView;//大图
@property(nonatomic,retain)UIImageView *bottomMaskImageView;//底部阴影

@property(nonatomic,retain)UIImageView *discountImageView;//折后图标

@property(nonatomic,retain)UIView *bottomMaskView;//底部view

@property(nonatomic,retain)UIButton *zanButton;//赞

@property(nonatomic,retain)UIButton *xinButton;//点赞心形button

@property(nonatomic,retain)UILabel *zanNumLable;//赞数字

- (void)setCellWithModel:(id)aModel;

@end
