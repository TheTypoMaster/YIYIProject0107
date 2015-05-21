//
//  GEditMyTtaiViewController.h
//  YiYiProject
//
//  Created by gaomeng on 15/5/19.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//编辑T台
#import <UIKit/UIKit.h>
typedef enum{
    PILIANGTYPE_NONE = 0,
    PILIANGTYPE_UPDOWN,
    PILIANGTYPE_DELETE
}PILIANGTYPE;
@interface GEditMyTtaiViewController : MyViewController

@property(nonatomic,strong)UILabel *numLabel;//记录批量操作时选中了多少个
@property(nonatomic,strong)NSMutableArray *indexes;//记录点击要批量操作的单元格index数组
@property(nonatomic,assign)PILIANGTYPE piliangType;//批量操作的类型

//cell的回调 跳转T台编辑界面
-(void)editTtaiWithTag:(NSInteger)theTag;


@end
