//
//  GmyproductsListViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/3/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//


//点击管理单品 进入单品列表界面
#import "GmyproductsListViewController.h"
#import "GupClothesViewController.h"
#import "ProductDetailController.h"
#import "GEditProductTableViewCell.h"
@interface GmyproductsListViewController ()<UITableViewDataSource,GrefreshDelegate,UITableViewDelegate,UIActionSheetDelegate>
{
    int _page;//第几页
    NSArray *_dataArray;//数据源
    GrefreshTableView *_tableView;//主tableview
    
    UIView *_menu_view;
    NSMutableArray *_btnArray;
    
    
    UIView *_dview;//下面删除view
    
    UIButton* _my_right_button;//右边按钮
    
}
@end

@implementation GmyproductsListViewController



-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
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
    
    _page = 1;
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    _my_right_button.frame = CGRectMake(0,0,60,44);
    _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    [_my_right_button setTitle:@"批量操作" forState:UIControlStateNormal];
    _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_my_right_button setTitleColor:RGBCOLOR(253, 106, 157) forState:UIControlStateNormal];
    [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
    
    self.myTitle=@"管理单品";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self creatMenuSelectView];
    
    [self creatTableView];
    
    [self creatDview];
    
    self.indexes = [NSMutableArray arrayWithCapacity:1];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GupDateProduct) name:GEDITPRODUCT_SUCCESS object:nil];
    
    
}

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


//确认批量编辑
-(void)numLabelClicked{
    
    
    if (self.piliangType == PILIANGTYPE_DELETE) {//批量删除
        
        
        NSLog(@"%@",self.indexes);
        NSLog(@"批量删除");
        NSMutableArray *productIdArray = [NSMutableArray arrayWithCapacity:1];
        for (NSIndexPath *ip in self.indexes) {
            ProductModel *amodel = _dataArray[ip.row];
            [productIdArray addObject:amodel.product_id];
        }
        
        if (productIdArray.count>0) {
            NSString *deleteProductIdStr = [productIdArray componentsJoinedByString:@","];
            NSLog(@"需要删除的产品id:%@",deleteProductIdStr);
            [self gDeletProductsWithProductsIdStr:deleteProductIdStr];
        }else{
            [self editFinishAndChangeView];
        }
        
        
    }else if (self.piliangType == PILIANGTYPE_UPDOWN){//批量上下架
        
        if (_selectIndex == 100) {//线上产品
            NSLog(@"批量下架");
            NSLog(@"%@",self.indexes);
            NSMutableArray *productIdArray = [NSMutableArray arrayWithCapacity:1];
            for (NSIndexPath *ip in self.indexes) {
                ProductModel *amodel = _dataArray[ip.row];
                [productIdArray addObject:amodel.product_id];
            }
            
            if (productIdArray.count>0) {
                NSString *downProductIdStr = [productIdArray componentsJoinedByString:@","];
                NSLog(@"需要删除的产品id:%@",downProductIdStr);
                [self gUpdownProductWithProductId:downProductIdStr upOrDown:@"down"];
            }else{
                [self editFinishAndChangeView];
            }
        }else if (_selectIndex == 101){//仓库产品
            NSLog(@"批量上架");
            NSLog(@"%@",self.indexes);
            NSMutableArray *productIdArray = [NSMutableArray arrayWithCapacity:1];
            for (NSIndexPath *ip in self.indexes) {
                ProductModel *amodel = _dataArray[ip.row];
                [productIdArray addObject:amodel.product_id];
            }
            
            if (productIdArray.count>0) {
                NSString *upProductIdStr = [productIdArray componentsJoinedByString:@","];
                NSLog(@"需要删除的产品id:%@",upProductIdStr);
                [self gUpdownProductWithProductId:upProductIdStr upOrDown:@"up"];
            }else{
                [self editFinishAndChangeView];
            }
        }
        
        
    }
    
    
    
    
}


//完成编辑之后改变界面效果
-(void)editFinishAndChangeView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self hideenDview];
    self.piliangType = PILIANGTYPE_NONE;
    [_my_right_button setTitle:@"批量操作" forState:UIControlStateNormal];
    [_tableView showRefreshHeader:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_FABUDANPIN_SUCCESS object:nil];
    
}



//navigation 右侧按钮
-(void)rightButtonTap:(UIButton *)sender
{
    
    
    if ([sender.titleLabel.text isEqualToString:@"批量操作"]) {
        NSString *str = @" ";
        if (_selectIndex == 100) {
            str = @"下架";
        }else if (_selectIndex == 101){
            str = @"上架";
        }
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:str,@"删除", nil];
        [act showInView:self.view];
    }else if ([sender.titleLabel.text isEqualToString:@"取消"]){
        [_my_right_button setTitle:@"批量操作" forState:UIControlStateNormal];
        self.piliangType = PILIANGTYPE_NONE;
        [_tableView reloadData];
        
        [self hideenDview];
    }
    
    
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//上下架
        self.piliangType = PILIANGTYPE_UPDOWN;
        [self showDview];
        [_my_right_button setTitle:@"取消" forState:UIControlStateNormal];
        [_tableView reloadData];
        
    }else if (buttonIndex == 1){//删除
        self.piliangType = PILIANGTYPE_DELETE;
        [self showDview];
        [_my_right_button setTitle:@"取消" forState:UIControlStateNormal];
        [_tableView reloadData];
        
    }
}



