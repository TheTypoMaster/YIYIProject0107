//
//  GMyWalletViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/6/29.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GMyWalletViewController.h"
#import "GMyJianquanViewController.h"

@interface GMyWalletViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titleArray;
    UITableView *_tableView;
    CGFloat _cellHeight;
    CGRect _jiangquanCGRECT;
    int _isOpen[20];
}
@end



@implementation GMyWalletViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.myTitle = @"我的钱包";
    
    for (int i=0; i<20; i++) {
        _isOpen[i]=0;
    }
    _isOpen[1]=1;
    
    _titleArray = @[@"积分",@"奖券"];
    
    _cellHeight = 274.0/750*DEVICE_WIDTH;
    _jiangquanCGRECT = CGRectMake(51.0/750*DEVICE_WIDTH, 20.0/750*DEVICE_WIDTH, 650.0/750*DEVICE_WIDTH, 650.0/750*DEVICE_WIDTH*234/650);
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self prepareNetData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger aa = 0;
    if (section == 0) {
        aa = 0;
    }else if(section == 1){
        aa = self.dataArray.count;
        if (!_isOpen[section]) {
            aa=0;
        }
    }
    return aa;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
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
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:_jiangquanCGRECT];
    [imv setImage:[UIImage imageNamed:@"mywallet_01.png"]];
    [cell.contentView addSubview:imv];
    
    UILabel *tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(35.0*imv.frame.size.width/650, 30.0/234*imv.frame.size.height+168.0/234*imv.frame.size.height *0.1, 480.0/650*imv.frame.size.width, 168.0/234*imv.frame.size.height *0.3)];
    
    //提示
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    NSString *prize_tips = [dataDic stringValueForKey:@"prize_tips"];
    //奖项
    NSDictionary *category_info = [dataDic dictionaryValueForKey:@"category_info"];
    NSString *category_name = [category_info stringValueForKey:@"category_name"];
    tishiLabel.text = prize_tips;
    tishiLabel.font = [UIFont systemFontOfSize:14.0];
    tishiLabel.textColor = RGBCOLOR(249, 148, 151);
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    [imv addSubview:tishiLabel];
//    tishiLabel.backgroundColor = [UIColor orangeColor];
    
    UILabel *jiangxiangLabel = [[UILabel alloc]initWithFrame:CGRectMake(tishiLabel.frame.origin.x, CGRectGetMaxY(tishiLabel.frame), tishiLabel.frame.size.width, 168.0/234*imv.frame.size.height *0.6)];
    jiangxiangLabel.text = category_name;
    jiangxiangLabel.font = [UIFont systemFontOfSize:22];
    jiangxiangLabel.textColor = [UIColor whiteColor];
    jiangxiangLabel.textAlignment = NSTextAlignmentCenter;
//    jiangxiangLabel.backgroundColor = [UIColor purpleColor];
    [imv addSubview:jiangxiangLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        NSDictionary *dataDic = self.dataArray[indexPath.row];
        NSDictionary *category_info = [dataDic dictionaryValueForKey:@"category_info"];
        NSString *prize_id = [category_info stringValueForKey:@"prize_id"];
        
        GMyJianquanViewController *cc = [[GMyJianquanViewController alloc]init];
        cc.jiangQuanId = prize_id;
        [self.navigationController pushViewController:cc animated:YES];
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0.5)];
    view.backgroundColor = RGBCOLOR(220, 221, 223);
    return view;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 45)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    view.tag = section +10;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ggShouFang:)];
    [view addGestureRecognizer:tap];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 15)];
    titleLabel.text = _titleArray[section];
    [view addSubview:titleLabel];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 15, DEVICE_WIDTH-10-70-30, 15)];
    if (section == 0) {
        [numLabel setFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 15, DEVICE_WIDTH-10-70-10, 15)];
    }
    numLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:numLabel];
    
    if (section == 0) {
        numLabel.text = [NSString stringWithFormat:@"%@分",self.jifen];
    }else if (section == 1){
        numLabel.text = [NSString stringWithFormat:@"%lu张",(unsigned long)self.dataArray.count];
    }
    if (numLabel.text.length>0) {
        NSMutableAttributedString *tt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",numLabel.text]];
        [tt addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(253, 106, 157) range:NSMakeRange(0,numLabel.text.length-1)];
        [tt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,numLabel.text.length-1)];
        [tt addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(numLabel.text.length-1, 1)];
        [tt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(numLabel.text.length-1, 1)];
        numLabel.attributedText = tt;
    }
    if (section == 1) {
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 44.5, DEVICE_WIDTH, 0.5)];
        line.backgroundColor = RGBCOLOR(220, 221, 223);
        [view addSubview:line];
        
        //箭头
        UIButton *jiantou = [UIButton buttonWithType:UIButtonTypeCustom];
        [jiantou setFrame:CGRectMake(DEVICE_WIDTH - 30, 7, 30, 30)];
        jiantou.userInteractionEnabled = NO;
        [view addSubview:jiantou];
        
        if ( !_isOpen[view.tag-10]) {
            [jiantou setImage:[UIImage imageNamed:@"buy_jiantou_d.png"] forState:UIControlStateNormal];
        }else{
            [jiantou setImage:[UIImage imageNamed:@"buy_jiantou_u.png"] forState:UIControlStateNormal];
        }
        
        
    }
    
    
    return view;
    
}



#pragma mark - MyMethod
-(void)prepareNetData{
   
    NSString *url = [NSString stringWithFormat:@"%@&authcode=%@",MYJIANGQUAN_LIST,[GMAPI getAuthkey]];
    
//    url = @"http://www119.alayy.com/index.php?d=api&c=prize&m=get_join_list&authcode=US5SK1ApBeNV7gabVuZci1L3V7UE8Qf2Ay5dbFcyBjEBMgAyBmMHMFFtBDNXOg19BTICOQ==";
    
    LTools *ll = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    __weak typeof(self)bself = self;
    
    [ll requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
            self.dataArray = [result arrayValueForKey:@"list"];
            if (self.dataArray.count == 0) {
                _isOpen[1] = 0;
            }
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)ggShouFang:(UIGestureRecognizer*)ges{
    
    
    if (self.dataArray.count == 0) {
        return;
    }
    
    _isOpen[ges.view.tag-10]=!_isOpen[ges.view.tag-10];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:ges.view.tag-10];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    
}


@end
