//
//  UploadPicViewController.m
//  YiYiProject
//
//  Created by unisedu on 15/1/4.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "UploadPicViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface UploadPicViewController ()
{
    UIView *_maskView;
    NSMutableArray *_dataSourceArray;
    UITableView *myTableView;
    UILabel *chooseLabel;
    NSDictionary *chooseDic;
    UITextField * _textField;
    UIView *bgViewClassication;//添加分类的
    
    UIView *chooseView;//选择分类的
    
    UIView *chooseFenleiView;
    
    UIView *bgView;
}
@end

@implementation UploadPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.myTitle=@"上传";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self cretaeViewsWithImageArray:imageArray];
    [self createRightBarItem];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
}
-(void)createRightBarItem
{
    UIButton *rightBarItem = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 111/3.0, 111/3.0) normalTitle:@"完成" image:nil backgroudImage:nil superView:nil target:self action:@selector(rightBtnClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarItem];
    
}
-(void)cretaeViewsWithImageArray:(NSArray *) array
{
    if(!bgView)
    {
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, DEVICE_WIDTH, 100)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:bgView];
    }
    
    NSMutableArray *showImageArray = [NSMutableArray arrayWithArray:imageArray];
    if(imageArray.count < 9)
    {
        UIImage *image = [UIImage imageNamed:@"yc_sc_tj"];
        [showImageArray addObject:image];
        
    }
    //移除bgView上的所有图片
    for(UIImageView *imageVew in bgView.subviews)
    {
        if(imageVew.tag >= 100)
        {
            [imageVew removeFromSuperview];
        }
    }
        
    float imageViewWindth = (DEVICE_WIDTH - 60) / 4.0;
    int columnNum = 4;//列数
    int rowNum = (int)(showImageArray.count/4 + ((showImageArray.count%4 > 0)?1:0));//行数
    float sourceX = 30/2.0;
    float sourceY = 13;
    for(int i = 0; i < rowNum ; i++)
    {
        for(int j = 0 ;j < columnNum ; j++)
        {  
            UIImageView *classificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(sourceX, sourceY, imageViewWindth, imageViewWindth)];
            classificationImageView.backgroundColor = [UIColor yellowColor];
            CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
            CGColorRef colorRef=CGColorCreate(colorSpace, (CGFloat[]){204/255.0,204/255.0,204/255.0,1});
            [classificationImageView.layer setCornerRadius:5];//设置矩形是个圆角半径
            [classificationImageView.layer setBorderWidth:0.5];//边框宽度
            [classificationImageView.layer setBorderColor:colorRef];
            classificationImageView.tag = 100 + j +i*4;
            classificationImageView.userInteractionEnabled = YES;
            [bgView addSubview:classificationImageView];
             sourceX = sourceX+imageViewWindth+10;
            NSLog(@"iiiii = %d",j+i*4);
            if(j+i*4 < showImageArray.count)
            {
                NSLog(@"kkkkk = %@",[showImageArray objectAtIndex:j+i*4]);
                [classificationImageView setImage:[showImageArray objectAtIndex:j+i*4]];
                
                //如果当前图片不到九个 给最后一个图片加单机手势
                if(imageArray.count < 9 && j+i*4 == showImageArray.count - 1)
                {
                    classificationImageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *addTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageTap:)];
                    [classificationImageView addGestureRecognizer:addTapGesture];
                }
            }
            else
            {
                [classificationImageView removeFromSuperview];
            }
        }
        sourceX = 30/2.0;
        sourceY = sourceY+imageViewWindth +11;
        
    }
    
    bgView.frame = CGRectMake(0, 15, DEVICE_WIDTH, sourceY);
    
    if(!chooseFenleiView)
    {
    chooseFenleiView = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.frame.origin.y+bgView.frame.size.height+10, DEVICE_WIDTH, 50)];
    chooseFenleiView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chooseFenleiView];
    
    UILabel *xuanzeFenlei = [LTools createLabelFrame:CGRectMake(15, (50-16)/2.0, 16*4, 16) title:@"选择分类" font:16 align:0 textColor:[UIColor colorWithHexString:@"727272"]];
    [chooseFenleiView addSubview:xuanzeFenlei];
    
    UIImageView * jianTouImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-15-9, (chooseFenleiView.height-16)/2.0, 9, 16)];
    jianTouImageView.image = [UIImage imageNamed:@"dapei_jiantou"];
    [chooseFenleiView addSubview:jianTouImageView];
    UITapGestureRecognizer *chooseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseFenlei:)];
    [chooseFenleiView addGestureRecognizer:chooseTap];
    
    chooseLabel = [LTools createLabelFrame:CGRectMake(jianTouImageView.frame.origin.x-20-64, (chooseFenleiView.height-16)/2.0, 16*4, 16) title:nil font:16 align:NSTextAlignmentRight textColor:[UIColor colorWithHexString:@"727272"]];
    [chooseFenleiView addSubview:chooseLabel];
    }
    else
    {
        chooseFenleiView.frame = CGRectMake(0, bgView.frame.origin.y+bgView.frame.size.height+10, DEVICE_WIDTH, 50);
    }
}
-(void)chooseFenlei:(UITapGestureRecognizer *) tap
{
    [self getNetData];
    [self createChooseView];
}
-(void)createChooseView
{
    UIWindow *currentWindow =(UIWindow*) [UIApplication sharedApplication].keyWindow;
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [currentWindow addSubview:_maskView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMaskView:)];
    tapGesture.delegate = self;
    [_maskView addGestureRecognizer:tapGesture];
    
    chooseView = [[UIView alloc] initWithFrame:CGRectMake(0, 260, DEVICE_WIDTH, DEVICE_HEIGHT-260)];
    chooseView.backgroundColor = [UIColor whiteColor];
    chooseView.layer.cornerRadius = 5.f;
    chooseView.clipsToBounds = YES;
    [_maskView addSubview:chooseView];
    
    UIView *line_hor = [[UIView alloc]initWithFrame:CGRectMake(0, 44 , chooseView.width, 0.5)];
    line_hor.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
    [chooseView addSubview:line_hor];
    
    UIButton *cancelButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 44, 44) normalTitle:@"" image:[UIImage imageNamed:@"my_sc_guanbi"] backgroudImage:nil superView:chooseView target:self action:@selector(cancelBtonClick:)];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.imageEdgeInsets = UIEdgeInsetsMake((44-14)/2.0, (44-21)/2.0, (44-14)/2.0, (44-21)/2.0);
    
    UIButton *confirmButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(chooseView.width-44, 0, 44, 44) normalTitle:@"" image:[UIImage imageNamed:@"my_sc_dui"] backgroudImage:nil superView:chooseView target:self action:@selector(confirmBtonClick:)];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.imageEdgeInsets = UIEdgeInsetsMake((44-14)/2.0, (44-21)/2.0, (44-14)/2.0, (44-21)/2.0);
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, line_hor.frame.origin.y+line_hor.frame.size.height, DEVICE_WIDTH, chooseView.height-(line_hor.frame.origin.y+line_hor.frame.size.height)) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 44;
    [chooseView addSubview:myTableView];
                                                                            
    
}
//创建添加分类的视图
-(void)createClassicationView
{
    chooseView.hidden = YES;
    
    bgViewClassication= [[UIView alloc] initWithFrame:CGRectMake(0,(self.view.height -150), DEVICE_WIDTH,150)];
    bgViewClassication.backgroundColor = [UIColor whiteColor];
    bgViewClassication.layer.cornerRadius = 5.f;
    bgViewClassication.clipsToBounds = YES;
    [_maskView addSubview:bgViewClassication];
    
    UIView *line_hor = [[UIView alloc]initWithFrame:CGRectMake(0, 44 , bgViewClassication.width, 0.5)];
    line_hor.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
    [bgViewClassication addSubview:line_hor];
    
    UILabel *titleLabel = [LTools createLabelFrame:CGRectMake((bgViewClassication.width-16*4)/2.0, 15, 64, 13) title:@"添加分类" font:16 align:NSTextAlignmentCenter textColor:[UIColor colorWithHexString:@"000000"]];
    [bgViewClassication addSubview:titleLabel];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, line_hor.frame.origin.y+line_hor.frame.size.height+20,bgViewClassication.width - 20*2, 40)];
    _textField.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    _textField.keyboardType =  UIKeyboardTypeDefault;
    [bgViewClassication addSubview:_textField];
    
    UIButton *cancelButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 44, 44) normalTitle:@"" image:[UIImage imageNamed:@"my_sc_guanbi"] backgroudImage:nil superView:bgViewClassication target:self action:@selector(cancelBtonClickAddClass:)];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.imageEdgeInsets = UIEdgeInsetsMake((44-14)/2.0, (44-21)/2.0, (44-14)/2.0, (44-21)/2.0);
    
    UIButton *confirmButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(bgViewClassication.width-44, 0, 44, 44) normalTitle:@"" image:[UIImage imageNamed:@"my_sc_dui"] backgroudImage:nil superView:bgViewClassication target:self action:@selector(confirmBtonClickAddClass:)];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.imageEdgeInsets = UIEdgeInsetsMake((44-14)/2.0, (44-21)/2.0, (44-14)/2.0, (44-21)/2.0);
    [_textField becomeFirstResponder];

}
#pragma mark--UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *countLabel = [LTools createLabelFrame:CGRectMake(DEVICE_WIDTH-20-100, (44-12)/2.0, 100, 12) title:nil font:12 align:NSTextAlignmentRight textColor:[UIColor colorWithHexString:@"aaaaaa"]];
        [cell addSubview:countLabel];
        countLabel.tag = 101;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    UILabel *countLabel = (UILabel *)[cell viewWithTag:101];
    if(indexPath.row == 0)
    {
        cell.textLabel.text = [_dataSourceArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
    }
    else
    {
        cell.textLabel.text = [[_dataSourceArray objectAtIndex:indexPath.row] objectForKey:@"sort_name"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"404040"];
        countLabel.text = [[_dataSourceArray objectAtIndex:indexPath.row] objectForKey:@"total"];
    }
    return cell;
}
#pragma mark--UITableViewDeleGate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _maskView.hidden = YES;
    chooseDic = [_dataSourceArray objectAtIndex:indexPath.row];
    chooseLabel.text = [[_dataSourceArray objectAtIndex:indexPath.row] objectForKey:@"sort_name"];
    
}
#pragma mark--UIButtonClickMethod
-(void)cancelBtonClick:(UIButton *) sender
{
    _maskView.hidden = YES;
}
-(void)confirmBtonClick:(UIButton *) sender
{
    [self createClassicationView];
}
-(void)rightBtnClick:(UIButton *) sender
{
    [self upLoadImage];
}
//上传
-(void)upLoadImage
{
    NSString *str = [chooseDic objectForKey:@"sort_id"];
    if(str.length == 0)
    {
        [LTools showMBProgressWithText:@"请选择分类" addToView:self.view];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:POST_ADDCLOTHES_URL
                                   parameters:@{
                                                @"authcode":[GMAPI getAuthkey],
                                                @"sort_id": [chooseDic objectForKey:@"sort_id"]
                                                }
                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                   {
//                                       //如果要上传多张图片把下面两句代码放到for循环里即可
                                       for (int i = 0; i < imageArray.count; i++) {
                                           NSData *imageData =UIImageJPEGRepresentation([imageArray objectAtIndex:i], 0.1);
                                           [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"pic%d",i] fileName: [NSString stringWithFormat:@"icon%d.jpg",i] mimeType:@"image/jpg"];
                                       }
                                   }
                                   success:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       NSLog(@"success %@",operation.responseString);
                                       NSError * myerr;
                                       NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:0 error:&myerr];
                                       NSLog(@"mydic == %@ err0 = %@",mydic,myerr);
                                       [LTools showMBProgressWithText:mydic[@"msg"] addToView:self.view];
                                       int erroCode = [mydic[@"errorcode"] intValue]; 
                                       if (erroCode == 0) {
                                           NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                           NSLog(@"....str = %@",str);
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyYiChuList" object:nil];
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }
                                       
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                                   }];
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
    
}
-(void)cancelBtonClickAddClass:(UIButton *) sender
{
    [_textField resignFirstResponder];
    [bgViewClassication removeFromSuperview];
    chooseView.hidden = NO;
}

