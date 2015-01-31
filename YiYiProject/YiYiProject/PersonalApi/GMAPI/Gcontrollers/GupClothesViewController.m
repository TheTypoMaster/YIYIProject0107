//
//  GupClothesViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/18.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GupClothesViewController.h"
#import "UploadPicViewController.h"
#import "AFNetworking.h"
#import "JKImagePickerController.h"
#import "PhotoCell.h"

@interface GupClothesViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,JKImagePickerControllerDelegate>
{
    UIView *_view1;//填写信息view
    UIView *_view2;//上传图片view
    
    
    
    NSMutableArray *_imageArray;//所选图片数组
    NSMutableArray *_showPicsBtnArray;//展示图片的btn
    NSMutableArray *_deleteImageIndexArray;//删除的图片在_imageArray中的下标
    
    
    NSMutableArray *_upImagesArray;//上传图片的数组
    
    
    NSMutableArray *_shurukuangArray;//输入框的数组
    
    
    //单品类型 打折 新品 热销
    UILabel *_leixingLabel;
    
    
    //性别
    UILabel *_genderLabel;
    
    
    
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
    _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT+58+50+15);
    
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
    _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT+58+50+15);
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"%ld",(long)textField.tag);
    _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT+360);
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
    }else if (textField.tag == 206){//类型
        if (_mainScrollView.contentOffset.y<208) {
            _mainScrollView.contentOffset = CGPointMake(0, 208);
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
    
    
    //判断信息完整性
    for (UITextField *tf in _shurukuangArray) {
        if (tf.text.length == 0 || _showPicsBtnArray.count == 0) {
            [GMAPI showAutoHiddenMBProgressWithText:@"请完善信息" addToView:self.view];
            return;
        }
        
    }
    
    //获取需要上传的图片
    [self getChoosePics];
    
    
    
}





#pragma mark - 上传图片 & 上传信息

//上传
-(void)upLoadImage:(NSArray *)aImage_arr{
    
    
    NSLog(@"uploadImage and info");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //上传的url
    NSString *uploadImageUrlStr = GFABUDIANPIN;
    
    UITextField *tf = _shurukuangArray[0];//品牌
    UITextField *tf1 = _shurukuangArray[1];//品名
    UITextField *tf2 = _shurukuangArray[2];//型号
    UITextField *tf3 = _shurukuangArray[3];//价格
    UITextField *tf4 = _shurukuangArray[4];//折扣
    UITextField *tf5 = _shurukuangArray[5];//标签
    
    
    //类型
    NSString *product_hotsale = nil;//热销
    NSString *product_new = nil;//新品
    
    
    NSString *gengder = nil;
    if ([_genderLabel.text isEqualToString:@"男"]) {
        gengder = @"2";
    }else if ([_genderLabel.text isEqualToString:@"女"]){
        gengder = @"1";
    }
    
    if ([_leixingLabel.text isEqualToString:@"折扣"]) {
        product_new = @"0";
        product_hotsale = @"0";
    }else if ([_leixingLabel.text isEqualToString:@"新品"]){
        product_new = @"1";
        product_hotsale = @"0";
    }else if ([_leixingLabel.text isEqualToString:@"畅销"]){
        product_new = @"0";
        product_hotsale = @"0";
    }
    
    
    
    
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:uploadImageUrlStr
                                   parameters:@{
                                                @"product_name":tf1.text,//产品名
                                                @"product_gender":gengder,//产品适用性别
                                                @"product_price":tf3.text,//产品价格
                                                @"product_brand_id":self.mallInfo.brand_id,//产品品牌id
                                                @"product_brand_name":tf.text,//品牌名称
                                                @"product_shop_id":self.userInfo.shop_id,//商店id
                                                @"product_sku":tf2.text,//产品唯一标示
                                                @"product_hotsale":product_hotsale,//是否热销
                                                @"product_new":product_new,//是否新品
                                                @"discount_num":tf4.text,//打折力度
                                                @"product_tag":tf5.text,//标签
                                                @"authcode":[GMAPI getAuthkey]//用户标示
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
                                       
                                       
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       
                                       NSLog(@"success %@",responseObject);
                                       
                                       NSError * myerr;
                                       
                                       NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:0 error:&myerr];
                                       
                                       
                                       NSLog(@"mydic == %@ err0 = %@",mydic,myerr);
                                       
                                       if ([[mydic objectForKey:@"errorcode"]intValue]==0) {
                                           [GMAPI showAutoHiddenMBProgressWithText:@"添加成功" addToView:self.view];
                                           [self performSelector:@selector(fabuyifuSuccessToGoBack) withObject:[NSNumber numberWithBool:YES] afterDelay:1];
                                           
                                       }
                                       
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       
                                       [GMAPI showAutoHiddenMBProgressWithText:@"添加失败请重新上传" addToView:self.view];
                                       
                                       NSLog(@"失败 : %@",error);
                                       
                                       
                                   }];
    
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
    
}



-(void)fabuyifuSuccessToGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}




