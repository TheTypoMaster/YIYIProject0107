//
//  HuoDongListTableViewCell.m
//  YiYiProject
//
//  Created by szk on 15/1/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "HuoDongListTableViewCell.h"

//#import "LTools.h"

@implementation HuoDongListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

  self=  [super init];
    
    if (self) {
        [self setAllViews];
    }
    
    return self;

}

-(void)setAllViews{
    
//    self.titleLabel=[LTools createLabelFrame:CGRectMake(0, 0, 0, 0) title:@"" font:16 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    
    


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
