//
//  GScanViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GScanViewController.h"

#import "GwebViewController.h"

#import "MineViewController.h"

#define ScanKuangFrame CGRectMake(50, 90, 220, 223)

#import "NSDictionary+GJson.h"

@interface GScanViewController ()
{
    UIImageView * _fourJiaoImageView;
}
@end

@implementation GScanViewController

- (void)dealloc
{
    
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    //导航栏
    UIView *daohangView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 64)];
    UIImageView *imv = [[UIImageView alloc]initWithFrame:daohangView.bounds];
    [imv setImage:[UIImage imageNamed:@"navigationBarBackground.png"]];
    [daohangView addSubview:imv];
    [self.view addSubview:daohangView];
    
    //标题
    UILabel *_myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/2.0-100,20,200,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = @"扫描二维码";
    _myTitleLabel.textColor = RGBCOLOR(253, 106, 157);
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    [daohangView addSubview:_myTitleLabel];
    
    
    //返回按钮
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(16,20,40,44)];
    [button_back addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [button_back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [daohangView addSubview:button_back];
    
    
    
    //半透明的浮层
//    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
//    backImageView.image = [UIImage imageNamed:@"saoyisao_bg_640_996.png"];
//    [self.view addSubview:backImageView];
    
    
    //四个角
    _fourJiaoImageView =[[UIImageView alloc]init];
    
    if (iPhone6){
        [_fourJiaoImageView setFrame:CGRectMake(58, 108, 258, 266)];
    }else{
        [_fourJiaoImageView setFrame:ScanKuangFrame];
    }
    
    NSLog(@"%f",DEVICE_WIDTH);
    
    if (DEVICE_WIDTH == 414) {
        [_fourJiaoImageView setFrame:CGRectMake(65, 120, 285, 298)]; //150 270
        
    }
    
    _fourJiaoImageView.image = [UIImage imageNamed:@"fkuang.png"];
    [self.view addSubview:_fourJiaoImageView];
    
    
    //文字提示label
    
    UILabel *tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(_fourJiaoImageView.frame.origin.x, CGRectGetMaxY(_fourJiaoImageView.frame)+68, _fourJiaoImageView.frame.size.width, 12)];
    tishiLabel.font = [UIFont systemFontOfSize:12];
    tishiLabel.textColor = [UIColor whiteColor];
    tishiLabel.backgroundColor = [UIColor clearColor];
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    tishiLabel.text = @"将二维码显示在扫描框内，即可自动扫描";
    [self.view addSubview:tishiLabel];
    
    
    //我的二维码
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(tishiLabel.frame.origin.x, CGRectGetMaxY(tishiLabel.frame)+37, tishiLabel.frame.size.width, 15);
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    
    
    
    upOrdown = NO;
    num =0;
    
    //上下滚动的条
    _line = [[UIImageView alloc]initWithFrame:CGRectMake(40, 6+89-18-6, 240, 18)];
    [_line setImage:[UIImage imageNamed:@"fshan.png"]];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    
    
    
    [timer fire];
    
    
}

//左边按钮点击方法
-(void)leftButtonTap:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}


-(void)animation1
{
    //一个条
    if (upOrdown == NO) {
        num ++;
        
        
        
        if (iPhone6){
            [_line setFrame:CGRectMake(48, 6+107-9-6+2*num, 278, 18)];
        }else{
            
            _line.frame = CGRectMake(40, 6+89-9-6+2*num, 240, 18);
            //CGRectMake(50, 90, 220, 223)
        }
        
        NSLog(@"%f",DEVICE_WIDTH);
        
        if (DEVICE_WIDTH == 414) {
            [_line setFrame:CGRectMake(55, 6+119-9-6+2*num, 305, 18)]; //150 270
            
        }
        
        
        int hh = _fourJiaoImageView.frame.size.height;
        
        if (hh == 223) {
            hh =220;
        }
        
        if (2*num == hh) {
            
            upOrdown = YES;
        }
        
    }
    else {
        num --;
        
        if (iPhone6){
            [_line setFrame:CGRectMake(48, 6+107-9-6+2*num, 278, 18)];
        }else{
            _line.frame = CGRectMake(40, 6+89-9-6+2*num, 240, 18);
        }
        
        NSLog(@"%f",DEVICE_WIDTH);
        
        if (DEVICE_WIDTH == 414) {
            [_line setFrame:CGRectMake(55, 6+119-9-6+2*num, 305, 18)];
            
        }
        
        
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}




-(void)viewWillAppear:(BOOL)animated
{
    
    [MBProgressHUD showHUDAddedTo:_fourJiaoImageView animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!TARGET_IPHONE_SIMULATOR) {
            [self checkAVAuthorizationStatus];
            [MBProgressHUD hideHUDForView:_fourJiaoImageView animated:YES];
        }
    });
    
    
}

