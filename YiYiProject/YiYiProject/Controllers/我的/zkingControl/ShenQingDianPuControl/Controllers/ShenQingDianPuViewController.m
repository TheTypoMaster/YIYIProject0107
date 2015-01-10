//
//  ShenQingDianPuViewController.m
//  YiYiProject
//
//  Created by szk on 15/1/5.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ShenQingDianPuViewController.h"

@interface ShenQingDianPuViewController (){

    UIView *indicator;
    
    UIScrollView *bgScroll;



}

@end

@implementation ShenQingDianPuViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden=NO;
    

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];

    self.navigationController.navigationBarHidden=YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.myTitle=@"申请店铺";
    
    self.view.backgroundColor=RGBCOLOR(239, 239, 239);
    
    
    [self createViews];
    
    [self createSegButton];
    
    
    // Do any additional setup after loading the view.
}



#pragma mark--切换精品店和商场店

- (void)createSegButton
{
    UIView *segView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 58)];
    segView.backgroundColor = RGBCOLOR(239, 239, 239);
    [self.view addSubview:segView];
    
    NSArray *titles = @[@"精品店",@"商场店"];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.frame = CGRectMake(DEVICE_WIDTH/2.f * i, 0, DEVICE_WIDTH/2.f, 45);
        [btn setBackgroundColor:[UIColor whiteColor]];
        [segView addSubview:btn];
        [btn addTarget:self action:@selector(clickToSwap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    indicator = [[UIView alloc]initWithFrame:CGRectMake(0, 43, DEVICE_WIDTH/2.f, 2)];
    indicator.backgroundColor = [UIColor colorWithHexString:@"ea5670"];
    [segView addSubview:indicator];
}


- (void)clickToSwap:(UIButton *)sender
{
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:100];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
    if (sender.tag == 100) {
        btn1.selected = YES;
        btn2.selected = NO;
        indicator.left = 0;
        bgScroll.contentOffset = CGPointMake(0, 0);
    }else
    {
        btn1.selected = NO;
        btn2.selected = YES;
        indicator.left = DEVICE_WIDTH/2.f;
        bgScroll.contentOffset = CGPointMake(DEVICE_WIDTH, 0);
    }
}


#pragma mark--精品店的view


- (void)createViews
{
    bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 58, DEVICE_WIDTH, self.view.height - 58)];
    bgScroll.scrollEnabled=NO;
    [self.view addSubview:bgScroll];
    bgScroll.contentSize = CGSizeMake(DEVICE_WIDTH * 2, bgScroll.height);
    
    //精品
    [self createJingPinDianView];
    
    //品牌
 
}


-(void)createJingPinDianView{
    
    
    
    
    UIView *witheBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 200)];
    
    witheBgView.backgroundColor=[UIColor whiteColor];
    [bgScroll addSubview:witheBgView];
    
    NSArray *titleArr=@[@"名称",@"地址",@"电话",@"验证码"];

    for (int i=0; i<4; i++) {
        
        
        
        UILabel *title_Label=[LTools createLabelFrame:CGRectMake(17, i*50, DEVICE_WIDTH, 50) title:titleArr[i] font:17 align:NSTextAlignmentLeft textColor:RGBCOLOR(95, 95, 95)];
        [witheBgView addSubview:title_Label];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 50*i, DEVICE_WIDTH, 0.5)];
        lineView.backgroundColor=RGBCOLOR(229, 229, 229);
        [witheBgView addSubview:lineView];
        
        UITextField *shuRuTextfield=[[UITextField alloc]initWithFrame:CGRectMake(85, i*50, DEVICE_WIDTH, 50)];
        shuRuTextfield.tag=100+i;
        [witheBgView addSubview:shuRuTextfield];
        
        
        
        
    }
    
    UIButton *commitButton=[LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(20, 290, DEVICE_WIDTH-40, 44) normalTitle:@"提交" image:nil backgroudImage:nil superView:witheBgView target:self action:@selector(tijiao:)];
    
    commitButton.backgroundColor=RGBCOLOR(208, 40, 73);
    
    CALayer *l = [commitButton layer];   //获取ImageView的层
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.0f];
    
    [bgScroll addSubview:commitButton];

}


-(void)tijiao:(UIButton *)sender{
    
    
    
    /*mall_name 商铺名称 string 限制30字以内
     mall_type 商铺类型(商场小店), 1 商场 2 精品店
     mobile 手机号 code 验证码 latitude 维度, 小数点后8
     longitude 经度, 小数点后8
     floor_num 楼层 int
     province_id 省id int
     city_id 市id int
     disctrict_id 区id, int
     street 街道地址 string
     authcode 约定好的code 判断店铺所有人*/
    
    
    NSString *authkey = [GMAPI getAuthkey];
    
    
    
    NSString *post = [NSString stringWithFormat:@"&mall_name=%@&street=%@&mobile=%@&code=%@&mall_type=%@&authkey=%@",@"SS",@"知春路",@"18600912932",@"213",@"1",authkey];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url = [NSString stringWithFormat:KAITONG_DIANPU_URL];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        
        NSLog(@"faildic==%@",failDic);
        
        [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
    }];
    
    

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
