//
//  PublishActivityController.m
//  YiYiProject
//
//  Created by lichaowei on 15/6/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "PublishActivityController.h"
#import "LRichTextView.h"
#import "AFNetworking.h"
#import "TopicImageModel.h"

#import "JSONKit.h"

#import "ActivityImageModel.h"

@interface PublishActivityController ()
{
    LRichTextView *editor;
    
    NSMutableArray *temp_arr;//存放发布内容
    
    int imageCount;//图片总数
    
    NSString *_actitityTitle;//标题
    UIImage *_activityCoverImage;//活动封面
    NSString *_activityStartTime;//开始时间
    NSString *_activityEndTime;//结束时间
    NSString *_shopId;//店铺id
}

@end

@implementation PublishActivityController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)leftButtonTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:self.lastPageNavigationHidden animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTitleLabel.text = @"发布话题";
    self.myTitleLabel.textColor = [UIColor whiteColor];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    [self createNavigationbarTools];
    
    
//    [self setActivityTitle:@"六一活动节！！！" coverImage:nil startTime:@"2015-6-1" endTime:@"2015-6-10" shopId:@"2638"];
    
    if (![self isInfoValidate]) {
        
        [LTools showMBProgressWithText:@"请填写有效的活动信息" addToView:self.view];
        
        [self performSelector:@selector(clickToBack:) withObject:nil afterDelay:1.f];
        
        return;
    }
    
    editor = [[LRichTextView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - 64) rootViewController:self];
    [self.view addSubview:editor];
    
}

/**
 *  判断上一页信息是否有效
 *
 *  @return
 */
