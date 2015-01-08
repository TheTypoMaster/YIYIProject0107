//
//  MineViewController.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/10.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "GTableViewCell.h"
#import "MLImageCrop.h"
#import "GcustomActionSheet.h"
#import "AFNetworking.h"
#import "GeditUserInfoViewController.h"
#import "GMapViewController.h"//测试地图vc

#import "GmyMainViewController.h"//我的主页

#import "GSettingViewController.h"

#import "MyYiChuViewController.h"//我的衣橱

#import "MyConcernController.h"//我的关注

#import "ShenQingDianPuViewController.h"

typedef enum{
    USERFACE = 0,//头像
    USERBANNER,//banner
    USERIMAGENULL,
}CHANGEIMAGETYPE;

#define CROPIMAGERATIO_USERBANNER 0.618//banner 图片裁剪框宽高比
#define CROPIMAGERATIO_USERFACE 1.0//头像 图片裁剪框宽高比例

#define UPIMAGECGSIZE_USERBANNER CGSizeMake(1080,1080*0.618)//需要上传的banner的分辨率
#define UPIMAGECGSIZE_USERFACE CGSizeMake(200,200)//需要上传的头像的分辨率

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,GcustomActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MLImageCropDelegate>
{
    UITableView *_tableView;//主tableview
    CHANGEIMAGETYPE _changeImageType;
    NSArray *_tabelViewCellTitleArray;//title文字数组
    NSArray *_logoImageArray;//title前面的logo图数组
    NSDictionary *_customInfo_tabelViewCell;//cell数据源
}
@end

@implementation MineViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myTitleLabel.text = @"我的";
    
    
    
    //判断是否登录
    if ([LTools cacheBoolForKey:USER_LONGIN] == NO) {
        
        LoginViewController *login = [[LoginViewController alloc]init];
        
        UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
        
        [self presentViewController:unVc animated:YES completion:nil];
        
    }
    
    
    //初始化相关
    _changeImageType = USERIMAGENULL;
    
    _tabelViewCellTitleArray = @[@[@"我的主页"]
                                 ,@[@"我的收藏",@"我的搭配"]
                                 ,@[@"我的衣橱",@"我的体型",@"穿衣日记"]
                                 ,@[@"我的关注"]
                                 ,@[@"我是店主，申请衣+衣店铺"]
                                 ,@[@"邀请好友"]];
    _logoImageArray = @[@[[UIImage imageNamed:@"my_zhuye.png"]]
                        ,@[[UIImage imageNamed:@"my_shoucang.png"],[UIImage imageNamed:@"my_dapei.png"]]
                        ,@[[UIImage imageNamed:@"my_yichu.png"],[UIImage imageNamed:@"my_tixing.png"],[UIImage imageNamed:@"my_rizhi.png"]]
                        ,@[[UIImage imageNamed:@"my_guanzhu.png"]]
                        ,@[[UIImage imageNamed:@"my_shenqing.png"]]
                        ,@[[UIImage imageNamed:@"my_haoyou.png"]]
                        ];
    _customInfo_tabelViewCell = @{@"titleLogo":_logoImageArray,
                                  @"titleArray":_tabelViewCellTitleArray
                                  };
    
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self creatTableViewHeaderView];
    [self.view addSubview:_tableView];
    
    NSLog(@"%@",NSStringFromCGRect(_tableView.frame));
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///创建用户头像banner的view
-(UIView *)creatTableViewHeaderView{
    //底层view
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 150.00)];
    backView.backgroundColor = [UIColor whiteColor];
    
    //banner
    self.userBannerImv = [[UIImageView alloc]initWithFrame:backView.frame];
    self.userBannerImv.backgroundColor = RGBCOLOR_ONE;
    //模糊效果
    //    self.userBannerImv.layer.masksToBounds = NO;
    //    self.userBannerImv.layer.shadowColor = [UIColor blackColor].CGColor;
    //    self.userBannerImv.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    //    self.userBannerImv.layer.shadowOpacity = 0.5f;//阴影透明度，默认0
    //    self.userBannerImv.layer.shadowRadius = 4;//阴影半径，默认3
    
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((DEVICE_WIDTH-33.00)*0.5, 33, 33, 17)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"我的";
    titleLabel.textColor = [UIColor whiteColor];
    [self.userBannerImv addSubview:titleLabel];
    
    //小齿轮设置按钮
    UIButton *chilunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chilunBtn setFrame:CGRectMake(DEVICE_WIDTH - 40, 30, 25, 25)];
    [chilunBtn setBackgroundImage:[UIImage imageNamed:@"my_shezhi.png"] forState:UIControlStateNormal];
    [chilunBtn addTarget:self action:@selector(xiaochilun) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    //头像
    self.userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake(30*GscreenRatio_320, 75*GscreenRatio_320, 50, 50)];
    self.userFaceImv.backgroundColor = RGBCOLOR_ONE;
    self.userFaceImv.layer.cornerRadius = 25*GscreenRatio_320;
    self.userFaceImv.layer.masksToBounds = YES;
    
    //昵称
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userFaceImv.frame)+10, self.userFaceImv.frame.origin.y+6, 120*GscreenRatio_320, 14)];
    self.userNameLabel.text = @"昵称";
    self.userNameLabel.font = [UIFont systemFontOfSize:14];
    self.userNameLabel.textColor = [UIColor whiteColor];
    //    self.userNameLabel.backgroundColor = [UIColor lightGrayColor];
    
    //积分
    self.userScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLabel.frame.origin.x, CGRectGetMaxY(self.userNameLabel.frame)+10, self.userNameLabel.frame.size.width, self.userNameLabel.frame.size.height)];
    self.userScoreLabel.font = [UIFont systemFontOfSize:14];
    self.userScoreLabel.text = @"积分：2000";
    self.userScoreLabel.textColor = [UIColor whiteColor];
    //    self.userScoreLabel.backgroundColor = [UIColor orangeColor];
    
    //编辑按钮
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(CGRectGetMaxX(self.userNameLabel.frame)+35, self.userFaceImv.frame.origin.y+20, 55, 44)];
    //    editBtn.backgroundColor = [UIColor purpleColor];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [editBtn addTarget:self action:@selector(goToEdit) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    
    
    
    //手势
    UITapGestureRecognizer *ddd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userBannerClicked)];
    self.userBannerImv.userInteractionEnabled = YES;
    [self.userBannerImv addGestureRecognizer:ddd];
    UITapGestureRecognizer *eee = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userFaceClicked)];
    self.userFaceImv.userInteractionEnabled = YES;
    [self.userFaceImv addGestureRecognizer:eee];
    
    
    //添加视图
    [backView addSubview:self.userBannerImv];
    [backView addSubview:self.userFaceImv];
    [backView addSubview:self.userNameLabel];
    [backView addSubview:self.userScoreLabel];
    [backView addSubview:editBtn];
    [backView addSubview:chilunBtn];
    
    return backView;
}



