//
//  GEditMyTtaiViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/5/19.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GEditMyTtaiViewController.h"
#import "RefreshTableView.h"
#import "TTaiDetailController.h"
#import "GEditTtaiTableViewCell.h"
#import "NSDictionary+GJson.h"
#import "GTTPublishViewController.h"

@interface GEditMyTtaiViewController ()<UITableViewDataSource,RefreshDelegate>
{
    RefreshTableView *_refreshTableView;
    
    UIButton* _my_right_button;//右边按钮
    
    UIView *_dview;//下面删除view
    
}



@end

@implementation GEditMyTtaiViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    _refreshTableView.dataSource = nil;
    _refreshTableView.refreshDelegate = nil;
    _refreshTableView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self creatTheView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editTtaiSuccess) name:NOTIFICATION_TTAI_EDIT_SUCCESS object:nil];
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 通知方法

//编辑T台成功后刷新数据
-(void)editTtaiSuccess{
    
    [_refreshTableView showRefreshHeader:YES];
}






#pragma mark - 界面初始化
-(void)creatTheView{
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTitleLabel.text = @"修改T台";
    self.myTitleLabel.textColor = RGBCOLOR(252, 76, 139);
    _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    _my_right_button.frame = CGRectMake(0,0,60,44);
    _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    [_my_right_button setTitle:@"批量删除" forState:UIControlStateNormal];
    _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_my_right_button setTitleColor:RGBCOLOR(253, 106, 157) forState:UIControlStateNormal];
    [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
    
    self.indexes = [NSMutableArray arrayWithCapacity:1];
    
    _refreshTableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    _refreshTableView.dataSource = self;
    _refreshTableView.refreshDelegate = self;
    [self.view addSubview:_refreshTableView];
    [_refreshTableView showRefreshHeader:YES];
    
    [self creatDview];
    
    
}




#pragma mark - 批量删除界面处理

//底部删除view
-(void)creatDview{
    _dview = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT-64, DEVICE_WIDTH, 60)];
    _dview.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_dview];
    
    
    //红色view
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(30, 10, DEVICE_WIDTH-60, 40)];
    redView.userInteractionEnabled = YES;
    redView.backgroundColor = RGBCOLOR(235, 77, 104);
    redView.layer.cornerRadius = 4;
    [_dview addSubview:redView];
    
    
    //编辑状态下的计数Label
    self.numLabel = [[UILabel alloc]initWithFrame:redView.bounds];
    self.numLabel.font = [UIFont systemFontOfSize:12];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(numLabelClicked)];
    [self.numLabel addGestureRecognizer:tap];
    self.numLabel.userInteractionEnabled = YES;
    self.numLabel.textColor = [UIColor whiteColor];
    [redView addSubview:self.numLabel];
    
    
}

-(void)showDview{
    self.indexes = [NSMutableArray arrayWithCapacity:1];
    self.numLabel.text = @"确认删除()";
    [UIView animateWithDuration:0.2 animations:^{
        [_dview setFrame:CGRectMake(0, DEVICE_HEIGHT-64-60, DEVICE_WIDTH, 60)];
    } completion:^(BOOL finished) {
        
    }];
}


-(void)hideenDview{
    [self.indexes removeAllObjects];
    
    [UIView animateWithDuration:0.2 animations:^{
        [_dview setFrame:CGRectMake(0, DEVICE_HEIGHT-64, DEVICE_WIDTH, 60)];
    } completion:^(BOOL finished) {
        
    }];
}


//完成编辑之后改变界面效果
-(void)editFinishAndChangeView{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self hideenDview];
    self.piliangType = PILIANGTYPE_NONE;
    [_my_right_button setTitle:@"批量操作" forState:UIControlStateNormal];
    [_refreshTableView showRefreshHeader:YES];
    
    
    
}

//确认批量编辑
-(void)numLabelClicked{
    if (self.piliangType == PILIANGTYPE_DELETE) {//批量删除
        NSLog(@"%@",self.indexes);
        NSLog(@"批量删除");
        NSMutableArray *productIdArray = [NSMutableArray arrayWithCapacity:1];
        for (NSIndexPath *ip in self.indexes) {
            TPlatModel *amodel = _refreshTableView.dataArray[ip.row];
            [productIdArray addObject:amodel.tt_id];
        }
        if (productIdArray.count>0) {
            NSString *deleteTtaiIdStr = [productIdArray componentsJoinedByString:@","];
            NSLog(@"需要删除的产品id:%@",deleteTtaiIdStr);
            [self gDeletTtaiWithIdStr:deleteTtaiIdStr];
        }else{
            [self editFinishAndChangeView];
        }
        
    }
    
}


