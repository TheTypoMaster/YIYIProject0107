//
//  MyConcernController.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyConcernController.h"
#import "RefreshTableView.h"

#import "ShopViewCell.h"
#import "BrandViewCell.h"

@interface MyConcernController ()<RefreshDelegate,UITableViewDataSource>
{
    UIButton *heartButton;
    UIView *indicator;
    UIScrollView *bgScroll;
    RefreshTableView *shopTable;//店铺table
    RefreshTableView *brandTable;//品牌table
    
    BOOL isEditing;//是否处于编辑状态
    
}

@end

@implementation MyConcernController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden=NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBCOLOR(200, 200, 200);
    
    self.myTitleLabel.text = @"我的关注";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    [self createNavigationbarTools];
    [self createSegButton];
    [self createViews];
    
    [self getBrand];
    [self getShop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求

/**
 *  取消关注 品牌
 */
- (void)cancelConcernBrand:(UIButton *)sender
{
    int index = (int)sender.tag - 100000;
    BrandModel *aModel = brandTable.dataArray[index];
    
    __weak typeof(self)weakSelf = self;
    //测试
    NSString *authkey = [GMAPI getAuthkey];
    
    NSString *post = [NSString stringWithFormat:@"brand_id=%@&authcode=%@",aModel.id,authkey];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@&%@",MY_CONCERN_BRAND_CANCEL,post];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        [weakSelf refreshBrandList:index];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
    }];
    
}

/**
 *  取消关注 商家
 */
- (void)cancelConcernMail:(UIButton *)sender
{
    int index = (int)sender.tag - 100;
    MailModel *aModel = shopTable.dataArray[index];
    
    __weak typeof(self)weakSelf = self;
    
    //测试
    NSString *authkey = [GMAPI getAuthkey];
    NSString *post = [NSString stringWithFormat:@"mall_id=%@&authcode=%@",aModel.mall_id,authkey];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
    NSString *url = [NSString stringWithFormat:MY_CONCERN_MAIL_CANCEL];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        //刷新数据
        [weakSelf refreshMailList:index];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
    }];
    
}

/**
 *  获取品牌
 */
- (void)getBrand
{
    //关注接口:http://182.92.158.32/index.php?d=api&c=brand&m=attend_brand&authcode=AX4BeFojV7EBulfKVuYJ3lP2V7UB9Ar7Ay5WZ1YzBDJabAAyWzhcZgM1V2RTMgp6BTFWaA==&brand_id=
    
    NSString *url = [NSString stringWithFormat:MY_CONCERN_BRAND,[GMAPI getAuthkey],brandTable.pageNum];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        NSArray *brand_data = result[@"brand_data"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *aDic in brand_data) {
            
            BrandModel *aModel = [[BrandModel alloc]initWithDictionary:aDic];
            [arr addObject:aModel];
        }
        
//        int count = [result[@"count"] intValue];
        
        BOOL isHaveMore = YES;
        
        if (arr.count < L_PAGE_SIZE) {
            
            isHaveMore = NO;
        }
        
        [brandTable reloadData:arr isHaveMore:isHaveMore];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
//        [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
        
        [brandTable loadFail];
    }];
}
/**
 *  获取商家
 */
- (void)getShop
{
    NSString *url = [NSString stringWithFormat:MY_CONCERN_SHOP,[GMAPI getAuthkey],shopTable.pageNum,L_PAGE_SIZE];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        id list = result[@"list"];
        NSArray *temp_arr;
        if ([list isKindOfClass:[NSArray class]]) {
            
            temp_arr = [NSArray arrayWithArray:list];
        }else if([list isKindOfClass:[NSDictionary class]]){
            
            temp_arr = [NSArray arrayWithArray:((NSDictionary *)list).allValues];
        }
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:temp_arr.count];
        for (NSDictionary *aDic in temp_arr) {
            
            MailModel *aModel = [[MailModel alloc]initWithDictionary:aDic];
            [arr addObject:aModel];
        }
        
        [shopTable reloadData:arr total:100];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
//        [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
        
        [shopTable loadFail];
    }];
}

#pragma mark - 创建视图

