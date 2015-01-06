//
//  RootViewController.m
//  TestClouth
//
//  Created by lichaowei on 14/12/9.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "TTaiViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"

#import "CHTumblrMenuView.h"

#import "MyCollectionController.h"

@interface RootViewController ()<UITabBarControllerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareItems];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareItems
{
    
    NSArray *classNames = @[@"HomeViewController",@"TTaiViewController",@"UIViewController",@"MessageViewController",@"MineViewController"];
    
    NSArray *item_names = @[@"首页",@"T台",@"+",@"消息",@"我的"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5;i ++) {
        
        if (i == 0) {
            
            HomeViewController *home = [[HomeViewController alloc]init];
            UINavigationController *unvc = [[UINavigationController alloc]initWithRootViewController:home];
            [items addObject:unvc];
        }else
        {
            
            NSString *className = classNames[i];
            UIViewController *vc = [[NSClassFromString(className) alloc]init];
            UINavigationController *unvc = [[UINavigationController alloc]initWithRootViewController:vc];
            [items addObject:unvc];
        }
        
    }
    
    self.viewControllers = [NSArray arrayWithArray:items];
    
    CGSize tabbarSize = self.tabBar.frame.size;
//    UIView *customTabbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tabbarSize.width, tabbarSize.height)];
//    customTabbar.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
//    customTabbar.alpha = 0.97;
//    [self.tabBar addSubview:customTabbar];
    
    CGSize allSize = [UIScreen mainScreen].applicationFrame.size;
    
    CGFloat aWidth = allSize.width / 5;
    
    NSArray *normalImages = @[@"home_up",@"ttai_up",@"tianjia_up",@"xiaoxi_up",@"my_up"];
    NSArray *selectedImages = @[@"home_down",@"ttai_down",@"tianjia_up",@"xiaoxi_down",@"my_down"];
    
    for (int i = 0; i < 5; i ++) {
        
        UITabBarItem *item = self.tabBar.items[i];
        UIImage *aImage = [UIImage imageNamed:[normalImages objectAtIndex:i]];
        aImage = [aImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = aImage;
        
        UIImage *selectImage = [UIImage imageNamed:[selectedImages objectAtIndex:i]];
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = selectImage;
        
        if (i != 2) {
            item.title = [item_names objectAtIndex:i];
        }
        
        //中间特殊按钮
        
        if (i == 2) {
            //上 左 下 右
            [item setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
            
            UIButton *center = [UIButton buttonWithType:UIButtonTypeCustom];
            center.frame = CGRectMake(0, 0, aWidth, tabbarSize.height);
            [self.tabBar addSubview:center];
            center.backgroundColor = [UIColor clearColor];
            center.center = CGPointMake(DEVICE_WIDTH/2.f, center.center.y);
            center.tag = 102;
            [center setImage:[UIImage imageNamed:normalImages[2]] forState:UIControlStateNormal];
            [center setImage:[UIImage imageNamed:selectedImages[2]] forState:UIControlStateSelected];
            [center addTarget:self action:@selector(clickToSelectForIndex:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"666666"],                                                                                                              NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"dc4b6c"],                                                                                                              NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
//    self.tabBar.backgroundImage=[UIImage imageNamed:@"bottom"];
    
//    for (int i = 0; i < 5; i ++) {
//        
//        UIButton *item_btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        item_btn.frame = CGRectMake(aWidth * i, 0,64, 49);
//        
//        
//        item_btn.backgroundColor = i % 2 ? [UIColor orangeColor] : [UIColor greenColor];
//        [item_btn setTitle:item_names[i] forState:UIControlStateNormal];
//        item_btn.tag = 100 + i;
//        [item_btn addTarget:self action:@selector(clickToSelectForIndex:) forControlEvents:UIControlEventTouchUpInside];
//        [customTabbar addSubview:item_btn];
//        
//        item_btn.titleLabel.font = [UIFont systemFontOfSize:10];//title字体大小
//        item_btn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
//        [item_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
//        [item_btn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];//设置title在button被选中情况下为灰色字体
//        
//        //===========================
//        
//        //    在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets、titleEdgeInsets、imageEdgeInsets
//        [item_btn setImage:[UIImage imageNamed:normalImages[i]] forState:UIControlStateNormal];//给button添加image
//        [item_btn setImage:[UIImage imageNamed:selectedImages[i]] forState:UIControlStateSelected];
//        
//        
//        
////        item_btn.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,item_btn.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
////        
////        item_btn.titleEdgeInsets = UIEdgeInsetsMake(71, -item_btn.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
//        //    [button setContentEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];//
//        //   button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置button的内容横向居中。。设置content是title和image一起变化
//        
//    }
    
}

- (void)clickToSelectForIndex:(UIButton *)sender
{
    if (sender.tag - 100 == 2) {
        NSLog(@"点击加号");
        
        CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
        [menuView addMenuItemWithTitle:@"拍照" andIcon:[UIImage imageNamed:@"t_paizhao"] andSelectedBlock:^{
            NSLog(@"Text selected");
        }];
        [menuView addMenuItemWithTitle:@"相册" andIcon:[UIImage imageNamed:@"t_xiangce"] andSelectedBlock:^{
            NSLog(@"Photo selected");
        }];
        [menuView addMenuItemWithTitle:@"搭配" andIcon:[UIImage imageNamed:@"t_dapei"] andSelectedBlock:^{
            NSLog(@"Quote selected");
            
        }];
        [menuView addMenuItemWithTitle:@"衣橱" andIcon:[UIImage imageNamed:@"t_yichu"] andSelectedBlock:^{
            NSLog(@"Link selected");
            
        }];
        [menuView addMenuItemWithTitle:@"收藏" andIcon:[UIImage imageNamed:@"t_shoucang"] andSelectedBlock:^{
            NSLog(@"Chat selected");
            
            MyCollectionController *collection = [[MyCollectionController alloc]init];
            [self.navigationController pushViewController:collection animated:YES];
            
        }];
        [menuView addMenuItemWithTitle:@"日记" andIcon:[UIImage imageNamed:@"t_rizhi"] andSelectedBlock:^{
            NSLog(@"Video selected");
            
        }];
        
        
        
        [menuView show];
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"点击中间按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        
        return;
    }
    
    self.selectedIndex = sender.tag - 100;
}

@end
