//
//  GmyActivetiesViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/3/25.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GmyActivetiesViewController.h"
#import "RefreshTableView.h"
#import "GEditActivityTableViewCell.h"
#import "MessageDetailController.h"
#import "GupActivityViewController.h"

@interface GmyActivetiesViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_tableView;
    int _page;//第几页
    NSArray *_dataArray;//数据源
}
@end

@implementation GmyActivetiesViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    self.myTitle = @"管理活动";
    [self creatTableView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNewData) name:NOTIFICATION_FABUHUODONG_SUCCESS object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creatTableView{
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    _tableView.refreshDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView showRefreshHeader:YES];
}

//请求网络数据
-(void)prepareNetData{
    NSString *key = [GMAPI getAuthkey];
    NSString *url = [NSString stringWithFormat:GET_MAIL_ACTIVITY_LIST,key,_tableView.pageNum,L_PAGE_SIZE];
    
    LTools *ccc = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *list = result[@"activities"];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *aDic in list) {
                ActivityModel *aModel = [[ActivityModel alloc]initWithDictionary:aDic];
                [arr addObject:aModel];
            }
            
//            [self reloadData:arr isReload:YES];
            [_tableView reloadData:arr pageSize:L_PAGE_SIZE];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        if (_tableView.isReloadData) {
            _page --;
            [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
        }
        
    }];
}



#pragma mark - 下拉刷新上提加载更多
/**
 *  刷新数据列表
 *
 *  @param dataArr  新请求的数据
 *  @param isReload 判断在刷新或者加载更多
 */
- (void)reloadData:(NSArray *)dataArr isReload:(BOOL)isReload
{
    if (isReload) {
        
        _dataArray = dataArr;
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _dataArray = newArr;
    }
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:0.1];
}



#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    _page = 1;
    
    [self prepareNetData];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    _page ++;
    
    [self prepareNetData];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__FUNCTION__);
    //跳转活动详情页
    ActivityModel *aModel = _tableView.dataArray[indexPath.row];
    MessageDetailController *detail = [[MessageDetailController alloc]init];
    detail.msg_id = aModel.id;
    detail.isActivity = YES;
    detail.shopName = self.mallInfo.shop_name;
    detail.shopImageUrl = self.mallInfo.logo;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


#pragma mark -  UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GEditActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GEditActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.delegate = self;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    ActivityModel *amodel = _tableView.dataArray[indexPath.row];
    
    [cell loadCustomViewWithData:amodel indexpath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableView.dataArray.count;
}




-(void)editBtnClickedWithTag:(NSInteger)theTag{
    
    ActivityModel *amodel = _tableView.dataArray[theTag-10];
    GupActivityViewController *ccc = [[GupActivityViewController alloc]init];
    ccc.userInfo = self.userInfo;
    ccc.mallInfo = self.mallInfo;
    ccc.thetype = GUPACTIVITYTYPE_EDIT;
    ccc.theEditActivity = amodel;
    [self.navigationController pushViewController:ccc animated:YES];
}



@end
