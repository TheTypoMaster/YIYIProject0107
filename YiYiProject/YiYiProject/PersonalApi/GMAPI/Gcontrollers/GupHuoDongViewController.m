//
//  GupHuoDongViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/21.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GupHuoDongViewController.h"
#import "GHolderTextView.h"
#import "MLImageCrop.h"

#import "AFNetworking.h"

@interface GupHuoDongViewController ()<UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MLImageCropDelegate>
{
    GHolderTextView *_gholderTextView;
    
    UIView *_view1;//标题
    
    UIView *_view2;//活动内容
    
    UIView *_view3;//图片
    
    UIButton *_showPicBtn;//展示图片的button
    
    UIImage *_showImage;//选择的图片
    
    NSData *_showImageData;//需要上传的图片
    
    UILabel *_startTime;//开始时间
    UILabel *_endTime;//结束时间
    
    NSDate* _date_start;//开始时间
    NSDate *_date_end;//结束时间
    
    
    UIView *_dateChooseView;//时间选择view
    UIDatePicker *_datePicker;//时间选择器
    
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
    if (self.thetype == GUPHUODONGTYPE_EDIT) {
        self.myTitle = @"修改活动";
    }
    
    
    NSLog(@"self.mallInfo.brand_id: %@",self.mallInfo.brand_id);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self creatView1];
    
    [self creatView2];
    
    [self creatView3];
    
    [self creatTijiaoBtn];
    
    [self creatDatePickerChooseView];
    
    if (self.thetype == GUPHUODONGTYPE_EDIT) {
        [self setDataWithModel:self.theEditActivity];
    }
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gShou) name:UIKeyboardWillHideNotification object:nil];
    
}


//修改活动填充数据
-(void)setDataWithModel:(ActivityModel*)amodel{
//    NSString *mall_id = self.mallInfo.mall_id;//商场id
//    NSString *shop_id = self.userInfo.shop_id;//店铺id
    
    UITextField *titleLabel = (UITextField *)[self.view viewWithTag:200];
    titleLabel.text = amodel.activity_title;
    _endTime.text = [GMAPI timechangeAll1:amodel.end_time];
    _startTime.text = [GMAPI timechangeAll1:amodel.start_time];
    _gholderTextView.text = amodel.activity_info;
    _gholderTextView.TV.hidden = YES;
    
    UIImageView *imv = [[UIImageView alloc]init];
    [imv sd_setImageWithURL:[NSURL URLWithString:amodel.pic] placeholderImage:[UIImage imageNamed:@"gremovephoto.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _showImage = image;
        [_showPicBtn setBackgroundImage:_showImage forState:UIControlStateNormal];
    }];
    
    
    
}





//时间选择器view
-(void)creatDatePickerChooseView{
    _dateChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 300)];
    _dateChooseView.backgroundColor = [UIColor whiteColor];
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, DEVICE_WIDTH, 260)];
    [_dateChooseView addSubview:_datePicker];
    
    //确定按钮
    UIButton *quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quedingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [quedingBtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    quedingBtn.frame = CGRectMake(DEVICE_WIDTH-70, 5, 60, 40);
    quedingBtn.layer.borderWidth = 1;
    quedingBtn.layer.borderColor = [[UIColor blackColor]CGColor];
    quedingBtn.layer.cornerRadius = 5;
    [quedingBtn addTarget:self action:@selector(datePickerHideen) forControlEvents:UIControlEventTouchUpInside];
    [_dateChooseView addSubview:quedingBtn];
    
    
    
    
    [self.view addSubview:_dateChooseView];
    
    
}


-(void)datePickerHideen{
    [UIView animateWithDuration:0.3 animations:^{
        _dateChooseView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, _dateChooseView.frame.size.height);
        if (_dateChooseView.tag == 1000) {//开始时间
            _date_start = _datePicker.date;
            _startTime.text = [GMAPI getTimeWithDate:_datePicker.date];
        }else if (_dateChooseView.tag == 1001){//结束时间
            _date_end = _datePicker.date;
            _endTime.text = [GMAPI getTimeWithDate:_datePicker.date];
        }
    } completion:^(BOOL finished) {
        
    }];
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
    shuruTf.placeholder = @"请输入活动标题";
    shuruTf.font = [UIFont systemFontOfSize:17];
    shuruTf.textColor = RGBCOLOR(3, 3, 3);
    shuruTf.tag = 200;
    shuruTf.delegate = self;
    [_view1 addSubview:shuruTf];
    
    
    
    [self.view addSubview:_view1];
    
}


