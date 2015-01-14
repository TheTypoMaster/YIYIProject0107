//
//  MessageViewController.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/10.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageViewCell.h"
#import "YIYIChatViewController.h"

#import "MailMessageViewController.h"

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
    cell1.iconImageView.image = [UIImage imageNamed:@"yixx150_150"];
    cell1.nameLabel.text = @"衣+衣团队";
    cell1.messageLabel.text = @"欢迎使用衣+衣!";
    [cell1.clickButton addTarget:self action:@selector(tapToYIJiaYi:) forControlEvents:UIControlEventTouchUpInside];
    
    MessageViewCell *cell2 = [[[NSBundle mainBundle]loadNibNamed:@"MessageViewCell" owner:self options:nil]lastObject];
    cell2.frame = CGRectMake(0, 65, DEVICE_WIDTH, 65);
    [view addSubview:cell2];
    cell2.iconImageView.layer.cornerRadius = 43/2.f;
    cell2.nameLabel.text = @"商家消息";
    cell2.messageLabel.text = @"您关注的商家没有最新消息!";
    cell2.iconImageView.image = [UIImage imageNamed:@"sjxx150_150"];
    [cell2.clickButton addTarget:self action:@selector(tapToMail:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求

#pragma mark - 事件处理

/**
 *  衣加衣团队
 */
- (void)tapToYIJiaYi:(UITapGestureRecognizer *)tap
{
    NSLog(@"衣加衣团队");
}

/**
 *  商家消息
 */
- (void)tapToMail:(UITapGestureRecognizer *)tap
{
    NSLog(@"商家消息");
    MailMessageViewController *mail = [[MailMessageViewController alloc]init];
    mail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mail animated:YES];
}

#pragma mark - Rongcloud 方法重新

/**
 *  重载选择表格事件
 *
 *  @param conversation
 */
-(void)onSelectedTableRow:(RCConversation*)conversation{
    
    
//    if(conversation.conversationType == ConversationType_GROUP)
//    {
//        DemoGroupListViewController* groupVC = [[DemoGroupListViewController alloc] init];
//        self.currentGroupListView = groupVC;
//        groupVC.portraitStyle = RCUserAvatarCycle;
//        [self.navigationController pushViewController:groupVC animated:YES];
//        return;
//    }
    
    if ([LTools isLogin:self]) {
        
        NSString *useriId = conversation.targetId;
        NSString *userName = conversation.conversationTitle;
        
        YIYIChatViewController *contact = [[YIYIChatViewController alloc]init];
        contact.currentTarget = useriId;
        contact.currentTargetName = userName;
        contact.portraitStyle = RCUserAvatarCycle;
        contact.enableSettings = NO;
        contact.conversationType = conversation.conversationType;
        contact.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contact animated:YES];
    }

}

@end
