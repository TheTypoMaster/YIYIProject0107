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


#import "MyYiChuViewController.h"//我的衣橱

#import "MyConcernController.h"//我的关注
#import "MyCollectionController.h"//我的收藏

#import "MyBodyViewController.h"//我的体型
#import "MyMatchViewController.h"//我的搭配

#import "MySettingsViewController.h" //设置
#import "EditMyInfoViewController.h"  //编辑资料

//#import "ShenQingDianPuViewController.h"
#import "ShenQingDianPuViewController.h"

#import "MyShopViewController.h"//我的店铺

#import "LShareSheetView.h"

#import "ParallaxHeaderView.h"
#import "UIImage+ImageEffects.h"
#import "NSDictionary+GJson.h"

#import "UserInfo.h"

typedef enum{
    USERFACE = 0,//头像
    USERBANNER,//banner
    USERIMAGENULL,
}CHANGEIMAGETYPE;

#define CROPIMAGERATIO_USERBANNER 320.00/150 //banner 图片裁剪框宽高比
#define CROPIMAGERATIO_USERFACE 1.0//头像 图片裁剪框宽高比例

#define UPIMAGECGSIZE_USERBANNER CGSizeMake(1080,1080*0.4687)//需要上传的banner的分辨率
#define UPIMAGECGSIZE_USERFACE CGSizeMake(200,200)//需要上传的头像的分辨率

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,GcustomActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MLImageCropDelegate>
{
    UITableView *_tableView;//主tableview
    CHANGEIMAGETYPE _changeImageType;
    NSArray *_tabelViewCellTitleArray;//title文字数组
    NSArray *_logoImageArray;//title前面的logo图数组
    NSDictionary *_customInfo_tabelViewCell;//cell数据源
    ParallaxHeaderView *_backView;//banner
    
    UserInfo *_userInfo;//用户信息model
    
    
    BOOL _getUserinfoSuccess;//加载用户数据是否成功
    
    
    
    UIActivityIndicatorView *_hud;
    
}
@end

@implementation MineViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBarHidden = YES;
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myTitleLabel.text = @"我的";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    //加载视图
    [self loadMineView];
    
    //判断是否登录
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
        
        LoginViewController *login = [[LoginViewController alloc]init];
        
        UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
        
        [self presentViewController:unVc animated:YES completion:nil];
        
    }else{
        [self GgetUserInfo];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//加载视图
-(void)loadMineView{
    //初始化相关
    _changeImageType = USERIMAGENULL;

    _logoImageArray = @[@[[UIImage imageNamed:@"my_zhuye.png"]]
                        ,@[[UIImage imageNamed:@"my_shoucang.png"],[UIImage imageNamed:@"my_guanzhu.png"]]
                        ,@[[UIImage imageNamed:@"my_shenqing.png"]]
                        ,@[[UIImage imageNamed:@"my_haoyou.png"]]
                        ];
    
//    _tabelViewCellTitleArray = @[@[@"我的主页"]
//                                 ,@[@"我的收藏",@"我的关注"]
//                                 ,@[@"我的衣橱",@"我的搭配",@"我的体型"]
//                                 ,@[@"我是店主，申请衣+衣店铺"]
//                                 ,@[@"邀请好友"]];
    
    _tabelViewCellTitleArray = @[@[@"我的主页"]
                                 ,@[@"我的收藏",@"我的关注"]
                                 ,@[@"我是店主，申请衣+衣店铺"]
                                 ,@[@"邀请好友"]
                                 ];

    
    _customInfo_tabelViewCell = @{@"titleLogo":_logoImageArray,
                                  @"titleArray":_tabelViewCellTitleArray
                                  };
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self creatTableViewHeaderView];
//    _tableView.userInteractionEnabled = NO;
    [self.view addSubview:_tableView];
    
    
    //通知相关=====
    
    //登录成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GgetUserInfo) name:NOTIFICATION_LOGIN object:nil];
    
    //退出登录
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GLogoutAction) name:NOTIFICATION_LOGOUT object:nil];
    
//    //测试审核成功
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GgetUserInfo) name:NOTIFICATION_SHENQINGDIANPU_SUCCESS object:nil];
    
    //接收审核结果
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GgetUserInfo) name:NOTIFICATION_SHENQINGDIANPU_STATE object:nil];
}




//退出登录成功后的页面调整

-(void)GLogoutAction{

    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    [self loadMineView];
}