//创建信息填写view
-(void)creatView1{
    
//    UIView *topGrayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 15)];
//    topGrayView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 15, DEVICE_WIDTH, 353)];
    _view1.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_view1];
    
    
    NSString *pinpai = nil;
    if ([self.mallInfo.brand_id isEqualToString:@"0"]) {//精品店
        
    }else{//商场店
        pinpai = self.mallInfo.shop_name;//品牌
    }
    
    NSArray *titleNameArray = @[@"品牌",@"品名",@"型号",@"价格",@"折扣",@"标签",@"类型"];
    
    for (int i = 0; i<7; i++) {
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
        
        
        if (i == 0) {
            if (pinpai) {
                shuruTf.text = pinpai;
                shuruTf.userInteractionEnabled = NO;
            }
        }
        
        
        if (i == 6) {
            shuruTf.text = @"123";
            shuruTf.hidden = YES;
            _leixingLabel = [[UILabel alloc]initWithFrame:shuruTf.frame];
            _leixingLabel.userInteractionEnabled = YES;
            _leixingLabel.textColor = RGBCOLOR(199, 199, 205);
            _leixingLabel.text = @"请选择单品类型";
            UITapGestureRecognizer *ttt = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseLeixing)];
            [_leixingLabel addGestureRecognizer:ttt];
            [backView addSubview:_leixingLabel];
        }
        
        
        
        
        if (i == 3) {
            shuruTf.placeholder = @"单位:元";
        }else if (i == 4){
            shuruTf.placeholder = @"如:8.8即为88折扣";
        }else if (i == 5){
            shuruTf.placeholder = @"如:运动,休闲,时尚,商务";
        }else if (i == 1){
            shuruTf.placeholder = @"请填写单品名称";
        }else if (i == 2){
            shuruTf.placeholder = @"请填写单品型号";
        }
        
        
        
        [_view1 addSubview:backView];
        
    }
    
}

//选择类型
-(void)chooseLeixing{
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"选择商品类型" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"折扣",@"新品",@"畅销", nil];
    
    [al show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    _leixingLabel.textColor = [UIColor blackColor];
    if (buttonIndex == 1) {
        _leixingLabel.text = @"折扣";
    }else if (buttonIndex == 2){
        _leixingLabel.text = @"新品";
    }else if (buttonIndex == 3){
        _leixingLabel.text = @"畅销";
    }else{
        _leixingLabel.textColor = RGBCOLOR(199, 199, 205);
        _leixingLabel.text = @"请选择单品类型";
    }
    
}



-(void)creatView2{
    _view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame)+12, DEVICE_WIDTH, 160)];
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
//            [btn addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
            [_showPicsBtnArray addObject:btn];
        }
        
        
        
        
        [btn setFrame:CGRectMake(13+(btnWeight+13)*i, CGRectGetMaxY(titleLabel.frame)+13, btnWeight, btnWeight)];
        
        [_view2 addSubview:btn];
    }
    
    
    
    //选择性别
    UILabel *ttt = [[UILabel alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(titleLabel.frame)+btnWeight+25, 70, 20)];
    ttt.text = @"选择性别";
    ttt.textColor = RGBCOLOR(114, 114, 114);
    UISwitch *ggg = [[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ttt.frame)+5, ttt.frame.origin.y-5, 50, 50)];
    [ggg addTarget:self action:@selector(nnnn:) forControlEvents:UIControlEventValueChanged];
    _genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ggg.frame)+10, ttt.frame.origin.y, 50, 20)];
    _genderLabel.text = @"男";
    _genderLabel.textColor = RGBCOLOR(114, 114, 114);
    [_view2 addSubview:ttt];
    [_view2 addSubview:ggg];
    [_view2 addSubview:_genderLabel];
    
    
    
    
}


-(void)nnnn:(UISwitch*)sender{
    if (sender.on) {
        _genderLabel.text = @"女";
    }else{
        _genderLabel.text = @"男";
    }
}




//弹出action提示
-(void)tianjiatupian:(UIButton *) sender
{
    UIActionSheet *selectPhotoSheet=[[UIActionSheet alloc]initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取", nil];
    selectPhotoSheet.actionSheetStyle=UIActionSheetStyleDefault;
    [selectPhotoSheet showInView:self.view];
}



#pragma mark--UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self composePicAdd];
    }
    
}




#pragma mark - 获取所选图片
-(void)getChoosePics{
    
    self.uploadImageArray = [NSMutableArray arrayWithCapacity:1];
    
    NSLog(@"-------%lu",(unsigned long)self.assetsArray.count);
    
    for (int i = 0;i<self.assetsArray.count;i++) {
        
        JKAssets* jkAsset = self.assetsArray[i];
        
        ALAssetsLibrary* lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:jkAsset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            
            if (asset) {
                
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                [self.uploadImageArray addObject:image];
                
                if (self.uploadImageArray.count == self.assetsArray.count) {
                    
                    [self upLoadImage:self.uploadImageArray];
                }
            }
            
        } failureBlock:^(NSError *error) {
            
            
        }];
    }
    
}







- (void)composePicAdd
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 0;
    imagePickerController.maximumNumberOfSelection = 3;
    imagePickerController.selectedAssetArray = self.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        for (int i = 0; i<self.assetsArray.count; i++) {
            JKAssets *asset = self.assetsArray[i];
            [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
                if (asset) {
                    UIButton *btn = _showPicsBtnArray[i];
                    [btn setBackgroundImage:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] forState:UIControlStateNormal];
                }
            } failureBlock:^(NSError *error) {
                
            }];
        }
        
        
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}






@end
