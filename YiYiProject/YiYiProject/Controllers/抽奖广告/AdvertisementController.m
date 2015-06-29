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
    

    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.myTitleLabel.text = self.targetTitle;
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.targetUrl]]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark UIWebViewDelegate <NSObject>

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError %@",error);

}

@end
