//
//  MailMessageViewController.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MailMessageViewController.h"
#import "RefreshTableView.h"

#import "MailMessageCell.h"

@interface MailMessageViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
}
@end

@implementation MailMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTitleLabel.text = @"商家消息";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,DEVICE_HEIGHT)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求



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
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return 70;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MailMessageCell";
    MailMessageCell *cell = (MailMessageCell *)[LTools cellForIdentify:identify cellName:identify forTable:tableView];
    
    cell.bottomLine.top = 69.5f;
    cell.bottomLine.height = 0.5f;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numbeLabel.layer.cornerRadius = 10.f;
    cell.numbeLabel.clipsToBounds = YES;
    
    return cell;
}


@end
