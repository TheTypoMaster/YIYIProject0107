//
//  MallListViewController.m
//  YiYiProject
//
//  Created by lichaowei on 15/8/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MallListViewController.h"
#import "RefreshTableView.h"
#import "MallCell.h"

@interface MallListViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
}

@end

@implementation MallListViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    _table.dataSource = nil;
    _table.refreshDelegate = nil;
    _table = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(235, 235, 235);
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.myTitle = @"所在商场";
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,DEVICE_HEIGHT - 64)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_table];
    
    [_table showRefreshHeader:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  获取单品同款
 */
- (void)networkForDetailSameStyle
{
    __weak typeof(self)weakSelf = self;
    __weak typeof(_table)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:HOME_PRODUCT_DETAIL_SAME_STYLE,_longtitude,_latitude,self.product_id];
    url = [NSString stringWithFormat:@"%@&page=%d&per_page=%d",url,1,30];

    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        NSArray *list = result[@"list"];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:list.count];
        for (NSDictionary *aDic in list) {
            ProductModel *aModel = [[ProductModel alloc]initWithDictionary:aDic];
            [temp addObject:aModel];
        }
        [weakTable reloadData:temp pageSize:30];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [weakTable loadFail];
    }];
}

#pragma - mark RefreshDelegate

-(void)loadNewData
{
    [self networkForDetailSameStyle];
}

-(void)loadMoreData
{
    [self networkForDetailSameStyle];
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    //调转至老版本 详情页
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProductModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    int shopType = [aModel.mall_type intValue];
    [MiddleTools pushToStoreDetailVcWithId:aModel.mall_id shopType:shopType storeName:aModel.mall_name brandName:aModel.brand_name fromViewController:self lastNavigationHidden:NO hiddenBottom:NO isTPlatPush:NO];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return 40;
}

#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"MallCell";
    
    MallCell *cell = (MallCell *)[LTools cellForIdentify:identify cellName:identify forTable:tableView];
    
    ProductModel *aModel = _table.dataArray[indexPath.row];
    
    //距离
    NSString *distanceStr;
    double dis = [aModel.distance doubleValue];
    
    if (dis > 1000) {
        
        distanceStr = [NSString stringWithFormat:@" %.1fkm",dis/1000];
    }else
    {
        distanceStr = [NSString stringWithFormat:@" %@m",aModel.distance];
    }

    NSString *name = [NSString stringWithFormat:@"%@-%@ %@",aModel.brand_name,aModel.mall_name,distanceStr];
    

    NSRange range = [name rangeOfString:distanceStr];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:name];
    [attributedString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:range];
    [cell.nameLabel setAttributedText:attributedString1];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",aModel.product_price];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
        [_table setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //按照作者最后的意思还要加上下面这一段
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        
        [cell setPreservesSuperviewLayoutMargins:NO];
        
    }
    
}

@end
