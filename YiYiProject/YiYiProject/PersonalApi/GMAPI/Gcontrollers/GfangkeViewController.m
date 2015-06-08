//
//  GfangkeViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/5/11.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GfangkeViewController.h"
#import "GrefreshTableView.h"
#import "NSDictionary+GJson.h"
@interface GfangkeViewController ()<GrefreshDelegate,UITableViewDataSource>
{
    GrefreshTableView *_tableView;//主tableview
    
    int _page;//第几页
    int _pageCapacity;//每页几个
    NSArray *_dataArray;//数据源
}
@end

@implementation GfangkeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
}


-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    _tableView.dataSource = nil;
    _tableView.GrefreshDelegate = nil;
    _tableView = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",self.shop_id);
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myTitleLabel.text = @"访客列表";
    self.myTitleLabel.textColor = RGBCOLOR(252, 76, 139);
    
    
    _tableView = [[GrefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    _tableView.GrefreshDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _pageCapacity = 20;
    [_tableView showRefreshHeader:YES];
    
}


//请求网络数据
-(void)prepareNetData{
    
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@&authcode=%@&page=%d&per_page=%d",FANGKE_MYSHOP,self.shop_id,[GMAPI getAuthkey],_page,_pageCapacity];
    
    LTools *ccc = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"店铺访客:%@",result);
        NSArray *arr = [result arrayValueForKey:@"list"];
        
        if (arr.count < _pageCapacity) {
            
            _tableView.isHaveMoreData = NO;
        }else
        {
            _tableView.isHaveMoreData = YES;
        }
        
        
        [self reloadData:arr isReload:_tableView.isReloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        if (_tableView.isReloadData) {
            _page --;
            [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:0.1];
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
    
    NSDictionary *dic = _dataArray[indexPath.row];
    
    NSString *uid = [dic stringValueForKey:@"uid"];
    
    if ([uid isEqualToString:@"0"]) {
        
        [LTools showMBProgressWithText:@"不能查看未识别身份游客信息" addToView:self.view];
        
        return;
    }
    
    [MiddleTools pushToPersonalId:uid userType:G_Other forViewController:self lastNavigationHidden:NO];
    
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    
    //头像
    UIImageView *touxiangImv = [[UIImageView alloc]initWithFrame:CGRectMake(12, 5, 50, 50)];
    touxiangImv.layer.cornerRadius = 25;
    touxiangImv.layer.borderWidth = 0.5;
    touxiangImv.layer.borderColor = [[UIColor grayColor]CGColor];
    touxiangImv.layer.masksToBounds = YES;
    [cell.contentView addSubview:touxiangImv];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0,74,0,0);
    
    //名称
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(touxiangImv.frame)+12, 5, DEVICE_WIDTH-74-12, 25)];
    nameLable.font = [UIFont boldSystemFontOfSize:15];
    nameLable.textColor = [UIColor blackColor];
    [cell.contentView addSubview:nameLable];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLable.frame.origin.x, CGRectGetMaxY(nameLable.frame), nameLable.frame.size.width, nameLable.frame.size.height)];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:timeLabel];
    
    
    
    //数据填充
    
    NSDictionary *dic = _dataArray[indexPath.row];
    [touxiangImv sd_setImageWithURL:[NSURL URLWithString:[dic stringValueForKey:@"photo"]] placeholderImage:nil];
    nameLable.text = [dic stringValueForKey:@"user_name"];
    NSString *timestr = [dic stringValueForKey:@"view_time"];
    timeLabel.text = [GMAPI timechangeAll:timestr];
    [cell.contentView addSubview:nameLable];
    
    
    
    
    
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
