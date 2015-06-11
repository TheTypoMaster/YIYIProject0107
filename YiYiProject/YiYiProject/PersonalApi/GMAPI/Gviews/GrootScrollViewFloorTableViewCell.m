//
//  GrootScrollViewFloorTableViewCell.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GrootScrollViewFloorTableViewCell.h"
#import "NSDictionary+GJson.h"

@implementation GrootScrollViewFloorTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





-(void)loadCustomViewWithDicData:(NSDictionary *)dic{
    //logo
    UIImageView *logoImv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 70, 70)];
    logoImv.layer.cornerRadius = 35;
    logoImv.layer.borderWidth = 1;
    logoImv.layer.masksToBounds = YES;
    logoImv.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    
    [logoImv sd_setImageWithURL:[NSURL URLWithString:[dic stringValueForKey:@"brand_logo"]] placeholderImage:nil];
    
    //name
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImv.frame)+10, logoImv.frame.origin.y+17, self.bounds.size.width-logoImv.frame.size.width -17, 18)];
    nameLabel.textColor = RGBCOLOR(35, 36, 37);
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = [dic stringValueForKey:@"brand_name"];
    
    
    
    
    
    //门牌号
    NSString *menpaihao = [dic stringValueForKey:@"doorno"];
    //活动
    NSDictionary *huodongDic = [dic dictionaryValueForKey:@"activity"];
    NSString *huodong = nil;
    if (huodongDic) {
        huodong = [huodongDic stringValueForKey:@"activity_title"];
    }else{
        huodong = @"";
    }
    
    //号码 活动
    UILabel *activeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+7, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    activeLabel.font = [UIFont systemFontOfSize:15];
    
    NSString *aaa = [NSString stringWithFormat:@"%@   %@",menpaihao,huodong];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:aaa];
    NSInteger haomaLength = menpaihao.length;
    NSInteger huodongLength = huodong.length;
    [title addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(73, 74, 75) range:NSMakeRange(0,haomaLength)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,haomaLength)];
    
    [title addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(235,203,77) range:NSMakeRange(haomaLength+3, huodongLength)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(haomaLength+3, huodongLength)];
    activeLabel.attributedText = title;
    
    
    [self.contentView addSubview:logoImv];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:activeLabel];
    
    
}




@end
