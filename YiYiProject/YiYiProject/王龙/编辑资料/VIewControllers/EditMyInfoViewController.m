//
//  EditMyInfoViewController.m
//  YiYiProject
//
//  Created by 王龙 on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "EditMyInfoViewController.h"
#import "AFNetworking.h"
#import "GMAPI.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#import "MineViewController.h"

@interface EditMyInfoViewController ()

@end

@implementation EditMyInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightString = @"完成";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    self.myTitleLabel.text = @"修改个人信息";
    
    self.view.backgroundColor = RGBA(248, 248, 248, 1);
    
    [self initInfoSubViews];
    
    [self addGesturesOnViews];
    
    [self getMyUserInfo];
    
    // Do any additional setup after loading the view from its nib.
}



-(void)initInfoSubViews{
    infoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, DEVICE_WIDTH,self.view.height)];
    infoScrollView.showsVerticalScrollIndicator = NO;
    infoScrollView.backgroundColor =  RGBCOLOR(242, 242, 242);;
    [self.view addSubview:infoScrollView];
    
    infoView = [[[NSBundle mainBundle] loadNibNamed:@"EditInfoView" owner:nil options:nil] lastObject];
    [infoView setPropertiesUi];
    infoView.frame = CGRectMake(0, 0, DEVICE_WIDTH, infoScrollView.frame.size.height);
    infoView.backgroundColor= RGBA(248, 248, 248, 1);
    [infoScrollView addSubview:infoView];
    
    
    [infoView.manBtn addTarget:self action:@selector(sexAction:) forControlEvents:UIControlEventTouchUpInside];
    [infoView.womanBtn addTarget:self action:@selector(sexAction:) forControlEvents:UIControlEventTouchUpInside];
    
   // 1002 男  1001 女
    
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 250+44)];
    [self.view addSubview:dateView];
    
    
    UIView *topTool = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
    topTool.backgroundColor = [UIColor blackColor];
    [dateView addSubview:topTool];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(DEVICE_WIDTH-44,0,44,44);

    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.imageEdgeInsets = UIEdgeInsetsMake((44-14)/2.0, (44-21)/2.0, (44-14)/2.0, (44-21)/2.0);
    [sureBtn setImage:[UIImage imageNamed:@"my_sc_dui"] forState:UIControlStateNormal];
    
    [topTool addSubview:sureBtn];
    
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0,0,44,44);
    [cancelBtn setImage:[UIImage imageNamed:@"my_sc_guanbi"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.imageEdgeInsets = UIEdgeInsetsMake((44-14)/2.0, (44-21)/2.0, (44-14)/2.0, (44-21)/2.0);
    [topTool addSubview:cancelBtn];
    
    ////// 日期滚轮
    datePicker = [[UIDatePicker alloc] init];
    datePicker.frame = CGRectMake(0,44 , DEVICE_WIDTH, 250);
    datePicker.datePickerMode = UIDatePickerModeDate;
    [dateView addSubview:datePicker];


    NSDate *select = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    infoView.birthdayLabel.text = dateAndTime;
    
}

////性别
-(void)sexAction:(UIButton *)btn{
    if (btn.tag == 1001) {
        //nv
        infoView.manBtn.selected = NO;
        infoView.womanBtn.selected = YES;
    }else{
        //nan
        infoView.manBtn.selected = YES;
        infoView.womanBtn.selected = NO;
    }
}
/////按钮事件
-(void)sureBtnAction{
    NSDate *select = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    infoView.birthdayLabel.text = dateAndTime;
    
    [self cancelBtnAction];
}

-(void)cancelBtnAction{
    [UIView animateWithDuration:.3 animations:^{
        dateView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 250+44);
        infoScrollView.contentOffset = CGPointZero;
    }];
}
//给视图添加手势
-(void)addGesturesOnViews{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHead:)];
    [infoView.headView addGestureRecognizer:tapGesture];
    infoView.nickerTf.delegate = self;
    
    UITapGestureRecognizer *birthTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBirth:)];
    [infoView.birthViiew addGestureRecognizer:birthTap];
    
}

#pragma mark------UITextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [infoView.nickerTf resignFirstResponder];
    return YES;
}


