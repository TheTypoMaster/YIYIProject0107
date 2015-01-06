//
//  GLeadbuyTableViewCell.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

//带你去买地图vc 下面弹出框内的tableview 自定义cell

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "UILabel+GautoMatchedText.h"
@interface GLeadbuyTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *titielImav;//图标
@property(nonatomic,strong)UILabel *contentLabel;//内容labal




//加载控件
-(void)loadViewWithIndexPath:(NSIndexPath*)theIndexPath;

//填充数据
-(CGFloat)configWithDataModel:(BMKPoiInfo*)poiModel indexPath:(NSIndexPath*)TheIndexPath;


@end
