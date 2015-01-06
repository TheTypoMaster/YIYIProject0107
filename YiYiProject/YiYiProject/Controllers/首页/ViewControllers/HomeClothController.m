//
//  HomeClothViewController.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/12.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "HomeClothController.h"
#import "GCycleScrollView.h"
#import "GnearbyStoreViewController.h"
#import "GmPrepareNetData.h"
#import "NSDictionary+GJson.h"
#import "GScrollView.h"
#import "GpinpaiDetailViewController.h"
#import "GnearbyStoreViewController.h"

@interface HomeClothController ()<GCycleScrollViewDatasource,GCycleScrollViewDelegate,UIScrollViewDelegate>
{
    
    //第一行
    GCycleScrollView *_gscrollView;//上方循环滚动的scrollview
    NSMutableArray *_topScrollviewImvInfoArray;//顶部广告scrollview图片数组
    
    //第二行
    UIView *_nearbyView;//附近的view
    GScrollView *_scrollview_nearbyView;//附近的view上面的scrollview
    
    //第三行
    UIView *_pinpaiView;//品牌的view
    GScrollView *_scrollView_pinpai;//品牌的scrollview
    NSMutableArray *_pinpaiScrollViewModelInfoArray;//品牌信息数组

}
@end

@implementation HomeClothController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT -  64 - 44)];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, 180+218+155);
    
    [scrollView addSubview:[self creatGscrollView]];//循环滚动幻灯片
    
    [scrollView addSubview:[self creatNearbyView]];//附近的商场
    
    [scrollView addSubview:[self creatPinpaiView]];//品牌
    
    [self.view addSubview:scrollView];
    
    
    
    
    //网络请求
    //请求顶部滚动广告栏
    [self prepareTopScrollViewIms];
    //请求附近的品牌
    [self prepareNearbyPinpai];
    //请求附近的商店
    [self prepareNearbyStore];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//请求顶部scrollview一组图片
-(void)prepareTopScrollViewIms{
    NSString *api = HOME_CLOTH_TOPSCROLLVIEW;
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%@",result);
        _topScrollviewImvInfoArray = [result objectForKey:@"advertisements_data"];
        [_gscrollView reloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
    
}

//请求附近的品牌
-(void)prepareNearbyPinpai{
    NSString *api = HOME_CLOTH_NEARBYPINPAI;
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%@",result);
        _pinpaiScrollViewModelInfoArray = [result objectForKey:@"brand_data"];
        _scrollView_pinpai.dataArray = _pinpaiScrollViewModelInfoArray;
        [_scrollView_pinpai gReloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
}

//请求附近的商店
-(void)prepareNearbyStore{
    NSString *api = [NSString stringWithFormat:@"%@&page=1&count=100",HOME_CLOTH_NEARBYSTORE];
    GmPrepareNetData *dd = [[GmPrepareNetData alloc]initWithUrl:api isPost:YES postData:nil];
    [dd requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%@",result);
        _scrollview_nearbyView.dataArray = [result objectForKey:@"list"];
        
        [_scrollview_nearbyView gReloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
    
}



///创建循环滚动的scrollview
-(UIView*)creatGscrollView{
    _gscrollView = [[GCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 180)];
    _gscrollView.backgroundColor = [UIColor orangeColor];
    _gscrollView.delegate = self;
    _gscrollView.datasource = self;
    return _gscrollView;
}

//创建附近的view
-(UIView*)creatNearbyView{
    
    
    _nearbyView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_gscrollView.frame), DEVICE_WIDTH, 218)];
    _nearbyView.backgroundColor = [UIColor whiteColor];
    
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 30, 15)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"附近";
    [_nearbyView addSubview:titleLabel];
    
    
    //滚动界面
    _scrollview_nearbyView = [[GScrollView alloc]initWithFrame:CGRectMake(15, 30, DEVICE_WIDTH-15-40, 218-30-14)];
    _scrollview_nearbyView.backgroundColor = [UIColor whiteColor];
    _scrollview_nearbyView.contentSize = CGSizeMake(1000, 218-30-14);
    _scrollview_nearbyView.tag = 10;
    _scrollview_nearbyView.gtype = 10;
    _scrollview_nearbyView.delegate = self;
    _scrollview_nearbyView.delegate1 = self;
    _scrollview_nearbyView.showsHorizontalScrollIndicator = NO;
    [_nearbyView addSubview:_scrollview_nearbyView];
    
    
    for (int i = 0; i<20; i++) {
//        UIView *pinpaiView = [[UIView alloc]initWithFrame:CGRectMake(0+i*77, 0, 70, 218-30-14)];
//        pinpaiView.backgroundColor = [UIColor lightGrayColor];
//        pinpaiView.userInteractionEnabled = YES;
//        
//        UITapGestureRecognizer *tt = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goNearbyStoreVC)];
//        [pinpaiView addGestureRecognizer:tt];
//        [_scrollview_nearbyView addSubview:pinpaiView];
        
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(goNearbyStoreVC) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(0+i*77, 0, 70, 218-30-14)];
        btn.backgroundColor = [UIColor lightGrayColor];
        [_scrollview_nearbyView addSubview:btn];
        
    }
    
    
    
    
    
    
    //标题下面的分割线
    UIView *downTitleLine = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame)+3, DEVICE_WIDTH-30, 1)];
    downTitleLine.backgroundColor = RGBCOLOR(213, 213, 213);
    [_nearbyView addSubview:downTitleLine];
    
    
    
    //向右按钮btn
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(DEVICE_WIDTH-37, CGRectGetMaxY(downTitleLine.frame)+15, 22, 22)];
    rightBtn.layer.cornerRadius = 4;
    rightBtn.backgroundColor = RGBCOLOR(195, 195, 195);
    [rightBtn addTarget:self action:@selector(nearGoRight) forControlEvents:UIControlEventTouchUpInside];
    [_nearbyView addSubview:rightBtn];
    
    
    
    
    return _nearbyView;
}


