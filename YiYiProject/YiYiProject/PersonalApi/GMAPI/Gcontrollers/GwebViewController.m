//
//  GwebViewController.m
//  fblifebbs
//
//  Created by gaomeng on 14/10/17.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GwebViewController.h"

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface GwebViewController ()

@end

@implementation GwebViewController



-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *url =[NSURL URLWithString:self.urlstring];
    self.myTitle = @"详情";
    
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    awebview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64-40)];
    awebview.delegate=self;
    [awebview loadRequest:request];
    awebview.scalesPageToFit = YES;
    [self.view addSubview:awebview];;
    
    UIView *toolview=[[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT-65-40, DEVICE_WIDTH, 40)];
    toolview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"ios7_webviewbar.png"]];
    [self.view addSubview:toolview];
    
    
    NSArray *array_imgname=[NSArray arrayWithObjects:@"ios7_goback4032.png",@"ios7_goahead4032.png",@"ios7_refresh4139.png", nil];
    for (int i=0; i<3; i++) {
        UIImage *img=[UIImage imageNamed:[array_imgname objectAtIndex:i]];
        
        UIButton *tool_Button=[[UIButton alloc]initWithFrame:CGRectMake(5+i*70, 5, img.size.width, img.size.height)];
        tool_Button.center=CGPointMake(22+i*i*68.5*GscreenRatio_320, 20);
        
        tool_Button.tag=99+i;
        [tool_Button setBackgroundImage:[UIImage imageNamed:[array_imgname objectAtIndex:i]] forState:UIControlStateNormal];
        
        [tool_Button addTarget:self action:@selector(dobuttontool:) forControlEvents:UIControlEventTouchUpInside];
        [toolview addSubview:tool_Button];
        
    }
    
    
}


-(void)dobuttontool:(UIButton *)sender{
    switch (sender.tag) {
        case 99:
            [awebview goBack];
            break;
        case 100:
            [awebview goForward];
            break;
        case 101:
            [awebview reload];
            break;
            
            
        default:
            break;
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
//    string_title=[NSString stringWithFormat:@"%@",[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    
//    self.title=string_title;
    
    button_comment.userInteractionEnabled=YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
