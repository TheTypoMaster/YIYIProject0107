//
//  ZanListViewController.m
//  YiYiProject
//
//  Created by lichaowei on 15/5/5.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ZanListViewController.h"
#import "RefreshTableView.h"
#import "ZanUserModel.h"
#import "ZanUserCell.h"
#import "TPlatModel.h"

@interface ZanListViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    
    NSString *cellIdentify;
    
    UIButton *zan_btn;//赞按钮
}

@end

@implementation ZanListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:self.lastPageNavigationHidden animated:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.listType == User_TPlatZanList) {
        self.myTitleLabel.text = [NSString stringWithFormat:@"%@人喜欢",self.t_model.tt_like_num];

    }else
    {
        [self updateNavigationTitle];
    }
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64) showLoadMore:NO];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    if (self.listType == User_TPlatZanList) {
        
        _table.height = DEVICE_HEIGHT - 64 - 49;
        [self createBottomTools];

    }
    
    cellIdentify = @"ZanUserCell";
    UINib *nib = [UINib nibWithNibName:cellIdentify bundle:nil];
    [_table registerNib:nib forCellReuseIdentifier:cellIdentify];
    
    [_table showRefreshHeader:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [_table showRefreshHeader:NO];
    
//    _table.isReloadData = YES;
//    
//    [self getZanList];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 创建视图

- (void)createBottomTools
{
    //底部
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 49 - 64, DEVICE_WIDTH, 49)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"666666"];
    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, -0.5, bottomView.width, 0.5)];
//    line.backgroundColor = [UIColor grayColor];
//    [bottomView addSubview:line];
    
    NSString *iconUrl = @"";
    NSString *userName = @"";
    NSString *userId = @"";
    if ([self.t_model.uinfo isKindOfClass:[NSDictionary class]]) {
        
        iconUrl = self.t_model.uinfo[@"photo"];
        userName = self.t_model.uinfo[@"user_name"];
        userId = self.t_model.uinfo[@"uid"];
    }
    
    //头像
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 35, 35)];
    iconImageView.layer.cornerRadius = 35/2.f;
    iconImageView.clipsToBounds = YES;
    //    iconImageView.backgroundColor = [UIColor redColor];
    [bottomView addSubview:iconImageView];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:DEFAULT_HEADIMAGE];
    
    //跳转个人中心
    
    [iconImageView addTaget:self action:@selector(clickToPersonal:) tag:(100 + [userId intValue])];
    
    
    UILabel *nameLabel = [LTools createLabelFrame:CGRectMake(iconImageView.right + 10, 0, DEVICE_WIDTH - 20 - iconImageView.width - 50 - 10, 49) title:userName font:14 align:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
    [bottomView addSubview:nameLabel];
    
    
    //红心
    zan_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(DEVICE_WIDTH - 10 - 50, 0, 50, 50) normalTitle:nil image:[UIImage imageNamed:@"productDetail_zan_nornal_white"] backgroudImage:nil superView:nil target:self action:@selector(clickToZan:)];
    [bottomView addSubview:zan_btn];
    [zan_btn setImage:[UIImage imageNamed:@"productDetail_zan_selected"] forState:UIControlStateSelected];
    
    zan_btn.selected = self.t_model.is_like == 1 ? YES : NO;
    
}

#pragma - mark 事件处理

- (void)updateNavigationTitle
{
    NSString *url = nil;
    if (self.listType == User_ShopMember) { //店铺会员
        
        url = @"店铺会员";
        
    }else if (self.listType == User_MyConcernList) //关注列表
    {
        url = @"关注";
        
    }else if (self.listType == User_MyFansList) //粉丝
    {
        
        url = @"粉丝";
    }else if (self.listType == User_ProductZanList){
        
        url = @"赞";
    }

    self.myTitleLabel.text = url;
}

/**
 *  跳转至个人页
 *
 *  @param sender 按钮
 */
- (void)clickToPersonal:(UIButton *)sender
{
    
    [MiddleTools pushToPersonalId:NSStringFromInt((int)sender.tag - 100) userType:G_Other forViewController:self lastNavigationHidden:YES];
}

/**
 *  更新赞列表
 */
- (void)refreshZanList
{
    _table.isReloadData = YES;
    [self getUserList];
}

/**
 *  更新和赞相关的视图和数据源
 *
 *  @param zan 是否是赞
 */
- (void)updateZanState:(BOOL)zan
{
    zan_btn.selected = zan;
    
    int like_num = [self.t_model.tt_like_num intValue];
    self.t_model.tt_like_num = [NSString stringWithFormat:@"%d",zan ? like_num + 1 : like_num - 1];
    
    self.t_model.is_like = zan ? 1 : 0;
    
    
    //更新赞的数字
    if (_aParmasBlock) {
        
        _aParmasBlock(@{UPDATE_PARAM:@"UpdateLike",
                        UPDATE_TPLAT_LIKENUM:[LTools safeString:self.t_model.tt_like_num],
                        UPDATE_TPLAT_ISLIKE:[NSNumber numberWithBool:zan]});
    }
}

/**
 *  点击去关注
 *
 *  @param sender
 */

- (void)clickToCencern:(UIButton *)sender
{
    if (![LTools isLogin:self]) {
        
        return;
    }
    
    __weak typeof(_table)weakTable = _table;
    
    NSInteger indexRow = sender.tag - 100;
    
    ZanUserModel *aModel = [_table.dataArray objectAtIndex:indexRow];

    NSString *userId = aModel.friend_uid;
    
    NSString *api = sender.selected ? USER_CONCERN_CANCEL : USER_CONCERN_ADD;
    
    NSString *url = [NSString stringWithFormat:@"%@&friend_uid=%@&authcode=%@",api,userId,[GMAPI getAuthkey]];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        if (self.listType == User_MyConcernList || self.listType == User_MyFansList) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_MINEVC_THREENUMLABEL object:nil];
        }
        
