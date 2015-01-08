//
//  FreeCollocationViewController.m
//  YiYiProject
//
//  Created by unisedu on 15/1/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "FreeCollocationViewController.h"
#import "ChooseClothesViewController.h"
@interface FreeCollocationViewController ()

@end

@implementation FreeCollocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.myTitle= @"自由搭配";
    self.rightString = @"完成";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f0f1"];
    [self createViews];
}
-(void)createViews
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(25, 25, DEVICE_WIDTH-50, (DEVICE_WIDTH-50)*1.4)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    UIButton *addImageBtn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(DEVICE_WIDTH-30-70, contentView.frame.origin.y+contentView.height+10, 70, 30) normalTitle:@"添加" image:nil backgroudImage:nil superView:self.view target:self action:@selector(addImageClick:)];
    addImageBtn.backgroundColor = [UIColor colorWithHexString:@"bebebe"];
    
}
-(void)addImageClick:(UIButton *) sender
{
    ChooseClothesViewController *chooseClothesVC = [[ChooseClothesViewController alloc] init];
    chooseClothesVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chooseClothesVC animated:YES];
}
-(void)rightButtonTap:(UIButton *) sender
{
    NSLog(@"完成");
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
