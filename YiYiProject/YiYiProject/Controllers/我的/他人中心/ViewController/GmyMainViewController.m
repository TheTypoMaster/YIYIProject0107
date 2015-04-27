//
//  GmyMainViewController.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GmyMainViewController.h"
#import "GShowStarsView.h"
#import "TMQuiltView.h"
#import "LWaterflowView.h"
#import "TPlatModel.h"

#import "TTaiDetailController.h"

#define NORMAL_TEXT @"上拉加载更多"
#define NOMORE_TEXT @"没有更多数据"
#define TABLEFOOTER_HEIGHT 50.f

#import "LWaterflowView.h"

#import "TPlatCell.h"

@interface GmyMainViewController ()<TMQuiltViewDataSource,WaterFlowDelegate>
{
    
    
    
    //第一层
    UIView *_upUserInfoView;//用户信息view
    UIImageView *_userFaceImv;//头像
    UIImageView *_userBannerImv;//banner
    UILabel *_userNameLabel;//用户名
    UILabel *_guanzhuLabel;//关注
    UILabel *_fensiLabel;//粉丝
    
    //第二层 (自己的主页没有这一层)
    UIView *_jiaoliuGuanzhuView;//交流关注view
    
    UIView *_ttaiView;
    
    
    UIView *_backView_water;
    LWaterflowView *_waterFlow;
    int _per_page;
    int _page;
    
    
    
}

@property(nonatomic,retain)UIActivityIndicatorView *loadingIndicator;
@property(nonatomic,retain)UILabel *normalLabel;
@property(nonatomic,retain)UILabel *loadingLabel;

@end

@implementation GmyMainViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)dealloc
{
    _waterFlow.waterDelegate = nil;
    _waterFlow.quitView.dataSource = nil;
    _waterFlow = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.myTitleLabel.textColor = [UIColor whiteColor];
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    _per_page = 20;
    _page = 1;
    
    [self creatHeadView];
    
    [self creatWaterFlowView];
    
    [_waterFlow showRefreshHeader:YES];
    
    NSLog(@"%f",DEVICE_WIDTH);
    
    
}


///初始化头部的view
-(void)creatHeadView{
    
    //整个view
    _upUserInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_upUserInfoView.frame), DEVICE_WIDTH, 150)];
    _upUserInfoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_upUserInfoView];
    
    _userBannerImv = [[UIImageView alloc]initWithFrame:_upUserInfoView.bounds];
    _userBannerImv.userInteractionEnabled = YES;
    _userBannerImv.image = [GMAPI getUserBannerImage];
    [_upUserInfoView addSubview:_userBannerImv];
    
    
    
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 15, 30, 50)];
    [backBtn setFrame:CGRectMake(0, 0, 80, 80)];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
    [backBtn addTarget:self action:@selector(gGoBackVc) forControlEvents:UIControlEventTouchUpInside];
    [_upUserInfoView addSubview:backBtn];
    
    
    //头像
    _userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_WIDTH-60)*0.5, 35, 60, 60)];
    _userFaceImv.backgroundColor = RGBCOLOR_ONE;
    _userFaceImv.layer.cornerRadius = 30;
    _userFaceImv.layer.borderWidth = 1;
    _userFaceImv.layer.borderColor = [[UIColor whiteColor]CGColor];
    _userFaceImv.layer.masksToBounds = YES;
    [_userFaceImv sd_setImageWithURL:[NSURL URLWithString:_headImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    [_upUserInfoView addSubview:_userFaceImv];
    
    //用户名
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(_userFaceImv.frame)+5, DEVICE_WIDTH, 20)];
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.font = [UIFont systemFontOfSize:18];
    _userNameLabel.text = [GMAPI getUsername];
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    [_upUserInfoView addSubview:_userNameLabel];
    
    //整个view
    _ttaiView = [[UIView alloc]initWithFrame:CGRectMake(0, _upUserInfoView.frame.size.height+_upUserInfoView.frame.origin.y, DEVICE_WIDTH, 25)];
    _ttaiView.backgroundColor = RGBCOLOR(235, 235, 235);
    [self.view addSubview:_ttaiView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 2, 25)];
    lineView.backgroundColor = RGBCOLOR(239, 47, 48);
    lineView.layer.cornerRadius = 3;
    [_ttaiView addSubview:lineView];
    
    UILabel *titaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineView.frame.size.width+lineView.frame.origin.x+5, 0,150,25)];
    titaiLabel.font = [UIFont systemFontOfSize:15];
    titaiLabel.backgroundColor = [UIColor clearColor];
    titaiLabel.textAlignment = NSTextAlignmentLeft;
    titaiLabel.text = @"我的T台";
    [_ttaiView addSubview:titaiLabel];
    
    
    
    
    
    
}