-(void)showDview{
    self.indexes = [NSMutableArray arrayWithCapacity:1];
    if (self.piliangType == PILIANGTYPE_UPDOWN) {
        self.numLabel.text = @"确认上架()";
    }else if (self.piliangType == PILIANGTYPE_DELETE){
        self.numLabel.text = @"确认删除()";
    }
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GupDateProduct{
    [_tableView showRefreshHeader:YES];
}

-(void)creatMenuSelectView{
    //选择搜索类型view
    CGFloat aWidth = (ALL_FRAME_WIDTH - 24)/ 2.f;
    _menu_view = [[UIView alloc]initWithFrame:CGRectMake(12, 5, aWidth * 2, 30)];
    _menu_view.clipsToBounds = YES;
    _menu_view.layer.cornerRadius = 15.f;
    _menu_view.backgroundColor = RGBCOLOR(212, 59, 85);
    [self.view addSubview:_menu_view];
    NSLog(@"%@",NSStringFromCGRect(_menu_view.frame));
    
    NSArray *titles = @[@"线上产品",@"仓库产品"];
    _btnArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(aWidth * i + 0.5 * i, 0, aWidth, 30);
        
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setHighlighted:NO];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        btn.tag = 100 + i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"d7425c"] forState:UIControlStateSelected];
        
        [_menu_view addSubview:btn];
        [_btnArray addObject:btn];
        [btn addTarget:self action:@selector(GbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    UIButton *btn = (UIButton *)[_menu_view viewWithTag:100];
    _selectIndex = 100;
    btn.backgroundColor = RGBCOLOR(240, 122, 142);
}


- (void)GbtnClicked:(UIButton *)sender
{
    
    
    NSLog(@"%d",self.piliangType);
    if (self.piliangType != PILIANGTYPE_NONE) {
        return;
    }
    
    int tag = (int)sender.tag;
    //改变点击颜色
    for (UIButton *btn in _btnArray) {
        btn.backgroundColor = RGBCOLOR(212, 59, 85);
    }
    sender.backgroundColor = RGBCOLOR(240, 122, 142);
    
    _selectIndex = tag;
    if (_selectIndex == 100) {//线上产品
        [_tableView showRefreshHeader:YES];
    }else if (_selectIndex == 101){//仓库产品
        [_tableView showRefreshHeader:YES];
    }
}



-(void)creatTableView{
    _tableView = [[GrefreshTableView alloc]initWithFrame:CGRectMake(0, 40, DEVICE_WIDTH, DEVICE_HEIGHT-64-40)style:UITableViewStylePlain];
    _tableView.GrefreshDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView showRefreshHeader:YES];
}


-(void)setDataArrayWithArray:(NSArray *)array{
    _dataArray = [NSMutableArray arrayWithArray:array];
}






//请求网络数据
-(void)prepareNetData{
    //by_time为按时间排序（新品），by_discount为按折扣排序，by_hot为是否热销，默认为by_time
    
    NSString *url = @"";
    
    if (_selectIndex == 100) {//线上产品
        url = [NSString stringWithFormat:GET_MAIL_PRODUCT_LIST,self.userInfo.shop_id,_page,L_PAGE_SIZE,[GMAPI getAuthkey]];
    }else if (_selectIndex == 101){//仓库产品
        url = [NSString stringWithFormat:GET_MAIL_PRODUCT_LIST,self.userInfo.shop_id,_page,L_PAGE_SIZE,[GMAPI getAuthkey]];
        url = [url stringByAppendingString:@"&status=2"];
    }
    
    LTools *ccc = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSMutableArray *arr;
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *list = result[@"list"];
            arr = [NSMutableArray arrayWithCapacity:list.count];
            if ([list isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *aDic in list) {
                    
                    ProductModel *aModel = [[ProductModel alloc]initWithDictionary:aDic];
                    
                    [arr addObject:aModel];
                }
                
            }
            
            [self reloadData:arr isReload:YES];
            
        }
        
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
    
    
    ProductModel *aMode = _dataArray[indexPath.row];
    
    ProductDetailController *detail = [[ProductDetailController alloc]init];
    detail.product_id = aMode.product_id;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


#pragma mark -  UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GEditProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GEditProductTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.delegate = self;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    //数据源
    ProductModel *aModel = _dataArray[indexPath.row];
    [cell loadCustomViewWithData:aModel indexpath:indexPath withType:self.piliangType];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}



//跳转到修改单品界面
-(void)editProductWithTag:(NSInteger)theTag{
    ProductModel *amodel = _dataArray[theTag-10];
    GupClothesViewController *ccc = [[GupClothesViewController alloc]initWithType:GEDITCLOTH editProduct:amodel];
    ccc.mallInfo = self.mallInfo;
    ccc.userInfo = self.userInfo;
    [self.navigationController pushViewController:ccc animated:YES];
}


//删除单品
-(void)gDeletProductsWithProductsIdStr:(NSString *)theStr{
    NSString *api = [NSString stringWithFormat:@"%@&authcode=%@&product_ids=%@",GDELETPRODUCTS,[GMAPI getAuthkey],theStr];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LTools *cc = [[LTools alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",result);
        [GMAPI showAutoHiddenMBProgressWithText:[result objectForKey:@"msg"] addToView:self.view];
        if ([[result objectForKey:@"errorcode"]intValue]==0) {
            [self editFinishAndChangeView];
        }
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

//上架下架单品
-(void)gUpdownProductWithProductId:(NSString *)theId upOrDown:(NSString *)type{
    NSString *api = [NSString stringWithFormat:@"%@&authcode=%@&product_ids=%@&action=%@",GUPDOWNPRODUCTS,[GMAPI getAuthkey],theId,type];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LTools *cc = [[LTools alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",result);
        [GMAPI showAutoHiddenMBProgressWithText:[result objectForKey:@"msg"] addToView:self.view];
        if ([[result objectForKey:@"errorcode"]intValue]==0) {
            [self editFinishAndChangeView];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}



@end