//品牌
-(UIView *)creatPinpaiView{
    
    _pinpaiView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nearbyView.frame), DEVICE_HEIGHT, 155)];
    _pinpaiView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 30, 15)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"品牌";
    [_pinpaiView addSubview:titleLabel];
    
    
    //滚动界面
    _scrollView_pinpai = [[GScrollView alloc]initWithFrame:CGRectMake(15, 30, DEVICE_WIDTH-15-15, 155-30-14)];
    _scrollView_pinpai.backgroundColor = RGBCOLOR(242, 242, 242);
    _scrollView_pinpai.contentSize = CGSizeMake(1000, 155-30-14);
    _scrollView_pinpai.tag = 11;
    _scrollView_pinpai.gtype = 11;
    _scrollView_pinpai.delegate = self;
    _scrollView_pinpai.delegate1 = self;
    [_pinpaiView addSubview:_scrollView_pinpai];
    
    
    for (int i = 0; i<_scrollView_pinpai.dataArray.count; i++) {
        UIView *pinpaiView = [[UIView alloc]initWithFrame:CGRectMake(0+i*77, 0, 70, 120)];
        pinpaiView.backgroundColor = [UIColor orangeColor];
        
        
        UIView *yuan = [[UIView alloc]initWithFrame:CGRectMake(2, 15, 66, 66)];
        yuan.layer.cornerRadius = 33;
        yuan.backgroundColor = [UIColor whiteColor];
        yuan.layer.borderWidth = 1;
        yuan.layer.borderColor = RGBCOLOR(212, 212, 212).CGColor;
        [pinpaiView addSubview:yuan];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(yuan.frame)+10, 70, 13)];
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.text = @"ONLY";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = RGBCOLOR(114, 114, 114);
        [pinpaiView addSubview:nameLabel];
        
        
        
        [_scrollView_pinpai addSubview:pinpaiView];
        
    }
    
    
    
    
    
    
    
    //标题下面的分割线
    UIView *downTitleLine = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame)+3, DEVICE_WIDTH-30, 1)];
    downTitleLine.backgroundColor = RGBCOLOR(213, 213, 213);
    [_pinpaiView addSubview:downTitleLine];
    
    
    
    
    //向左按钮btn
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(15, CGRectGetMaxY(downTitleLine.frame)+40, 22, 22)];
    leftBtn.layer.cornerRadius = 4;
    leftBtn.backgroundColor = RGBCOLOR(195, 195, 195);
    [leftBtn addTarget:self action:@selector(pinpaiGoleft) forControlEvents:UIControlEventTouchUpInside];
    [_pinpaiView addSubview:leftBtn];
    
    
    //向右按钮btn
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(DEVICE_WIDTH-37, CGRectGetMaxY(downTitleLine.frame)+40, 22, 22)];
    rightBtn.layer.cornerRadius = 4;
    rightBtn.backgroundColor = RGBCOLOR(195, 195, 195);
    [rightBtn addTarget:self action:@selector(pinpaiGoRight) forControlEvents:UIControlEventTouchUpInside];
    [_pinpaiView addSubview:rightBtn];
    
    
    return _pinpaiView;
    
}



