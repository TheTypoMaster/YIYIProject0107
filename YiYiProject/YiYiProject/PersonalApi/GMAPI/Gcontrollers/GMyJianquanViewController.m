//
//  GMyJianquanViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/6/29.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GMyJianquanViewController.h"
#import "GTimeSwitch.h"

@interface GMyJianquanViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
}
@end

@implementation GMyJianquanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.myTitle = @"我的奖券";
    
    NSLog(@"%@",self.jiangQuanId);
    
    
    _titleArray = @[@"活动名:",@"地点:",@"奖项:",@"奖品:",@"是否兑奖:",@"兑换码:",@"二维码:",@"兑奖截止时间:"];
    
    
    
    [self prepareNetData];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 65, 50)];
    titleLabel.text = _titleArray[indexPath.row];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+10, 0, DEVICE_WIDTH-13-65-13, 50)];
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 3;
    [cell.contentView addSubview:contentLabel];
    
    
    NSDictionary *prize_info = [self.infoDic dictionaryValueForKey:@"prize_info"];
    NSDictionary *category_info = [self.infoDic dictionaryValueForKey:@"category_info"];
    
    if (indexPath.row == 6) {//二维码
        [contentLabel removeFromSuperview];
        [titleLabel setFrame:CGRectMake(13, 0, 65, 210)];

        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 166, 166)];
        imv.center = CGPointMake((DEVICE_WIDTH-CGRectGetMaxX(titleLabel.frame))*0.5+CGRectGetMaxX(titleLabel.frame), 105);
        NSString *str = [self.infoDic stringValueForKey:@"prize_code"];
        [imv sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
        
        [cell.contentView addSubview:imv];
        
    }else if (indexPath.row == 0){//活动名
        contentLabel.text = [prize_info stringValueForKey:@"title"];
    }else if (indexPath.row == 1){//地点
        contentLabel.text = [prize_info stringValueForKey:@"mall_name"];
    }else if (indexPath.row == 2){//奖项
        contentLabel.text = [category_info stringValueForKey:@"category_name"];
    }else if (indexPath.row == 3){//奖品
        contentLabel.text = [category_info stringValueForKey:@"prize_name"];
    }else if (indexPath.row == 4){//是否兑奖
        if ([[category_info stringValueForKey:@"is_accepted"]intValue] == 0) {//未兑奖
            contentLabel.text = @"未兑奖";
        }else if ([[category_info stringValueForKey:@"is_accepted"]intValue] == 1){//已兑奖
            contentLabel.text = @"已兑奖";
        }
    }else if (indexPath.row == 5){//兑换码
        contentLabel.text = [self.infoDic stringValueForKey:@"prize_no"];
    }else if (indexPath.row ==7){//兑奖截止时间
        [titleLabel setFrame:CGRectMake(13, 0, 90, 60)];
        [contentLabel setFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+10, 0, DEVICE_WIDTH-13-90-13, 60)];
        NSString *tt = [prize_info stringValueForKey:@"get_end_time"];
        contentLabel.text = [GTimeSwitch testtime:tt];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 6) {
        return 210;
    }
    return 50;
}






#pragma mark - MyMethod
-(void)prepareNetData{
    
    NSString *url = [NSString stringWithFormat:@"%@&authcode=%@&prize_id=%@",MYJIANGQUAN_ONE,[GMAPI getAuthkey],self.jiangQuanId];
    
//    url = @"http://www119.alayy.com/index.php?d=api&c=prize&m=get_join_info&authcode=US5SK1ApBeNV7gabVuZci1L3V7UE8Qf2Ay5dbFcyBjEBMgAyBmMHMFFtBDNXOg19BTICOQ==&prize_id=1";
    
    LTools *ll = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    __weak typeof(self)bself = self;
    
    [ll requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
            self.infoDic = [result dictionaryValueForKey:@"info"];
            [bself creatMyTab];
        }else{
            if ([[result stringValueForKey:@"errorcode"]intValue]>2000) {
                [GMAPI showAutoHiddenMBProgressWithText:[result stringValueForKey:@"msg"] addToView:self.view];
            }else{
                [GMAPI showAutoHiddenMBProgressWithText:@"加载失败,请重新加载" addToView:self.view];
            }
        }
        
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}

-(void)creatMyTab{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}



@end
