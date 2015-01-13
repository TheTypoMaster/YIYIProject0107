//
//  MessageViewController.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/10.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageViewCell.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.myTitleLabel.text = @"消息";
    
    [self setNavigationTitle:@"消息" textColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        //iOS 5 new UINavigationBar custom background
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:MY_MACRO_NAME?IOS7DAOHANGLANBEIJING_PUSH:IOS6DAOHANGLANBEIJING] forBarMetrics: UIBarMetricsDefault];
    }
    
    self.hidesDefaultBackView = YES;
    self.portraitStyle = RCUserAvatarCycle;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65 * 2)];
    view.backgroundColor = [UIColor whiteColor];
    self.conversationListView.tableHeaderView = view;
    
    MessageViewCell *cell1 = [[[NSBundle mainBundle]loadNibNamed:@"MessageViewCell" owner:self options:nil]lastObject];
    cell1.frame = CGRectMake(0, 0, DEVICE_WIDTH, 65);
    [view addSubview:cell1];
    cell1.iconImageView.layer.cornerRadius = 43/2.f;
    
    MessageViewCell *cell2 = [[[NSBundle mainBundle]loadNibNamed:@"MessageViewCell" owner:self options:nil]lastObject];
    cell2.frame = CGRectMake(0, 65, DEVICE_WIDTH, 65);
    [view addSubview:cell2];
    cell2.iconImageView.layer.cornerRadius = 43/2.f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
