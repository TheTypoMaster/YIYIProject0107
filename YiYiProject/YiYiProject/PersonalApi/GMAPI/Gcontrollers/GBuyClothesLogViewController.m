//
//  GBuyClothesLogViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/6/27.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GBuyClothesLogViewController.h"
#import "GupLogClothesViewController.h"
#import "RefreshTableView.h"
#import "GBuyClothLogModel.h"
#import "GTimeSwitch.h"
#import "GbuyClothTableViewCell.h"

@interface GBuyClothesLogViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_tableView;//住tableview
    UIView *_noClothesLogView;
}
@end

@implementation GBuyClothesLogViewController







- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeText];
    self.myTitle = @"买衣日志";
    self.rightString = @"上传";
    self.view.backgroundColor = [UIColor whiteColor];
    
    

    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatNoLogView];
    
    [self creatTabelView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTheInfo) name:GUPBUYCLOTHES_SUCCESS object:nil];
  
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cleanTheInfo) name:NOTIFICATION_LOGOUT object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTheInfo) name:NOTIFICATION_LOGIN object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - RefreshTableViewDelegate

-(void)loadNewData{
    [self prpareNetData];
}

-(void)loadMoreData{
    [self prpareNetData];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource


- (UIView *)viewForFooterInSection:(NSInteger)section tableView:(UITableView *)tableView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0.5)];
    view.backgroundColor = RGBCOLOR(220, 221, 223);
    return view;
}

- (CGFloat)heightForFooterInSection:(NSInteger)section tableView:(UITableView *)tableView{
    return 0.5;
}

- (UIView *)viewForHeaderInSection:(NSInteger)section tableView:(UITableView *)tableView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 65)];
    UILabel *yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 100, 15)];
    yearLabel.font = [UIFont systemFontOfSize:15];
    yearLabel.textColor = [UIColor blackColor];
    NSArray *arr = _tableView.dataArray[section];
    GBuyClothLogModel *model = arr[0];
    yearLabel.text = [GTimeSwitch testtimeByYear:model.buy_time];
    [view addSubview:yearLabel];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(yearLabel.frame)+10, 100, 15)];
    [view addSubview:numLabel];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共计 %lu件",(unsigned long)arr.count]];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,3)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,3)];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, title.length-3)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(3, title.length-3)];
    numLabel.attributedText = title;
    
    UILabel *totlePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame)+10, numLabel.frame.origin.y, 200, 15)];
    [view addSubview:totlePriceLabel];
    CGFloat tot = 0.0f;
    for (GBuyClothLogModel *model in arr) {
        CGFloat onePrice = [model.price floatValue];
        tot += onePrice;
    }
    NSMutableAttributedString *tt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"消费总额 %.2f元",tot]];
    [tt addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,5)];
    [tt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,5)];
    [tt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, tt.length-5)];
    [tt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(5, tt.length-5)];
    totlePriceLabel.attributedText = tt;
    
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(10, 59.5, DEVICE_WIDTH-10, 0.5)];
    downLine.backgroundColor = RGBCOLOR(220, 221, 223);
    [view addSubview:downLine];
    
    return view;
}

-(CGFloat)heightForHeaderInSection:(NSInteger)section tableView:(UITableView *)tableView{
    return 65;
}

-(CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tableView.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *oneArray = _tableView.dataArray[section];
    return oneArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GbuyClothTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GbuyClothTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray *arr = _tableView.dataArray[indexPath.section];
    GBuyClothLogModel *model = arr[indexPath.row];
    
    [cell loadCustomCellWithModel:model];
    if (indexPath.row != 0) {
        GBuyClothLogModel *mm = arr[indexPath.row-1];
        if ([mm.buy_time isEqualToString:model.buy_time]) {
            cell.timeLabel.hidden = YES;
        }
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



#pragma mark - MyMethod
-(void)goToUpLogClothesVC{
    
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
        LoginViewController *login = [[LoginViewController alloc]init];
        UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
        [self presentViewController:unVc animated:YES completion:nil];
        return;
    }else{
        GupLogClothesViewController *ccc = [[GupLogClothesViewController alloc]init];
        ccc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ccc animated:YES];
    }
    
    
    
}

-(void)rightButtonTap:(UIButton *)sender
{
    GupLogClothesViewController *ccc = [[GupLogClothesViewController alloc]init];
    ccc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ccc animated:YES];
}