- (BOOL)isInfoValidate
{
    if (!_actitityTitle.length>0) {
        
//        [LTools showMBProgressWithText:@"未填写有效活动标题" addToView:self.view];
        return NO;
    }
    
    if (!_activityStartTime.length > 0 || !_activityEndTime.length > 0) {
        
//        [LTools showMBProgressWithText:@"请填写有效的活动开始结束时间" addToView:self.view];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - 创建视图

- (void)createNavigationbarTools
{
    
    UIButton *rightView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    rightView.backgroundColor=[UIColor clearColor];
    
    UIButton *insertButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [insertButton addTarget:self action:@selector(clickToOpenAlbum:) forControlEvents:UIControlEventTouchUpInside];
    //    [heartButton setTitle:@"喜欢" forState:UIControlStateNormal];
    [insertButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [insertButton setImage:[UIImage imageNamed:@"fabu_pic"] forState:UIControlStateNormal];
    [insertButton setTitle:@"图片" forState:UIControlStateNormal];
    
    [insertButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    
    UIButton *fabuButton =[[UIButton alloc]initWithFrame:CGRectMake(rightView.width - 44,0, 44,42.5)];
    [fabuButton addTarget:self action:@selector(clickToPub:) forControlEvents:UIControlEventTouchUpInside];
    //    [fabuButton setImage:[UIImage imageNamed:@"shoucangb"] forState:UIControlStateNormal];
    [fabuButton setTitle:@"发布" forState:UIControlStateNormal];
    [fabuButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [fabuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fabuButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(44 + 8, 7 + 5, 0.5, 20)];
    line.backgroundColor = [UIColor whiteColor];
    [rightView addSubview:line];
    
    
    
    [rightView addSubview:insertButton];
    [rightView addSubview:fabuButton];
    
    UIBarButtonItem *comment_item=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    
    self.navigationItem.rightBarButtonItem = comment_item;
}


#pragma mark - 事件处理

/**
 *  发布活动上一级页面传参数
 *
 *  @param title     活动标题
 *  @param aImage    活动封面
 *  @param startTime 开始时间
 *  @param endTime   结束时间
 */
- (void)setActivityTitle:(NSString *)title
              coverImage:(UIImage *)aImage
               startTime:(NSString *)startTime
                 endTime:(NSString *)endTime
                  shopId:(NSString *)shopId
{
    _actitityTitle = title;
    _activityCoverImage = aImage;
    _activityStartTime = startTime;
    _activityEndTime = endTime;
    _shopId = shopId;
}

/**
 *  处理活动content
 *
 *  @param imageModels 上传成功后图片model
 */
- (void)replaceContentWithSuccessImages:(NSArray *)imageModels
{
    //    NSMutableString *temp_content = [NSMutableString stringWithString:[temp_arr JSONString]];
    
    
    int imageIndex = 0;
    
    int sum = (int)temp_arr.count;
    
    for (int i = 0; i < sum; i ++) {
        
        NSDictionary *aDic = temp_arr[i];
        NSString *content = aDic[CELL_CONTENT];
        if ([content rangeOfString:@"image"].length > 0)
        {
            //需要替换
            
            ActivityImageModel *aImageModel = (ActivityImageModel*)[imageModels objectAtIndex:imageIndex];
            
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:aDic];
            
            NSString *content = [NSString stringWithFormat:@"<img src=\"%@\" width=\"%@\" height=\"%@\">",aImageModel.image_resize_url,aImageModel.image_resize_width,aImageModel.image_resize_height];
            [temp setObject:content forKey:CELL_CONTENT];

            [temp_arr replaceObjectAtIndex:i withObject:temp];
            
            imageIndex ++;
            
        }
        
    }
    
    NSLog(@"commit content %@",temp_arr);
    
    //正式发布活动
    
    [self publishActivityContent:[self postContent:temp_arr]];
    
}

/**
 *  区分是文字还是图片
 *
 *  @param content
 *
 *  @return
 */
- (int)typeForContent:(NSString *)content
{
    if ([content rangeOfString:@"<img"].length > 0) {
        
        return 1;//图片
    }else
    {
        return 2;//文字
    }
}

/**
 *  拼接成要发布的内容字符串
 *
 *  @param tempArr 内容数组
 *
 *  @return
 */
- (NSString *)postContent:(NSArray *)tempArr
{
//    //去除空行
//    NSMutableArray *arr = [NSMutableArray array];
//    for (NSDictionary *aDic in tempArr) {
//        
//        NSString *aContent = aDic[CELL_CONTENT];
//        NSLog(@"aContent %@",aContent);
//        if (aContent && aContent.length > 0 && ![aContent isEqualToString:@"(null)"]) {
//            [arr addObject:aDic];
//        }
//    }
    
    
    NSMutableString *contentString = [NSMutableString stringWithFormat:@""];
    
    for (int i = 0; i < tempArr.count - 1; i ++) {
        
        NSDictionary *aDic = tempArr[i];
        NSDictionary *bDic = tempArr[i + 1];
        NSString *aContent = aDic[CELL_CONTENT];
        NSString *bContent = bDic[CELL_CONTENT];
        
        if (i == 0) {
            
            [contentString appendString:aContent];
        }
        //前后都是文字用换行符分割
        if ([self typeForContent:aContent] == 1 && [self typeForContent:bContent] == 1) {
            
            [contentString appendFormat:@"\n%@",bContent];
        }else
        {
            if (bContent.length > 0 && ![bContent isEqualToString:@"(null)"]) {
                
                [contentString appendFormat:@"%@",bContent];

            }
            
        }
    }
    
    return contentString;
}

- (void)clickToPub:(UIButton *)sender
{
    NSLog(@"发布 %@",[editor content]);
    
    [editor hiddenKeyboard];
    
    NSArray *content_arr = [editor content];
    
    BOOL contentIsNull = YES;
    
    for (NSDictionary *aDic in content_arr) {
        
        id dd = [aDic objectForKey:CELL_CONTENT];
        if ([dd isKindOfClass:[UIImage class]]) {
            contentIsNull = NO;
        }else if (((NSString *)dd).length > 0){
            
            contentIsNull = NO;
        }
    }
    
    if (content_arr.count == 0 || contentIsNull) {
        
        [LTools showMBProgressWithText:@"活动内容不能为空" addToView:self.view];
        return;
    }
    
    NSArray *contentArr = [NSArray arrayWithArray:[editor content]];
    
    temp_arr = [NSMutableArray array];//存储新的内容
    
    NSMutableArray *image_arr = [NSMutableArray array];
    
    int imageIndex = 0;
    
    int i = 0;
    
    for (NSDictionary *aDic in contentArr) {
        
        NSString *content = aDic[CELL_CONTENT];
        if ([content isKindOfClass:[UIImage class]]) {
            
            //先把image 替换成image7 格式
            [image_arr addObject:content];
            
            NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithDictionary:aDic];
            
            NSString *imageName = [NSString stringWithFormat:@"image_%d",imageIndex];
            
            [imageDic setObject:imageName forKey:CELL_CONTENT];
            
            
            [temp_arr addObject:imageDic];
            
            imageIndex ++;
            
        }else
        {
            [temp_arr addObject:aDic];
        }
        
        i ++;
    }
    
    //上传 image_arr里面的image
    
    NSLog(@"allcontent ---> %@",temp_arr);
    
    //将上传之后imageurl
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    if (image_arr.count > 0) {
        
        [self upLoadImage:image_arr];
    }else
    {
        //直接发布活动
        [self publishActivityContent:[self postContent:temp_arr]];
    }
}

- (IBAction)clickToOpenAlbum:(id)sender {
    
    [editor clickToAddAlbum:sender];
}

//返回
- (void)clickToBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

/**
 *  发布成功返回店铺页面
 */
- (void)backToShopViewController
{
    [self.navigationController popToViewController:self.shopViewController animated:NO];
}


#pragma mark 网络请求


/**
 *  发布活动
 */
-(void)publishActivityContent:(NSString *)activityContent{
    
    
    //上传的url
    NSString *uploadImageUrlStr = GFABUHUODONG;
    
    
    NSString *type = nil;
    type = @"2";
    
    
    NSString *shop_id = _shopId;//店铺id
    NSString *activity_info = activityContent;//活动内容
    NSString *start_time = _activityStartTime;//活动开始时间
    NSString *end_time = _activityEndTime;//活动结束时间
    NSString *activity_title = _actitityTitle;//活动标题
    
    
    NSDictionary *parameters_dic = @{
                           @"type":type,
                           @"shop_id":shop_id,
                           @"activity_title":activity_title,
                           @"activity_info":activity_info,
                           @"start_time":start_time,
                           @"end_time":end_time,
                           @"authcode":[GMAPI getAuthkey],
                           };
    
    
    __weak typeof(self)weakSelf = self;
    
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
                                           
                                           NSData * data= UIImageJPEGRepresentation(_activityCoverImage, 1.0);
                                           if (data) {
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
                                           
                                           [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

                                           NSLog(@"%@",responseObject);
                                           
                                           NSError * myerr;
                                           
                                           NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:&myerr];
                                           NSLog(@"%@",mydic);
                                           
                                           int errorCode = [mydic[@"errorcode"] intValue];
                                           NSString *erroInfo = mydic[@"msg"];
                                           if (errorCode > 2000) {
                                               
                                               [LTools showMBProgressWithText:erroInfo addToView:weakSelf.view];
                                           }
                                           
                                           //发布成功返回店铺页面
                                           if (errorCode == 0) {
                                               
                                               [weakSelf performSelector:@selector(backToShopViewController) withObject:nil afterDelay:1.f];
                                           }
                                           
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                            NSLog(@"%@",error);
                                           [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

                                           NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)operation.responseObject options:NSJSONReadingAllowFragments error:nil];
                                           NSLog(@"%@",mydic);
                                           
                                           int errorCode = [mydic[@"errorcode"] intValue];
                                           NSString *erroInfo = mydic[@"msg"];
                                           if (errorCode > 2000) {
                                               
                                               [LTools showMBProgressWithText:erroInfo addToView:weakSelf.view];
                                           }
                                           
                                           
                                       }];
        
        //设置上传操作的进度
        [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
    }
    
    
    
}


#pragma mark - 上传图片

//上传
-(void)upLoadImage:(NSArray *)aImage_arr{
    
    //上传的url
    NSString *uploadImageUrlStr = UPLOAD_IMAGE_URL;
    
    __weak typeof(self)weakSelf = self;
    
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:uploadImageUrlStr
                                   parameters:@{
                                                @"action":@"activity"
                                                }
                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                   {
                                       
                                       for (int i = 0; i < aImage_arr.count; i ++) {
                                           
                                           UIImage *aImage = aImage_arr[i];
                                           
                                           NSData * data= UIImageJPEGRepresentation(aImage, 1);
                                           
                                           NSLog(@"---> 大小 %ld",(unsigned long)data.length);
                                           
                                           NSString *imageName = [NSString stringWithFormat:@"icon%d.jpg",i];
                                           
                                           NSString *picName = [NSString stringWithFormat:@"pic%d",i];
                                           
                                           [formData appendPartWithFileData:data name:picName fileName:imageName mimeType:@"image/jpg"];
                                           
                                       }
                                       
                                       
                                   }
                                   success:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                       
                                       NSLog(@"success %@",responseObject);
                                       
                                       NSError * myerr;
                                       
                                       NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:0 error:&myerr];
                                       
                                       NSLog(@"mydic == %@ err0 = %@",mydic,myerr);
                                       
                                       if ([mydic isKindOfClass:[NSDictionary class]]) {
                                           
                                           NSArray *pics = mydic[@"pics"];
                                           
                                           NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:pics.count];
                                           for (NSDictionary *aDic in pics) {
                                               
                                               ActivityImageModel *aModel = [[ActivityImageModel alloc]initWithDictionary:aDic];
                                               [tempArr addObject:aModel];
                                           }
                                           
                                           //上传完图片处理活动内容
                                           [weakSelf replaceContentWithSuccessImages:tempArr];
                                       }
                                       
                                       
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       
//                                       [LTools showMBProgressWithText:@"" addToView:self.view];
                                       NSLog(@"失败 : %@",error);
                                       [LTools showMBProgressWithText:@"上传图片失败" addToView:self.view];
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                                   }];
    
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
    
}


@end
