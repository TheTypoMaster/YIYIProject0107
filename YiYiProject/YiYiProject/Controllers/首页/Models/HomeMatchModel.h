//
//  HomeMatchModel.h
//  YiYiProject
//
//  Created by soulnear on 14-12-16.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface HomeMatchModel : BaseModel

///星级
@property(nonatomic,strong)NSString * grade;
///昵称
@property(nonatomic,strong)NSString * name;
///用户id
@property(nonatomic,strong)NSString * uid;
///用户头像
@property(nonatomic,strong)NSString * photo;
@end
