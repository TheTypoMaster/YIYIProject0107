//
//  PublishHuatiController.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "PublishHuatiController.h"
#import "LEditor.h"
#import "AFNetworking.h"
#import "TopicImageModel.h"

#import "JSONKit.h"

@interface PublishHuatiController ()
{
    LEditor *editor;
    
    NSMutableArray *temp_arr;//存放发布内容
    
    int imageCount;//图片总数
}

@end

@implementation PublishHuatiController


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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [editor setFirstResponder];
//    [editor performSelector:@selector(setFirstResponder) withObject:nil afterDelay:0.1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTitleLabel.text = @"发布话题";
    self.myTitleLabel.textColor = [UIColor whiteColor];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    [self createNavigationbarTools];
    
    editor = [[LEditor alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - 50 - 20) rootViewController:self];
    [self.view addSubview:editor];
}

#pragma mark - 事件处理

- (void)dealPostContentWithSuccessImages:(NSArray *)imageModels
{
//    NSMutableString *temp_content = [NSMutableString stringWithString:[temp_arr JSONString]];
    
    
    int imageIndex = 0;
    
    int sum = (int)temp_arr.count;
    
    for (int i = 0; i < sum; i ++) {
        
        NSDictionary *aDic = temp_arr[i];
        NSString *content = aDic[CELL_TEXT];
        if ([content rangeOfString:@"image"].length > 0)
        {
            //需要替换
            
            TopicImageModel *aImageModel = (TopicImageModel*)[imageModels objectAtIndex:imageIndex];
            
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:aDic];
            [temp setObject:aImageModel.image_resize_url forKey:CELL_TEXT];
            [temp setObject:[NSNumber numberWithFloat:aImageModel.image_resize_height] forKey:CELL_NEW_HEIGHT];
            [temp setObject:[NSNumber numberWithFloat:aImageModel.image_resize_width] forKey:CELL_NEW_WIDTH];
            [temp setObject:aImageModel.image_url forKey:IMAGE_ORIGINAL_URL];
            [temp setObject:[NSNumber numberWithFloat:aImageModel.image_height] forKey:IMAGE_HEIGHT_ORIGINAL];
            [temp setObject:[NSNumber numberWithFloat:aImageModel.image_width] forKey:IMAGE_WIDTH_ORIGINAL];
            
            [temp_arr replaceObjectAtIndex:i withObject:temp];
            
            imageIndex ++;
            
        }

    }
    
    NSLog(@"commit content %@",temp_arr);
    
    [self addTopicContent:[temp_arr JSONString] title:[editor editorTitle]];
}

/**
 *  解析上传成功图片数据
 *
 *  @param mydic 成功之后返回字典
 */
- (void)dealWithUploadImageSuccessDic:(NSDictionary *)mydic
{
    if ([mydic isKindOfClass:[NSDictionary class]]) {
        
        NSArray *pics = mydic[@"pics"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:pics.count];
        
        for (NSDictionary *aDic in pics) {
            
            TopicImageModel *aImageModel = [[TopicImageModel alloc]initWithDictionary:aDic];
            [arr addObject:aImageModel];
        }
        
        
        [self dealPostContentWithSuccessImages:arr];
        
    }else
    {
        [LTools showMBProgressWithText:@"上传图片错误" addToView:self.view];
    }
}

- (void)clickToPub:(UIButton *)sender
{
    NSLog(@"发布 %@",[editor content]);
    
    [editor hiddenKeyboard];
    
    if ([editor editorTitle].length == 0) {
        [LTools showMBProgressWithText:@"话题标题不能为空" addToView:self.view];
        return;
    }
    
    NSArray *content_arr = [editor content];
    
    BOOL contentIsNull = YES;
    
    for (NSDictionary *aDic in content_arr) {
        
        id dd = [aDic objectForKey:CELL_TEXT];
        if ([dd isKindOfClass:[UIImage class]]) {
            contentIsNull = NO;
        }else if (((NSString *)dd).length > 0){
            
            contentIsNull = NO;
        }
    }
    
    if (content_arr.count == 0 || contentIsNull) {
        
        [LTools showMBProgressWithText:@"话题内容不能为空" addToView:self.view];
        return;
    }
    
    NSArray *contentArr = [NSArray arrayWithArray:[editor content]];
    
    temp_arr = [NSMutableArray array];//存储新的内容
    
    NSMutableArray *image_arr = [NSMutableArray array];
    
    int imageIndex = 0;
    
    int i = 0;
    
    for (NSDictionary *aDic in contentArr) {
        
        NSString *content = aDic[CELL_TEXT];
        if ([content isKindOfClass:[UIImage class]]) {
            
            //先把image 替换成image7 格式
            [image_arr addObject:content];
            
            NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithDictionary:aDic];
            
            NSString *imageName = [NSString stringWithFormat:@"image_%d",imageIndex];
            
            [imageDic setObject:imageName forKey:CELL_TEXT];
            
            
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
    
    if (image_arr.count > 0) {
        
        [self upLoadImage:image_arr];
    }else
    {
        NSString *jsonString = [temp_arr JSONString];
        
        [self addTopicContent:jsonString title:[editor editorTitle]];
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

#pragma mark 网络请求
/**
 *  添加话题
 */
- (void)addTopicContent:(NSString *)content
                  title:(NSString *)title
{
    NSString *authkey = [GMAPI getAuthkey];
    NSString *post = [NSString stringWithFormat:@"topic_title=%@&topic_content=%@&authcode=%@",title,content,authkey];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSLog(@"---->话题 %@",post);
    
    NSString *url = [NSString stringWithFormat:TOPIC_ADD];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        
        [self performSelector:@selector(leftButtonTap:) withObject:nil afterDelay:0.2];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
}

#pragma mark - 上传图片

//上传
-(void)upLoadImage:(NSArray *)aImage_arr{
    
    //上传的url
    NSString *uploadImageUrlStr = UPLOAD_IMAGE_URL;
    
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:uploadImageUrlStr
                                   parameters:@{
                                                @"action":@"topic_pic"
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
                                       
                                       [self dealWithUploadImageSuccessDic:mydic];
                                       
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       
                                       
                                       NSLog(@"失败 : %@",error);
                                       
                                       
                                   }];
    
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
    
}



@end
