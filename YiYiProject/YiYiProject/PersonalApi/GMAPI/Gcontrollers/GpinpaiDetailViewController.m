//
//  GpinpaiDetailViewController.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GpinpaiDetailViewController.h"
#import "NSDictionary+GJson.h"
#import "GnearbyStoreViewController.h"
#import "GStorePinpaiViewController.h"
#import "GcustomStoreTableViewCell.h"
#import "EGORefreshTableHeaderView.h"
#import "NSDictionary+GJson.h"
#import "RefreshTableView.h"

@interface GpinpaiDetailViewController ()<UITableViewDataSource,RefreshDelegate>
{
    RefreshTableView *_tableView;
    
    GcustomStoreTableViewCell *_tmpCell;//用户获取自定义单元格高度

    //收藏相关
    UIButton *_my_right_button;
    
}
@end

@implementation GpinpaiDetailViewController




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTitleLabel.textColor = RGBCOLOR(252, 74, 139);
    self.myTitle = self.pinpaiName;
    
    
    
    
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-44)];
    _tableView.refreshDelegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    
    
    
    
    
    
    _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    _my_right_button.frame = CGRectMake(0,0,60,44);
    _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_my_right_button setTitleColor:RGBCOLOR(253, 104, 157) forState:UIControlStateNormal];
    [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
//    _my_right_button.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_my_right_button];
    
    
    
    [self getGuanzhuYesOrNoForPinpai];//获取是否收藏了该品牌
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareNetData{
    
    NSString *api = nil;
    if (self.locationDic) {
        api = [NSString stringWithFormat:@"%@&brand_id=%@&page=%d&per_page=%d&long=%@&lat=%@",HOME_CLOTH_PINPAI_STORELIST,self.pinpaiIdStr,_tableView.pageNum,L_PAGE_SIZE,[self.locationDic stringValueForKey:@"long"],[self.locationDic stringValueForKey:@"lat"]];
    }else{
        GMAPI *aa = [GMAPI sharedManager];
        api = [NSString stringWithFormat:@"%@&brand_id=%@&page=%d&per_page=%d&long=%@&lat=%@",HOME_CLOTH_PINPAI_STORELIST,self.pinpaiIdStr,_tableView.pageNum,L_PAGE_SIZE,[aa.theLocationDic stringValueForKey:@"long"],[aa.theLocationDic stringValueForKey:@"lat"]];
    }
    
    
    NSLog(@"%@",api);
    
    LTools *cc = [[LTools alloc]initWithUrl:api isPost:NO postData:nil];
    
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%@",result);
        NSArray *arr = [result objectForKey:@"mall_list"];
        [_tableView reloadData:arr pageSize:L_PAGE_SIZE];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"失败");
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableView.dataArray.count;
}




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
    NSDictionary *dic = _tableView.dataArray[indexPath.row];
    
    
    
    //通过数据源加载数据
    [cell loadCustomCellWithDic:dic];
    
    
    
    return cell;
}



//cell单元格个数一个屏幕里占不满的话 下面不显示出来
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}






//收藏品牌
-(void)guanzhupinpai{
    //判断是否收藏品牌
    NSLog(@"self.guanzhu:%@",self.guanzhu);
    
    if ([self.guanzhu intValue] == 0) {//未收藏
        NSString *post = [NSString stringWithFormat:@"&brand_id=%@&authcode=%@",self.pinpaiIdStr,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:GUANZHUPINPAI];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        LTools *ccc = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
                 [GMAPI showAutoHiddenMBProgressWithText:@"收藏成功" addToView:self.view];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_PINPAI object:nil];
                [_my_right_button setTitle:@"已收藏" forState:UIControlStateNormal];
                self.guanzhu = @"1";
            }
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }else if ([self.guanzhu intValue] == 1){
        NSString *post = [NSString stringWithFormat:@"&brand_id=%@&authcode=%@",self.pinpaiIdStr,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:QUXIAOGUANZHUPINPAI];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        LTools *ccc = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if ([[result stringValueForKey:@"errorcode"]intValue]==0) {
                [GMAPI showAutoHiddenMBProgressWithText:@"取消收藏成功" addToView:self.view];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_PINPAI_QUXIAO object:nil];
                [_my_right_button setTitle:@"收藏" forState:UIControlStateNormal];
                self.guanzhu = @"0";
            }
            
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}


//获取是否收藏 品牌
-(void)getGuanzhuYesOrNoForPinpai{
    
    NSString *api = [NSString stringWithFormat:@"%@&brand_id=%@&authcode=%@",GUANZHUPINPAI_ISORNO,self.pinpaiIdStr,[GMAPI getAuthkey]];
    LTools *ccc = [[LTools alloc]initWithUrl:api isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",result);
        
        if ([result stringValueForKey:@"errorcode"]) {
            self.guanzhu = [result stringValueForKey:@"relation"];
        }
        
        if ([self.guanzhu intValue]==0) {//未收藏
            [_my_right_button setTitle:@"收藏" forState:UIControlStateNormal];
        }else if ([self.guanzhu intValue] == 1){//已收藏
            [_my_right_button setTitle:@"已收藏" forState:UIControlStateNormal];
        }
        
        [self prepareNetData];//获取品牌附近的商场
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


-(void)rightButtonTap:(UIButton *)sender
{
    
    NSLog(@"在这里添加收藏");
    
    
    //判断是否登录
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
        
        LoginViewController *login = [[LoginViewController alloc]init];
        
        UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
        
        [self presentViewController:unVc animated:YES completion:nil];
        
        
        return;
        
    }else{
        
        
        [self guanzhupinpai];
        
        
    }
    
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

//点击跳转
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%ld",(long)indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = _tableView.dataArray[indexPath.row];
    
    GStorePinpaiViewController *cc = [[GStorePinpaiViewController alloc]init];
    if (self.isChooseProductLink) {
        cc.isChooseProductLink = YES;
    }
    cc.storeIdStr = [dic stringValueForKey:@"mb_id"];
    cc.pinpaiId = self.pinpaiIdStr;
    cc.pinpaiNameStr = self.pinpaiName;
    cc.storeNameStr = [dic stringValueForKey:@"mall_name"];
//    if ([[dic stringValueForKey:@"mall_type"]intValue]== 1) {//大商场
//        cc.guanzhuleixing = @"商场";
//    }else if ([[dic stringValueForKey:@"mall_type"]intValue]== 2){
//        cc.guanzhuleixing = @"精品店";
//    }else if ([[dic stringValueForKey:@"mall_type"]intValue]== 3){
//        cc.guanzhuleixing = @"品牌店";
//    }
    
    cc.guanzhuleixing = @"品牌店";
    
    [self.navigationController pushViewController:cc animated:YES];
    
    
    
    
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
//    CGFloat cellHeight = 0.0f;
//    
//    if (_tmpCell) {
//        cellHeight = [_tmpCell loadCustomCellWithDic:_tableView.dataArray[indexPath.row]];
//    }else{
//        _tmpCell = [[GcustomStoreTableViewCell alloc]init];
//        cellHeight = [_tmpCell loadCustomCellWithDic:_tableView.dataArray[indexPath.row]];
//    }
//    
//    
//    return cellHeight;
    
    return 52;
}


@end