//跳转个人设置界面
-(void)xiaochilun{
    GSettingViewController *gg = [[GSettingViewController alloc]init];
    gg.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:gg animated:YES];
}



#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tabelViewCellTitleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[_tabelViewCellTitleArray objectAtIndex:section] count];
    
    
    //return num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 10)];
    view.backgroundColor = RGBCOLOR(242, 242, 242);
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSLog(@"indexpath.section:%ld row:%ld",(long)indexPath.section,(long)indexPath.row);
    NSLog(@"%@",_tabelViewCellTitleArray[indexPath.section][indexPath.row]);
    
    [cell creatCustomViewWithGcellType:GPERSON indexPath:indexPath customObject:_customInfo_tabelViewCell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            GmyMainViewController *dd = [[GmyMainViewController alloc]init];
            dd.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dd animated:YES];
            
        }
            break;
            
        case 1:
        {
            
        }
            break;
            
        case 2:
        {
            
            if (indexPath.row==0) {
                
                MyYiChuViewController *_myyichuVC=[[MyYiChuViewController alloc]init];
                
                _myyichuVC.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:_myyichuVC animated:YES];
                
                NSLog(@"我的衣橱");
                
                
            }else if(indexPath.row==1){
                
                NSLog(@"我的体型");
                
                
            }else if(indexPath.row==2){
                
                NSLog(@"穿衣日记");
                
                
            }
            
            
        }
            break;
            
        case 3:
        {
            MyConcernController *concern = [[MyConcernController alloc]init];
            concern.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:concern animated:YES];
        }
            break;
            
        case 4:
        {
            
            
            if (indexPath.row==0) {
                
                ShenQingDianPuViewController *_shenqingVC = [[ShenQingDianPuViewController alloc]init];
                _shenqingVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:_shenqingVC animated:YES];
                
            }
            
            
        }
            break;
            
        case 5:
        {
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    
    //    if (indexPath.row == 0) {
    //        GmyMainViewController *dd = [[GmyMainViewController alloc]init];
    //        dd.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:dd animated:YES];
    //    }
    
    
    
    NSLog(@"xxxx==%ld=row=%ld=",indexPath.section,indexPath.row);
    
    NSLog(@"在这里进行跳转");
}



-(void)goToEdit{
    GMapViewController *ggg = [[GMapViewController alloc]init];
    ggg.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ggg animated:YES];
}