-(void)confirmBtonClickAddClass:(UIButton *) sender
{
    [_textField resignFirstResponder];
    [bgViewClassication removeFromSuperview];
    if(_textField.text.length == 0)
    {
        return;
    }
    NSString *api = [NSString stringWithFormat:GET_ADDCLASSICATION_URL,_textField.text,[GMAPI getAuthkey]];
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
        {
            [self getNetData];
            chooseView.hidden = NO;
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"%@",failDic);
        
    }];
}
-(void)addImageTap:(UITapGestureRecognizer *) sender
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
        picker.maximumNumberOfSelection = 9 - imageArray.count;
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
        [imageArray addObject:tempImg];
    }
    [self cretaeViewsWithImageArray:imageArray];
    
}
#pragma mark--UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageNew = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [imageArray addObject:imageNew];
    }];
    
    
}
#pragma mark 键盘


- (void)keyboardWillShow:(NSNotification*)notification{
    
    NSLog(@"keyboardWillShow");
    
    //    __weak typeof(self)weakSelf = self;
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    float keyboard_y = keyboardRect.origin.y;//记录键盘y
    
    bgViewClassication.frame = CGRectMake(0,keyboard_y-150, DEVICE_WIDTH,150);

}

- (void)keyboardWillHide:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
}
#pragma mark--UIgestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
#pragma mark--NetWorkMetod
-(void)getNetData
{
    NSString *api = [NSString stringWithFormat:GET_MYYICHU_LIST_URL,[GMAPI getAuthkey]];
    
    NSLog(@"api===%@",api);
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
        {
            _dataSourceArray = [NSMutableArray arrayWithArray:[result objectForKey:@"list"]];
            [_dataSourceArray replaceObjectAtIndex:0 withObject:@"所有分类"];
            [myTableView reloadData];
            NSLog(@"%@",result);
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"%@",[failDic objectForKey:@"msg"]);
        
    }];
}
-(void)hiddenMaskView:(UITapGestureRecognizer *) tap
{
    _maskView.hidden = YES;
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
