//
//  ChooseImageViewController.m
//  YiYiProject
//
//  Created by unisedu on 15/1/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ChooseImageViewController.h"

@interface ChooseImageViewController ()

@end

@implementation ChooseImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    NSArray *clothesArray = (NSArray *)[sourceDic objectForKey:@"clothes"];
    long count = clothesArray.count;
    self.myTitle = [NSString stringWithFormat:@"%@(%ld)",[sourceDic objectForKey:@"sort_name"],count];
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.view.backgroundColor = [UIColor whiteColor];
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