//修改banner&&头像
-(void)userBannerClicked{
    NSLog(@"点击用户banner");
    _changeImageType = USERBANNER;
    GcustomActionSheet *aaa = [[GcustomActionSheet alloc]initWithTitle:nil
                                                          buttonTitles:@[@"更换相册封面"]
                                                     buttonTitlesColor:[UIColor blackColor]
                                                           buttonColor:[UIColor whiteColor]
                                                           CancelTitle:@"取消"
                                                      cancelTitelColor:[UIColor whiteColor]
                                                           CancelColor:RGBCOLOR(253, 144, 39)
                                                       actionBackColor:RGBCOLOR(236, 236, 236)];
    aaa.tag = 90;
    aaa.delegate = self;
    [aaa showInView:self.view WithAnimation:YES];
    
    
}
-(void)userFaceClicked{
    NSLog(@"点击头像");
    _changeImageType = USERFACE;
    GcustomActionSheet *aaa = [[GcustomActionSheet alloc]initWithTitle:nil
                                                          buttonTitles:@[@"更换头像"]
                                                     buttonTitlesColor:[UIColor blackColor]
                                                           buttonColor:[UIColor whiteColor]
                                                           CancelTitle:@"取消"
                                                      cancelTitelColor:[UIColor whiteColor]
                                                           CancelColor:RGBCOLOR(253, 144, 39)
                                                       actionBackColor:RGBCOLOR(236, 236, 236)];
    aaa.tag = 91;
    aaa.delegate = self;
    [aaa showInView:self.view WithAnimation:YES];
}




#pragma mark - GcustomActionSheetDelegate

///隐藏或显示tabbar
-(void)gHideTabBar:(BOOL)hidden{
    
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.5];
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        if (hidden) {
            NSLog(@"加等 %f",self.tabBarController.tabBar.top);
            
            self.tabBarController.tabBar.top = DEVICE_HEIGHT;
        }else{
            NSLog(@"减等 %f",self.tabBarController.tabBar.top);
            self.tabBarController.tabBar.top = DEVICE_HEIGHT-49;
        }
    } completion:^(BOOL finished) {
        
    }];
    
    
    //    [UIView commitAnimations];
    
    
    //    self.tabBarController.tabBar.hidden = hidden;//无动画
}

-(void)gActionSheet:(GcustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"buttonIndex:%ld",(long)buttonIndex);
    
    //图片选择器
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    if (actionSheet.tag == 90) {//banner
        if (buttonIndex == 1) {//修改
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }else if (actionSheet.tag == 91){//头像
        if (buttonIndex == 1) {//修改
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }
    
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
        
        //按比例缩放
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
        
        
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
        imageCrop.delegate = self;
        
        //按像素缩放
        imageCrop.ratioOfWidthAndHeight = 400.0f/400.0f;//设置缩放比例
        
        imageCrop.image = scaleImage;
        //[imageCrop showWithAnimation:NO];
        picker.navigationBar.hidden = YES;
        [picker pushViewController:imageCrop animated:YES];
        
    }
}


#pragma mark - MLImageCropDelegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    
    if (_changeImageType == USERBANNER) {
        UIImage *doneImage = [self scaleToSize:cropImage size:UPIMAGECGSIZE_USERBANNER];//按像素缩放
        self.userBanner = doneImage;
        self.userUploadImagedata = UIImageJPEGRepresentation(self.userBanner, 0.8);
        [GMAPI setUserBannerImageWithData:self.userUploadImagedata];//存储到本地
        [self.userBannerImv setImage:[GMAPI getUserBannerImage]];//及时更新banner
        [GMAPI setUpUserBannerYes];//设置是否上传标志位
    }else if (_changeImageType == USERFACE){
        UIImage *doneImage = [self scaleToSize:cropImage size:UPIMAGECGSIZE_USERFACE];//按像素缩放
        self.userFace = doneImage;
        self.userUploadImagedata = UIImagePNGRepresentation(self.userFace);
        [GMAPI setUserFaceImageWithData:self.userUploadImagedata];//存储到本地
        [self.userFaceImv setImage:[GMAPI getUserFaceImage]];//及时更新face
        [GMAPI setUpUserFaceYes];//设置是否上传标志位
    }
    
    
    //ASI上传
    [self upLoadImage];
    
    [_tableView reloadData];
    
}

//上传
-(void)upLoadImage{
    
    //上传的url
    NSString *uploadImageUrlStr = @"";
    
    if (_changeImageType == USERBANNER) {//banner
        uploadImageUrlStr = PERSON_CHANGEUSERBANNER;
    }else if (_changeImageType == USERFACE){//头像
        uploadImageUrlStr = @"456";
    }
    
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:uploadImageUrlStr
                                   parameters:@{
                                                @"authcode":[GMAPI getAuthkey]
                                                }
                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                   {
                                       //开始拼接表单
                                       //获取图片的二进制形式
                                       NSData * data= self.userUploadImagedata;
                                       
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
                                   success:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                       
                                       
                                       
                                       NSLog(@"%@",responseObject);
                                       
                                       NSError * myerr;
                                       
                                       NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:&myerr];
                                       
                                       
                                       NSLog(@"%@",mydic);
                                       
                                       if (_changeImageType == USERBANNER) {
                                           [GMAPI setUpUserBannerNo];
                                       }else if (_changeImageType == USERFACE){
                                           [GMAPI setUpUserFaceNo];
                                       }
                                       
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       
                                       
                                       NSLog(@"%@",error);
                                       
                                       
                                       if (_changeImageType == USERBANNER) {
                                           [GMAPI setUpUserBannerYes];
                                       }else if (_changeImageType == USERFACE){
                                           [GMAPI setUpUserFaceYes];
                                       }
                                   }];
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
    
}




@end