//提交按钮
-(void)creatTijiaoBtn{
    UIButton *tijiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tijiaoBtn setTitle:@"提  交" forState:UIControlStateNormal];
    if (self.thetype == GUPHUODONGTYPE_EDIT) {
        [tijiaoBtn setTitle:@"完 成" forState:UIControlStateNormal];
    }
    [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tijiaoBtn setBackgroundColor:RGBCOLOR(217, 66, 93)];
    tijiaoBtn.layer.cornerRadius = 5;
    [tijiaoBtn setFrame:CGRectMake(20, CGRectGetMaxY(_view3.frame)+11, DEVICE_WIDTH-40, 44)];
    [tijiaoBtn addTarget:self action:@selector(gtijiao) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tijiaoBtn];
}


-(void)gtijiao{
    
    
    //判断信息完整性
//    if (!self.mallInfo.mall_id || !self.userInfo.shop_id || !_gholderTextView.text.length>0 || !_startTime.text.length>0 || !_endTime.text.length) {
//        [GMAPI showAutoHiddenMidleQuicklyMBProgressWithText:@"请完善信息" addToView:self.view];
//        return;
//    }
    
    if (!_gholderTextView.text.length>0) {
        [GMAPI showAutoHiddenMidleQuicklyMBProgressWithText:@"请填写活动内容" addToView:self.view];
        return;
    }
    
    if (!_startTime.text.length>0 || !_endTime.text.length > 0) {
        [GMAPI showAutoHiddenMidleQuicklyMBProgressWithText:@"请填写活动时间" addToView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //上传的url
    NSString *uploadImageUrlStr = GFABUHUODONG;
    
    if (self.thetype == GUPHUODONGTYPE_EDIT) {
        uploadImageUrlStr = GEDITHUODONG;
    }
    
    NSString *type = nil;
    type = @"2";
    
    
    
    
//    NSString *mall_id = self.mallInfo.mall_id;//商场id
    NSString *shop_id = self.userInfo.shop_id;//店铺id
    NSString *activity_info = _gholderTextView.text;//活动内容
    NSString *start_time = _startTime.text;//活动开始时间
    NSString *end_time = _endTime.text;//活动结束时间
    
    UITextField *titleLabel = (UITextField *)[self.view viewWithTag:200];
    NSString *activity_title = titleLabel.text;//活动标题
    
    
    NSDictionary *parameters_dic = [NSDictionary dictionary];
    NSString *activity_id = [NSString stringWithFormat:@"%@",self.theEditActivity.id];
    if (self.thetype == GUPHUODONGTYPE_NONE) {
        parameters_dic = @{
                     @"type":type,
                     @"shop_id":shop_id,
                     @"activity_title":activity_title,
                     @"activity_info":activity_info,
                     @"start_time":start_time,
                     @"end_time":end_time,
                     @"authcode":[GMAPI getAuthkey],
                     };
    }else if (self.thetype == GUPHUODONGTYPE_EDIT){
        parameters_dic = @{
                     @"type":type,
                     @"shop_id":shop_id,
                     @"activity_title":activity_title,
                     @"activity_info":activity_info,
                     @"start_time":start_time,
                     @"end_time":end_time,
                     @"authcode":[GMAPI getAuthkey],
                     @"activity_id":activity_id
                     };
    }
    
    
    
    
    
    if ([type isEqualToString:@"2"]) {//type为2的时候是店铺发布活动
        
        //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        AFHTTPRequestOperation  * o2= [manager
                                       POST:uploadImageUrlStr
                                       parameters:parameters_dic
                                       constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                       {
                                           //开始拼接表单
                                           //获取图片的二进制形式
                                           
                                           _showImageData = UIImageJPEGRepresentation(_showImage, 0.2);
                                           NSData * data= _showImageData;
                                           if (_showImageData) {
                                               NSLog(@"%ld",(unsigned long)data.length);
                                               
                                               //将得到的二进制图片拼接到表单中
                                               /**
                                                *  data,指定上传的二进制流
                                                *  name,服务器端所需参数名
                                                *  fileName,指定文件名
                                                *  mimeType,指定文件格式
                                                */
                                               [formData appendPartWithFileData:data name:@"pic" fileName:@"icon.jpg" mimeType:@"image/jpg"];
                                               //多用途互联网邮件扩展（MIME，Multipurpose Internet Mail Extensions）
                                           }
                                           
                                           
                                       }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
                                       {
                                           
                                           
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           
                                           
                                           
                                           NSLog(@"%@",responseObject);
                                           
                                           NSError * myerr;
                                           
                                           NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:&myerr];
                                           NSLog(@"%@",mydic);
                                           
                                           
                                           if ([[mydic objectForKey:@"errorcode"]intValue]==0) {
                                               if (self.thetype == GUPHUODONGTYPE_EDIT) {
                                                   [GMAPI showAutoHiddenMBProgressWithText:@"修改成功" addToView:self.view];
                                               }else if (self.thetype == GUPHUODONGTYPE_NONE){
                                                   [GMAPI showAutoHiddenMBProgressWithText:@"发布成功" addToView:self.view];
                                               }
                                               
                                               [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_FABUHUODONG_SUCCESS object:nil];
                                               [self performSelector:@selector(fabuSuccessToGoBack) withObject:[NSNumber numberWithBool:YES] afterDelay:1];
                                           }else{
                                               [GMAPI showAutoHiddenMBProgressWithText:[mydic objectForKey:@"msg"] addToView:self.view];
                                           }
                                           
                                           
                                           
                                           
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           if (self.thetype == GUPHUODONGTYPE_NONE) {
                                               [GMAPI showAutoHiddenMBProgressWithText:@"发布失败请检查网络" addToView:self.view];
                                           }else if (self.thetype == GUPHUODONGTYPE_EDIT){
                                               [GMAPI showAutoHiddenMBProgressWithText:@"修改失败请检查网络" addToView:self.view];
                                           }
                                           
                                           
                                           NSLog(@"%@",error);
                                           
                                           
                                       }];
        
        //设置上传操作的进度
        [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
    }
    
    
    
}


//发布成功之后返回上一个界面
-(void)fabuSuccessToGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}



