//
//  GStorePinpaiViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/10.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GStorePinpaiViewController.h"
#import "GtopScrollView.h"
#import "GRootScrollView.h"

@interface GStorePinpaiViewController ()

@end

@implementation GStorePinpaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    NSString *aaa = [NSString stringWithFormat:@"%@.%@",self.pinpaiNameStr,self.storeNameStr];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:aaa];
    NSInteger pinpaiNameLength = self.pinpaiNameStr.length;
    NSInteger storeNameLength = self.storeNameStr.length;
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,pinpaiNameLength)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0,pinpaiNameLength)];
    
    [title addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(240, 173, 184) range:NSMakeRange(pinpaiNameLength+1, storeNameLength)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(pinpaiNameLength+1, storeNameLength)];
    
    self.myTitleLabel.attributedText = title;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建楼层滚动view
-(void)creatFloorScrollViewWithDic:(NSDictionary *)dic{
    
    id brandDic = nil;
    if (dic) {
        brandDic = [dic objectForKey:@"brand"];
    }
    
    //取出brand字段中所有的key
    NSArray *keys = nil;
    if ([brandDic isKindOfClass:[NSDictionary class]]) {
        keys = [brandDic allKeys];
    }else{
        return;
    }
    //楼层数
    NSMutableArray *floorsNameArray = [NSMutableArray arrayWithCapacity:1];
    for (NSString *str in keys) {
        [floorsNameArray addObject:[NSString stringWithFormat:@"F%@",str]];
    }
    
    //每层的数据的二维数组
    NSMutableArray *data_2Array = [NSMutableArray arrayWithCapacity:1];
    for (NSString *key in keys) {
        [data_2Array addObject:[brandDic objectForKey:key]];
    }
    
    
    UIView *floorView = [[UIView alloc]initWithFrame:CGRectMake(12, 185, DEVICE_WIDTH-24, DEVICE_HEIGHT)];
    
    GtopScrollView *topScrollView = [[GtopScrollView alloc]initWithFrame:CGRectMake(0, 0, floorView.frame.size.width, 30)];
    GRootScrollView *rootScrollView = [[GRootScrollView alloc]initWithFrame:CGRectMake(0, 28, topScrollView.frame.size.width, DEVICE_HEIGHT-30)];
    
    NSLog(@"%@",NSStringFromCGRect(rootScrollView.frame));
    topScrollView.myRootScrollView = rootScrollView;
    rootScrollView.myTopScrollView = topScrollView;
    
    topScrollView.nameArray = (NSArray*)floorsNameArray;
    rootScrollView.viewNameArray =topScrollView.nameArray;
    
    //数据源二维数组
    rootScrollView.dataArray = data_2Array;
    
    
    [topScrollView initWithNameButtons];
    [rootScrollView initWithViews];
    
    
    [floorView addSubview:topScrollView];
    [floorView addSubview:rootScrollView];
    
    [self.view addSubview:floorView];
    
}

@end