-(void)goNearbyStoreVC{
    
    GnearbyStoreViewController *nn = [[GnearbyStoreViewController alloc]init];
    nn.hidesBottomBarWhenPushed = YES;
    [self.rootViewController.navigationController pushViewController:nn animated:YES];
    
}





-(void)nearGoRight{
    CGFloat xx = _scrollview_nearbyView.contentOffset.x;
    CGFloat yy = _scrollview_nearbyView.contentOffset.y;
    xx+=100;
    if (xx>_scrollview_nearbyView.contentSize.width*0.5) {
        xx = _scrollview_nearbyView.contentSize.width*0.5;
    }
    
    
    [UIView animateWithDuration:0.2 animations:^{
        _scrollview_nearbyView.contentOffset = CGPointMake(xx, yy);
    } completion:^(BOOL finished) {
        
    }];
}


-(void)pinpaiGoleft{
    
    CGFloat xx = _scrollView_pinpai.contentOffset.x;
    CGFloat yy = _scrollView_pinpai.contentOffset.y;
    xx-=100;
    if (xx<0) {
        xx = 0;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView_pinpai.contentOffset = CGPointMake(xx, yy);
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}


-(void)pinpaiGoRight{
    
    CGFloat xx = _scrollView_pinpai.contentOffset.x;
    CGFloat yy = _scrollView_pinpai.contentOffset.y;
    NSLog(@"%f",xx);
    xx+=100;
    if (xx>_scrollView_pinpai.contentSize.width*0.5) {
        xx = _scrollView_pinpai.contentSize.width*0.5;
    }
    
    
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView_pinpai.contentOffset = CGPointMake(xx, yy);
    } completion:^(BOOL finished) {
        
    }];
}





#pragma mark - 循环滚动的scrollView的代理方法

//滚动总共几页
- (NSInteger)numberOfPages
{
    
    return _topScrollviewImvInfoArray.count;
}

//每一页
- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 180)];
    imv.userInteractionEnabled = YES;
    
    NSDictionary *dic = _topScrollviewImvInfoArray[index];
    NSString *str = nil;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        str = [dic stringValueForKey:@"img_url"];
    }
    
    [imv sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
    
    
    
    
    return imv;
    
}

//点击的哪一页
- (void)didClickPage:(GCycleScrollView *)csView atIndex:(NSInteger)index
{
    
    id obj=NSClassFromString(@"UIAlertController");
    if ( obj!=nil){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前点击第%ld个页面",index] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"当前点击第%ld个页面",index]
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
        [alert show];
    }
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 10) {
        NSLog(@"附近 x:%f,y:%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    }else if (scrollView.tag == 11){
        NSLog(@"品牌 x:%f,y:%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    }
    
    
}







-(void)pushToPinpaiDetailVCWithIdStr:(NSString *)theID{
    
    GpinpaiDetailViewController *cc = [[GpinpaiDetailViewController alloc]init];
    cc.hidesBottomBarWhenPushed = YES;
    cc.pinpaiIdStr = theID;
    [self.rootViewController.navigationController pushViewController:cc animated:YES];
    
}



-(void)pushToNearbyStoreVCWithIdStr:(NSString *)theID{
    GnearbyStoreViewController *dd = [[GnearbyStoreViewController alloc]init];
    dd.storeIdStr = theID;
    dd.hidesBottomBarWhenPushed = YES;
    [self.rootViewController.navigationController pushViewController:dd animated:YES];
}





@end
