//
//  GpinpaiDetailViewController.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GpinpaiDetailViewController.h"
#import "GmPrepareNetData.h"
#import "NSDictionary+GJson.h"
#import "GnearbyStoreViewController.h"
#import "GStorePinpaiViewController.h"
#import "GcustomStoreTableViewCell.h"
#import "EGORefreshTableHeaderView.h"

@interface GpinpaiDetailViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    
    
    GcustomStoreTableViewCell *_tmpCell;//用户获取自定义单元格高度
    
}
@end

@implementation GpinpaiDetailViewController




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTitleLabel.textColor = [UIColor whiteColor];
    self.myTitle = self.pinpaiName;
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = self.pinpaiIdStr;
    [self.view addSubview:label];
    
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    
    
    //下拉刷新
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0-_tableView.bounds.size.height, DEVICE_WIDTH, _tableView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_tableView addSubview:_refreshHeaderView];
    
    [self prepareNetData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareNetData{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *api = [NSString stringWithFormat:@"%@&brand_id=%@&page=1&per_page=100",HOME_CLOTH_PINPAI_STORELIST,self.pinpaiIdStr];
    
    NSLog(@"%@",api);
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",result);
        _dataArray = [result objectForKey:@"mall_list"];
        
        [_tableView reloadData];
        
        [self doneLoadingTableViewData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [GMAPI showAutoHiddenMBProgressWithText:@"加载数据失败，请下拉列表重新加载" addToView:self.view];
        NSLog(@"失败");
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 67;
//}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GcustomStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GcustomStoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    //数据源
    NSDictionary *dic = _dataArray[indexPath.row];
    
    
    
    //通过数据源加载数据
    [cell loadCustomCellWithDic:dic];
    
    
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellHeight = 0.0f;
    
    if (_tmpCell) {
        cellHeight = [_tmpCell loadCustomCellWithDic:_dataArray[indexPath.row]];
    }else{
        _tmpCell = [[GcustomStoreTableViewCell alloc]init];
        cellHeight = [_tmpCell loadCustomCellWithDic:_dataArray[indexPath.row]];
    }
    
    return cellHeight;
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = _dataArray[indexPath.row];
    
    GStorePinpaiViewController *cc = [[GStorePinpaiViewController alloc]init];
    cc.storeIdStr = [dic stringValueForKey:@"mall_id"];
    cc.pinpaiId = self.pinpaiIdStr;
    cc.pinpaiNameStr = self.pinpaiName;
    cc.storeNameStr = [dic stringValueForKey:@"mall_name"];
    cc.guanzhuleixing = @"品牌";
    [self.navigationController pushViewController:cc animated:YES];
    
    
}




#pragma mark -  下拉刷新代理
-(void)reloadTableViewDataSource{
    
    _reloading = YES;
}

-(void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == _tableView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
}


#pragma mark - EGORefreshTableDelegate

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
    
    
    _dataArray = nil;
    
    //网络请求
    [self prepareNetData];
    
    
    
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view;{
    return _reloading;
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
    return [NSDate date];
}




@end