//navigation 右侧按钮
-(void)rightButtonTap:(UIButton *)sender
{
    
    if ([sender.titleLabel.text isEqualToString:@"批量删除"]) {
        self.piliangType = PILIANGTYPE_DELETE;
        [_my_right_button setTitle:@"取消" forState:UIControlStateNormal];
        [_refreshTableView reloadData];
        [self showDview];
        
        
    }else if ([sender.titleLabel.text isEqualToString:@"取消"]){
        [_my_right_button setTitle:@"批量删除" forState:UIControlStateNormal];
        self.piliangType = PILIANGTYPE_NONE;
        [_refreshTableView reloadData];
        [self hideenDview];
    }
    
}




#pragma mark - 请求网络数据

//请求T台列表
-(void)prepareNetData{
    NSString *userId = [GMAPI getUid];
    
    //请求网络数据
    NSString *api = [NSString stringWithFormat:@"%@&page=%d&count=%d&user_id=%@&authcode=%@",TTAi_LIST,_refreshTableView.pageNum,L_PAGE_SIZE,userId,[GMAPI getAuthkey]];
    NSLog(@"请求的接口%@",api);
    
    LTools *cc = [[LTools alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result : %@",result);
        NSMutableArray *arr;
        __weak typeof(_refreshTableView)_weakRefreshTableView = _refreshTableView;
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *list = result[@"list"];
            arr = [NSMutableArray arrayWithCapacity:list.count];
            if ([list isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *aDic in list) {
                    
                    TPlatModel *aModel = [[TPlatModel alloc]initWithDictionary:aDic];
                    
                    [arr addObject:aModel];
                }
                
            }
        }
        
        [_weakRefreshTableView reloadData:arr pageSize:L_PAGE_SIZE];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [_refreshTableView loadFail];
    }];
}

//删除T台
-(void)gDeletTtaiWithIdStr:(NSString *)theIdStr{
    NSLog(@"%s",__FUNCTION__);
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

    NSLog(@"%@",theIdStr);
    
    NSString *url = [NSString stringWithFormat:@"%@&tt_id=%@&authcode=%@",DELETE_TTAI,theIdStr,[GMAPI getAuthkey]];
    LTools *cc = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSLog(@"success %@",result);
        if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
            [GMAPI showAutoHiddenMBProgressWithText:[result stringValueForKey:@"msg"] addToView:self.view];
            [self editFinishAndChangeView];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TTAI_EDIT_SUCCESS object:nil];
            
        }else{
            
        }
        
        
        
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"failed %@",result);
        
        
    }];
    
    
}



#pragma mark - RefreshDelegate

- (void)loadNewData
{
    [self prepareNetData];
}
- (void)loadMoreData
{
    [self prepareNetData];
}

//新加
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%ld",(long)indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TPlatModel *model = (TPlatModel *)_refreshTableView.dataArray[indexPath.row];
    
    TTaiDetailController *t_detail = [[TTaiDetailController alloc]init];
    t_detail.tt_id = model.tt_id;
    
    t_detail.lastPageNavigationHidden = YES;
    [self.navigationController pushViewController:t_detail animated:YES];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return 90;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _refreshTableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    GEditTtaiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GEditTtaiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.delegate = self;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    //数据源
    TPlatModel *aModel = _refreshTableView.dataArray[indexPath.row];

    [cell loadCustomViewWithData:aModel indexpath:indexPath withType:self.piliangType];
    
    return cell;
}




//跳转到修改T台界面
-(void)editTtaiWithTag:(NSInteger)theTag{
    
    
    TPlatModel *amodel = _refreshTableView.dataArray[theTag-10];
    NSLog(@"%s",__FUNCTION__);
    
    
    
    GTTPublishViewController *ccc = [[GTTPublishViewController alloc]init];
    ccc.theTtaiModel = amodel;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:ccc];
    
    [self presentViewController:navc animated:YES completion:^{
        
    }];
    
    
}


@end