//活动内容
-(void)creatView2{
    
    _view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame), DEVICE_WIDTH, 180)];
    
    
    
    //收键盘
    UIControl *tapshou = [[UIControl alloc]initWithFrame:_view2.bounds];
    [tapshou addTarget:self action:@selector(gShou) forControlEvents:UIControlEventTouchDown];
    [_view2 addSubview:tapshou];
    
    _gholderTextView = [[GHolderTextView alloc]initWithFrame:CGRectMake(16, 10, DEVICE_WIDTH-32, 100) placeholder:@"活动内容..." holderSize:15];
    _gholderTextView.tag = 300;
    
    _gholderTextView.font = [UIFont systemFontOfSize:15];
    _gholderTextView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    [_view2 addSubview:_gholderTextView];
    
    
    //开始时间
    UILabel *startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(_gholderTextView.frame)+5, 70, 25)];
    startTimeLabel.textColor = RGBCOLOR(114, 114, 114);
    startTimeLabel.text = @"开始时间";
    
    _startTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(startTimeLabel.frame)+5, startTimeLabel.frame.origin.y, DEVICE_WIDTH-16-16-5-70, 25)];
    _startTime.textColor = RGBCOLOR(114, 114, 114);
    _startTime.backgroundColor = RGBCOLOR(242, 242, 242);
    _startTime.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseStartTime:)];
    [_startTime addGestureRecognizer:tap];
    
    
    [_view2 addSubview:startTimeLabel];
    [_view2 addSubview:_startTime];
    
    //结束时间
    UILabel *endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(startTimeLabel.frame)+5, 70, 25)];
    endTimeLabel.textColor = RGBCOLOR(114, 114, 114);
    endTimeLabel.text = @"结束时间";
    
    _endTime = [[UILabel alloc]initWithFrame:CGRectMake(_startTime.frame.origin.x, endTimeLabel.frame.origin.y, _startTime.frame.size.width, _startTime.frame.size.height)];
    _endTime.textColor = RGBCOLOR(114, 114, 114);
    _endTime.backgroundColor = RGBCOLOR(242, 242, 242);
    _endTime.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapc = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseEndTime:)];
    [_endTime addGestureRecognizer:tapc];
    
    
    
    
    [_view2 addSubview:endTimeLabel];
    [_view2 addSubview:_endTime];
    
    [self.view addSubview:_view2];
    
}