//请求到userinfo之后根据shopman参数判断是否拥有店铺 调整 标题和图标二维数组
-(void)changeTheTitleAndPicArray_dianzhu{//已经是店主
    _logoImageArray = @[@[[UIImage imageNamed:@"my_zhuye.png"],[UIImage imageNamed:@"my_shenqing.png"]]
                        ,@[[UIImage imageNamed:@"my_shoucang.png"],[UIImage imageNamed:@"my_guanzhu.png"]]
                        ,@[[UIImage imageNamed:@"my_haoyou.png"]]
                        ];
    
    _tabelViewCellTitleArray = @[@[@"我的主页",@"我的店铺"]
                                 ,@[@"我的收藏",@"我的关注"]
                                 ,@[@"邀请好友"]];
    
    
    
    
    _customInfo_tabelViewCell = @{@"titleLogo":_logoImageArray,
                                  @"titleArray":_tabelViewCellTitleArray
                                  };
}

-(void)changeTheTitleAndPicArray_shenhe{//正在审核
    _logoImageArray = @[@[[UIImage imageNamed:@"my_zhuye.png"]]
                        ,@[[UIImage imageNamed:@"my_shoucang.png"],[UIImage imageNamed:@"my_guanzhu.png"]]
                        ,@[[UIImage imageNamed:@"my_shenqing.png"]]
                        ,@[[UIImage imageNamed:@"my_haoyou.png"]]
                        ];
    
    _tabelViewCellTitleArray = @[@[@"我的主页"]
                                 ,@[@"我的收藏",@"我的关注"]
                                 ,@[@"店铺审核中"]
                                 ,@[@"邀请好友"]];
    
    
    
    
    _customInfo_tabelViewCell = @{@"titleLogo":_logoImageArray,
                                  @"titleArray":_tabelViewCellTitleArray
                                  };
}



//网络请求获取用户信息
-(void)GgetUserInfo{
    
    if (!_hud) {
        _hud = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _hud.frame = CGRectMake(20, 35, 0, 0);
    }
    [self.view addSubview:_hud];
    [_hud startAnimating];
    
    
    
    NSString *URLstr = [NSString stringWithFormat:@"%@&authcode=%@",PERSON_GETUSERINFO,[GMAPI getAuthkey]];
    
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:URLstr isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%@",result);
        
        
        _getUserinfoSuccess = YES;
        
        [_hud stopAnimating];
        
        NSDictionary *dic = [result dictionaryValueForKey:@"user_info"];
        
        _userInfo = [[UserInfo alloc]initWithDictionary:dic];
        if ([_userInfo.shopman intValue] == 2) {//已经是店主
            [self changeTheTitleAndPicArray_dianzhu];
        }else if ([_userInfo.shopman intValue]==1){//正在审核
            [self changeTheTitleAndPicArray_shenhe];
        }
        
        NSString *name = [dic stringValueForKey:@"user_name"];
        NSString *score = [dic stringValueForKey:@"score"];
        self.userNameLabel.text = [NSString stringWithFormat:@"昵称:%@",name];
        self.userScoreLabel.text = [NSString stringWithFormat:@"积分:%@",score];
        
        user_bannerUrl = [dic stringValueForKey:@"user_banner"];
        [_backView.imageView sd_setImageWithURL:[NSURL URLWithString:user_bannerUrl] placeholderImage:[UIImage imageNamed:@"my_bg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [GMAPI setUserBannerImageWithData:UIImagePNGRepresentation(_backView.imageView.image)];
        }];
        
        
        NSString *userFaceUrl = [NSString stringWithFormat:@"%@",[dic stringValueForKey:@"photo"]];
        headImageUrl = userFaceUrl;
        
//        [self.userFaceImv sd_setImageWithURL:[NSURL URLWithString:userFaceUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [GMAPI setUserFaceImageWithData:UIImagePNGRepresentation(self.userFaceImv.image)];
//        }];
        
        [self.userFaceImv sd_setImageWithURL:[NSURL URLWithString:userFaceUrl] placeholderImage:[UIImage imageNamed:@"grzx150_150.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [GMAPI setUserFaceImageWithData:UIImagePNGRepresentation(self.userFaceImv.image)];
        }];
        
        [_tableView reloadData];
//        _tableView.userInteractionEnabled = YES;
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        if (!_getUserinfoSuccess) {
            
            [self performSelector:@selector(GgetUserInfo) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
        }
    }];
    
}



