//
//  TopicParseModel.h
//  YiYiProject
//
//  Created by lichaowei on 15/1/10.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseModel.h"
/**
 *  话题解析model
 */
@interface TopicParseModel : BaseModel

@property(nonatomic,retain)NSString *CELL_TEXT;//内容文字 或者 图片压缩地址
@property(nonatomic,assign)CGFloat IMAGE_WIDTH_ORIGINAL;//原图宽度
@property(nonatomic,assign)CGFloat CELL_NEW_HEIGHT;//实际高度
@property(nonatomic,assign)CGFloat CELL_NEW_WIDTH;//实际宽度
@property(nonatomic,retain)NSString *IMAGE_ORIGINAL_URL;//原图地址
@property(nonatomic,assign)CGFloat IMAGE_HEIGHT_ORIGINAL;//图片原始高度

@end