- (void)checkAVAuthorizationStatus
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //    NSString *tips = NSLocalizedString(@"AVAuthorization", @"您没有权限访问相机");
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized
        [self setupCamera];
    } else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您没有权限访问相机,请到设置界面打开相机设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alertView show];
    }
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //_preview.frame =CGRectMake(20,110,280,280);
    _preview.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    
    
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    [timer invalidate];
    NSLog(@"123");
    
    NSLog(@"%@",stringValue);

    _urlStr = stringValue;
    NSArray *aaa = [_urlStr componentsSeparatedByString:@","];
    
    if (([stringValue rangeOfString:@"http://"].length && [stringValue rangeOfString:@"."].length)||([stringValue rangeOfString:@"https://"].length && [stringValue rangeOfString:@"."].length))
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否打开此链接" message:stringValue delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        alert.tag = 100000;
        
        [alert show];
        
    }else if ([aaa[0]intValue]==2){//关注精品店
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否关注该店铺" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        if (aaa.count>2) {
            _urlStr = aaa[1];
        }
        
        alert.tag = 31;
        [alert show];
    }else if ([aaa[0]intValue]==3){//关注品牌店
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"是否关注该店铺" message:nil delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil,nil];
        if (aaa.count>2) {
            _urlStr = aaa[1];
        }
        alert.tag = 32;
        [alert show];
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"未识别的二维码" message:nil delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil,nil];
        alert.tag = 30;
        [alert show];
    }
    
    
    
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 100000) {
        if (buttonIndex == 1) {//确定
            if (_urlStr) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate gScanvcPushWithString:_urlStr];
                }];
                
            }
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }else if (alertView.tag == 30){//未能识别的二维码
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else if (alertView.tag == 31){//是否关注该店铺 精品店
        if (buttonIndex == 0) {//取消
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }else if (buttonIndex == 1){
            [self guanzhuShopWithShopId:_urlStr];
        }
    }else if (alertView.tag == 32){//品牌店
        if (buttonIndex == 0) {//取消
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }else if (buttonIndex == 1){
            [self guanzhuPinpaidianWithShopId:_urlStr];
        }
    }
}



//关注精品店
-(void)guanzhuShopWithShopId:(NSString *)shopId{
    NSString *post = [NSString stringWithFormat:@"&mall_id=%@&authcode=%@",shopId,[GMAPI getAuthkey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *url = [NSString stringWithFormat:GUANZHUSHANGCHANG];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
            [GMAPI showAutoHiddenMBProgressWithText:@"关注成功" addToView:self.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE object:nil];
            
            [self performSelector:@selector(gdismiss) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
            
            
        }else{
            [GMAPI showAutoHiddenMBProgressWithText:result[@"msg"] addToView:self.view];
            [self performSelector:@selector(gdismiss) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
        }
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [GMAPI showAutoHiddenMBProgressWithText:@"关注失败" addToView:self.view];
        [self performSelector:@selector(gdismiss) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
    }];
}

//关注品牌店
-(void)guanzhuPinpaidianWithShopId:(NSString *)shopId{
    NSString *post = [NSString stringWithFormat:@"&shop_id=%@&authcode=%@",shopId,[GMAPI getAuthkey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *url = [NSString stringWithFormat:GGUANZHUPINPAIDIAN];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
            [GMAPI showAutoHiddenMBProgressWithText:@"关注成功" addToView:self.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_STORE object:nil];
            
            [self performSelector:@selector(gdismiss) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
            
            
        }else{
            [GMAPI showAutoHiddenMBProgressWithText:result[@"msg"] addToView:self.view];
            [self performSelector:@selector(gdismiss) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
        }
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [GMAPI showAutoHiddenMBProgressWithText:@"关注失败" addToView:self.view];
        [self performSelector:@selector(gdismiss) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
    }];
}



-(void)gdismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
