//
//  ShenQingDianPuViewController.m
//  YiYiProject
//
//  Created by szk on 15/1/5.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ShenQingDianPuViewController.h"
#import "GRootScrollView.h"
#import "GtopScrollView.h"

@interface ShenQingDianPuViewController (){

    UIView *_indicator;
    
    
    UIScrollView *_jingpingdianView;
    UIScrollView *_shanchangdianView;


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
    
    //分配内存
    self.shuruTextFieldArray = [NSMutableArray arrayWithCapacity:1];
    self.chooseLabelArray = [NSMutableArray arrayWithCapacity:1];
    
    [self createViews];
    
    [self createSegButton];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gShou) name:UIKeyboardWillHideNotification object:nil];
    
    
    
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
    
    _indicator = [[UIView alloc]initWithFrame:CGRectMake(0, 43, DEVICE_WIDTH/2.f, 2)];
    _indicator.backgroundColor = [UIColor colorWithHexString:@"ea5670"];
    [segView addSubview:_indicator];
}


- (void)clickToSwap:(UIButton *)sender
{
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:100];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
    if (sender.tag == 100) {
        btn1.selected = YES;
        btn2.selected = NO;
        _indicator.left = 0;
        _jingpingdianView.hidden = NO;
        _shanchangdianView.hidden = YES;
    }else
    {
        btn1.selected = NO;
        btn2.selected = YES;
        _indicator.left = DEVICE_WIDTH/2.f;
        _jingpingdianView.hidden = YES;
        _shanchangdianView.hidden = NO;
    }
}


#pragma mark--精品店的view


- (void)createViews
{
    
    
    
    //精品店
    _jingpingdianView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 58, DEVICE_WIDTH, DEVICE_HEIGHT - 58)];
    _jingpingdianView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT+58+58);
    _jingpingdianView.scrollEnabled = NO;
    [self.view addSubview:_jingpingdianView];
    
    //商场店
    _shanchangdianView = [[UIScrollView alloc]initWithFrame:_jingpingdianView.frame];
    _shanchangdianView.hidden = YES;
    [self.view addSubview:_shanchangdianView];
    
    //精品
    [self createJingPinDianView];
    
    //商场店
    [self createShangchangdianView];
    
    
}

-(void)createShangchangdianView{
    UIView *witheBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 300)];
    
    witheBgView.backgroundColor=[UIColor whiteColor];
    [_shanchangdianView addSubview:witheBgView];
    
    NSArray *titleArr=@[@"选择商场",@"选择楼层",@"选择品牌",@"门牌号",@"电话",@"验证码"];
    
    for (int i=0; i<6; i++) {
        
        
        UILabel *title_Label=[LTools createLabelFrame:CGRectMake(17, i*50, DEVICE_WIDTH-17, 50) title:titleArr[i] font:17 align:NSTextAlignmentLeft textColor:RGBCOLOR(95, 95, 95)];
        [witheBgView addSubview:title_Label];
        
        [self.chooseLabelArray addObject:title_Label];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 50*i, DEVICE_WIDTH, 0.5)];
        lineView.backgroundColor=RGBCOLOR(229, 229, 229);
        [witheBgView addSubview:lineView];
        
        
//        UITextField *shuRuTextfield=[[UITextField alloc]initWithFrame:CGRectMake(100, i*50, DEVICE_WIDTH, 50)];
//        shuRuTextfield.tag=200+i;
//        [witheBgView addSubview:shuRuTextfield];
        
    }
    
    UIButton *commitButton=[LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(20+DEVICE_WIDTH, 390, DEVICE_WIDTH-40, 44) normalTitle:@"提交" image:nil backgroudImage:nil superView:witheBgView target:self action:@selector(tijiao:)];
    
    commitButton.tag=300;
    commitButton.backgroundColor=RGBCOLOR(208, 40, 73);
    
    CALayer *l = [commitButton layer];   //获取ImageView的层
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.0f];
    
    [_shanchangdianView addSubview:commitButton];

}


-(void)createJingPinDianView{
    
    //收键盘
    //收键盘
    UIControl *backControl = [[UIControl alloc]initWithFrame:_jingpingdianView.bounds];
    [backControl addTarget:self action:@selector(gShou) forControlEvents:UIControlEventTouchDown];
    [_jingpingdianView addSubview:backControl];
    
    
    //背景色
    UIView *witheBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 200)];
    witheBgView.backgroundColor=[UIColor whiteColor];
    witheBgView.userInteractionEnabled = NO;
    [_jingpingdianView addSubview:witheBgView];
    
    
    NSArray *titleArr=@[@"名称",@"地址",@"电话",@"验证码"];

    for (int i=0; i<4; i++) {
        
        
        
        UILabel *title_Label=[LTools createLabelFrame:CGRectMake(17, i*50, 65, 50) title:titleArr[i] font:17 align:NSTextAlignmentLeft textColor:RGBCOLOR(95, 95, 95)];
        [_jingpingdianView addSubview:title_Label];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 50*i, DEVICE_WIDTH, 0.5)];
        lineView.backgroundColor=RGBCOLOR(229, 229, 229);
        [_jingpingdianView addSubview:lineView];
        
        UITextField *shuRuTextfield=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title_Label.frame), i*50, DEVICE_WIDTH-17-title_Label.frame.size.width-17, 50)];
        shuRuTextfield.tag=100+i;
        [self.shuruTextFieldArray addObject:shuRuTextfield];
        shuRuTextfield.delegate = self;
        [_jingpingdianView addSubview:shuRuTextfield];
        
        
        
        
    }
    
    UIButton *commitButton=[LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(20, 290, DEVICE_WIDTH-40, 44) normalTitle:@"提交" image:nil backgroudImage:nil superView:_jingpingdianView target:self action:@selector(tijiao:)];
    commitButton.tag=400;
    commitButton.backgroundColor=RGBCOLOR(208, 40, 73);
    
    CALayer *l = [commitButton layer];   //获取ImageView的层
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.0f];
    
    [_jingpingdianView addSubview:commitButton];

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
    
    
    if (sender.tag==400)//申请普通精品小店
    {
        [self gShou];
        
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
        
        
    }else if(sender.tag==300)//申请商场店
    {
        
    
    }
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    NSLog(@"textField.tag = %ld",(long)textField.tag);
    
    _jingpingdianView.scrollEnabled = YES;
    if (textField.tag == 102||textField.tag == 103) {//电话 验证码
        if (_jingpingdianView.contentOffset.y>=58) {
            
        }else{
            _jingpingdianView.contentOffset = CGPointMake(0, 58);
        }
        
    }
    
}




-(void)gShou{
    NSLog(@"收键盘了");
    if (_jingpingdianView.contentOffset.y>=58) {
        _jingpingdianView.contentOffset = CGPointMake(0, 0);
    }
    for (UITextField *tf in self.shuruTextFieldArray) {
        [tf resignFirstResponder];
    }
    _jingpingdianView.scrollEnabled = NO;
}

@end
