//
//  DynamicMessageCell.h
//  YiYiProject
//
//  Created by gaomeng on 15/4/21.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;


- (void)setCellWithModel:(id)aModel;

+ (CGFloat)heightForWithModel:(id)aModel;

@end
