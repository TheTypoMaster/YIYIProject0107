//
//  GRootScrollView.h
//  YiYiProject
//
//  Created by gaomeng on 15/1/4.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GtopScrollView;


typedef void(^pinpaiClick)(NSString *pinpaiId,NSString *pinpaiName);//品牌楼层block
typedef void(^shenqingDianpuBlock)(NSIndexPath *indexPath,NSInteger tableViewTag);//申请店铺block

typedef enum{
    GROOTTYPENULL = 0,
    GROOTFLOOR ,
    GROOTPINPAI,
    GROOTSHENQINGDIANPU,
}GROOTTYPE;

@interface GRootScrollView : UIScrollView<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>



@property(nonatomic,assign)CGFloat userContentOffsetX;
@property(nonatomic,strong)NSArray *viewNameArray;
@property(nonatomic,assign)BOOL isLeftScroll;
@property(nonatomic,assign)GtopScrollView *myTopScrollView;


@property(nonatomic,strong)NSMutableArray *tabelViewArray;//所有的tableview数组
@property(nonatomic,strong)NSMutableArray *dataArray;//数据源 二维数组
@property(nonatomic,assign)GROOTTYPE theGRootScrollType;
@property(nonatomic,copy)pinpaiClick thePinpaiBlock;
@property(nonatomic,copy)shenqingDianpuBlock theShenqingDianpuBlock;

- (void)initWithViews;

-(void)setThePinpaiBlock:(pinpaiClick)thePinpaiBlock;
-(void)setTheShenqingDianpuBlock:(shenqingDianpuBlock)theShenqingDianpuBlock;

-(void)GreloadData;


@end
