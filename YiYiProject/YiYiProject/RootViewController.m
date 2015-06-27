//
//  RootViewController.m
//  TestClouth
//
//  Created by lichaowei on 14/12/9.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "TTaiViewController.h" //小图

#import "BigPhotoTTaiViewController.h"//大图t台

#import "MessageViewController.h"
#import "MineViewController.h"

#import "CHTumblrMenuView.h"

#import "PublishHuatiController.h"

#import "MyMatchViewController.h"//搭配

#import "MyYiChuViewController.h"//衣橱

#import "MyConcernController.h" //关注

#import "TTPublishViewController.h"//T台发布

#import "MenuView.h"

#import "RCIM.h"

#import "MessageListController.h"//消息列表 分四个

#import "GTTPublishViewController.h"//发布T台

#import "GBuyClothesLogViewController.h"//买衣日志

@interface RootViewController ()<UITabBarControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    MessageViewController *messageVc;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareItems];
    
    //更新未读消息数字
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateRemoteMessage:) name:NOTIFICATION_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateRemoteMessage:) name:NOTIFICATION_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelHotpoint:) name:NOTIFICATION_LOGOUT object:nil];
    
    [self getMyMessage];
    
    self.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"RootViewController viewWillAppear");

    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hidden" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//取消红点
- (void)cancelHotpoint:(NSNotification *)notify
{
    [self updateTabbarNumber:0];
}

//更新未读消息条数

- (void)updateRemoteMessage:(NSNotification *)notification
{
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf getMyMessage];
    });
}

- (void)prepareItems
{
    
    
    NSArray *classNames = @[@"HomeViewController",@"BigPhotoTTaiViewController",@"GBuyClothesLogViewController",@"MineViewController"];
    NSArray *item_names = @[@"附近",@"T台",@"买衣日志",@"我的"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:classNames.count];
    for (int i = 0; i < classNames.count;i ++) {
        
        if (i == 0) {
            
            HomeViewController *home = [[HomeViewController alloc]init];
            LNavigationController *unvc = [[LNavigationController alloc]initWithRootViewController:home];
            [items addObject:unvc];
        }else
        {
            
            NSString *className = classNames[i];
            UIViewController *vc = [[NSClassFromString(className) alloc]init];
            LNavigationController *unvc = [[LNavigationController alloc]initWithRootViewController:vc];
            [items addObject:unvc];
        }
        
    }
    
    self.viewControllers = [NSArray arrayWithArray:items];
    
    
    NSArray *normalImages = @[@"gfujin_up",@"ttai_up",@"my_up",@"my_up"];
    NSArray *selectedImages = @[@"gfujin_down",@"ttai_down",@"my_down",@"my_down"];
    
    for (int i = 0; i < normalImages.count; i ++) {
        
        UITabBarItem *item = self.tabBar.items[i];
        UIImage *aImage = [UIImage imageNamed:[normalImages objectAtIndex:i]];
        aImage = [aImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = aImage;
        
        UIImage *selectImage = [UIImage imageNamed:[selectedImages objectAtIndex:i]];
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = selectImage;
        
        item.title = [item_names objectAtIndex:i];
        

    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"666666"],                                                                                                              NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"dc4b6c"],                                                                                                              NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    

    
}


- (void)clickToSelectForIndex:(UIButton *)sender
{
    if (sender.tag - 100 == 2) {
        NSLog(@"点击加号");
        
        [self showMenu];
        
        return;
    }
    
    self.selectedIndex = sender.tag - 100;
}