-(void)gGoBackVc{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化瀑布流
-(void)creatWaterFlowView{
    
    
    //瀑布流相关
    _backView_water = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_ttaiView.frame), ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - _upUserInfoView.frame.size.height)];
    _backView_water.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_backView_water];
    _waterFlow = [[LWaterflowView alloc]initWithFrame:_backView_water.bounds waterDelegate:self waterDataSource:self];
    _waterFlow.backgroundColor = RGBCOLOR(235, 235, 235);
    [_backView_water addSubview:_waterFlow];
    
}






#pragma mark-----------------获取数据


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - _waterFlowDelegate

- (void)waterLoadNewData
{
    
    //请求网络数据
    NSString *api = nil;
    
    _page = 1;
    
    
    api = [NSString stringWithFormat:@"%@&page=%d&count=%d&user_id=%@&authcode=%@",POST_TLIST_URL,_page,_per_page,[GMAPI getUid],[GMAPI getAuthkey]];
    NSLog(@"请求的接口%@",api);
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result : %@",result);
        NSMutableArray *arr;
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *list = result[@"list"];
            arr = [NSMutableArray arrayWithCapacity:list.count];
            if ([list isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *aDic in list) {
                    
                    TPlatModel *aModel = [[TPlatModel alloc]initWithDictionary:aDic];
                    
                    [arr addObject:aModel];
                }
                
            }
        }
        
        [_waterFlow reloadData:arr pageSize:_per_page];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [_waterFlow loadFail];
    }];
    
}
- (void)waterLoadMoreData
{
    //加载更多
    //请求网络数据
    NSString *api = nil;
    
    NSLog(@"请求的接口%@",api);
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result : %@",result);
        NSMutableArray *arr;
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *list = result[@"list"];
            arr = [NSMutableArray arrayWithCapacity:list.count];
            if ([list isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *aDic in list) {
                    
                    TPlatModel *aModel = [[TPlatModel alloc]initWithDictionary:aDic];
                    
                    [arr addObject:aModel];
                }
                
            }
        }
        
        
        //重载瀑布流
        [_waterFlow reloadData:arr pageSize:_per_page];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [_waterFlow loadFail];
    }];
}

//点击方法
- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPlatModel *model = (TPlatModel *)_waterFlow.dataArray[indexPath.row];
    
    TTaiDetailController *t_detail = [[TTaiDetailController alloc]init];
    t_detail.tt_id = model.tt_id;
    
    t_detail.lastPageNavigationHidden = YES;
    [self.navigationController pushViewController:t_detail animated:YES];
    
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    TPlatModel *aModel = _waterFlow.dataArray[indexPath.row];
    CGFloat image_height = [aModel.image[@"height"]floatValue];
    CGFloat image_width = [aModel.image[@"width"]floatValue];
    
    if (image_width == 0.0) {
        image_width = image_height;
    }
    float rate = image_height/image_width;
    
    return (DEVICE_WIDTH-30)/2.0*rate + 55 + 36;
}
- (CGFloat)waterViewNumberOfColumns
{
    
    return 2;
}

#pragma mark - TMQuiltViewDataSource

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [_waterFlow.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TPlatCell *cell = (TPlatCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"TPlatCell"];
    if (!cell) {
        cell = [[TPlatCell alloc] initWithReuseIdentifier:@"TPlatCell"];
    }
    
    cell.layer.cornerRadius = 3.f;
    
    
    TPlatModel *aMode = _waterFlow.dataArray[indexPath.row];
    [cell setCellWithModel:aMode];
    
//    CGRect r = cell.photoView.frame;
//    
//    NSLog(@"%@",NSStringFromCGRect(r));
//    r.origin.y = 0;
//    
//    NSLog(@"%@",NSStringFromCGRect(r));
//    cell.photoView.frame = r;
//    
//    NSLog(@"%@",NSStringFromCGRect(cell.photoView.frame));
    
    
    cell.like_btn.tag = 100 + indexPath.row;
    
    return cell;
}


@end
