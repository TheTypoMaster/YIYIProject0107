//
//  MessageDetailController.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/18.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MessageDetailController.h"
#import "MailMessageCell.h"

#import "ActivityModel.h"

@interface MessageDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    
    id detail_model;
//    ActivityModel *aModel;
}

@end

@implementation MessageDetailController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
//
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:self.lastPageNavigationHidden animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myTitleLabel.text = self.isActivity ? @"活动详情" : @"消息详情";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,DEVICE_HEIGHT - 64) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    _table.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getMessageInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求

//action= yy(衣加衣) shop（商家） dynamic（动态）
- (void)getMessageInfo
{
    NSString *key = [GMAPI getAuthkey];
    
    NSString *url = [NSString stringWithFormat:MESSAGE_GET_DETAIL,self.msg_id,key];
    
    if (self.isActivity) {
        
        url = [NSString stringWithFormat:GET_MAIL_ACTIVITY_DETAIL,self.msg_id];
    }
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"");
        
        
        if ([LTools isDictinary:result]) {
            
            if (self.isActivity) {
                
                detail_model = [[ActivityModel alloc]initWithDictionary:result];
            }else
            {
                detail_model = [[MessageModel alloc]initWithDictionary:result];

            }
            
            [_table reloadData];
        }
    
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
    }];
}

#pragma mark - RefreshDelegate

- (void)loadNewData
{
    
}
- (void)loadMoreData
{
    
}

//新加
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    NSLog(@"详情");
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    
    return [MailMessageCell heightForModel:detail_model cellType:icon_Yes seeAll:NO];
}

#pragma mark - UITableDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MailMessageCell heightForModel:detail_model cellType:icon_Yes seeAll:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MailMessageCell";
    MailMessageCell *cell = (MailMessageCell *)[LTools cellForIdentify:identify cellName:identify forTable:tableView];
    
    if (_isActivity) {
        
        [cell setCellWithModel:detail_model cellType:icon_No seeAll:NO];
    }else
    {
        [cell setCellWithModel:detail_model cellType:icon_Yes seeAll:NO];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



@end
