//
//  ApplyForViewController.m
//  YiYiProject
//
//  Created by soulnear on 14-12-21.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "ApplyForViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface ApplyForViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString * phone_num_string;///手机号
    NSString * verification_string;//验证码
    NSString * qq_string;//qq号
    NSString * wechat_string;//微信号
    NSMutableArray * string_array;
    NSArray * placeHolder_array;
    
    ///上传身份证按钮及展示视图
    UIButton * idcard_button;
    ///图标
    NSArray * image_array;
    ///获取验证码按钮
    UIButton * timer_button;
    ///输入手机号码
    UITextField * tel_textField;
    ///验证码
    UITextField * ver_textField;
    ///qq号
    UITextField * qq_textField;
    ///微信号
    UITextField * wechat_textField;
    
    ///计时器
    NSTimer * timer;
    ///倒计时时间
    int theCount;
    
    ///身份证图片
    UIImage * idcard_image;
}



@property(nonatomic,strong)UITableView * myTableView;


@end

@implementation ApplyForViewController

-(void)leftButtonTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(242,242,242);
    self.myTitle = @"申请搭配师";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    string_array = [NSMutableArray arrayWithObjects:phone_num_string,verification_string,qq_string,wechat_string,nil];
    placeHolder_array = [NSArray arrayWithObjects:@"",@"请输入手机号",@"请输入短信验证码",@"请输入QQ号",@"请输入微信号",@"",@"",nil];
    image_array = [NSArray arrayWithObjects:@"",[UIImage imageNamed:@"login_phone"],[UIImage imageNamed:@"login_xinfeng"],[UIImage imageNamed:@"apply_qq_image"],[UIImage imageNamed:@"apply_wechat_image"],@"",@"",nil];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT) style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = RGBCOLOR(234,234,234);
    [self.view addSubview:_myTableView];
    
    UIView * vvvvv = [[UIView alloc] init];
    _myTableView.tableFooterView = vvvvv;
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)doTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}


#pragma mark - UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)///灰色部分
    {
        return 30;
    }else if (indexPath.row == 5)///提交身份证，上传
    {
        return 370;
    }else
    {
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.row == 0)///灰色部分
    {
        cell.backgroundColor = RGBCOLOR(242,242,242);
        cell.contentView.backgroundColor = RGBCOLOR(242,242,242);
    }else if (indexPath.row == 5)///提交身份证，上传
    {
        cell.backgroundColor = RGBCOLOR(242,242,242);
        cell.contentView.backgroundColor = RGBCOLOR(242,242,242);
        ///白色背景
        UIView * whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0,12,DEVICE_WIDTH,144)];
        whiteBackView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:whiteBackView];
        
        
        UILabel * idcard_label = [[UILabel alloc] initWithFrame:CGRectMake(58,0,200,46)];
        idcard_label.text = @"上传身份证照片";
        idcard_label.font = [UIFont systemFontOfSize:16];
        idcard_label.textAlignment = NSTextAlignmentLeft;
        idcard_label.textColor = RGBCOLOR(114,114,114);
        [whiteBackView addSubview:idcard_label];
        
        
        idcard_button = [UIButton buttonWithType:UIButtonTypeCustom];
        idcard_button.frame = CGRectMake(76,35+10,80,80);
//        idcard_button.backgroundColor = [UIColor grayColor];
        [idcard_button setImage:[UIImage imageNamed:@"apply_idcard_image"] forState:UIControlStateNormal];
        [idcard_button addTarget:self action:@selector(chooseIdCardTap:) forControlEvents:UIControlEventTouchUpInside];
        [whiteBackView addSubview:idcard_button];
        
        UILabel * tishi_label = [[UILabel alloc] initWithFrame:CGRectMake(56,170,168,40)];
        tishi_label.text = @"您还需要完善个人主页的详细资料在T台中晒20张搭配图片哦!";
        tishi_label.font = [UIFont systemFontOfSize:12];
        tishi_label.numberOfLines = 0;
        tishi_label.textColor = RGBCOLOR(219,64,91);
        [cell.contentView addSubview:tishi_label];
        
        
        UIButton * done_button = [UIButton buttonWithType:UIButtonTypeCustom];
        done_button.frame = CGRectMake(20,240,DEVICE_WIDTH-40,45);
        done_button.backgroundColor = RGBCOLOR(236,0,82);
        done_button.layer.masksToBounds = YES;
        [done_button setTitle:@"提交申请" forState:UIControlStateNormal];
        done_button.layer.cornerRadius = 3;
        [done_button addTarget:self action:@selector(doneButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:done_button];
        
        
    }else if(indexPath.row == 2)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[image_array objectAtIndex:indexPath.row]];
        imageView.center = CGPointMake(33,25);
        [cell.contentView addSubview:imageView];
        
        ver_textField = [[UITextField alloc] initWithFrame:CGRectMake(54,0,DEVICE_WIDTH-160,50)];
        ver_textField.delegate = self;
        ver_textField.placeholder = [placeHolder_array objectAtIndex:indexPath.row];
        ver_textField.tag = 100+indexPath.row;
        [cell.contentView addSubview:ver_textField];
        
        
        timer_button = [UIButton buttonWithType:UIButtonTypeCustom];
        timer_button.frame = CGRectMake(DEVICE_WIDTH-100,10,80,30);
        timer_button.titleLabel.font = [UIFont systemFontOfSize:15];
        [timer_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [timer_button setTitle:@"获取验证码" forState:UIControlStateNormal];
        timer_button.backgroundColor = RGBCOLOR(189,189,189);
        timer_button.layer.masksToBounds = YES;
        timer_button.layer.cornerRadius = 5;
        [timer_button addTarget:self action:@selector(timerButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:timer_button];
    }else if(indexPath.row == 1)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[image_array objectAtIndex:indexPath.row]];
        imageView.center = CGPointMake(33,25);
        [cell.contentView addSubview:imageView];
        
        tel_textField = [[UITextField alloc] initWithFrame:CGRectMake(54,0,DEVICE_WIDTH-160,50)];
        tel_textField.delegate = self;
        tel_textField.placeholder = [placeHolder_array objectAtIndex:indexPath.row];
        tel_textField.tag = 100+indexPath.row;
        [cell.contentView addSubview:tel_textField];
    }else if(indexPath.row == 3)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[image_array objectAtIndex:indexPath.row]];
        imageView.center = CGPointMake(33,25);
        [cell.contentView addSubview:imageView];
        
        qq_textField = [[UITextField alloc] initWithFrame:CGRectMake(54,0,DEVICE_WIDTH-160,50)];
        qq_textField.delegate = self;
        qq_textField.placeholder = [placeHolder_array objectAtIndex:indexPath.row];
        qq_textField.tag = 100+indexPath.row;
        [cell.contentView addSubview:qq_textField];
    }else if(indexPath.row == 4)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[image_array objectAtIndex:indexPath.row]];
        imageView.center = CGPointMake(33,25);
        [cell.contentView addSubview:imageView];
        
        wechat_textField = [[UITextField alloc] initWithFrame:CGRectMake(54,0,DEVICE_WIDTH-160,50)];
        wechat_textField.delegate = self;
        wechat_textField.placeholder = [placeHolder_array objectAtIndex:indexPath.row];
        wechat_textField.tag = 100+indexPath.row;
        [cell.contentView addSubview:wechat_textField];
    }
    
    return cell;
}

