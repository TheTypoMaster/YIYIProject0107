//
//  GTTPublishViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GTTPublishViewController.h"
#import "AFNetworking.h"
#import "GHolderTextView.h"
#import "GmoveImv.h"
#import "GImvUpScrollView.h"
#import "GAddTtaiImageLinkViewController.h"

@interface GTTPublishViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    BOOL imageIsValid;//图片是否有效
    
    UIView *_tfBackview;//textfield输入框下层view
    
    //添加锚点相关
    UIImageView *_editImageView;//添加锚点的view
    GmoveImv *_showImageView;//显示可以添加锚点的图片imageview
    UIControl *_theImvTouched;//图片点击
    
    GmoveImv *_maodian;
    
    UIImage *_theChooseImage;//用户选择的图片
    
}
@end

@implementation GTTPublishViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.maodianDic);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.rightString = @"发送";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHiddenKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    
//
//    if (self.publishImage) {
//        
//        imageIsValid = YES;
//        [self.addImageButton setImage:self.publishImage forState:UIControlStateNormal];
//    }
    
    
    [self creatCustomView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 网络请求
#pragma mark 图片上传

//上传
-(void)upLoadImage:(UIImage *)aImage{
    
    NSString *content = self.contentTF.text;
    NSString *brand = [NSString stringWithFormat:@"%@,%@,%@",self.brandTF.text,self.modelTF.text,self.priceTF.text];
    NSString *img_x = [self.maodianDic objectForKey:@"locationxbili"];
    NSString *img_y = [self.maodianDic objectForKey:@"locationybili"];
    NSString *shop_ids = [self.maodianDic objectForKey:@"shopIds"];
    NSString *product_ids = [self.maodianDic objectForKey:@"productid"];
    
    //上传的url
    NSString *uploadImageUrlStr = TTAI_ADD;
    
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:uploadImageUrlStr
                                   parameters:@{
                                                @"authcode":[GMAPI getAuthkey],
                                                @"ttInfo":brand,
                                                @"tt_content":content,
                                                @"img_x":img_x,
                                                @"img_y":img_y,
                                                @"shop_ids":shop_ids,
                                                @"product_ids":product_ids
                                                }
                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                   {
                                       //开始拼接表单
                                       //获取图片的二进制形式
                                       NSData * data= UIImageJPEGRepresentation(aImage, 0.5);
                                       
                                       NSLog(@"---> 大小 %ld",(unsigned long)data.length);
                                       
                                       [formData appendPartWithFileData:data name:@"pic" fileName:@"icon.jpg" mimeType:@"image/jpg"];
                                       //多用途互联网邮件扩展（MIME，Multipurpose Internet Mail Extensions）
                                   }
                                   success:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                       
                                       
                                       NSLog(@"success %@",operation.responseString);
                                       
                                       NSError * myerr;
                                       
                                       NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:0 error:&myerr];
                                       
                                       
                                       NSLog(@"mydic == %@ err0 = %@",mydic,myerr);
                                       
                                       [LTools showMBProgressWithText:mydic[@"msg"] addToView:self.view];
                                       
                                       
                                       int erroCode = [mydic[@"errorcode"] intValue];
                                       
                                       if (erroCode == 0) {
                                           
                                           NSLog(@"成功了");
                                           
                                           
                                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TTAI_PUBLISE_SUCCESS object:nil];
                                           
                                           [self performSelector:@selector(leftButtonTap:) withObject:nil afterDelay:0.5];
                                       }
                                       
                                       
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       
                                       
                                       NSLog(@"失败 : %@",error);
                                       
                                       self.my_right_button.userInteractionEnabled = YES;
                                       
                                       
                                   }];
    
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        
    }];
    
    
}



#pragma mark 事件处理

- (void)tapToHiddenKeyboard:(UITapGestureRecognizer *)tap
{
    [self.contentTF resignFirstResponder];
    [self.brandTF resignFirstResponder];
    [self.modelTF resignFirstResponder];
    [self.priceTF resignFirstResponder];
    
    [self updateViewFrameY:64];
}

- (void)leftButtonTap:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)rightButtonTap:(UIButton *)sender
{
    NSLog(@"发送");
    
    [self tapToHiddenKeyboard:nil];
    
    //    self.brandTF.text,self.modelTF.text,self.priceTF.text
    
    //    if ([LTools isEmpty:self.brandTF.text]) {
    //
    //        [LTools showMBProgressWithText:@"品牌不能为空" addToView:self.view];
    //        return;
    //    }
    //    if ([LTools isEmpty:self.modelTF.text]) {
    //
    //        [LTools showMBProgressWithText:@"型号不能为空" addToView:self.view];
    //        return;
    //    }
    //
    //    if ([LTools isEmpty:self.priceTF.text]) {
    //
    //        [LTools showMBProgressWithText:@"价格不能为空" addToView:self.view];
    //        return;
    //    }
    //
    //    if ([LTools isValidateFloat:self.priceTF.text]) {
    //
    //        [LTools showMBProgressWithText:@"请填写有效价格" addToView:self.view];
    //        return;
    //    }
    
    
    if (imageIsValid) {
        
        self.my_right_button.userInteractionEnabled = NO;
        
        [self upLoadImage:self.addImageButton.imageView.image];
    }else
    {
        [LTools showMBProgressWithText:@"请添加有效照片" addToView:self.view];
    }
    
}

- (void)clickToAction:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet showInView:self.view];
}

/**
 *  添加添加图片
 */

- (void)clickToAddAlbum:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

/**
 *  拍照
 */

