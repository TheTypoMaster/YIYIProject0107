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

#import "MessageModel.h"

#import "RCIM.h"

@interface MessageViewController ()
{
    MessageModel *yiyi_model;//衣+衣 消息
    MessageModel *shop_model;//商家消息
    MessageModel *other_model;//动态消息
    
    MessageViewCell *yiyi_cell;
    MessageViewCell *shop_cell;
    MessageViewCell *other_cell;
}

@end

@implementation MessageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self refreshChatListView];//刷新列表
    
    self.navigationController.navigationBarHidden = NO;
    
    [self updateTabbarNumber:[self unreadMessgeNum]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

}

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
    
    //暂时解决避免手势冲突
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, DEVICE_HEIGHT)];
    leftView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:leftView];
    
    
    self.portraitStyle = RCUserAvatarCycle;
    
    if (self.only_rongcloud == NO) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65 * 3)];
        view.backgroundColor = [UIColor whiteColor];
        self.conversationListView.tableHeaderView = view;
        
        
        [self getMyMessage];//获取我的消息
        
        yiyi_cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageViewCell" owner:self options:nil]lastObject];
        yiyi_cell.frame = CGRectMake(0, 0, DEVICE_WIDTH, 65);
        [view addSubview:yiyi_cell];
        yiyi_cell.iconImageView.layer.cornerRadius = 43/2.f;
        yiyi_cell.iconImageView.image = [UIImage imageNamed:@"yixx150_150"];
        yiyi_cell.nameLabel.text = @"衣+衣团队";
        yiyi_cell.messageLabel.text = @"";
        [yiyi_cell.clickButton addTarget:self action:@selector(tapToYIJiaYi:) forControlEvents:UIControlEventTouchUpInside];
        
        
        shop_cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageViewCell" owner:self options:nil]lastObject];
        shop_cell.frame = CGRectMake(0, 65, DEVICE_WIDTH, 65);
        [view addSubview:shop_cell];
        shop_cell.iconImageView.layer.cornerRadius = 43/2.f;
        shop_cell.nameLabel.text = @"商家消息";
        shop_cell.messageLabel.text = @"";
        shop_cell.iconImageView.image = [UIImage imageNamed:@"sjxx150_150"];
        [shop_cell.clickButton addTarget:self action:@selector(tapToMail:) forControlEvents:UIControlEventTouchUpInside];
        
        other_cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageViewCell" owner:self options:nil]lastObject];
        other_cell.frame = CGRectMake(0, 65 * 2, DEVICE_WIDTH, 65);
        [view addSubview:other_cell];
        other_cell.iconImageView.layer.cornerRadius = 43/2.f;
        other_cell.nameLabel.text = @"动态消息";
        other_cell.messageLabel.text = @"";
        other_cell.iconImageView.image = [UIImage imageNamed:@"t_shoucang"];
        [other_cell.clickButton addTarget:self action:@selector(tapToDynamic:) forControlEvents:UIControlEventTouchUpInside];
        
    }else
    {
        [self addBackButtonWithTarget:self action:@selector(leftButtonTap:)];
        
        [self setNavigationTitle:@"聊天消息" textColor:RGBCOLOR(251, 108, 157)];

    }
    
}

-(BOOL)showCustomEmptyBackView
{
    return YES;
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

- (void)getMyMessage
{
    __weak typeof(self)weakSelf = self;
    
    NSString *key = [GMAPI getAuthkey];
    
    if (key.length == 0) {
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:MESSAGE_GET_MINE,key];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        if ([LTools isDictinary:result]) {
            
           MessageModel *a_yiyi_model = [[MessageModel alloc]initWithDictionary:[result objectForKey:@"yy_msg"]];
           MessageModel *a_shop_model = [[MessageModel alloc]initWithDictionary:[result objectForKey:@"shop_msg"]];
           MessageModel *a_other_model = [[MessageModel alloc]initWithDictionary:[result objectForKey:@"dynamic_msg"]];
            
            [weakSelf setCellWithYiyiModel:a_yiyi_model shopModel:a_shop_model otherModel:a_other_model];
            
            [weakSelf updateTabbarNumber:[self unreadMessgeNum]];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"");
        
    }];
}

#pragma mark - 事件处理

/**
 *  获取未读消息条数
 */
- (int)unreadMessgeNum
{
    int sum = 0;
    
    int rong_num = [[RCIM sharedRCIM] getTotalUnreadCount];
    
    if (rong_num <= 0) {
        rong_num = 0;
    }
    
    sum = yiyi_model.unread_msg_num + shop_model.unread_msg_num + other_model.unread_msg_num + rong_num;
    
    return sum;
}

/**
 *  更新未读消息显示
 *
 *  @param number 未读数
 */
- (void)updateTabbarNumber:(int)number
{
    NSString *number_str = nil;
    if (number > 0) {
        number_str = [NSString stringWithFormat:@"%d",number];
    }
    
    self.navigationController.tabBarItem.badgeValue = number_str;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [number_str intValue];
}

- (void)setCellWithYiyiModel:(MessageModel *)yiyi_Model_c
                   shopModel:(MessageModel *)shop_Model_c
                  otherModel:(MessageModel *)other_Model_c
{
    yiyi_model = yiyi_Model_c;
    shop_model = shop_Model_c;
    other_model = other_Model_c;
    
    [yiyi_cell setCellWithModel:yiyi_Model_c placeHolder:@"欢迎使用衣+衣!"];
    [shop_cell setCellWithModel:shop_Model_c placeHolder:@"您关注的商家没有最新消息!"];
    [other_cell setCellWithModel:other_Model_c placeHolder:@"暂时没有动态消息!"];
}

/**
 *  衣加衣团队
 */
- (void)tapToYIJiaYi:(UITapGestureRecognizer *)tap
{
    NSLog(@"衣加衣团队");
    MailMessageViewController *mail = [[MailMessageViewController alloc]init];
    mail.aType = Message_List_Yy;
    mail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mail animated:YES];
}

/**
 *  商家消息
 */
- (void)tapToMail:(UITapGestureRecognizer *)tap
{
    NSLog(@"商家消息");
    MailMessageViewController *mail = [[MailMessageViewController alloc]init];
    mail.aType = Message_List_Shop;
    mail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mail animated:YES];
}

/**
 *  衣加衣团队
 */
- (void)tapToDynamic:(UITapGestureRecognizer *)tap
{
    NSLog(@"动态消息");
    MailMessageViewController *mail = [[MailMessageViewController alloc]init];
    mail.aType = Message_List_Dynamic;
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
        contact.GTitleLabel.text = userName;
        contact.GTitleLabel.textColor = RGBCOLOR(251, 108, 157);
        contact.portraitStyle = RCUserAvatarCycle;
        contact.enableSettings = NO;
        contact.conversationType = conversation.conversationType;
        contact.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contact animated:YES];
    }

}

@end
