//
//  AboutTailCircleViewController.m
//  TailCircle
//
//  Created by 王龙 on 14/12/19.
//  Copyright (c) 2014年 王龙. All rights reserved.
//

#import "AboutTailCircleViewController.h"

@interface AboutTailCircleViewController ()

@end

@implementation AboutTailCircleViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.myTitleLabel.text = @"关于我们";
    
    [self.iconImageView addCornerRadius:30.f];
    
    NSString *version = [[NSString alloc] initWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    self.versionLabel.text = [NSString stringWithFormat:@"V %@",version];
    // Do any additional setup after loading the view from its nib.
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
