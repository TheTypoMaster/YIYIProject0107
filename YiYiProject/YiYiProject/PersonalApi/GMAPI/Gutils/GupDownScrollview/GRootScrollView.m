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
//    for (int i = 0; i < [self.viewNameArray count]; i++) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0+320*i, 0, 320, GrootScrollViewHeight)];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont boldSystemFontOfSize:50.0];
//        label.tag = 200 + i;
//        if (i == 0) {
//            label.text = [self.viewNameArray objectAtIndex:i];
//        }
//        [self addSubview:label];
//    }
//    self.contentSize = CGSizeMake(320*[self.viewNameArray count], GrootScrollViewHeight);
    
    
    if (self.theGRootScrollType == GROOTPINPAI) {//品牌
        
    }
    
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
    
    [self loadData];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self loadData];
}

-(void)loadData
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
    [self.myTopScrollView setScrollViewContentOffset];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
    
    
    NSArray *dataArray = self.dataArray[tableView.tag-200];
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    //数据源
    NSArray *dataArray = self.dataArray[tableView.tag-200];
    NSDictionary *dic = dataArray[indexPath.row];
    
    
    //logo
    UIImageView *logoImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 70, 70)];
    logoImv.layer.cornerRadius = 35;
    logoImv.layer.borderWidth = 1;
    logoImv.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    
    NSLog(@"%@",[dic objectForKey:@"brand_logo"]);
    [logoImv sd_setImageWithURL:[NSURL URLWithString:[dic stringValueForKey:@"brand_logo"]] placeholderImage:nil];
    
    //name
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImv.frame)+10, logoImv.frame.origin.y+17, cell.bounds.size.width-logoImv.frame.size.width -17, 18)];
//    nameLabel.backgroundColor = [UIColor orangeColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = [dic stringValueForKey:@"brand_name"];
    
    
    //号码 活动
    UILabel *activeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+7, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    activeLabel.text = @"B2016   满100减30";
    
    
    [cell.contentView addSubview:logoImv];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:activeLabel];
    
    cell.contentView.backgroundColor = RGBCOLOR(248, 248, 248);
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *dataArray = self.dataArray[tableView.tag-200];
    NSDictionary *dicInfo = dataArray[indexPath.row];
    NSString *storeIdStr = [dicInfo stringValueForKey:@"brand_id"];
    NSLog(@"商城id:%@",storeIdStr);
    NSDictionary *dic = dataArray[indexPath.row];
    NSString *pinpaiNameStr = [dic stringValueForKey:@"brand_name"];
    self.thePinpaiBlock(storeIdStr,pinpaiNameStr);
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
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



@end
