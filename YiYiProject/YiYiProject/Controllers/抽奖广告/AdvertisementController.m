//
//  AdvertisementController.m
//  YiYiProject
//
//  Created by lichaowei on 15/6/26.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "AdvertisementController.h"

@interface AdvertisementController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}

@end

@implementation AdvertisementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    
    UIButton *closeBtn = [[UIButton alloc]initWithframe:CGRectMake(DEVICE_WIDTH - 27 - 15 + 2, 30 - 4, 30, 30) buttonType:UIButtonTypeCustom normalTitle:nil selectedTitle:nil nornalImage:[UIImage imageNamed:@"Ttai_guanbi"] selectedImage:nil target:self action:@selector(clickToClose:)];
    [self.view addSubview:closeBtn];
    
}

- (void)clickToClose:(UIButton *)sender
{
    
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
