//
//  GSettingViewController.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/21.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GSettingViewController.h"

@interface GSettingViewController ()

@end

@implementation GSettingViewController




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