- (void)showMenu {
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    MenuItem *menuItem = [[MenuItem alloc] initWithTitle:@"拍照" iconName:@"t_paizhao" glowColor:[UIColor grayColor] index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"相册" iconName:@"t_xiangce" glowColor:[UIColor redColor] index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"搭配" iconName:@"t_dapei" glowColor:[UIColor colorWithRed:0.687 green:0.000 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"衣橱" iconName:@"t_yichu" glowColor:[UIColor colorWithRed:0.687 green:0.000 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"收藏" iconName:@"t_shoucang" glowColor:[UIColor colorWithRed:0.687 green:0.000 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"关注" iconName:@"t_guanzhu" glowColor:[UIColor colorWithRed:0.687 green:0.000 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    
    __weak typeof(self)weakSelf = self;
    MenuView *centerButton = [[MenuView alloc] initWithFrame:self.view.bounds items:items];
    centerButton.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
        
        [weakSelf swapToIndex:(int)selectedItem.index];
        
    };
    [centerButton showMenuAtView:self.view];
}

- (void)clickToPublish:(UIButton *)sender
{
    PublishHuatiController *publish = [[PublishHuatiController alloc]init];
    publish.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publish animated:YES];
}

- (void)swapToIndex:(int)index
{
    if (![LTools isLogin:self]) {
        
        return;
    }
    
    index --;
    switch (index) {
        case 0:
        {
            NSLog(@"拍照--发布T台");
            [self clickToPhoto:nil];
        }
            break;
        case 1:
        {
            NSLog(@"相册--发布T台");
            
            [self clickToAddAlbum:nil];
        }
            break;
        case 2:
        {
            NSLog(@"搭配");
            MyMatchViewController *myMatchVC = [[MyMatchViewController alloc] init];
            [self pushToViewController:myMatchVC];
            
        }
            break;
        case 3:
        {
            NSLog(@"衣橱");
            MyYiChuViewController *_myyichuVC=[[MyYiChuViewController alloc]init];
            [self pushToViewController:_myyichuVC];
        }
            break;
        case 4:
        {
            NSLog(@"收藏");
//            MyCollectionController *collection = [[MyCollectionController alloc]init];
//            [self pushToViewController:collection];
        }
            break;
        case 5:
        {
            NSLog(@"关注");
            MyConcernController *concern = [[MyConcernController alloc]init];
            [self pushToViewController:concern];
        }
            break;
            
        default:
            break;
    }
}

- (void)pushToViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    [(UINavigationController *)self.selectedViewController pushViewController:viewController animated:YES];
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"--> %d  %@",(int)tabBarController.selectedIndex,viewController);
    
}

#pragma mark - 图片选择

/**
 *  添加添加图片
 */

- (void)clickToAddAlbum:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

/**
 *  拍照
 */

- (void)clickToPhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //压缩图片 不展示原图
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        
        UIImage * scaleImage = [LTools scaleToSizeWithImage:originImage size:CGSizeMake(originImage.size.width>1024?1024:originImage.size.width,originImage.size.width>1024?originImage.size.height*1024/originImage.size.width:originImage.size.height)];
        //        UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
        
        NSData *data;
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 0.4);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        //        [self addPhoto:image];
        
        GTTPublishViewController *publish = [[GTTPublishViewController alloc]init];
        publish.publishImage = image;
        
        [self pushToViewController:publish];
        
        
        [picker dismissViewControllerAnimated:NO completion:^{
            
            
        }];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - 获取未读消息

#pragma mark - 网络请求

- (void)getMyMessage
{
    if ([GMAPI getAuthkey].length == 0) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:MESSAGE_GET_MINE,[GMAPI getAuthkey]];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"未读消息 result %@",result);
        
        if ([LTools isDictinary:result]) {
            
            MessageModel *a_yiyi_model = [[MessageModel alloc]initWithDictionary:[result objectForKey:@"yy_msg"]];
            MessageModel *a_shop_model = [[MessageModel alloc]initWithDictionary:[result objectForKey:@"shop_msg"]];
            MessageModel *a_other_model = [[MessageModel alloc]initWithDictionary:[result objectForKey:@"dynamic_msg"]];
            
            [LDataInstance shareInstance].shop_model = a_yiyi_model;
            [LDataInstance shareInstance].yiyi_model = a_shop_model;
            [LDataInstance shareInstance].other_model = a_other_model;
            
            [weakSelf updateTabbarNumber:[weakSelf unreadMessgeNum]];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        
    }];
}
/**
 *  获取未读消息条数
 */
- (int)unreadMessgeNum
{
    int sum = 0;
    
    MessageModel *yiyi_model = [LDataInstance shareInstance].yiyi_model;
    MessageModel *shop_model = [LDataInstance shareInstance].shop_model;
    MessageModel *other_model = [LDataInstance shareInstance].other_model;
    
    int rong_num = [[RCIM sharedRCIM] getTotalUnreadCount];
    
    if (rong_num <= 0) {
        rong_num = 0;
    }
    
    sum = yiyi_model.unread_msg_num + shop_model.unread_msg_num + other_model.unread_msg_num + rong_num;
    
    return sum;
}

/**
 *  更新未读消息显示
 *
 *  @param number 未读数
 */
- (void)updateTabbarNumber:(int)number
{
    NSString *number_str = nil;
    if (number > 0) {
        number_str = [NSString stringWithFormat:@"%d",number];
    }
    
    UINavigationController *unvc = [self.viewControllers objectAtIndex:3];
    unvc.tabBarItem.badgeValue = number_str;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [number_str intValue];
}

@end
