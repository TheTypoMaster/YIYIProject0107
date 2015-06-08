//
//  GmyShopHuiyuanViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/16.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GmyShopHuiyuanViewController.h"
#import "GrefreshTableView.h"
#import "NSDictionary+GJson.h"
#import "YIYIChatViewController.h"

@interface GmyShopHuiyuanViewController ()<GrefreshDelegate,UITableViewDataSource>

{
    GrefreshTableView *_tableView;//主tableview
    
    int _page;//第几页
    int _pageCapacity;//每页几个
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
    
    _pageCapacity = 20;
    [_tableView showRefreshHeader:YES];
    
    
}


//请求网络数据
-(void)prepareNetData{
    
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@&page=%d&per_page=%d",GMYSHOPHUIYUANLIST,self.mallInfo.id,_page,_pageCapacity];
    
    LTools *ccc = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"收藏我的店铺的人:%@",result);
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
    YIYIChatViewController *contact = [[YIYIChatViewController alloc]init];
    contact.GTitleLabel.text = [dic stringValueForKey:@"user_name"];
    contact.currentTarget = [dic stringValueForKey:@"uid"];
    contact.portraitStyle = RCUserAvatarCycle;
    contact.enableSettings = NO;
    contact.conversationType = ConversationType_PRIVATE;
    
    [self.navigationController pushViewController:contact animated:YES];
    
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
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(touxiangImv.frame)+12, 10, DEVICE_WIDTH-74-12, 32)];
    nameLable.font = [UIFont boldSystemFontOfSize:15];
    nameLable.textColor = [UIColor blackColor];
    [cell.contentView addSubview:nameLable];
    
    
    //数据填充
    
    NSDictionary *dic = _dataArray[indexPath.row];
    [touxiangImv sd_setImageWithURL:[NSURL URLWithString:[dic stringValueForKey:@"photo"]] placeholderImage:nil];
    nameLable.text = [dic stringValueForKey:@"user_name"];
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
