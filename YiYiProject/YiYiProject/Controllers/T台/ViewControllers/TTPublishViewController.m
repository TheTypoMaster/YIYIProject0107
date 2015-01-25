//
//  TTPublishViewController.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "TTPublishViewController.h"

#import "AFNetworking.h"


@interface TTPublishViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    BOOL imageIsValid;//图片是否有效
}

@end

@implementation TTPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = RGBCOLOR(200, 200, 200);
    self.rightString = @"发送";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHiddenKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    [self.addImageButton addTarget:self action:@selector(clickToAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.publishImage) {
        
        imageIsValid = YES;
        [self.addImageButton setImage:self.publishImage forState:UIControlStateNormal];
    }
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
                                                @"tt_content":content
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
}

- (void)leftButtonTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonTap:(UIButton *)sender
{
    NSLog(@"发送");
    
    [self tapToHiddenKeyboard:nil];
    
//    self.brandTF.text,self.modelTF.text,self.priceTF.text
    
    if ([LTools isEmpty:self.brandTF.text]) {
        
        [LTools showMBProgressWithText:@"品牌不能为空" addToView:self.view];
        return;
    }
    if ([LTools isEmpty:self.modelTF.text]) {
        
        [LTools showMBProgressWithText:@"型号不能为空" addToView:self.view];
        return;
    }
    
    if ([LTools isEmpty:self.priceTF.text]) {
        
        [LTools showMBProgressWithText:@"价格不能为空" addToView:self.view];
        return;
    }
    
    if ([LTools isValidateFloat:self.priceTF.text]) {
        
        [LTools showMBProgressWithText:@"请填写有效价格" addToView:self.view];
        return;
    }
    
    
    self.my_right_button.userInteractionEnabled = NO;
    
    if (imageIsValid) {
        
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

#pragma mark 代理

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

@end
