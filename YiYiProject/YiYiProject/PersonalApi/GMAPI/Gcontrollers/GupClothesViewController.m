//
//  GupClothesViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/18.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GupClothesViewController.h"

@interface GupClothesViewController ()

@end

@implementation GupClothesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.myTitle=@"申请店铺";
    
    
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    
    
    //主scrollview
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 15, DEVICE_WIDTH, DEVICE_HEIGHT-15)];
    _mainScrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_mainScrollView];
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
