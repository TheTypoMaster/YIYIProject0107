//
//  MyBodyViewController.m
//  YiYiProject
//
//  Created by unisedu on 15/1/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyBodyViewController.h"
#import "AFHTTPRequestOperationManager.h"
@interface MyBodyViewController ()
{
    UIScrollView *rootScrollView;
    UITextField *shenGaoTextField;//身高
    UITextField *tiZhongTextField;//体重
    UITextField *jianKuanTextField;//肩宽
    UITextField *xiongWeiTextField;//胸围
    UITextField *yaoWeiTextField;//腰围
    UITextField *TunWeiTextField;//臀围
    UIImageView *imageView;//生活照
    NSDictionary *sourceDic;//数据源字典
}
@end

@implementation MyBodyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.rightString = @"完成";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTitle=@"我的体型";
    [self createRootScrolliew];
    [self createViews];
    [self getNetData];
    // Do any additional setup after loading the view.
}
-(void)createRootScrolliew
{
    rootScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    rootScrollView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:rootScrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerKeyBord:)];
    [rootScrollView addGestureRecognizer:tapGesture];
    
}
-(void)createViews
{
    UIView *jiBenInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 16, DEVICE_WIDTH, 150)];
    jiBenInfoView.backgroundColor = [UIColor whiteColor];
    [rootScrollView addSubview:jiBenInfoView];
    
    UIView *line_hor1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50 ,DEVICE_WIDTH, 0.5)];
    line_hor1.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
    [jiBenInfoView addSubview:line_hor1];
    
    UIView *line_hor2 = [[UIView alloc]initWithFrame:CGRectMake(0, 100 ,DEVICE_WIDTH, 0.5)];
    line_hor2.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
    [jiBenInfoView addSubview:line_hor2];
    
    NSArray *array1 = @[@"身高",@"体重",@"肩宽"];
    for(int i = 0 ; i< 3 ; i++)
    {
        UILabel *label = [LTools createLabelFrame:CGRectMake(17, (50-15)/2.0+50*i, 30, 15) title:[array1 objectAtIndex:i] font:15 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"727272"]];
        [jiBenInfoView addSubview:label];
    }
    
    shenGaoTextField = [[UITextField alloc] initWithFrame:CGRectMake(68, (50-40)/2.0, 100, 40)];
    shenGaoTextField.backgroundColor = [UIColor whiteColor];
    shenGaoTextField.font = [UIFont systemFontOfSize:15];
    shenGaoTextField.keyboardType = UIKeyboardTypeDecimalPad;
    //shenGaoTextField.textAlignment = NSTextAlignmentRight;
    shenGaoTextField.placeholder = @"单位:cm";
    shenGaoTextField.delegate = self;
    [jiBenInfoView addSubview:shenGaoTextField];
    
