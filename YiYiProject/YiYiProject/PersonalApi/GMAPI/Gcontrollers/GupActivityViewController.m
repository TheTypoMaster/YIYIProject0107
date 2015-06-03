//
//  GupActivityViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/6/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GupActivityViewController.h"
#import "PublishActivityController.h"
#import "MLImageCrop.h"
@interface GupActivityViewController ()<UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MLImageCropDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;//主tbaleview
    NSArray *_titleArray;//每个cell的title
    
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

@implementation GupActivityViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:self.lastPageNavigationHidden animated:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatCustomView];
    [self creatDatePickerChooseView];

    
    
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80+38;
    }
    return 80;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    if (indexPath.row == 4) {//下一步
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn setFrame:CGRectMake(38, 0, DEVICE_WIDTH-76, 35)];
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        nextBtn.backgroundColor = RGBCOLOR(244, 76, 139);
        [nextBtn addTarget:self action:@selector(gotoTheNextVc) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:nextBtn];
        return cell;
    }
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, DEVICE_WIDTH-40, 16)];
    if (indexPath.row == 0) {
        [titleLabel setFrame:CGRectMake(20, 38, DEVICE_WIDTH-40, 16)];
    }
    titleLabel.text = _titleArray[indexPath.row];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:titleLabel];
    
    
    
    if (indexPath.row == 0) {
        //输入框
        UIView *backInView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame)+14, DEVICE_WIDTH-40, 32)];
        backInView.layer.borderColor = [RGBCOLOR(183, 184, 186)CGColor];
        backInView.layer.borderWidth = 0.5;
        backInView.layer.cornerRadius = 5.0f;
        [cell.contentView addSubview:backInView];
        
        UITextField *contentTf = [[UITextField alloc]initWithFrame:backInView.bounds];
        contentTf.tag = 200;
        contentTf.font = [UIFont systemFontOfSize:16];
        [backInView addSubview:contentTf];
    }else if (indexPath.row == 1) {//封面图
        UIButton *jiahao = [UIButton buttonWithType:UIButtonTypeCustom];
        [jiahao setTitle:@"上传" forState:UIControlStateNormal];
        [jiahao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        jiahao.titleLabel.font = [UIFont systemFontOfSize:15];
        [jiahao setFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame)+14, 90, 32)];
        jiahao.layer.borderWidth = 0.5f;
        jiahao.layer.cornerRadius = 5;
        jiahao.layer.borderColor = [RGBCOLOR(183, 184, 186)CGColor];
        [jiahao addTarget:self action:@selector(choosePic) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:jiahao];
        
        _showPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPicBtn setFrame:CGRectMake(CGRectGetMaxX(jiahao.frame)+20, 0, 160, 100)];
        [_showPicBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_showPicBtn];
        
        
    }else if (indexPath.row == 2){
        _startTime = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame)+14, DEVICE_WIDTH-40, 32)];
        _startTime.layer.borderColor = [RGBCOLOR(183, 184, 186)CGColor];
        _startTime.layer.borderWidth = 0.5;
        _startTime.layer.cornerRadius = 5.0f;
        [cell.contentView addSubview:_startTime];
        
        _startTime.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseStartTime:)];
        [_startTime addGestureRecognizer:tap];
        
    }else if (indexPath.row == 3){
        //结束时间
        _endTime = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame)+14, DEVICE_WIDTH-40, 32)];;
        _endTime.layer.borderColor = [RGBCOLOR(183, 184, 186)CGColor];
        _endTime.layer.borderWidth = 0.5;
        _endTime.layer.cornerRadius = 5.0f;
        _endTime.userInteractionEnabled = YES;
        [cell.contentView addSubview:_endTime];
        UITapGestureRecognizer *tapc = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseEndTime:)];
        [_endTime addGestureRecognizer:tapc];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITextField *tf = (UITextField*)[self.view viewWithTag:200];
    [tf resignFirstResponder];
    [self datePickerHideen];
}




#pragma mark - myMethod

//创建视图
-(void)creatCustomView{
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.myTitle=@"发布活动";
    if (self.thetype == GUPACTIVITYTYPE_EDIT) {
        self.myTitle = @"修改活动";
    }
    
    _titleArray = @[@"活动标题"
                    ,@"活动封面"
                    ,@"开始时间"
                    ,@"结束时间"
                    ,@"下一步"
                    ];
    
    NSLog(@"self.mallInfo.brand_id: %@",self.mallInfo.brand_id);
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


//跳转下一步
-(void)gotoTheNextVc{
    UITextField *tf = (UITextField*)[self.view viewWithTag:200];
    PublishActivityController *ccc = [[PublishActivityController alloc]init];
    [ccc setActivityTitle:tf.text coverImage:_showImage startTime:_startTime.text endTime:_endTime.text shopId:self.mallInfo.id];
    ccc.lastPageNavigationHidden = NO;
    [self.navigationController pushViewController:ccc animated:YES];
}

//添加图片
-(void)choosePic{
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


//创建时间选择器view
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

//隐藏datepick
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

//选择开始时间
-(void)chooseStartTime:(UITapGestureRecognizer*)sender{
    
    UITextField *tf = (UITextField*)[self.view viewWithTag:200];
    [tf resignFirstResponder];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _dateChooseView.frame = CGRectMake(0, DEVICE_HEIGHT-_dateChooseView.frame.size.height, DEVICE_WIDTH, _dateChooseView.frame.size.height);
        _dateChooseView.tag = 1000;
    } completion:^(BOOL finished) {
        
    }];
}

//选择结束时间
-(void)chooseEndTime:(UITapGestureRecognizer*)sender{
    
    UITextField *tf = (UITextField*)[self.view viewWithTag:200];
    [tf resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        _dateChooseView.frame = CGRectMake(0, DEVICE_HEIGHT-_dateChooseView.frame.size.height, DEVICE_WIDTH, _dateChooseView.frame.size.height);
        _dateChooseView.tag = 1001;
    } completion:^(BOOL finished) {
        
    }];
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
        
        
        
    }
}







#pragma mark - MLImageCropDelegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    
    
    _showImage = cropImage;
    _showImageData = UIImageJPEGRepresentation(_showImage, 1);
    
    
    
    
    [_showPicBtn setBackgroundImage:cropImage forState:UIControlStateNormal];
    
}


@end
