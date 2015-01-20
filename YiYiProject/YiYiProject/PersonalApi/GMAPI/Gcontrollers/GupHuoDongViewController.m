//
//  GupHuoDongViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/21.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GupHuoDongViewController.h"
#import "GHolderTextView.h"

@interface GupHuoDongViewController ()<UITextFieldDelegate>
{
    GHolderTextView *_gholderTextView;
    
    UIView *_view1;//标题
    
    UIView *_view2;//活动内容
    
    UIView *_view3;//图片
    
}
@end

@implementation GupHuoDongViewController



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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self creatView1];
    
    [self creatView2];
    
    [self creatView3];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gShou) name:UIKeyboardWillHideNotification object:nil];
    
}

//活动标题
-(void)creatView1{
    
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50)];
    
    //收键盘
    UIControl *tapshou = [[UIControl alloc]initWithFrame:_view1.bounds];
    [tapshou addTarget:self action:@selector(gShou) forControlEvents:UIControlEventTouchDown];
    [_view1 addSubview:tapshou];
    
    //分割线
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0.5)];
    line1.backgroundColor = RGBCOLOR(234, 234, 234);
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, DEVICE_WIDTH, 0.5)];
    line2.backgroundColor = RGBCOLOR(234, 234, 234);
    [self.view addSubview:line1];
    [self.view addSubview:line2];
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 15, 35, 20)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = RGBCOLOR(114, 114, 114);
    titleLabel.text = @"标题";
    [_view1 addSubview:titleLabel];
    
    
    //输入框
    UITextField *shuruTf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+20, titleLabel.frame.origin.y, DEVICE_WIDTH-17-17-20-titleLabel.frame.size.width, titleLabel.frame.size.height)];
    shuruTf.font = [UIFont systemFontOfSize:17];
    shuruTf.textColor = RGBCOLOR(3, 3, 3);
    shuruTf.tag = 200;
    shuruTf.delegate = self;
    [_view1 addSubview:shuruTf];
    
    
    [self.view addSubview:_view1];
    
}



//活动内容
-(void)creatView2{
    
    _view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame), DEVICE_WIDTH, 170)];
    _view2.backgroundColor = [UIColor orangeColor];
    
    
    //收键盘
    UIControl *tapshou = [[UIControl alloc]initWithFrame:_view2.bounds];
    [tapshou addTarget:self action:@selector(gShou) forControlEvents:UIControlEventTouchDown];
    [_view2 addSubview:tapshou];
    
    _gholderTextView = [[GHolderTextView alloc]initWithFrame:CGRectMake(16, 10, DEVICE_WIDTH-32, 150) placeholder:@"活动内容..." holderSize:15];
    _gholderTextView.tag = 300;
    
    _gholderTextView.font = [UIFont systemFontOfSize:15];
    _gholderTextView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    [_view2 addSubview:_gholderTextView];
    
    [self.view addSubview:_view2];
    
}


-(void)creatView3{
    _view3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_view2.frame), DEVICE_WIDTH, 200)];
    _view3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_view3];
}





-(void)gShou{
    NSLog(@"收键盘了");
   
    UITextField *tf = (UITextField*)[self.view viewWithTag:200];
    [tf resignFirstResponder];
    
    UITextView *tv = [(UITextView*)self.view viewWithTag:300];
    [tv resignFirstResponder];
    
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"%ld",(long)textField.tag);
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
