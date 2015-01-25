//
//  GupClothesViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/18.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GupClothesViewController.h"
#import "ZYQAssetPickerController.h"
#import "UploadPicViewController.h"
#import "AFNetworking.h"

@interface GupClothesViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate,UITextFieldDelegate>
{
    UIView *_view1;//填写信息view
    UIView *_view2;//上传图片view
    
    
    
    NSMutableArray *_imageArray;//所选图片数组
    NSMutableArray *_showPicsBtnArray;//展示图片的btn
    NSMutableArray *_deleteImageIndexArray;//删除的图片在_imageArray中的下标
    
    
    NSMutableArray *_upImagesArray;//上传图片的数组
    
    
    NSMutableArray *_shurukuangArray;//输入框的数组
    
    
    
    
}
@end

@implementation GupClothesViewController


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
    
    self.myTitle=@"上传衣服";
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    //初始化
    _shurukuangArray = [NSMutableArray arrayWithCapacity:1];
    _showPicsBtnArray = [NSMutableArray arrayWithCapacity:1];
    
    
    //主scrollview
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-15)];
    _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT+58);
    
    _mainScrollView.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:_mainScrollView];
    
    
    //填写信息view
    [self creatView1];
    
    //上传图片view
    [self creatView2];
    
    //提交按钮
    [self creatTijiaoBtn];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gShou) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//空白点击收键盘start=======
-(void)gShou{
    NSLog(@"收键盘了");
    
    if (_mainScrollView.contentOffset.y>=58) {
        _mainScrollView.contentOffset = CGPointMake(0, 0);
    }
    for (UITextField *tf in _shurukuangArray) {
        [tf resignFirstResponder];
    }
    _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT+58);
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"%ld",(long)textField.tag);
    _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT+300);
    _mainScrollView.userInteractionEnabled = YES;
    if (textField.tag == 203) {//价格
        if (_mainScrollView.contentOffset.y<58) {
            _mainScrollView.contentOffset = CGPointMake(0, 58);
        }
    }else if (textField.tag == 204){//折扣
        if (_mainScrollView.contentOffset.y<108) {
            _mainScrollView.contentOffset = CGPointMake(0, 108);
        }
        
    }else if (textField.tag == 205){//标签
        if (_mainScrollView.contentOffset.y<158) {
            _mainScrollView.contentOffset = CGPointMake(0, 158);
        }
    }
}

//空白点击手键盘end======


-(void)creatTijiaoBtn{
    UIButton *tijiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tijiaoBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tijiaoBtn setBackgroundColor:RGBCOLOR(217, 66, 93)];
    tijiaoBtn.layer.cornerRadius = 5;
    [tijiaoBtn setFrame:CGRectMake(20, CGRectGetMaxY(_view2.frame)+13, DEVICE_WIDTH-40, 44)];
    [tijiaoBtn addTarget:self action:@selector(tijiao) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainScrollView addSubview:tijiaoBtn];
}



-(void)tijiao{
    _upImagesArray = [NSMutableArray arrayWithCapacity:1];
    NSInteger _imageArrayCount = _imageArray.count;
    
    for (int i = 0; i<_imageArrayCount; i++) {
        BOOL have = NO;
        for (NSString *str in _deleteImageIndexArray) {
            if ([str intValue]==i) {
                have = YES;
                break;
            }
        }
        if (!have) {
            [_upImagesArray addObject:_imageArray[i]];
        }
    }
    
    
    
    //判断信息完整性
    for (UITextField *tf in _shurukuangArray) {
        if (tf.text.length == 0 || _upImagesArray.count == 0) {
            [GMAPI showAutoHiddenMBProgressWithText:@"请完善信息" addToView:self.view];
            return;
        }
        
    }
    
    
    //上传信息 多图上传
    [self upLoadImage:_upImagesArray];
    
    
}



#pragma mark - 上传图片

//上传
-(void)upLoadImage:(NSArray *)aImage_arr{
    
    //上传的url
    NSString *uploadImageUrlStr = GFABUDIANPIN;
    
    UITextField *tf = _shurukuangArray[0];//品牌
    UITextField *tf1 = _shurukuangArray[1];//品名
    UITextField *tf2 = _shurukuangArray[2];//型号
    UITextField *tf3 = _shurukuangArray[3];//价格
    UITextField *tf4 = _shurukuangArray[4];//折扣
    UITextField *tf5 = _shurukuangArray[5];//标签
    
    
    
    
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:uploadImageUrlStr
                                   parameters:@{
                                                @"product_name":tf1.text,//产品名
                                                @"product_gender":@"男",//产品适用性别
                                                @"product_price":tf3.text,//产品价格
                                                @"product_brand_id":@"123",//产品品牌id
                                                @"product_mall_id":@"1",//商店id
                                                @"product_sku":@"1",//产品唯一标示
                                                }
                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                   {
                                       
                                       for (int i = 0; i < aImage_arr.count; i ++) {
                                           
                                           UIImage *aImage = aImage_arr[i];
                                           
                                           NSData * data= UIImageJPEGRepresentation(aImage, 1);
                                           
                                           NSLog(@"---> 大小 %ld",(unsigned long)data.length);
                                           
                                           NSString *imageName = [NSString stringWithFormat:@"icon%d.jpg",i];
                                           
                                           NSString *picName = [NSString stringWithFormat:@"images%d",i];
                                           
                                           [formData appendPartWithFileData:data name:picName fileName:imageName mimeType:@"image/jpg"];
                                           
                                       }
                                       
                                       
                                   }
                                   success:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                       
                                       NSLog(@"success %@",responseObject);
                                       
                                       NSError * myerr;
                                       
                                       NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:0 error:&myerr];
                                       
                                       
                                       NSLog(@"mydic == %@ err0 = %@",mydic,myerr);
                                       
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       
                                       
                                       NSLog(@"失败 : %@",error);
                                       
                                       
                                   }];
    
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
    
}