//刷新资料
-(void)reloadUserInfo{
    NSString *headUrl = infoDic[@"photo"];
    NSString *nick = infoDic[@"user_name"];
    NSString *sex = infoDic[@"gender"];
    NSString *birth =infoDic[@"birthday"];
    [self judgeNil:headUrl];
    [self judgeNil:nick];
    [self judgeNil:sex];
    [self judgeNil:birth];
    [infoView.headImageView setImage:[GMAPI getUserFaceImage]];
    [infoView.headImageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:nil];
    infoView.nickerTf.text = nick;

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *birthDate = [NSDate dateWithTimeIntervalSince1970:[birth longLongValue]];
    infoView.birthdayLabel.text = [formatter stringFromDate:birthDate];
    
    
    if ([sex intValue] == 1) {
        //男
        infoView.manBtn.selected = YES;
        infoView.womanBtn.selected = NO;
    }else{
        //女
        infoView.manBtn.selected = NO;
        infoView.womanBtn.selected = YES;
        
    }
}

#pragma mark------------获取个人资料

-(void)getMyUserInfo{
    NSString *url = url = [NSString stringWithFormat:@"%@&authcode=%@",GET_UPDATEMYINFO_URL,[GMAPI getAuthkey]];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            if ([result[@"errorcode"] intValue] == 0) {
                infoDic = result[@"user_info"];
                [self reloadUserInfo];
            }
        }

        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
    }];
}
#pragma mark -完成 事件处理

-(void)rightButtonTap:(UIButton *)sender
{
    NSString *user_name = [self judgeNil:infoView.nickerTf.text];

    NSString *gender;
    if (infoView.manBtn.selected) {
        gender = @"1";
    }else{
        gender = @"2";
    }


    /////先判断网络
    
    NSDictionary *dic = @{
                          @"authcode":[GMAPI getAuthkey],
                          @"user_name":user_name,
                          @"gender": gender,
                          @"birthday":infoView.birthdayLabel.text,
                          };
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:POST_UPDATEMYINFO_URL
                                   parameters:dic
                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                   {
                                       if (infoView.headImageView.image!=nil) {
                                           NSData *imageData =UIImageJPEGRepresentation(infoView.headImageView.image, 0.1);
                                           [formData appendPartWithFileData:imageData name:@"pic" fileName:@"myhead.jpg" mimeType:@"image/jpg"];
                                       }
                                       
                                   }
                                   success:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                       
                                       
                                       NSDictionary * resultDic = [operation.responseString objectFromJSONString];
                                       
                                       if (![resultDic isKindOfClass:[NSDictionary class]]) {
                                           //打印服务器错误
                                       }
                                       if ([resultDic[@"errorcode"] intValue] == 0) {
                                           //刷新上一界面的头像
                                           [GMAPI setUserFaceImageWithData:UIImagePNGRepresentation(infoView.headImageView.image)];
                                           [self.delegate.userFaceImv setImage:infoView.headImageView.image];
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }else{
                                           //打印错误信息
                                           
                                           NSLog(@"错误－－－－－－%@",resultDic[@"msg"]);
                                       }

                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       
                                       
                                   }];
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
}

#pragma mark-----------------手势关联的事件

-(void)selectBirth:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:.3 animations:^{
        dateView.frame = CGRectMake(0, DEVICE_HEIGHT-294, DEVICE_WIDTH, 250+44);
        if (iPhone4) {
            
             infoScrollView.contentOffset = CGPointMake(0, 100);
        }
        
    }];
}


-(void)changeHead:(UITapGestureRecognizer *)gesture{
    UIActionSheet* alert = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"相机",@"从相机选择",nil];
    [alert showInView:self.view];
}

-(void)choseImageWithTypeCameraTypePhotoLibrary:(UIImagePickerControllerSourceType)type{
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate =self;
    imagePicker.sourceType = type;
    imagePicker.allowsEditing = YES;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing =YES;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}
#pragma mark UIACtionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==0){
        [self choseImageWithTypeCameraTypePhotoLibrary:UIImagePickerControllerSourceTypeCamera];
    }else if(buttonIndex == 1){
        [self choseImageWithTypeCameraTypePhotoLibrary:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}



#pragma mark xuan ze zhao pian de dai li
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData * imageData = UIImageJPEGRepresentation(image,0.6);
    //TODO：将图片发给服务器
    infoView.headImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}



////
-(NSString *)judgeNil:(NSString *)str{
    if (str == nil) {
        str = @"";
    }
    return str;
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