//    UILabel *label1 = [LTools createLabelFrame:CGRectMake(shenGaoTextField.frame.origin.x+shenGaoTextField.frame.size.width, shenGaoTextField.frame.origin.y, 30, 40) title:@"cm" font:15 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"000000"]];
//    [jiBenInfoView addSubview:label1];
    
    tiZhongTextField = [[UITextField alloc] initWithFrame:CGRectMake(68, (50-40)/2.0+50, 100, 40)];
    tiZhongTextField.backgroundColor = [UIColor clearColor];
    tiZhongTextField.font = [UIFont systemFontOfSize:15];
    tiZhongTextField.placeholder = @"单位:kg";
    tiZhongTextField.keyboardType = UIKeyboardTypeDecimalPad;
    tiZhongTextField.delegate = self;
    //tiZhongTextField.textAlignment = NSTextAlignmentRight;
    [jiBenInfoView addSubview:tiZhongTextField];
    
    jianKuanTextField = [[UITextField alloc] initWithFrame:CGRectMake(68, (50-40)/2.0+100, 100, 40)];
    jianKuanTextField.backgroundColor = [UIColor clearColor];
    jianKuanTextField.font = [UIFont systemFontOfSize:15];
    jianKuanTextField.keyboardType = UIKeyboardTypeDecimalPad;
    //jianKuanTextField.textAlignment = NSTextAlignmentRight;
    jianKuanTextField.placeholder = @"单位:cm";
    jianKuanTextField.delegate = self;
    [jiBenInfoView addSubview:jianKuanTextField];
    
    UIView *sanWeiView = [[UIView alloc] initWithFrame:CGRectMake(0, jiBenInfoView.frame.origin.y+jiBenInfoView.frame.size.height+16, DEVICE_WIDTH, 150)];
    sanWeiView.backgroundColor = [UIColor whiteColor];
    [rootScrollView addSubview:sanWeiView];
    
    UIView *line_hor3 = [[UIView alloc]initWithFrame:CGRectMake(0, 50 ,DEVICE_WIDTH, 0.5)];
    line_hor3.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
    [sanWeiView addSubview:line_hor3];
    
    UIView *line_hor4 = [[UIView alloc]initWithFrame:CGRectMake(0, 100 ,DEVICE_WIDTH, 0.5)];
    line_hor4.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
    [sanWeiView addSubview:line_hor4];
    
    NSArray *array2 = @[@"胸围",@"腰围",@"臀围"];
    for(int i = 0 ; i< 3 ; i++)
    {
        UILabel *label = [LTools createLabelFrame:CGRectMake(17, (50-15)/2.0+50*i, 30, 15) title:[array2 objectAtIndex:i] font:15 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"727272"]];
        [sanWeiView addSubview:label];
    }
    
    
    xiongWeiTextField = [[UITextField alloc] initWithFrame:CGRectMake(68, (50-40)/2.0, 100, 40)];
    xiongWeiTextField.backgroundColor = [UIColor clearColor];
    xiongWeiTextField.placeholder = @"单位:cm";
    xiongWeiTextField.delegate = self;
    xiongWeiTextField.font = [UIFont systemFontOfSize:15];
    xiongWeiTextField.keyboardType = UIKeyboardTypeDecimalPad;
    //xiongWeiTextField.textAlignment = NSTextAlignmentRight;
    [sanWeiView addSubview:xiongWeiTextField];
    
    yaoWeiTextField = [[UITextField alloc] initWithFrame:CGRectMake(68, (50-40)/2.0+50, 100, 40)];
    yaoWeiTextField.backgroundColor = [UIColor clearColor];
    yaoWeiTextField.font = [UIFont systemFontOfSize:15];
    yaoWeiTextField.placeholder = @"单位:cm";
    yaoWeiTextField.delegate = self;
    yaoWeiTextField.keyboardType = UIKeyboardTypeDecimalPad;
    //yaoWeiTextField.textAlignment = NSTextAlignmentRight;
    [sanWeiView addSubview:yaoWeiTextField];
    
    TunWeiTextField = [[UITextField alloc] initWithFrame:CGRectMake(68, (50-40)/2.0+100, 100, 40)];
    TunWeiTextField.backgroundColor = [UIColor clearColor];
    TunWeiTextField.font = [UIFont systemFontOfSize:15];
    TunWeiTextField.placeholder = @"单位:cm";
    TunWeiTextField.delegate = self;
    TunWeiTextField.keyboardType = UIKeyboardTypeDecimalPad;
    //TunWeiTextField.textAlignment = NSTextAlignmentRight;
    [sanWeiView addSubview:TunWeiTextField];
    
    UIView *shengHuoZhaoView = [[UIView alloc] initWithFrame:CGRectMake(0, sanWeiView.frame.origin.y+sanWeiView.frame.size.height+16, DEVICE_WIDTH, 145)];
    shengHuoZhaoView.backgroundColor = [UIColor whiteColor];
    [rootScrollView addSubview:shengHuoZhaoView];
    
    UILabel *labelShengHuo = [LTools createLabelFrame:CGRectMake(62, 18, 45, 15) title:@"生活照" font:15 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"727272"]];
    [shengHuoZhaoView addSubview:labelShengHuo];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(labelShengHuo.frame.origin.x, labelShengHuo.frame.origin.y+labelShengHuo.frame.size.height+15, 80, 80)];
    imageView.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    imageView.userInteractionEnabled = YES;
    //imageView.image = [UIImage imageNamed:@"navigationBarBackground"];
    [shengHuoZhaoView addSubview:imageView];
    
    UITapGestureRecognizer *addImageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageTapGesture:)];
    [imageView addGestureRecognizer:addImageTapGesture];
    
}
-(void)addImageTapGesture:(UITapGestureRecognizer *) tap
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
        picker.maximumNumberOfSelection = 1;
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
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        imageView.image = tempImg;
    }
    
}
#pragma mark--UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageNew = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
        imageView.image = imageNew;
    }];
    
    
}
-(void)registerKeyBord:(UITapGestureRecognizer *) tap
{
    [shenGaoTextField resignFirstResponder];
    [tiZhongTextField resignFirstResponder];
    [jianKuanTextField resignFirstResponder];
    [xiongWeiTextField resignFirstResponder];
    [yaoWeiTextField resignFirstResponder];
    [TunWeiTextField resignFirstResponder];
}
-(void)rightButtonTap:(UIButton *) sender
{
    [self upLoadInfo];
}

