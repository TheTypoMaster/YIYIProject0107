//
//  BrandModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/4.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"
/**
 *  品牌model
 */
@interface BrandModel : BaseModel

@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *brand_name;
@property(nonatomic,retain)NSString *brand_logo;


@end
