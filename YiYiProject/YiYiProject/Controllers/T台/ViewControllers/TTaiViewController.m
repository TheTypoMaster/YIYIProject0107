//
//  TTaiViewController.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/10.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "TTaiViewController.h"
#import "LoginViewController.h"
#import "PublishHuatiController.h"

#import "TTPublishViewController.h"
#import "TTaiDetailController.h"

#import "LWaterflowView.h"
#import "TPlatModel.h"
#import "TPlatCell.h"

#import "DataManager.h"

@interface TTaiViewController ()<TMQuiltViewDataSource,WaterFlowDelegate>
{
    LWaterflowView *waterFlow;
}

@end

@implementation TTaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myTitleLabel.text = @"T台";
    
    [self createNavigationbarTools];
    
    
    waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - 49 - 44) waterDelegate:self waterDataSource:self];
    waterFlow.backgroundColor = RGBCOLOR(240, 230, 235);
    [self.view addSubview:waterFlow];
    
    
//    NSDictionary *dic = [LTools cacheForKey:CACHE_TPLAT];
//    if (dic) {
//        
//        [self parseDataWithResult:dic];
//    }
    
    NSDictionary *dic = [DataManager getCacheDataForType:Cache_TPlat];
    if (dic) {
        [self parseDataWithResult:dic];
    }
    
    [waterFlow showRefreshHeader:YES];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTTai:) name:NOTIFICATION_TTAI_PUBLISE_SUCCESS object:nil];
}

#pragma mark 事件处理

- (void)updateTTai:(NSNotification *)noti
{
    [waterFlow showRefreshHeader:YES];
}

/**
 *  发布 T 台
 *
 *  @param sender <#sender description#>
 */
- (void)clickToPhoto:(UIButton *)sender
{
    
    //判断是否登录
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
        
        LoginViewController *login = [[LoginViewController alloc]init];
        
        UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
        
        [self presentViewController:unVc animated:YES completion:nil];
        
        return;
    }
    
    TTPublishViewController *publishT = [[TTPublishViewController alloc]init];
    publishT.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publishT animated:YES];
}

- (void)clickToPush:(UIButton *)sender
{
    LoginViewController *login = [[LoginViewController alloc]init];
    
    UINavigationController *unvc = [[UINavigationController alloc]initWithRootViewController:login];
    
    [self presentViewController:unvc animated:YES completion:nil];
}

- (void)clickToPublish:(UIButton *)sender
{
    PublishHuatiController *publish = [[PublishHuatiController alloc]init];
    publish.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publish animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createNavigationbarTools
{
    
    UIButton *rightView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightView.backgroundColor=[UIColor clearColor];
    
    UIButton *heartButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [heartButton addTarget:self action:@selector(clickToPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [heartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [heartButton setImage:[UIImage imageNamed:@"rizhi_xiangji"] forState:UIControlStateNormal];
    [heartButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    [rightView addSubview:heartButton];
    
    UIBarButtonItem *comment_item=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = comment_item;
}

#pragma mark 数据解析

- (void)parseDataWithResult:(NSDictionary *)result
{
    NSMutableArray *arr;
    int total;
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSArray *list = result[@"list"];
        
        total = [result[@"total"]intValue];
        arr = [NSMutableArray arrayWithCapacity:list.count];
        if ([list isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *aDic in list) {
                
                TPlatModel *aModel = [[TPlatModel alloc]initWithDictionary:aDic];
                
                [arr addObject:aModel];
            }
            
        }
        
        [waterFlow reloadData:arr pageSize:L_PAGE_SIZE];
        
    }
}

#pragma mark 网络请求

//T台赞 或 取消

- (void)zanTTaiDetail:(UIButton *)zan_btn
{
    if (![LTools isLogin:self]) {
        return;
    }
    
    NSString *authkey = [GMAPI getAuthkey];
    
    TPlatModel *detail_model = waterFlow.dataArray[zan_btn.tag - 100];
    NSString *t_id = detail_model.tt_id;
    NSString *post = [NSString stringWithFormat:@"tt_id=%@&authcode=%@",t_id,authkey];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString * url = TTAI_ZAN;
    
    
    TPlatCell *cell = (TPlatCell *)[waterFlow.quitView cellAtIndexPath:[NSIndexPath indexPathForRow:zan_btn.tag - 100 inSection:0]];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        zan_btn.selected = YES;
        
        int like_num = [detail_model.tt_like_num intValue];
        detail_model.tt_like_num = [NSString stringWithFormat:@"%d",like_num + 1];
        cell.like_label.text = detail_model.tt_like_num;
        detail_model.is_like = 1;
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        if ([failDic[RESULT_CODE] intValue] == -11 || [failDic[RESULT_CODE] intValue] == 2003) {
            [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
        }
        
    }];
}


- (void)getTTaiData
{
    
    __weak typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:TTAI_LIST,waterFlow.pageNum,L_PAGE_SIZE,[GMAPI getAuthkey]];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [weakSelf parseDataWithResult:result];
        
    
        
        if (waterFlow.pageNum == 1) {
//            [LTools cache:result ForKey:CACHE_TPLAT];
            
            [DataManager cacheDataType:Cache_TPlat content:result];
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [waterFlow loadFail];
        
    }];
}

#pragma mark - WaterFlowDelegate

- (void)waterLoadNewData
{
    [self getTTaiData];
}
- (void)waterLoadMoreData
{
    [self getTTaiData];
}

- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPlatModel *aModel = waterFlow.dataArray[indexPath.row];
    TTaiDetailController *t_detail = [[TTaiDetailController alloc]init];
    t_detail.tt_id = aModel.tt_id;
    t_detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:t_detail animated:YES];
    
}

- (CGFloat)height:(CGFloat)aHeight aWidth:(CGFloat)aWidth
{
    CGFloat realWidth = (DEVICE_WIDTH - 30 / 3);
    
    return realWidth * aHeight / aWidth;
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    TPlatModel *aModel = waterFlow.dataArray[indexPath.row];
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
    return [waterFlow.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TPlatCell *cell = (TPlatCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"TPlatCell"];
    if (!cell) {
        cell = [[TPlatCell alloc] initWithReuseIdentifier:@"TPlatCell"];
    }
    
    cell.layer.cornerRadius = 3.f;
    
    TPlatModel *aMode = waterFlow.dataArray[indexPath.row];
    [cell setCellWithModel:aMode];
    cell.like_btn.tag = 100 + indexPath.row;
    [cell.like_btn addTarget:self action:@selector(zanTTaiDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


@end