- (void)clickToPhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)updateViewFrameY:(CGFloat)frameY
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.top = frameY;
    }];
    
    
    
}

#pragma mark 代理

#pragma - mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //    if (textField == self.brandTF) {
    //
    //        [self updateViewFrameY:_brandTF.top * -1];
    //
    //    }else if (textField == _modelTF){
    //
    //        [self updateViewFrameY:_modelTF.top * -1];
    //
    //    }else if (textField == _priceTF){
    //
    //        [self updateViewFrameY:_priceTF.top * -1];
    //    }
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.brandTF) {
        
        [_modelTF becomeFirstResponder];
    }else if (textField == _modelTF){
        [_priceTF becomeFirstResponder];
    }else if (textField == _priceTF){
        
        [self tapToHiddenKeyboard:nil];
    }
    
    return YES;
}


#pragma - mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        
        self.placeHolderLabel.hidden = YES;
    }else
    {
        self.placeHolderLabel.hidden = NO;
    }
}


-(UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size{
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

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //压缩图片 不展示原图
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        
        UIImage * scaleImage = [self scaleToSizeWithImage:originImage size:CGSizeMake(originImage.size.width>1024?1024:originImage.size.width,originImage.size.width>1024?originImage.size.height*1024/originImage.size.width:originImage.size.height)];
        //        UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
        
        NSData *data;
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 0.4);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        //        [self addPhoto:image];
        
        if (image) {
            
            imageIsValid = YES;
        }
        
        [self.addImageButton setImage:image forState:UIControlStateNormal];
        
        
        _theChooseImage = image;
        [self creatShowImageView];
        
        [picker dismissViewControllerAnimated:NO completion:^{
            
            
        }];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIActionSheetDelegate <NSObject>

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [self clickToAddAlbum:nil];
    }else if (buttonIndex == 0){
        [self clickToPhoto:nil];
    }
}



#pragma mark - myMethod


//创建视图
-(void)creatCustomView{
    self.mainScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.mainScrollview.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT+100);
    [self.view addSubview:self.mainScrollview];
    
    //发表内容输入框
    self.contentTF = [[GHolderTextView alloc]initWithFrame:CGRectMake(10, 10, DEVICE_WIDTH-20, 100) placeholder:@"发表这一刻的想法" holderSize:15];
    self.contentTF.backgroundColor = [UIColor whiteColor];
    self.contentTF.font = [UIFont systemFontOfSize:15];
    [self.mainScrollview addSubview:self.contentTF];
    
    //添加图片的按钮
    UIView *addPicView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.contentTF.frame), self.contentTF.frame.size.width, 80)];
    addPicView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollview addSubview:addPicView];
    self.addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addImageButton setImage:[UIImage imageNamed:@"stianjia.png"] forState:UIControlStateNormal];
    [self.addImageButton setFrame:CGRectMake(6, 0, 80, 80)];
    [self.addImageButton addTarget:self action:@selector(clickToAction:) forControlEvents:UIControlEventTouchUpInside];
    [addPicView addSubview:self.addImageButton];
    
    
    
    //品牌型号价格
    _tfBackview = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(addPicView.frame)+7, DEVICE_WIDTH-32, 145)];
    NSArray *titleArray = @[@"品牌",@"型号",@"价格"];
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*44, _tfBackview.frame.size.width, 44)];
        [_tfBackview addSubview:view];
        _tfBackview.tag = 1000000;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 1)];
        line.backgroundColor = RGBCOLOR(208, 208, 208);
        [view addSubview:line];
        UILabel *tt = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
        tt.font = [UIFont systemFontOfSize:15];
        tt.text = titleArray[i];
        [view addSubview:tt];
        
        if (i == 0) {
            self.brandTF = [[UITextField alloc]initWithFrame:CGRectMake(75, 0, _tfBackview.frame.size.width-75, 44)];
            self.brandTF.textAlignment = NSTextAlignmentRight;
            self.brandTF.font = [UIFont systemFontOfSize:15];
            self.brandTF.placeholder = @"例如：ONLY";
            [view addSubview:self.brandTF];
        }else if (i==1){
            self.modelTF = [[UITextField alloc]initWithFrame:CGRectMake(75, 0, _tfBackview.frame.size.width-75, 44)];
            self.modelTF.textAlignment = NSTextAlignmentRight;
            self.modelTF.font = [UIFont systemFontOfSize:15];
            self.modelTF.placeholder = @"例如：BH1431938";
            [view addSubview:self.modelTF];
        }else if (i==2){
            self.priceTF = [[UITextField alloc]initWithFrame:CGRectMake(75, 0, _tfBackview.frame.size.width-75, 44)];
            self.priceTF.textAlignment = NSTextAlignmentRight;
            self.priceTF.font = [UIFont systemFontOfSize:15];
            self.priceTF.placeholder = @"例如：1000";
            [view addSubview:self.priceTF];
            
        }
    }
    
    [self.mainScrollview addSubview:_tfBackview];
    
}




//创建编辑图片的view
-(void)creatShowImageView{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"添加商品链接" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = RGBCOLOR(235, 235, 235);
    [btn setFrame:CGRectMake(0, CGRectGetMaxY(_tfBackview.frame)+5, DEVICE_WIDTH, 40)];
    [btn addTarget:self action:@selector(addProductLink) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollview addSubview:btn];
    
}


-(void)addProductLink{
    GAddTtaiImageLinkViewController *ddd = [[GAddTtaiImageLinkViewController alloc]init];
    ddd.theImage = _theChooseImage;
    ddd.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:ddd];
    
    [self presentViewController:navc animated:YES completion:^{
        
    }];
}




@end
