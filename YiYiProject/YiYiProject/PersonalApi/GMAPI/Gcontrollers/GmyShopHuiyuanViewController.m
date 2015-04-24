//
//  GmyShopHuiyuanViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/16.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GmyShopHuiyuanViewController.h"
#import "GrefreshTableView.h"

@interface GmyShopHuiyuanViewController ()<GrefreshDelegate,UITableViewDataSource>

{
    GrefreshTableView *_tableView;//主tableview
    
    int _page;//第几页
    NSArray *_dataArray;//数据源
}

@end

@implementation GmyShopHuiyuanViewController


-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    _tableView.dataSource = nil;
    _tableView.GrefreshDelegate = nil;
    _tableView = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:self.lastPageNavigationHidden animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.myTitleLabel.text = @"店铺会员";
    self.myTitleLabel.textColor = RGBCOLOR(252, 76, 139);
    
    
    _tableView = [[GrefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    _tableView.GrefreshDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView showRefreshHeader:YES];
    
    
}


//请求网络数据
-(void)prepareNetData{
    
    NSString *url = [NSString stringWithFormat:@"%@&mall_id=%@",GMYSHOPHUIYUANLIST,self.mallInfo.mall_id];
    
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:nil postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"关注我的店铺的人:%@",result);
        
        
//        [self reloadData:arr isReload:YES];
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
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
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
    
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


#pragma mark -  UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
