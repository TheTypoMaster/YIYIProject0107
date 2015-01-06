//
//  GShowStarsView.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//


//显示星星的自定义view

#import <UIKit/UIKit.h>

@interface GShowStarsView : UIView




///星星的宽度
@property(nonatomic,assign)float starWidth;
///最多几个星星
@property(nonatomic,assign)int maxStartNum;


///下列属性都需要设置---------------- 设置完这些属性之后  调用 updateStartNum方法 更新view信息

///星星的个数
@property(nonatomic,assign)float startNum;

///整颗星的图片名字
@property(nonatomic,strong)NSString *starNameStr;

///半颗星的图片名字
@property(nonatomic,strong)NSString *star_halfNameStr;








///初始化方法  num:底层星星总个数 最大星星个数   theBackStarNameStr:底层星星图片名  theStarWidth:星星宽度 theFrame:整个view的frame 星星的高度为frame的高度
-(GShowStarsView*)initWithStartNum:(int)num Frame:(CGRect)theFrame starBackName:(NSString *)theBackStarNameStr starWidth:(CGFloat)theStarWidth;


//填充数据
-(void)updateStartNum;

@end