//创建信息填写view
-(void)creatView1{
    
//    UIView *topGrayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 15)];
//    topGrayView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 15, DEVICE_WIDTH, 303)];
    _view1.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_view1];
    
    
    NSArray *titleNameArray = @[@"品牌",@"品名",@"型号",@"价格",@"折扣",@"标签"];
    
    for (int i = 0; i<6; i++) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0+i*50.5, DEVICE_WIDTH, 50)];
        //收键盘
        UIControl *tapshou = [[UIControl alloc]initWithFrame:backView.bounds];
        [tapshou addTarget:self action:@selector(gShou) forControlEvents:UIControlEventTouchDown];
        [backView addSubview:tapshou];
        
        //分割线
        if (i == 0) {
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0.5)];
            line1.backgroundColor = RGBCOLOR(234, 234, 234);
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, DEVICE_WIDTH, 0.5)];
            line2.backgroundColor = RGBCOLOR(234, 234, 234);
            [backView addSubview:line1];
            [backView addSubview:line2];
        }else{
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, DEVICE_WIDTH, 0.5)];
            line.backgroundColor = RGBCOLOR(234, 234, 234);
            [backView addSubview:line];
        }
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 15, 35, 20)];
        titleLabel.tag = 1000+i;
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = RGBCOLOR(114, 114, 114);
        titleLabel.text = titleNameArray[i];
        [backView addSubview:titleLabel];
        
        
        //输入框
        UITextField *shuruTf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+20, titleLabel.frame.origin.y, DEVICE_WIDTH-17-17-20-titleLabel.frame.size.width, titleLabel.frame.size.height)];
        shuruTf.font = [UIFont systemFontOfSize:17];
        shuruTf.textColor = RGBCOLOR(3, 3, 3);
        shuruTf.tag = 200+i;
        shuruTf.delegate = self;
        [_shurukuangArray addObject:shuruTf];
        [backView addSubview:shuruTf];
        
        
        [_view1 addSubview:backView];
        
    }
    
}








-(void)creatView2{
    _view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame)+12, DEVICE_WIDTH, 145)];
    _view2.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_view2];
    
    
    
    //收键盘
    UIControl *tapshou = [[UIControl alloc]initWithFrame:_view2.bounds];
    [tapshou addTarget:self action:@selector(gShou) forControlEvents:UIControlEventTouchDown];
    [_view2 addSubview:tapshou];
    
    
    
    //上传衣服标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 15, 70, 20)];
//    titleLabel.backgroundColor = RGBCOLOR_ONE;
    titleLabel.textColor = RGBCOLOR(114, 114, 114);
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = @"上传图片";
    [_view2 addSubview:titleLabel];
    
    
    //上传衣服加号和图片view
    
    CGFloat btnWeight = (DEVICE_WIDTH - 13*5)*0.25;
    
    for (int i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100+i;
        if (i == 0) {
            [btn setBackgroundImage:[UIImage imageNamed:@"gaddphoto.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(tianjiatupian:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"gremovephoto.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
            [_showPicsBtnArray addObject:btn];
        }
        
        
        
        
        [btn setFrame:CGRectMake(13+(btnWeight+13)*i, CGRectGetMaxY(titleLabel.frame)+13, btnWeight, btnWeight)];
        
        [_view2 addSubview:btn];
    }
    
    
}




-(void)removeSelf:(UIButton *)sender{
    NSString *tagIndex = [NSString stringWithFormat:@"%ld",sender.tag-100-1];
    BOOL have = NO;
    for (NSString *str in _deleteImageIndexArray) {
        if ([str isEqualToString:tagIndex]) {
            have = YES;
            break;
        }
    }
    
    if (!have) {
        [_deleteImageIndexArray addObject:tagIndex];
    }
    
    UIButton *btn = (UIButton *)[_view2 viewWithTag:sender.tag];
    [btn setBackgroundImage:[UIImage imageNamed:@"gremovephoto.png"] forState:UIControlStateNormal];
    
}


//弹出action提示
-(void)tianjiatupian:(UIButton *) sender
{
    UIActionSheet *selectPhotoSheet=[[UIActionSheet alloc]initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    selectPhotoSheet.actionSheetStyle=UIActionSheetStyleDefault;
    [selectPhotoSheet showInView:self.view];
}



#pragma mark--UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.sourceType=sourceType;
        //picker.allowsEditing=YES;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }else if(buttonIndex==1)
    {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = 9 - _imageArray.count;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}
#pragma mark--ZYQAssetPickerControllerDelegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;
{
    
    
    
    _imageArray = [NSMutableArray arrayWithCapacity:1];
    _deleteImageIndexArray = [NSMutableArray arrayWithCapacity:1];
    
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [_imageArray addObject:tempImg];
    }
    
    
    
    NSLog(@"imageArray:%lu",(unsigned long)_imageArray.count);
    
    
    NSInteger chooseImageCount = _imageArray.count;
    chooseImageCount = chooseImageCount>3?3:chooseImageCount;
    for (int i = 0; i<chooseImageCount; i++) {
        UIButton *btn = _showPicsBtnArray[i];
        [btn setBackgroundImage:_imageArray[i] forState:UIControlStateNormal];
    }
    
    
}







@end