- (void)createNavigationbarTools
{
    UIButton *rightView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightView.backgroundColor=[UIColor clearColor];
    
    heartButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [heartButton addTarget:self action:@selector(clickToEdit:) forControlEvents:UIControlEventTouchUpInside];
    [heartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [heartButton setTitle:@"编辑" forState:UIControlStateNormal];
    [heartButton  setTitle:@"完成" forState:UIControlStateSelected];
    [heartButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightView addSubview:heartButton];
    
    UIBarButtonItem *comment_item=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = comment_item;
}

- (void)createSegButton
{
    UIView *segView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 58)];
    segView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:segView];
    
    NSArray *titles = @[@"商家",@"品牌"];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.frame = CGRectMake(DEVICE_WIDTH/2.f * i, 0, DEVICE_WIDTH/2.f, 45);
        [btn setBackgroundColor:[UIColor whiteColor]];
        [segView addSubview:btn];
        [btn addTarget:self action:@selector(clickToSwap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    indicator = [[UIView alloc]initWithFrame:CGRectMake(0, 43, DEVICE_WIDTH/2.f, 2)];
    indicator.backgroundColor = [UIColor colorWithHexString:@"ea5670"];
    [segView addSubview:indicator];
}

- (void)createViews
{
    bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 58, DEVICE_WIDTH, self.view.height - 58)];
    [self.view addSubview:bgScroll];
    bgScroll.contentSize = CGSizeMake(DEVICE_WIDTH * 2, bgScroll.height);
    
    //店铺
    shopTable = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, bgScroll.height) showLoadMore:YES];
    shopTable.refreshDelegate = self;
    shopTable.dataSource = self;
    [bgScroll addSubview:shopTable];
    shopTable.backgroundColor = [UIColor clearColor];
    shopTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //品牌
    brandTable = [[RefreshTableView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, bgScroll.height) showLoadMore:YES];
    brandTable.refreshDelegate = self;
    brandTable.dataSource = self;
    [bgScroll addSubview:brandTable];
    brandTable.backgroundColor = [UIColor clearColor];
    brandTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 事件处理
/**
 *  刷新品牌列表
 *
 *  @param brandIndex 品牌下标
 */
- (void)refreshBrandList:(int)brandIndex
{
    [brandTable.dataArray removeObjectAtIndex:brandIndex];
    [brandTable reloadData];
}

/**
 *  刷新商家列表
 *
 *  @param mailIndex 商家下标
 */
- (void)refreshMailList:(int)mailIndex
{
    [shopTable.dataArray removeObjectAtIndex:mailIndex];
    [shopTable reloadData];
}

- (UIButton *)buttonForTag:(int)tag
{
    return (UIButton *)[self.view viewWithTag:tag];
}

- (void)clickToSwap:(UIButton *)sender
{
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:100];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
    if (sender.tag == 100) {
        btn1.selected = YES;
        btn2.selected = NO;
        indicator.left = 0;
        bgScroll.contentOffset = CGPointMake(0, 0);
    }else
    {
        btn1.selected = NO;
        btn2.selected = YES;
        indicator.left = DEVICE_WIDTH/2.f;
        bgScroll.contentOffset = CGPointMake(DEVICE_WIDTH, 0);
    }
}

- (void)clickToEdit:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    isEditing = sender.selected;
    
    [shopTable reloadData];
    [brandTable reloadData];
}

#pragma mark - 代理

#pragma - mark RefreshDelegate

- (void)loadNewData
{
    if ([self buttonForTag:100]) {
        
        [self getShop];
    }
    
    if ([self buttonForTag:101]) {
        
        [self getBrand];
    }
}
- (void)loadMoreData
{
//    [self loadNewData];
    
    if ([self buttonForTag:100]) {
        
        [self getShop];
    }
    
    if ([self buttonForTag:101]) {
        
        [self getBrand];
    }
}

//新加
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if (tableView == shopTable) {
        
        return 60;
    }
    return 90;
}

#pragma - mark UItableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ShopViewCell";
    
    if (tableView == shopTable) {
        
        ShopViewCell *cell = (ShopViewCell *)[LTools cellForIdentify:identify cellName:identify forTable:tableView];
        
        MailModel *aModel = shopTable.dataArray[indexPath.row];
        
        [cell setCellWithModel:aModel];
        
        cell.cancelButton.tag = 100 + indexPath.row;
        
        [cell.cancelButton addTarget:self action:@selector(cancelConcernMail:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.cancelButton.hidden = !isEditing;
        
        return cell;
        
    }
    
    static NSString *identify2 = @"BrandViewCell";
    BrandViewCell *cell = (BrandViewCell *)[LTools cellForIdentify:identify2 cellName:identify2 forTable:brandTable];
    BrandModel *aBrand = brandTable.dataArray[indexPath.row];

    [cell setCellWithModel:aBrand];
    cell.cancelButton.hidden = !isEditing;
    cell.cancelButton.tag = 100000 + indexPath.row;
    
    [cell.cancelButton addTarget:self action:@selector(cancelConcernBrand:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == shopTable) {
        
        return shopTable.dataArray.count;
    }
    
    return brandTable.dataArray.count;
}

@end
