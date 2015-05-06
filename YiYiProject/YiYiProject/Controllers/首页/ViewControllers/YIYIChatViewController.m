//
//  YIYIChatViewController.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/26.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "YIYIChatViewController.h"
#import "ProductDetailController.h"
#import "RCIM.h"
#import "GchatSettingViewController.h"

@implementation YIYIChatViewController




-(id)init{
    self = [super init];
    if (self) {
        self.GTitleLabel = [[UILabel alloc]init];
    }
    
    return self;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:self.lastPageNavigationHidden animated:animated];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton1.width = MY_MACRO_NAME?-13:5;
    
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME? -5:5,8,40,44)];
    [button_back addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH - 100, 44)];
    [self.GTitleLabel setFrame:titleView.bounds];
    self.GTitleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:self.GTitleLabel];
    self.GTitleLabel.textColor = [UIColor blackColor];
    UIBarButtonItem *title_item = [[UIBarButtonItem alloc]initWithCustomView:titleView];
    self.navigationItem.leftBarButtonItems=@[spaceButton1,back_item,title_item];
    
    
    //自定义导航左右按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemPressed:)];
    [rightButton setTintColor:RGBCOLOR(255, 78, 139)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    if (self.isProductDetailVcPush) {
        //发送产品图文链接
        [self sendProductDetailMessage];
    }else
    {
        self.GTitleLabel.text = self.currentTargetName;
    }
    
    //设置点击跳转
    [self setDetailMessageViewClickedBlock];
    
    
    
}


-(void)rightBarButtonItemPressed:(id)sender{
    GchatSettingViewController *temp = [[GchatSettingViewController alloc]init];
    temp.HeadsPadView.hidden = YES;
    temp.targetId = self.currentTarget;
    temp.conversationType = self.conversationType;
    temp.portraitStyle = RCUserAvatarCycle;
    [self.navigationController pushViewController:temp animated:YES];
}


//发送产品图文链接
-(void)sendProductDetailMessage{
    RCRichContentMessage *message = [[RCRichContentMessage alloc] init];
    message.title = self.theModel.product_name;
    NSString *zhekou = [NSString stringWithFormat:@"%.1f折",self.theModel.discount_num * 10];
    message.digest = [NSString stringWithFormat:@"现价：%@元\n折扣：%@\n标签：%@",self.theModel.product_price,zhekou,self.theModel.product_tag];
    message.imageURL = self.theModel.product_tag;
    NSArray *imageArray = self.theModel.images;
    if (imageArray.count>0) {
        NSDictionary *dic = imageArray[0];
        message.imageURL = dic[@"540Middle"][@"src"];
    }
    
    message.extra = self.theModel.product_id;
    
//    [[RCIM sharedRCIM]sendRichContentMessage:self.conversationType
//                                    targetId:self.currentTarget
//                          richContentMessage:message
//                                    delegate:self
//                                      object:self];
    
    
    
    [self sendRichContentMessage:message];
    
    
    
}




//设置消息框点击跳转
-(void)setDetailMessageViewClickedBlock{
    
    __weak typeof (self)bself = self;
    
    [self setMessageTapHandler:^(RCMessage *message){
        
        [bself pushToProductDetailVcWithMessage:message];
    }];
    
    
}

-(void)pushToProductDetailVcWithMessage:(RCMessage*)message{
    ProductDetailController *detail = [[ProductDetailController alloc]init];
    RCRichContentMessage *ccc = (RCRichContentMessage*)message.content;
    detail.product_id = ccc.extra;
    detail.isYYChatVcPush = YES;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}




@end
