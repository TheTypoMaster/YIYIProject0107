//
//  GupActivityViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/6/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GupActivityViewController.h"
#import "PublishActivityController.h"
@interface GupActivityViewController ()

@end

@implementation GupActivityViewController



-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.myTitle=@"发布活动";
    if (self.thetype == GUPACTIVITYTYPE_EDIT) {
        self.myTitle = @"修改活动";
    }
    
    
    NSLog(@"self.mallInfo.brand_id: %@",self.mallInfo.brand_id);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(100, 100, 100, 100)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor redColor];
    [nextBtn addTarget:self action:@selector(gotoTheNextVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoTheNextVc{
    PublishActivityController *ccc = [[PublishActivityController alloc]init];
    ccc.lastPageNavigationHidden = NO;
    [self.navigationController pushViewController:ccc animated:YES];
}

@end
