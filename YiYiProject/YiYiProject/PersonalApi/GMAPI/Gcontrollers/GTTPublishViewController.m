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

#import "NSDictionary+GJson.h"

@interface GTTPublishViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>
{
    BOOL imageIsValid;//图片是否有效
    
    UIView *_tfBackview;//textfield输入框下层view
    
    //添加锚点相关
    UIImageView *_editImageView;//添加锚点的view
    GmoveImv *_showImageView;//显示可以添加锚点的图片imageview
    UIControl *_theImvTouched;//图片点击
    
    GmoveImv *_maodian;
    
    UIImage *_theChooseImage;//用户选择的图片
    
    UIView *_addPicView;
    
    MBProgressHUD *loading;
    
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
    self.myTitleLabel.text = @"发表T台";
    if (self.theTtaiModel) {
        self.myTitleLabel.text = @"修改T台";
    }
    
    self.myTitleLabel.textColor = RGBCOLOR(253, 105, 155);
    self.rightString = @"发送";
    if (self.theTtaiModel) {
        self.rightString = @"完成";
    }
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHiddenKeyboard:)];
    [self.view addGestureRecognizer:tap];
    

    
    loading = [LTools MBProgressWithText:@"发布中..." addToView:self.view];
    
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
    
    NSString *content = self.contentTV.text;
    if (self.contentTV.text.length == 0) {
        content = @" ";
    }

    
    NSDictionary *theDic;
    if (self.maodianDic) {
        NSString *img_x = [self.maodianDic stringValueForKey:@"locationxbili"];
        NSString *img_y = [self.maodianDic stringValueForKey:@"locationybili"];
        NSString *shop_ids = [self.maodianDic stringValueForKey:@"shopIds"];
        NSString *product_ids = [self.maodianDic stringValueForKey:@"productid"];
        if (self.theTtaiModel) {
            
            theDic = @{
                       @"authcode":[GMAPI getAuthkey],
                       @"tt_content":content,
                       @"img_x":img_x,
                       @"img_y":img_y,
                       @"shop_ids":shop_ids,
                       @"product_ids":product_ids,
                       @"tt_id":self.theTtaiModel.tt_id
                       };
        }else{
            theDic = @{
                       @"authcode":[GMAPI getAuthkey],
                       @"tt_content":content,
                       @"img_x":img_x,
                       @"img_y":img_y,
                       @"shop_ids":shop_ids,
                       @"product_ids":product_ids
                       };
        }
        
    }else{
        if (self.theTtaiModel) {
            theDic = @{
                       @"authcode":[GMAPI getAuthkey],
                       @"tt_content":content,
                       @"tt_id":self.theTtaiModel.tt_id
                       };

        }else{
            theDic = @{
                       @"authcode":[GMAPI getAuthkey],
                       @"tt_content":content
                       };
        }
        
    }
    
    
    
    
    //上传的url
    NSString *uploadImageUrlStr = TTAI_ADD;
    
    
    if (self.theTtaiModel) {
        uploadImageUrlStr = EDIT_TTAI;
        
    }
    
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:uploadImageUrlStr
                                   parameters:theDic
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
                                       
                                       [loading hide:YES];
                                       
                                       NSLog(@"mydic == %@ err0 = %@",mydic,myerr);
                                       
                                       [LTools showMBProgressWithText:mydic[@"msg"] addToView:self.view];
                                       
                                       
                                       int erroCode = [mydic[@"errorcode"] intValue];
                                       
                                       if (erroCode == 0) {
                                           
                                           NSLog(@"成功了");
                                           
                                           if (self.theTtaiModel) {
                                               
                                               [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TTAI_EDIT_SUCCESS object:nil];
                                           }else{
                                               [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TTAI_PUBLISE_SUCCESS object:nil];
                                           }
                                           
                                           
                                           [self performSelector:@selector(leftButtonTap:) withObject:nil afterDelay:0.5];
                                       }else{
                                           self.my_right_button.userInteractionEnabled = YES;
                                       }
                                       
                                       
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       
                                       [loading hide:YES];
                                       
                                       
                                       
                                       if (self.theTtaiModel) {
                                           [LTools showMBProgressWithText:@"修改失败" addToView:self.view];
                                       }else{
                                           [LTools showMBProgressWithText:@"发布失败" addToView:self.view];
                                       }
                                       

                                       
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
    [self.contentTV resignFirstResponder];
    
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
    
    if (imageIsValid) {
        
        self.my_right_button.userInteractionEnabled = NO;
        
        [loading show:YES];
        
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
    
    
}




- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}


#pragma - mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.text.length>0) {
        self.placeHolderLabel.hidden = YES;
    }else{
        self.placeHolderLabel.hidden = NO;
    }
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
    
    
    self.maodianDic = nil;
    
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
    self.contentTV = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, DEVICE_WIDTH-20, 100)];
    self.contentTV.font = [UIFont systemFontOfSize:15];
    self.contentTV.delegate = self;
    
    self.placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,5, DEVICE_WIDTH-20, 20)];
    self.placeHolderLabel.font = [UIFont systemFontOfSize:15];
    
    [self.contentTV addSubview:self.placeHolderLabel];
    
    self.placeHolderLabel.text = @"发表这一刻的想法";
    self.placeHolderLabel.textColor = [UIColor grayColor];
    
    
    if (self.theTtaiModel) {
        
        if (self.theTtaiModel.tt_content.length>0 && ![self.theTtaiModel.tt_content isEqualToString:@" "]) {//有文字
            self.contentTV.text = self.theTtaiModel.tt_content;
            self.placeHolderLabel.hidden = YES;
        }
        
    }
    
    
    [self.mainScrollview addSubview:self.contentTV];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.contentTV.frame), DEVICE_WIDTH-24, 0.5)];
    lineView.backgroundColor = RGBCOLOR(208, 208, 208);
    [self.mainScrollview addSubview:lineView];
    
    
    //添加图片的按钮
    _addPicView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+10, self.contentTV.frame.size.width, 80)];
    _addPicView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollview addSubview:_addPicView];
    self.addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addImageButton setImage:[UIImage imageNamed:@"stianjia.png"] forState:UIControlStateNormal];
    [self.addImageButton setFrame:CGRectMake(6, 0, 80, 80)];
    [self.addImageButton addTarget:self action:@selector(clickToAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addPicView addSubview:self.addImageButton];
    
    [self.mainScrollview addSubview:_tfBackview];
    
    
    
    if (self.theTtaiModel) {
        
        UIImageView *imv = [[UIImageView alloc]init];
        [imv sd_setImageWithURL:[NSURL URLWithString:[self.theTtaiModel.image stringValueForKey:@"url"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                
                imageIsValid = YES;
            }
            
            [self.addImageButton setImage:image forState:UIControlStateNormal];
            
            
            _theChooseImage = image;
            [self creatShowImageView];
        }];
        
        
        
    }
    
    
    
}






//创建编辑图片的view
-(void)creatShowImageView{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"添加商品链接" forState:UIControlStateNormal];
    if (self.theTtaiModel) {
        [btn setTitle:@"修改商品链接" forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = RGBCOLOR(235, 235, 235);
    [btn setFrame:CGRectMake(0, CGRectGetMaxY(_addPicView.frame)+10, DEVICE_WIDTH, 40)];
    [btn addTarget:self action:@selector(addProductLink) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollview addSubview:btn];
    
    loading = [LTools MBProgressWithText:@"发布中..." addToView:self.view];
    
}


-(void)addProductLink{
    GAddTtaiImageLinkViewController *ddd = [[GAddTtaiImageLinkViewController alloc]init];
    ddd.theImage = _theChooseImage;
    ddd.delegate = self;
    
    
    if (self.maodianDic) {
        ddd.maodianArray = self.GimvArray;
    }
    if (self.theTtaiModel) {
        ddd.theTtaiModel = self.theTtaiModel;
    }
    
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:ddd];
    
    [self presentViewController:navc animated:YES completion:^{
        
    }];
}




@end
