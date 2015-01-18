//
//  EditInfoView.h
//  YiYiProject
//
//  Created by 王龙 on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditInfoView : UIView
@property (strong, nonatomic) IBOutlet UIView *headView; //头像view
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (strong, nonatomic) IBOutlet UIView *nickerView;//昵称view
@property (strong, nonatomic) IBOutlet UITextField *nickerTf;//昵称
@property (strong, nonatomic) IBOutlet UIView *sexView;//性别view
@property (strong, nonatomic) IBOutlet UIButton *manBtn;//男
@property (strong, nonatomic) IBOutlet UIButton *womanBtn; //女
@property (strong, nonatomic) IBOutlet UIView *birthViiew;//生日view
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;//生日

-(void)setPropertiesUi;


@end
