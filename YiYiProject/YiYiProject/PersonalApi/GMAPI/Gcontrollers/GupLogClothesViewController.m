//
//  GupLogClothesViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/6/27.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GupLogClothesViewController.h"
#import "GTimeSwitch.h"

@interface GupLogClothesViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIScrollView *_mainScrollView;
    
    NSMutableArray *_contentTfArray;
    
    UIImage *_chooseImage;
    
    UIImagePickerController *_imagePickController;
    
    UIButton *_showPicBtn;
    
    UILabel *_buyTimeLabel;
    
    UIView *_datePickerView;
    UIDatePicker *_datePick;
    
    UIButton *_finishBtn;
}
@end

@implementation GupLogClothesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    self.myTitle = @"上传衣服";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self creatCustomView];
    
    [self creatDatePickView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)creatCustomView{
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [_mainScrollView setContentSize:CGSizeMake(DEVICE_WIDTH, 500)];
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    
    _contentTfArray = [NSMutableArray arrayWithCapacity:1];
    
    NSArray *titleArray = @[@"品牌名称",@"产品描述",@"价格",@"购买时间",@"购买地点",@"图片",@"完成"];
    for (int i = 0; i<7; i++) {
        
        UIView *theView = [[UIView alloc]initWithFrame:CGRectMake(0, i*70, DEVICE_WIDTH, 70)];
        [_mainScrollView addSubview:theView];
        
        //收键盘
        UIControl *tapshou = [[UIControl alloc]initWithFrame:theView.bounds];
        [tapshou addTarget:self action:@selector(gShou) forControlEvents:UIControlEventTouchDown];
        [theView addSubview:tapshou];
        
        UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, DEVICE_WIDTH, 15) title:titleArray[i] font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
        [theView addSubview:tLabel];
        
        
        
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tLabel.frame)+10, DEVICE_WIDTH-40, 35)];
        tf.delegate = self;
        tf.layer.cornerRadius = 5;
        tf.layer.borderWidth = 0.5;
        tf.layer.borderColor = [RGBCOLOR(183, 184, 186)CGColor];
        [theView addSubview:tf];
        [_contentTfArray addObject:tf];
        
        
        
        if (i == 5) {//添加图片
            [theView setFrame:CGRectMake(0, i*70, DEVICE_WIDTH, 100)];
            [tf removeFromSuperview];
            [_contentTfArray removeObject:tf];
            UIButton *jiahaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [jiahaoBtn setFrame:CGRectMake(25, CGRectGetMaxY(tLabel.frame)+10, 60, 60)];
            [jiahaoBtn setImage:[UIImage imageNamed:@"gaddphoto.png"] forState:UIControlStateNormal];
            [jiahaoBtn addTarget:self action:@selector(addpic) forControlEvents:UIControlEventTouchUpInside];
            [theView addSubview:jiahaoBtn];
            
            _showPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_showPicBtn setFrame:CGRectMake(CGRectGetMaxX(jiahaoBtn.frame)+15, jiahaoBtn.frame.origin.y, 60, 60)];
            [_showPicBtn setImage:[UIImage imageNamed:@"gremovephoto.png"] forState:UIControlStateNormal];
            [theView addSubview:_showPicBtn];
            [_showPicBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==6){//完成按钮
            [theView setFrame:CGRectMake(0, (i-1)*70+100, DEVICE_WIDTH, 70)];
            [tf removeFromSuperview];
            [_contentTfArray removeObject:tf];
            [tLabel removeFromSuperview];
            _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_finishBtn setFrame:CGRectMake(30, 10, DEVICE_WIDTH-60, 35)];
            _finishBtn.layer.cornerRadius = 4;
            [_finishBtn setTitle:titleArray[i] forState:UIControlStateNormal];
            [_finishBtn setBackgroundColor:RGBCOLOR(244, 76, 138)];
            [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_finishBtn addTarget:self action:@selector(uploadBuyClothesLog) forControlEvents:UIControlEventTouchUpInside];
            [theView addSubview:_finishBtn];
        }else if (i == 3){//购买时间
            tf.text = @"123";
            tf.hidden = YES;
            _buyTimeLabel = [[UILabel alloc]initWithFrame:tf.frame];
            _buyTimeLabel.layer.cornerRadius = 5;
            _buyTimeLabel.layer.borderWidth = 0.5;
            _buyTimeLabel.layer.borderColor = [RGBCOLOR(183, 184, 186)CGColor];
            [theView addSubview:_buyTimeLabel];
            _buyTimeLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *ttt = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseBuyTime)];
            [_buyTimeLabel addGestureRecognizer:ttt];
        }else if (i == 2){//价格
            tf.keyboardType = UIKeyboardTypeNumberPad;
            
        }
        
        
        
        
    }
    
    
}



-(void)addpic{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [act showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    switch (buttonIndex) {
        case 0:
        {
            //图片选择器
            if (!_imagePickController) {
                _imagePickController = [[UIImagePickerController alloc]init];
            }
            
            _imagePickController.delegate = self;
            _imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_imagePickController animated:YES completion:^{
                
            }];
        }
            break;
        case 1:
        {
            //图片选择器
            
            if (!_imagePickController) {
                _imagePickController = [[UIImagePickerController alloc]init];
            }
            _imagePickController.delegate = self;
            _imagePickController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:_imagePickController animated:YES completion:^{
                
            }];
        }
            
            break;
        case 2:
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%s",__FUNCTION__);
    [UIApplication sharedApplication].statusBarHidden = NO;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        _chooseImage = originImage;
    }
    
    
    [_imagePickController dismissViewControllerAnimated:YES completion:^{
        [_showPicBtn setImage:_chooseImage forState:UIControlStateNormal];
    }];
    
}



