//
//  GuserPhoneViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GuserPhoneViewController.h"

@interface GuserPhoneViewController ()
{
    UITextField *_phoneTf;//手机号tf
    
    UIButton *_yanzhengmaBtn;//验证码btn
    
    UITextField *_yanzhengmaTf;//验证码Tf
    
    UIButton *_querenBtn;//确认btn
    
    UITextField *_passWordTf;//密码tf
    
    NSTimer *_timer;
    
    int _timeNum;
}
@end

@implementation GuserPhoneViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.myTitle=@"绑定手机号";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self creatPhoneView];
    
    
    
    
}



-(void)creatPhoneView{
    _phoneTf = [[UITextField alloc]initWithFrame:CGRectMake(14, 15, DEVICE_WIDTH-28, 30)];
    _phoneTf.placeholder = @"请输入手机号";
    _phoneTf.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_phoneTf];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(_phoneTf.frame.origin.x, CGRectGetMaxY(_phoneTf.frame), _phoneTf.frame.size.width, 0.5)];
    line1.backgroundColor = RGBCOLOR(206, 197, 181);
    [self.view addSubview:line1];
    
    _yanzhengmaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_yanzhengmaBtn setFrame:CGRectMake(_phoneTf.frame.origin.x, CGRectGetMaxY(_phoneTf.frame)+20, _phoneTf.frame.size.width, 30)];
    _yanzhengmaBtn.backgroundColor = RGBCOLOR(253, 105, 154);
    [_yanzhengmaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _yanzhengmaBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_yanzhengmaBtn addTarget:self action:@selector(huoquyanzhengma) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yanzhengmaBtn];
    
    _yanzhengmaTf = [[UITextField alloc]initWithFrame:CGRectMake(_yanzhengmaBtn.frame.origin.x, CGRectGetMaxY(_yanzhengmaBtn.frame)+20, _yanzhengmaBtn.frame.size.width, 30)];
    _yanzhengmaTf.font = [UIFont systemFontOfSize:13];
    _yanzhengmaTf.placeholder = @"请输入验证码";
    [self.view addSubview:_yanzhengmaTf];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(_yanzhengmaTf.frame.origin.x, CGRectGetMaxY(_yanzhengmaTf.frame), _yanzhengmaTf.frame.size.width, 0.5)];
    line2.backgroundColor = RGBCOLOR(206, 197, 181);
    [self.view addSubview:line2];
    
    
    _passWordTf = [[UITextField alloc]initWithFrame:CGRectMake(line2.frame.origin.x, CGRectGetMaxY(line2.frame)+20, line2.frame.size.width, 30)];
    _passWordTf.font = [UIFont systemFontOfSize:13];
    _passWordTf.placeholder = @"请设置手机登陆密码";
    _passWordTf.secureTextEntry = YES;
    [self.view addSubview:_passWordTf];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(_passWordTf.frame.origin.x, CGRectGetMaxY(_passWordTf.frame), _passWordTf.frame.size.width, 0.5)];
    line3.backgroundColor = RGBCOLOR(206, 197, 181);
    [self.view addSubview:line3];
    
    
    
    _querenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_querenBtn setFrame:CGRectMake(line3.frame.origin.x, CGRectGetMaxY(line3.frame)+20, line3.frame.size.width, 30)];
    _querenBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_querenBtn setTitle:@"确认" forState:UIControlStateNormal];
    _querenBtn.backgroundColor = RGBCOLOR(253, 105, 154);
    
    [_querenBtn addTarget:self action:@selector(querenClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_querenBtn];
    
}


//点击获取验证码
-(void)huoquyanzhengma{
    NSLog(@"获取验证码");
    //网络请求
    
    
    if (_phoneTf.text.length==11) {
        
        NSString *api = [NSString stringWithFormat:USER_GET_SECURITY_CODE,_phoneTf.text,5,[LTools md5Phone:_passWordTf.text]];
        GmPrepareNetData *ccc =[[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            
            NSLog(@"%@",result);
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            
        }];
        
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtnTitle) userInfo:nil repeats:YES];
        [_timer fire];
        _timeNum = 60;
        [_yanzhengmaBtn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum] forState:UIControlStateNormal];
        _yanzhengmaBtn.userInteractionEnabled = NO;
        
        
    }else{
        [GMAPI showAutoHiddenMBProgressWithText:@"请输入正确的手机号" addToView:self.view];
    }
    
}


-(void)changeBtnTitle{
    _yanzhengmaBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _timeNum--;
    [_yanzhengmaBtn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum] forState:UIControlStateNormal];
    
    if (_timeNum == 0) {
        [_yanzhengmaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _yanzhengmaBtn.userInteractionEnabled = YES;
    }
}

//点击确认按钮
-(void)querenClicked{
    NSLog(@"确认");
    
    NSString *phoneNum = _phoneTf.text;
    NSString *code = _yanzhengmaTf.text;
    NSString *password = _passWordTf.text;
    
    if (_phoneTf.text.length == 11 && code.length>0 && password.length > 0 ) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *postUrl = [NSString stringWithFormat:@"&authcode=%@&mobile=%@&password=%@&code=%@",[GMAPI getAuthkey],phoneNum,password,code];
        
        NSData *postData = [postUrl dataUsingEncoding:NSUTF8StringEncoding];
        
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:GBANGDINGPHONE isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSLog(@"%@",result);
            
            [GMAPI showAutoHiddenMBProgressWithText:result[@"msg"] addToView:self.view];
            
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:failDic[@"msg"] addToView:self.view];
        }];
        
    }else{
        [GMAPI showAutoHiddenMBProgressWithText:@"请完善信息" addToView:self.view];
    }
    
   
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