#pragma mark - 选取身份证照片
-(void)chooseIdCardTap:(UIButton *)button
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionView Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://拍照
        {
            [self choosePicWithCamera:YES];
        }
            break;
        case 1://相册选取
        {
            [self choosePicWithCamera:NO];
        }
            break;
        case 2://取消
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 调用系统相机或相册
-(void)choosePicWithCamera:(BOOL)isCamera
{
    if (isCamera)
    {
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }
}


#pragma mark - 提交申请
-(void)doneButtonTap:(UIButton *)button
{
    if (ver_textField.text.length == 0)
    {
        [LTools showMBProgressWithText:@"请输入验证码" addToView:self.view];
        return;
    }else if (tel_textField.text.length != 11)
    {
        [LTools showMBProgressWithText:@"请输入正确的手机号码" addToView:self.view];
        return;
    }else if (!idcard_image)
    {
        [LTools showMBProgressWithText:@"请上传身份证照片" addToView:self.view];
        return;
    }
    
    __weak typeof(self)bself = self;
    
    NSDictionary *parameters = @{@"authcode":[GMAPI getAuthkey],@"mobile":tel_textField.text,@"code":ver_textField.text,@"qq":qq_textField.text,@"weixin":wechat_textField.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:APPLY_MATCH_URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        NSData * image_data = UIImageJPEGRepresentation(idcard_image,1.0);
        [formData appendPartWithFileData:image_data name:@"uploadFile" fileName:@"pic" mimeType:@"image/png"];
        
        
    }success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        NSString * errcode = [allDic objectForKey:@"errorcode"];
        NSLog(@"allDic -----   %@",allDic);
        if ([errcode intValue] == 0)
        {
            [LTools showMBProgressWithText:@"申请成功" addToView:self.view];
            [bself performSelector:@selector(leftButtonTap:) withObject:nil afterDelay:1.5];
        }else
        {
            [LTools showMBProgressWithText:[allDic objectForKey:@"msg"] addToView:self.view];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [LTools showMBProgressWithText:@"申请失败,请检查当前网络" addToView:self.view];
    }];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    [string_array replaceObjectAtIndex:textField.tag-100 withObject:textField.text];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UIImagePicker Delegate  
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    
    idcard_image = image;
    
    [idcard_button setImage:idcard_image forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 获取验证码
-(void)timerButtonTap:(UIButton *)button
{
    if (tel_textField.text.length != 11)
    {
        [LTools showMBProgressWithText:@"请输入正确的手机号码" addToView:self.view];
        return;
    }
    
    NSString * fullUrl = [NSString stringWithFormat:USER_GET_SECURITY_CODE,tel_textField.text,4];
    
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        if ([[allDic objectForKey:@"errorcode"] intValue] == 0)
        {
            [bself TheTimer];
        }else
        {
            [LTools showMBProgressWithText:[allDic objectForKey:@"msg"] addToView:bself.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [LTools showMBProgressWithText:@"验证码获取失败" addToView:bself.view];
    }];
    
    [request start];
}

#pragma mark - 计时器
-(void)TheTimer
{
    timer_button.userInteractionEnabled = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerCount) userInfo:nil repeats:YES];
}
-(void)timerCount
{
    theCount++;

    [timer_button setTitle:[NSString stringWithFormat:@"%d",(60-theCount)] forState:UIControlStateNormal];
    
    if (theCount == 60)
    {
        [timer invalidate];
        [timer_button setTitle:@"重新发送" forState:UIControlStateNormal];
        timer_button.userInteractionEnabled = YES;
    }
    
    
    
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