-(void)removeSelf{
    [_showPicBtn setImage:[UIImage imageNamed:@"gremovephoto.png"] forState:UIControlStateNormal];
    _chooseImage = nil;
}



-(void)uploadBuyClothesLog{
    NSLog(@"123");
    
    
    _finishBtn.userInteractionEnabled = NO;
    
    
    
    if (!_chooseImage) {
        [GMAPI showAutoHiddenMBProgressWithText:@"请添加图片" addToView:self.view];
        _finishBtn.userInteractionEnabled = YES;
        return;
    }
    
    for (UITextField *tf in _contentTfArray) {
        if (tf.text.length == 0 || !tf.text) {
            [GMAPI showAutoHiddenMBProgressWithText:@"请完善信息" addToView:self.view];
            _finishBtn.userInteractionEnabled = YES;
            return;
        }
    }
    
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UITextField *tf0 = _contentTfArray[0];
    UITextField *tf1 = _contentTfArray[1];
    UITextField *tf2 = _contentTfArray[2];
    UITextField *tf4 = _contentTfArray[4];
    NSString *brand = tf0.text;
    NSString *desc = tf1.text;
    NSString *price = tf2.text;
    NSString *buy_time = _buyTimeLabel.text;
    NSString *buy_place = tf4.text;
    
    NSString *url = @"http://www119.alayy.com/index.php?d=api&c=buylog&m=add";
    NSDictionary *dataDic = @{
                              @"authcode":[GMAPI getAuthkey],
                              @"brand":brand,
                              @"price":price,
                              @"desc":desc,
                              @"buy_time":buy_time,
                              @"buy_place":buy_place
                              };
    
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:url
                                   parameters:dataDic
                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                   {
                                       
                                       UIImage *aImage = [self scaleImage:_chooseImage toScale:0.5];;
                                       
                                       //按比例缩放
                                       
                                       NSData * data= UIImageJPEGRepresentation(aImage, 0.8);
                                       
                                       NSLog(@"---> 大小 %ld",(unsigned long)data.length);
                                       
                                       NSString *imageName = @"icon.jpg";
                                       
                                       NSString *picName = @"image";
                                       
                                       [formData appendPartWithFileData:data name:picName fileName:imageName mimeType:@"image/jpg"];
                                       
                                       
                                   }
                                   success:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                       
                                       
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       
                                       NSLog(@"success %@",responseObject);
                                       
                                       NSError * myerr;
                                       
                                       NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:&myerr];
                                       
                                       
                                       NSLog(@"mydic == %@ err0 = %@",mydic,myerr);
                                       
                                       if (mydic == nil) {
                                           [GMAPI showAutoHiddenMBProgressWithText:@"发布失败" addToView:self.view];
                                           return;
                                       }
                                       
                                       if ([[mydic objectForKey:@"errorcode"]intValue]==0) {
                                           [GMAPI showAutoHiddenMBProgressWithText:@"发布成功" addToView:self.view];
                                           [[NSNotificationCenter defaultCenter]postNotificationName:GUPBUYCLOTHES_SUCCESS object:nil];
                                           [self performSelector:@selector(fabuyifuSuccessToGoBack) withObject:[NSNumber numberWithBool:YES] afterDelay:1.2];
                                           
                                       }else{
                                           [GMAPI showAutoHiddenMBProgressWithText:[mydic objectForKey:@"msg"] addToView:self.view];
                                       }
                                       
                                       
                                       
                                       
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       
                                       [GMAPI showAutoHiddenMBProgressWithText:@"发布失败请重新发布" addToView:self.view];
                                       
                                       NSLog(@"失败 : %@",error);
                                       
                                       _finishBtn.userInteractionEnabled = YES;
                                       
                                   }];
    
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
    
    return;
}


-(void)fabuyifuSuccessToGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)creatDatePickView{
    _datePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 250)];
    _datePickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_datePickerView];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(5, 0, 60, 50)];
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(gmbb) forControlEvents:UIControlEventTouchUpInside];
    [_datePickerView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(DEVICE_WIDTH-65, 0, 60, 50)];
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(gmaa) forControlEvents:UIControlEventTouchUpInside];
    [_datePickerView addSubview:btn2];
    
    _datePick = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, DEVICE_WIDTH, 250)];
    _datePick.datePickerMode = UIDatePickerModeDate;
    [_datePickerView addSubview:_datePick];
    
}


-(void)chooseBuyTime{
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [self gShou];
        [_datePickerView setFrame:CGRectMake(0, DEVICE_HEIGHT-300, DEVICE_WIDTH, 300)];
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}

-(void)gmaa{
    
    [UIView animateWithDuration:0.3 animations:^{
        [_datePickerView setFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 300)];
    } completion:^(BOOL finished) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *confromTimesp = _datePick.date;
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        _buyTimeLabel.text = confromTimespStr;
        
        [_mainScrollView setContentSize:CGSizeMake(DEVICE_WIDTH, 1000)];
        
        [self gShou];
    }];
    
}

-(void)gmbb{
    [UIView animateWithDuration:0.3 animations:^{
        [_datePickerView setFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 300)];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, 1000);
    
    [self gmbb];
    
}

-(void)gShou{
    NSLog(@"收键盘了");
    
    for (UITextField *tf in _contentTfArray) {
        [tf resignFirstResponder];
    }
    
    _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, 500);

    [self gmbb];
}


//按比例缩放
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
