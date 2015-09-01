//
//  GTtaiNearActivViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/8/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GTtaiNearActivViewController.h"
#import "GTtaiNearActOneView.h"
#import "RefreshTableView.h"
#import "MessageDetailController.h"

@interface GTtaiNearActivViewController ()<RefreshDelegate,UITableViewDataSource>
{
    LTools *_tool_detail;
    RefreshTableView *_refreshTab;
    
}
@end

@implementation GTtaiNearActivViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.myTitle = @"附近活动";
    
    [self creatTab];
    
}


-(void)creatTab{
    _refreshTab = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64) style:UITableViewStylePlain];
    _refreshTab.refreshDelegate = self;
    _refreshTab.dataSource = self;
    _refreshTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_refreshTab showRefreshHeader:YES];
    [self.view addSubview:_refreshTab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)prepareNetData{
    GMAPI *gmapi = [GMAPI sharedManager];
    NSDictionary *locationDic = gmapi.theLocationDic;
    NSString *longStr = [locationDic stringValueForKey:@"long"];
    NSString *latStr = [locationDic stringValueForKey:@"lat"];
    
    NSString *url = [NSString stringWithFormat:@"%@&long=%@&lat=%@&page=%d&per_page=%d",HOME_TTAI_ACTIVITY,longStr,latStr,_refreshTab.pageNum,L_PAGE_SIZE];
    
    _tool_detail = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [_tool_detail requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSArray *arr = [result arrayValueForKey:@"list"];
        NSMutableArray *viewsArray1 = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dic in arr) {
            
            ActivityModel *amodel = [[ActivityModel alloc]initWithDictionary:dic];
            GTtaiNearActOneView *view = [[GTtaiNearActOneView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 60) huodongModel:amodel type:@"活动列表"];
            view.backgroundColor = RGBCOLOR(239, 239, 239);
            [viewsArray1 addObject:view];
        }
        
        
        [_refreshTab reloadData:viewsArray1 pageSize:L_PAGE_SIZE];
        
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
        [_refreshTab loadFail];
        
    }];
}



#pragma mark - RefreshDelegate && UITableViewDataSource

- (void)loadNewDataForTableView:(UITableView *)tableView{
    [self prepareNetData];
}
- (void)loadMoreDataForTableView:(UITableView *)tableView{
    [self prepareNetData];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;{
    NSLog(@"%s",__FUNCTION__);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GTtaiNearActOneView *amodel = _refreshTab.dataArray[indexPath.row];
    
    NSString *activityId = amodel.activity_Id;
    MessageDetailController *detail = [[MessageDetailController alloc]init];
    detail.isActivity = YES;
    detail.msg_id = activityId;
    [self.navigationController pushViewController:detail animated:YES];
    
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _refreshTab.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *view = _refreshTab.dataArray[indexPath.row];
    view.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = RGBCOLOR(241, 242, 244);
    [cell.contentView addSubview:view];
    
    
    return cell;
}




@end