//创建没有日志时的提示页面
-(void)creatNoLogView{
    
    _noClothesLogView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 400)];
    
    _noClothesLogView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *noLogPic = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_WIDTH-85)*0.5, 50, 85, 150)];
    [noLogPic setImage:[UIImage imageNamed:@"gclothes.png"]];
    [_noClothesLogView addSubview:noLogPic];
    
    UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(noLogPic.frame)+20, DEVICE_WIDTH, 20)];
    [_noClothesLogView addSubview:tLabel];
    tLabel.font = [UIFont systemFontOfSize:14];
    tLabel.textAlignment = NSTextAlignmentCenter;
    tLabel.text = @"你还没有上传你的衣服哦";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(35, CGRectGetMaxY(tLabel.frame)+20, DEVICE_WIDTH-70, 35)];
    [btn setTitle:@"马上上传" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:RGBCOLOR(244, 76, 138)];
    [_noClothesLogView addSubview:btn];
    
    [btn addTarget:self action:@selector(goToUpLogClothesVC) forControlEvents:UIControlEventTouchUpInside];
    
}

//网络请求
-(void)prpareNetData{
    NSString *url = [NSString stringWithFormat:@"%@&page=%d&perpage=%d&uid=%@&authcode=%@",MYCLOTHESLOG_LIST,_tableView.pageNum,L_PAGE_SIZE,[GMAPI getUid],[GMAPI getAuthkey]];
    
    _tableView.tableFooterView = _noClothesLogView;
    _tableView.tableFooterView.hidden = YES;
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSArray *dic_arr = [result arrayValueForKey:@"list"];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dic in dic_arr) {
            GBuyClothLogModel *model = [[GBuyClothLogModel alloc]initWithDictionary:dic];
            [arr addObject:model];
        }
        
        if (arr.count>0 || _tableView.dataArray.count>0) {
            _tableView.tableFooterView = nil;
            _tableView.tableFooterView.hidden = NO;
        }else if (arr.count == 0){
            _tableView.tableFooterView.hidden = NO;
        }
        
        //_tableView的二维数组转为一维数组
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:1];
        for (NSArray *arr in _tableView.dataArray) {
            for (GBuyClothLogModel *model in arr) {
                [tempArr addObject:model];
            }
        }
        _tableView.dataArray = tempArr;
        [_tableView reloadData1:arr pageSize:L_PAGE_SIZE];
        
        
        //排序开始
        int count = _tableView.dataArray.count;
        for (GBuyClothLogModel *model in _tableView.dataArray) {
            model.time = NO;
            model.timeStr = [GTimeSwitch testtimeByYear:model.buy_time];
        }
        
        NSLog(@"%d",count);
        
        NSMutableArray *newArray_2 = [NSMutableArray arrayWithCapacity:1];
        //找出同一天的文章 放到一个数组里
        for (int i = 0; i < count; i++) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
            
            for (int j = i+1; j<count; j++) {
                GBuyClothLogModel *wz1 = _tableView.dataArray[i];
                GBuyClothLogModel *wz2 = _tableView.dataArray[j];
                //判断时间
                if ([wz1.timeStr isEqualToString:wz2.timeStr]) {
                    //如果相同并且time = NO 就加入数组里
                    
                    NSLog(@"%@",wz1.timeStr);
                    
                    if (!wz1.time) {
                        
                        [arr addObject:wz1];
                        wz1.time = YES;
                    }
                    
                    if (!wz2.time) {
                        
                        [arr addObject:wz2];
                        wz2.time = YES;
                    }
                }
            }
            
            GBuyClothLogModel *wz1 = _tableView.dataArray[i];
            if (arr.count == 0 && !wz1.time) {//判断一天只有一个文章的情况
                [arr addObject:wz1];
            }
            
            if (arr.count > 0) {
                [newArray_2 addObject:arr];
            }
        }
        
        _tableView.dataArray = newArray_2;
        
        NSLog(@"%lu",(unsigned long)_tableView.dataArray.count);
        NSLog(@"%@",_tableView.dataArray);
        
        
        //现在_tableView.dataArray为二维数组
        [_tableView finishReloadigData];
        
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
        
        if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
            
            _tableView.tableFooterView.hidden = NO;
            [_tableView loadFail];
            
        }else{
            _tableView.tableFooterView = nil;
            _tableView.tableFooterView.hidden = NO;
            [_tableView loadFail];
            
        }
        
        
        
        
    }];
}

//创建tableview
-(void)creatTabelView{
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.refreshDelegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = _noClothesLogView;
    _tableView.tableFooterView.hidden = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView showRefreshHeader:YES];
}


-(void)updateTheInfo{
    [_tableView showRefreshHeader:YES];
}

-(void)cleanTheInfo{
    [_tableView.dataArray removeAllObjects];
    [_tableView reloadData1:nil pageSize:L_PAGE_SIZE];
    _tableView.tableFooterView = _noClothesLogView;
    _tableView.tableFooterView.hidden = NO;
    [_tableView finishReloadigData];
}

@end