///创建用户头像banner的view
-(UIView *)creatTableViewHeaderView{
    //底层view
    _backView = [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(DEVICE_WIDTH, 150.00*DEVICE_WIDTH/320)];
    _backView.headerImage = [UIImage imageNamed:@"my_bg.png"];
    
    NSLog(@"%@",NSStringFromCGRect(_backView.frame));
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((DEVICE_WIDTH-50.00)*0.5, 33, 50, 17)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:16*GscreenRatio_320];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的";
    titleLabel.textColor = [UIColor whiteColor];
    [_backView addSubview:titleLabel];
    
    //小齿轮设置按钮
    UIButton *chilunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chilunBtn setFrame:CGRectMake(DEVICE_WIDTH - 55, 20, 40, 40)];
    [chilunBtn setImage:[UIImage imageNamed:@"my_shezhi.png"] forState:UIControlStateNormal];
    [chilunBtn addTarget:self action:@selector(xiaochilun) forControlEvents:UIControlEventTouchUpInside];
    
    
    //头像
    self.userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake(30*GscreenRatio_320, _backView.frame.size.height - 75, 50, 50)];
    [self.userFaceImv setImage:[UIImage imageNamed:@"grzx150_150.png"]];
//    self.userFaceImv.backgroundColor = RGBCOLOR_ONE;
    self.userFaceImv.layer.cornerRadius = 25;
    self.userFaceImv.layer.masksToBounds = YES;

    
    NSLog(@"%@",NSStringFromCGRect(self.userFaceImv.frame));
    
    //昵称
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userFaceImv.frame)+10, self.userFaceImv.frame.origin.y+6, DEVICE_WIDTH-CGRectGetMaxX(self.userFaceImv.frame)-10-17, 14)];
    self.userNameLabel.text = @"昵称：";
    self.userNameLabel.font = [UIFont systemFontOfSize:14*GscreenRatio_320];
    self.userNameLabel.textColor = [UIColor whiteColor];
//        self.userNameLabel.backgroundColor = [UIColor lightGrayColor];

    //积分
    self.userScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLabel.frame.origin.x, CGRectGetMaxY(self.userNameLabel.frame)+10, 150, self.userNameLabel.frame.size.height)];
    self.userScoreLabel.font = [UIFont systemFontOfSize:14*GscreenRatio_320];
    self.userScoreLabel.text = @"积分：";
    self.userScoreLabel.textColor = [UIColor whiteColor];
//        self.userScoreLabel.backgroundColor = [UIColor orangeColor];

    //编辑按钮
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(DEVICE_WIDTH-80, self.userFaceImv.frame.origin.y+15, 55, 44)];
    //    editBtn.backgroundColor = [UIColor purpleColor];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16*GscreenRatio_320];
    [editBtn addTarget:self action:@selector(goToEdit) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    
    //手势
    UITapGestureRecognizer *ddd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userBannerClicked)];
    _backView.imageView.userInteractionEnabled = YES;
    [_backView.imageView addGestureRecognizer:ddd];
    UITapGestureRecognizer *eee = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userFaceClicked)];
    self.userFaceImv.userInteractionEnabled = YES;
    [self.userFaceImv addGestureRecognizer:eee];
    
    
//    //添加视图
//    [backView addSubview:self.userBannerImv];
    [_backView addSubview:self.userFaceImv];
    [_backView addSubview:self.userNameLabel];
    [_backView addSubview:self.userScoreLabel];
    [_backView addSubview:editBtn];
    [_backView addSubview:chilunBtn];
    
    return _backView;
}



//跳转个人设置界面
-(void)xiaochilun{
    
    //判断是否登录
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
        
        LoginViewController *login = [[LoginViewController alloc]init];
        
        UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
        
        [self presentViewController:unVc animated:YES completion:nil];
        
        
        return;
        
    }
    
    
    if (!_getUserinfoSuccess) {
        return;
    }
    
    
    
    MySettingsViewController *mySettingVC = [[MySettingsViewController alloc]init];
    mySettingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mySettingVC animated:YES];
}


#pragma mark 事件处理

