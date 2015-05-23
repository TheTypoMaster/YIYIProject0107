//
//  GShopPhoneViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GShopPhoneViewController.h"

@interface GShopPhoneViewController ()
{
    UITextField *_phoneTf;
}
@end


@implementation GShopPhoneViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    
    self.navigationController.navigationBarHidden = NO;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.myTitle=@"店铺联系电话";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self creatPhoneView];
    
    
}




-(void)creatPhoneView{
    _phoneTf = [[UITextField alloc]initWithFrame:CGRectMake(24, 24, DEVICE_WIDTH-48, 30)];
    _phoneTf.layer.borderColor = [UIColor grayColor].CGColor;
    _phoneTf.layer.borderWidth = 0.5;
    _phoneTf.layer.cornerRadius = 4;
    _phoneTf.font = [UIFont systemFontOfSize:15];
    _phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    
    NSLog(@"---------%@-------",self.theShopPhone);
    if (self.theShopPhone.length>0) {
        _phoneTf.text = self.theShopPhone;
    }else{
        _phoneTf.placeholder = @"请输入联系电话";
    }
    [self.view addSubview:_phoneTf];
    
    UIButton *quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quedingBtn setFrame:CGRectMake(24, CGRectGetMaxY(_phoneTf.frame)+12, DEVICE_WIDTH-48, 30)];
    quedingBtn.backgroundColor = RGBCOLOR(252, 76, 139);
    quedingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [quedingBtn setTitle:@"确   定" forState:UIControlStateNormal];
    [quedingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quedingBtn.layer.cornerRadius = 4;
    [self.view addSubview:quedingBtn];
    
    
    [quedingBtn addTarget:self action:@selector(telePhone) forControlEvents:UIControlEventTouchUpInside];
    
    
}



-(void)telePhone{
    [_phoneTf resignFirstResponder];
    NSString *thePhone = @"";
    
    thePhone = _phoneTf.text;
    
    NSString *url = [NSString stringWithFormat:@"%@&authcode=%@&shop_phone=%@&shop_id=%@",GCHANGESHOPTELEPHONE,[GMAPI getAuthkey],_phoneTf.text,self.shop_id];
    
    NSLog(@"%@",url);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"------%@",result);
        
        if ([result[@"errorcode"]intValue] == 0) {
            [GMAPI showAutoHiddenMBProgressWithText:result[@"msg"] addToView:self.view];
        }else{
            [GMAPI showAutoHiddenMBProgressWithText:result[@"msg"] addToView:self.view];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [GMAPI showAutoHiddenMBProgressWithText:failDic[@"msg"] addToView:self.view];
    }];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
