//
//  MySettingsViewController.m
//  YiYiProject
//
//  Created by 王龙 on 15/1/1.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MySettingsViewController.h"
#import "MyseetingTableViewCell.h"
#import "AboutTailCircleViewController.h"

#import "UMFeedbackViewController.h"

#import "RCIM.h"

//RBG color
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@interface MySettingsViewController ()
{
    NSString *cellIdentifer;
}
@end

@implementation MySettingsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int size = [self sizeOfFolder:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
        NSString * lastSize = @"";
        if (size < (1024*1024)) {
            lastSize = [NSString stringWithFormat:@"%.1fKB",size/1024.0f];
        }else if(size > (1024*1024)){
            lastSize = [NSString stringWithFormat:@"%.1fMB",size/1024.0f/1024.0f];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            catchSize = lastSize;
            [_mTableVIew reloadData];
        });
    });
    
    
    
}

/////计算缓存
- (int)sizeOfFolder:(NSString*)folderPath
{
    NSArray *contents;
    NSEnumerator *enumerator;
    NSString *path;
    contents = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    enumerator = [contents objectEnumerator];
    int fileSizeInt = 0;
    while (path = [enumerator nextObject]) {
        NSError *error;
        NSDictionary *fattrib = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:path] error:&error];
        fileSizeInt +=[fattrib fileSize];
    }
    return fileSizeInt;
}

/////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
     self.myTitleLabel.text = @"设置";
    
    [self initSettingsArray];
    
    _mTableVIew.backgroundColor = RGBCOLOR(242, 242, 242);
    
    //注册cell
    
    cellIdentifer = @"MyseetingTableViewCell";
    UINib * cellNib = [UINib nibWithNibName:cellIdentifer bundle:nil];
    [_mTableVIew registerNib:cellNib forCellReuseIdentifier:cellIdentifer];
    
     //隐藏多余的分割线
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50)];
    footView.backgroundColor = RGBA(248, 248, 248, 1);
    
    ///退出登录
    
    UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logOutBtn.frame = CGRectMake(0, 10, DEVICE_WIDTH, 50);
    [logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logOutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    logOutBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    logOutBtn.backgroundColor = [UIColor whiteColor];
    [footView addSubview:logOutBtn];
    
    [logOutBtn addTarget:self action:@selector(logOutActon) forControlEvents:UIControlEventTouchUpInside];
    
    [_mTableVIew setTableFooterView:footView];
    
    
}


//初始化数据源
-(void)initSettingsArray{
    
    catchSize = @"";
    
    dataArray = @[@"关于我们",
                  @"清除缓存",
                  @"检测新版本",
                  @"爱的鼓励",
                  @"意见反馈",
                  ];
}




#pragma mark------------------UItableVIewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyseetingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    cell.contentLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 1) {
        cell.secondLabel.text = catchSize;
        cell.secondLabel.hidden = NO;
        cell.haveNewVersionView.hidden = YES;
    }else{
        cell.secondLabel.hidden = YES;
        
        if (indexPath.row == 2 ) {
            cell.haveNewVersionView.hidden = NO;
        }else{
            cell.haveNewVersionView.hidden = YES;
        }
    }
    
    
    
    return cell;

}

#pragma mark------------------UItableVIewDelegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = RGBA(248, 248, 248, 1);
    return view;
}

////////cell的点击事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        AboutTailCircleViewController *aboutVC = [[AboutTailCircleViewController alloc] initWithNibName:@"AboutTailCircleViewController" bundle:nil];
        
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    
    if (indexPath.row == 1) {
        /////////清理缓存
        [GMAPI showProgressWithText:@"正在清理..." hasMask:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
            NSLog(@"files :%d",[files count]);
            for (NSString *p in files) {
                NSError *error;
                NSString *path = [cachPath stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [GMAPI showSuccessProgessWithText:@"清理成功!" hasMask:NO];
                
                catchSize = @"0KB";
                
                [_mTableVIew reloadData];
            });
        });
    }
    
    
    if (indexPath.row == 2) {
         //检测新版本
        
        //TODO:
        
        //版本更新
        
        [[LTools shareInstance]versionForAppid:@"951259287" Block:^(BOOL isNewVersion, NSString *updateUrl, NSString *updateContent) {
            
            NSLog(@"updateContent %@ %@",updateUrl,updateContent);
            
            if (isNewVersion == NO) {
                
                [LTools alertText:@"已是最新版本" viewController:self];
            }
            
        }];
    }
    
    if (indexPath.row == 3) {
        //打分
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_RATING_URL]];
    }
    
    if (indexPath.row == 4) {
        //意见反馈
        
        UMFeedbackViewController *_feedbackVC=[[UMFeedbackViewController alloc]init];
        
        [self.navigationController pushViewController:_feedbackVC animated:YES];
        
        
        //TODO:  还没做
    }
    
    
    
}




#pragma mark---退出登录

-(void)logOutActon{
    //TODO:
    
    //清除用户数据,返回我的,弹出登录界面,融云退出登录
    
    
    [LTools cache:@"" ForKey:USER_NAME];
    [LTools cache:@"" ForKey:USER_UID];
    [LTools cache:@"" ForKey:USER_AUTHOD];
    [LTools cache:@"" ForKey:USER_HEAD_IMAGEURL];
    
    //保存登录状态 yes
    
    [LTools cacheBool:NO ForKey:LOGIN_SERVER_STATE];
    
    //融云Token
    
    [LTools cache:@"" ForKey:RONGCLOUD_TOKEN];
    [[RCIM sharedRCIM]disconnect];
    
    
    [GMAPI cleanUserFaceAndBanner];//清除banner和头像
    [GMAPI setUpUserBannerNo];//重置上传banner标志位
    [GMAPI setUpUserFaceNo];//重置上传用户头像标志位
    [GMAPI showSuccessProgessWithText:@"退出登录成功！" hasMask:NO];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGOUT object:nil];
    [self logout];
    [self performSelector:@selector(leftButtonTap:) withObject:nil afterDelay:0.2];
    
    
    
}

- (void)leftButtonTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求

- (void)logout
{
    __weak typeof(self)weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:USER_LOGOUT_ACTION,[GMAPI getAuthkey]];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@ erro %@",result,erro);
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@ erro %@",failDic,erro);
        
//        [LTools showMBProgressWithText:failDic[RESULT_INFO] addToView:self.view];
    }];
}


@end