- (void)clickToShare:(UIButton *)sender
{
    [[LShareSheetView shareInstance] showShareContent:@"我在使用衣+衣,我们一起来用吧!" title:nil shareUrl:@"http://www.alayy.com" shareImage:[UIImage imageNamed:@"about_icon"] targetViewController:self];
    [[LShareSheetView shareInstance]actionBlock:^(NSInteger buttonIndex, Share_Type shareType) {
        
        if (shareType == Share_QQ) {
            
            NSLog(@"Share_QQ");
            
        }else if (shareType == Share_QQZone){
            
            NSLog(@"Share_QQZone");
            
        }else if (shareType == Share_WeiBo){
            
            NSLog(@"Share_WeiBo");
            
        }else if (shareType == Share_WX_HaoYou){
            
            NSLog(@"Share_WX_HaoYou");
            
        }else if (shareType == Share_WX_PengYouQuan){
            
            NSLog(@"Share_WX_PengYouQuan");
            
        }
        
    }];
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
    
    //判断是否登录
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
        
        LoginViewController *login = [[LoginViewController alloc]init];
        
        UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
        
        [self presentViewController:unVc animated:YES completion:nil];

        
        return;
        
    }
    
    
    if (!_getUserinfoSuccess) {
        return;
    }
    
    
    
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {//我的主页
                GmyMainViewController *dd = [[GmyMainViewController alloc]init];
                dd.theType = GMYSELF;
                dd.bannerUrl = user_bannerUrl;
                dd.headImageUrl = headImageUrl;
                dd.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:dd animated:YES];
            }else if (indexPath.row == 1){//已经为店主时候的我的店铺
                int shopMan = [_userInfo.shopman intValue];
                if (shopMan == 2) {
                    NSLog(@"店主");
                    MyShopViewController *shop = [[MyShopViewController alloc]init];
                    shop.userInfo = _userInfo;
                    shop.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:shop animated:YES];
                }
                
            }
            
            
        }
            break;
            
        case 1:
        {
            
            if (indexPath.row == 0) {//我的收藏
                
                MyCollectionController *myMatchVC = [[MyCollectionController alloc] init];
                myMatchVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myMatchVC animated:YES];
                
            }else if (indexPath.row == 1){//我的关注
                
                MyConcernController *concern = [[MyConcernController alloc]init];
                concern.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:concern animated:YES];
                
            }
        }
            break;
            
        case 2://我是店主，申请衣加衣店铺  或 邀请好友
        {
            if (indexPath.row==0) {
                
                int shopMan = [_userInfo.shopman intValue];
                if (shopMan == 1){
                    NSLog(@"店铺申请");
                    [LTools showMBProgressWithText:@"您已申请店铺,正在审核中..." addToView:self.view];
                }else if (shopMan == 0){
                    NSLog(@"普通");
                    ShenQingDianPuViewController *_shenqingVC = [[ShenQingDianPuViewController alloc]init];
                    _shenqingVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:_shenqingVC animated:YES];
                }else if (shopMan == 2){//已经是店主
                    //邀请好友
                    [self clickToShare:nil];
                }
                
            }
            
            
            
            
        }
            break;
            
        case 3://邀请好友 或没有
        {
            
            if (indexPath.row == 0){
                
                
                [self clickToShare:nil];
            }
            
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    NSLog(@"xxxx==%zi=row=%zi=",indexPath.section,indexPath.row);
    
    NSLog(@"在这里进行跳转");
}



///编辑资料
-(void)goToEdit{
    
    if (!_getUserinfoSuccess) {
        return;
    }
    
    
    if ([LTools isLogin:self]) {
        //编辑
        EditMyInfoViewController *editInfoVC = [[EditMyInfoViewController alloc] init];
        editInfoVC.delegate = self;
        editInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editInfoVC animated:YES];
    }
    
    
}


//修改banner&&头像
-(void)userBannerClicked{
    NSLog(@"点击用户banner");
    if (!_getUserinfoSuccess) {
        return;
    }
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
    [aaa showInView:self.view.window WithAnimation:YES];
    
    
}
-(void)userFaceClicked{
    NSLog(@"点击头像");
    if (!_getUserinfoSuccess) {
        return;
    }
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
    [aaa showInView:self.view.window WithAnimation:YES];
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
        
        //按像素缩放  //设置缩放比例
        if (_changeImageType == USERBANNER) {
            imageCrop.ratioOfWidthAndHeight = CROPIMAGERATIO_USERBANNER;
        }else if (_changeImageType == USERFACE){
            imageCrop.ratioOfWidthAndHeight = 1;
        }
        
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
        _backView.headerImage = [GMAPI getUserBannerImage];//及时更新banner
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
        uploadImageUrlStr = PERSON_CHANGEUSERFACE;
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
                                       
                                       [GMAPI showAutoHiddenMBProgressWithText:@"更改成功" addToView:self.view];
                                       
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
                                       
                                       [GMAPI showAutoHiddenMBProgressWithText:@"更改失败,联网自动上传" addToView:self.view];
                                       
                                       
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



#pragma mark -
#pragma mark UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == _tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)_tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
        
        
        NSLog(@"contentOffSet.y == %f",scrollView.contentOffset.y);
        
//        if (scrollView.contentOffset.y <=-70) {
//            [self GgetUserInfo];
//        }
    }
    
    
    
    
    
}





@end