//上传
-(void)upLoadInfo
{
    
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    NSDictionary *paraments = @{
                                @"authcode":[GMAPI getAuthkey],
                                @"height": [shenGaoTextField.text substringToIndex:shenGaoTextField.text.length - 3],
                                @"weight": [tiZhongTextField.text substringToIndex:tiZhongTextField.text.length -3],
                                @"shoulder_width":[jianKuanTextField.text substringToIndex:jianKuanTextField.text.length - 3],
                                @"chest_width":[xiongWeiTextField.text substringToIndex:xiongWeiTextField.text.length -3],
                                @"waistline":[yaoWeiTextField.text substringToIndex:yaoWeiTextField.text.length - 3],
                                @"hipline":[TunWeiTextField.text substringToIndex:TunWeiTextField.text.length -3]
                                };
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:POST_EDITMYBODY_URL
                                   parameters:paraments
                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                   {
                                           NSData *imageData =UIImageJPEGRepresentation(imageView.image, 0.1);
                                           [formData appendPartWithFileData:imageData name:@"pic" fileName:@"icon.jpg" mimeType:@"image/jpg"];
                                   }
                                   success:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                       
                                       
                                       NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                       
                                       NSLog(@"....str = %@",str);
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       
                                       
                                   }];
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
    
}
-(void)getNetData{
    NSString *api = [NSString stringWithFormat:GET_GETMYBODY_URL,[GMAPI getAuthkey]];
    
    NSLog(@"api===%@",api);
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        if(result && [[result objectForKey:@"errorcode"] integerValue] == 0 && ![self isFirstShowWithDic:result])
        {
            sourceDic = result;
            shenGaoTextField.text = [[sourceDic objectForKey:@"height"] stringByAppendingString:@" cm"];
            tiZhongTextField.text = [[sourceDic objectForKey:@"weight"] stringByAppendingString:@" kg"];
            jianKuanTextField.text = [[sourceDic objectForKey:@"shoulder_width"] stringByAppendingString:@" cm"];
            xiongWeiTextField.text = [[sourceDic objectForKey:@"chest_width"] stringByAppendingString:@" cm"];
            yaoWeiTextField.text = [[sourceDic objectForKey:@"waistline"] stringByAppendingString:@" cm"];
            TunWeiTextField.text = [[sourceDic objectForKey:@"hipline"] stringByAppendingString:@" cm"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[sourceDic objectForKey:@"recent_photo"]]];
            
        }
        
        NSLog(@"%@",result);
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"%@",failDic);
        
    }];
    
}
//是否是第一次进来，没有体型数据
-(BOOL)isFirstShowWithDic:(NSDictionary *) dic
{
   if([[dic objectForKey:@"shoulder_width"] intValue] == 0 && [[dic objectForKey:@"chest_width"] intValue] == 0 && [[dic objectForKey:@"waistline"] intValue] == 0 && [[dic objectForKey:@"weight"] intValue] == 0)
   {
       return YES;
   }
    return NO;
}
-(void)createPickView
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.text.length > 3)
    {
    textField.text = [textField.text substringToIndex:textField.text.length -3];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length == 0)
    {
        return;
    }
    if(textField == tiZhongTextField)
    {
       textField.text = [textField.text stringByAppendingString:@" kg"];
    }
    else
    {
        textField.text = [textField.text stringByAppendingString:@" cm"];
    }
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
