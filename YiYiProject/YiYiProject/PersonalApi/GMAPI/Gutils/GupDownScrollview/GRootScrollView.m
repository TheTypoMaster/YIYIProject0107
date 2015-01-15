//
//  GRootScrollView.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/4.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GRootScrollView.h"
#import "GtopScrollView.h"
#import "NSDictionary+GJson.h"
#import "GrootScrollViewFloorTableViewCell.h"
#import "GshenqingdianpuTableViewCell.h"


#define POSITIONID (int)(scrollView.contentOffset.x/self.frame.size.width)
#define GrootScrollViewHeight self.frame.size.height
#define GtopHeight 28


@implementation GRootScrollView

- (void)dealloc
{
    
    NSLog(@"%s",__FUNCTION__);
    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor lightGrayColor];
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.userContentOffsetX = 0;
        self.tabelViewArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}


- (void)initWithViews
{
    
    
    
    if (self.theGRootScrollType == GROOTSHENQINGDIANPU) {//申请店铺
        //楼层
        for (int i = 0; i<[self.myTopScrollView.nameArray count]; i++) {
            UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0+self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
            tab.backgroundColor = RGBCOLOR(248, 248, 248);
            tab.tag = 200+i;
            tab.delegate = self;
            tab.dataSource = self;
            [self.tabelViewArray addObject:tab];
            if (i==0) {
                
            }
            [self addSubview:tab];
            
        }
        self.contentSize = CGSizeMake(self.frame.size.width*[self.myTopScrollView.nameArray count], self.frame.size.height);
    }else if (self.theGRootScrollType == GROOTFLOOR) {//楼层
        for (int i = 0; i<[self.myTopScrollView.nameArray count]; i++) {
            UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0+self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
            tab.backgroundColor = RGBCOLOR(248, 248, 248);
            tab.tag = 200+i;
            tab.delegate = self;
            tab.dataSource = self;
            [self.tabelViewArray addObject:tab];
            if (i==0) {
                
            }
            [self addSubview:tab];
            
        }
        self.contentSize = CGSizeMake(self.frame.size.width*[self.myTopScrollView.nameArray count], self.frame.size.height);
    }
    
    
    
    
    
    
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.userContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.userContentOffsetX < scrollView.contentOffset.x) {
        self.isLeftScroll = YES;
    }
    else {
        self.isLeftScroll = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];
    
    [self GreloadData];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self GreloadData];
}

-(void)GreloadData
{
//    CGFloat pagewidth = self.frame.size.width;
//    int page = floor((self.contentOffset.x - pagewidth/self.viewNameArray.count)/pagewidth)+1;
//    UILabel *label = (UILabel *)[self viewWithTag:page+200];
//    label.text = [NSString stringWithFormat:@"%@",[self.viewNameArray objectAtIndex:page]];
    
    CGFloat pageWidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pageWidth/self.myTopScrollView.nameArray.count)/pageWidth)+1;
    UITableView *tab = (UITableView *)[self viewWithTag:page+200];
    [tab reloadData];
    
    
}

//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    [self.myTopScrollView setButtonUnSelect];
    self.myTopScrollView.scrollViewSelectedChannelID = POSITIONID+100;
    [self.myTopScrollView setButtonSelect];
    if (self.theGRootScrollType != GROOTSHENQINGDIANPU) {//不是申请店铺界面
        [self.myTopScrollView setScrollViewContentOffset];
    }
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
    
    
    NSArray *dataArray = self.dataArray[tableView.tag-200];
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.theGRootScrollType == GROOTFLOOR) {//楼层
        static NSString *identifier = @"nearbypinpai";
        GrootScrollViewFloorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GrootScrollViewFloorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        //数据源
        NSArray *dataArray = self.dataArray[tableView.tag-200];
        NSDictionary *dic = dataArray[indexPath.row];
        //加载视图
        [cell loadCustomViewWithDicData:dic];
        
        return cell;
        
    }else if (self.theGRootScrollType == GROOTSHENQINGDIANPU){//申请店铺
        static NSString *identifier = @"shenqingdianpu";
        GshenqingdianpuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GshenqingdianpuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        [cell loadCustomViewWithData:nil];
        
        return cell;
        
        
    }
    
    
    return [[UITableViewCell alloc]init];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.theGRootScrollType == GROOTFLOOR) {//品牌
        NSArray *dataArray = self.dataArray[tableView.tag-200];
        NSDictionary *dicInfo = dataArray[indexPath.row];
        NSString *storeIdStr = [dicInfo stringValueForKey:@"brand_id"];
        NSLog(@"商城id:%@",storeIdStr);
        NSDictionary *dic = dataArray[indexPath.row];
        NSString *pinpaiNameStr = [dic stringValueForKey:@"brand_name"];
        if (self.thePinpaiBlock) {
            self.thePinpaiBlock(storeIdStr,pinpaiNameStr);
        }
    }else if (self.theGRootScrollType == GROOTSHENQINGDIANPU){//申请店铺
        if (self.theShenqingDianpuBlock) {
            self.theShenqingDianpuBlock(indexPath,tableView.tag);
        }
    }
    
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0f;
    if (self.theGRootScrollType == GROOTFLOOR) {
        height = 90;
    }
    return height;
}


//显示不全不显示
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(void)setThePinpaiBlock:(pinpaiClick)thePinpaiBlock{
    _thePinpaiBlock = thePinpaiBlock;
}
-(void)setTheShenqingDianpuBlock:(shenqingDianpuBlock)theShenqingDianpuBlock{
    _theShenqingDianpuBlock = theShenqingDianpuBlock;
}


@end