//        ZanUserModel *aModel = [_table.dataArray objectAtIndex:userId];
        
        aModel.flag = sender.selected ? 0 : 1;

        [weakTable reloadData];
        
        
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
    }];

}

- (void)clickToZan:(UIButton *)sender
{
    if ([LTools isLogin:self]) {
        
        sender.selected = !sender.selected;
        [self zanTTaiDetail:sender.selected];
        
        [LTools animationToBigger:sender duration:0.2 scacle:1.5];
        
        return;
    }
}

#pragma - mark 网络请求

//T台赞 或 取消

- (void)zanTTaiDetail:(BOOL)zan
{
    NSString *authkey = [GMAPI getAuthkey];
    NSString *post = [NSString stringWithFormat:@"tt_id=%@&authcode=%@",self.t_model.tt_id,authkey];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url;
    
    if (zan) {
        url = TTAI_ZAN;
    }else
    {
        url = TTAI_ZAN_CANCEL;
    }
    
    __weak typeof(self)weakSelf = self;
//    __weak typeof(_table)weakTable = _table;
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        [weakSelf updateZanState:zan];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"zanList" object:nil];//刷新赞列表
        
        [weakSelf refreshZanList];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
}

/**
 *  获人员列表
 */
- (void)getUserList
{
    //    NSString *key = [GMAPI getAuthkey];
    
    __weak typeof(self)weakSelf = self;
    
    __weak typeof(_table)weakTable = _table;
    
    NSString *url = nil;
    if (self.listType == User_ShopMember) { //店铺会员
        
        url = [NSString stringWithFormat:@"%@&shop_id=%@&page=%d&per_page=%d&authcode=%@",GMYSHOPHUIYUANLIST,self.objectId,_table.pageNum,L_PAGE_SIZE,[GMAPI getAuthkey]];
        
    }else if (self.listType == User_TPlatZanList){ //t台赞人员列表
        
        NSString *api = [NSString stringWithFormat:TPLat_ZanList,self.t_model.tt_id];
        url = [NSString stringWithFormat:@"%@&authcode=%@&page=%d&per_page=%d",api,[GMAPI getAuthkey],_table.pageNum,L_PAGE_SIZE];
        
    }else if (self.listType == User_MyConcernList) //关注列表
    {
        url = [NSString stringWithFormat:@"%@&authcode=%@&uid=%@&page=%d&per_page=%d",USER_CONCERN_LIST,[GMAPI getAuthkey],self.objectId,_table.pageNum,L_PAGE_SIZE];
        
    }else if (self.listType == User_MyFansList)
    {
        
        url = [NSString stringWithFormat:@"%@&authcode=%@&uid=%@&page=%d&per_page=%d",USER_FANS_LIST,[GMAPI getAuthkey],self.objectId,_table.pageNum,L_PAGE_SIZE];
    }else if (self.listType == User_ProductZanList){
        
        url = [NSString stringWithFormat:PRODUCT_ZAN_LIST,self.objectId];
        
        url = [NSString stringWithFormat:@"%@&authcode=%@&page=%d&per_page=%d",url,[GMAPI getAuthkey],_table.pageNum,L_PAGE_SIZE];
    }
    
    NSLog(@"%@",url);
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
//        NSLog(@"获取赞列表:%@",result);
        NSArray *list = [result objectForKey:@"list"];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:list.count];
        for (NSDictionary *aDic in list) {
            
            ZanUserModel *zan = [[ZanUserModel alloc]initWithDictionary:aDic];
            [temp addObject:zan];
            
        }
        
        int total_num = [[result objectForKey:@"total_num"]intValue];
        
        if (weakSelf.listType == User_TPlatZanList) {
            
            weakSelf.myTitleLabel.text = [NSString stringWithFormat:@"%d人喜欢",total_num];

        }
        
        [weakTable reloadData:temp pageSize:L_PAGE_SIZE];
        
        
        
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"获取赞列表failDic %@",failDic);
        
        [weakTable loadFail];
    }];
}

#pragma - mark RefreshDelegate

- (void)loadNewData
{
    [self getUserList];
}
- (void)loadMoreData
{
    [self getUserList];
}

//新加
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZanUserModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    
    NSString *url = aModel.friend_uid;//uid代表当前登录用户、friend_uid对方id
    
//    if (self.listType == User_ShopMember) { //店铺会员
//        
//        url = aModel.friend_uid;
//        
//    }else if (self.listType == User_TPlatZanList){ //t台赞人员列表
//        
//        url = aModel.friend_uid;
//        
//    }else if (self.listType == User_MyConcernList) //关注列表
//    {
//        url = aModel.friend_uid;
//        
//    }else if (self.listType == User_MyFansList) //粉丝
//    {
//        
//        url = aModel.friend_uid;
//    }

    [MiddleTools pushToPersonalId:url userType:0 forViewController:self lastNavigationHidden:NO];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return 70;
}

#pragma - mark UITableDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _table.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZanUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
    ZanUserModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    
    [cell setCellWithModel:aModel];
    
    cell.concernButton.tag = 100 + indexPath.row;
    
    [cell.concernButton addTarget:self action:@selector(clickToCencern:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


@end