-(void)chooseStartTime:(UITapGestureRecognizer*)sender{
    
    UITextField *tf = (UITextField*)[self.view viewWithTag:200];
    [tf resignFirstResponder];
    
    UITextView *tv = (UITextView*)[self.view viewWithTag:300];
    [tv resignFirstResponder];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _dateChooseView.frame = CGRectMake(0, DEVICE_HEIGHT-_dateChooseView.frame.size.height, DEVICE_WIDTH, _dateChooseView.frame.size.height);
        _dateChooseView.tag = 1000;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)chooseEndTime:(UITapGestureRecognizer*)sender{
    
    UITextField *tf = (UITextField*)[self.view viewWithTag:200];
    [tf resignFirstResponder];
    
    UITextView *tv = (UITextView*)[self.view viewWithTag:300];
    [tv resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        _dateChooseView.frame = CGRectMake(0, DEVICE_HEIGHT-_dateChooseView.frame.size.height, DEVICE_WIDTH, _dateChooseView.frame.size.height);
        _dateChooseView.tag = 1001;
    } completion:^(BOOL finished) {
        
    }];
}



-(void)creatView3{
    _view3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_view2.frame), DEVICE_WIDTH, 130)];
    _view3.backgroundColor = RGBCOLOR(242, 242, 242);
    //收键盘
    UIControl *tapshou = [[UIControl alloc]initWithFrame:_view3.bounds];
    [tapshou addTarget:self action:@selector(gShou) forControlEvents:UIControlEventTouchDown];
    [_view3 addSubview:tapshou];
    [self.view addSubview:_view3];
    
    //上传图片
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 80, 20)];
    titleLabel.text = @"上传图片";
    [_view3 addSubview:titleLabel];
    
    
    //加号
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"gaddphoto.png"] forState:UIControlStateNormal];
    [addBtn setFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)+10, 60, 60)];
    [addBtn addTarget:self action:@selector(tianjiatupian) forControlEvents:UIControlEventTouchUpInside];
    [_view3 addSubview:addBtn];
    
    //图片
    _showPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showPicBtn setBackgroundImage:[UIImage imageNamed:@"gremovephoto.png"] forState:UIControlStateNormal];
    [_showPicBtn setFrame:CGRectMake(CGRectGetMaxX(addBtn.frame)+15, addBtn.frame.origin.y, 60, 60)];
    [_showPicBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [_view3 addSubview:_showPicBtn];
    
    
    
    
    
}



//收键盘开始====
-(void)gShou{
    NSLog(@"收键盘了");
   
    UITextField *tf = (UITextField*)[self.view viewWithTag:200];
    [tf resignFirstResponder];
    
    UITextView *tv = (UITextView*)[self.view viewWithTag:300];
    [tv resignFirstResponder];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _dateChooseView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 300);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"%ld",(long)textField.tag);
    
}

//收键盘结束====



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加图片
-(void)tianjiatupian{
    //图片选择器
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:^{
        _showImageData = nil;
    }];
}

//删除图片
-(void)removeSelf{
    [_showPicBtn setBackgroundImage:[UIImage imageNamed:@"gremovephoto.png"] forState:UIControlStateNormal];
    _showImage = nil;
    
}



#pragma mark- 缩放图片
//按比例缩放
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//按像素缩放
-(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
#pragma mark - UIImagePickerControllerDelegate 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%s",__FUNCTION__);
    [UIApplication sharedApplication].statusBarHidden = NO;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //压缩图片 不展示原图
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        
        _showImage = originImage;
        _showImageData = UIImageJPEGRepresentation(_showImage, 0.3);
        [_showPicBtn setBackgroundImage:_showImage forState:UIControlStateNormal];
        
        
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
        imageCrop.delegate = self;
        //按像素缩放  //设置缩放比例
        imageCrop.ratioOfWidthAndHeight = 320/188.0f;
        imageCrop.image = originImage;
        picker.navigationBar.hidden = YES;
        [picker pushViewController:imageCrop animated:YES];
        
//        [picker dismissViewControllerAnimated:YES completion:^{
//            
//        }];
  
        
    }
}







#pragma mark - MLImageCropDelegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    
    
//    UIImage *doneImage = [self scaleToSize:cropImage size:CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT)];//按像素缩放
    _showImage = cropImage;
    _showImageData = UIImageJPEGRepresentation(_showImage, 1);
    
    
    
    
    [_showPicBtn setBackgroundImage:cropImage forState:UIControlStateNormal];

}





@end
