//
//  GmyTtaiViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/5/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GmyTtaiViewController.h"
#import "GEditMyTtaiViewController.h"
#import "LWaterflowView.h"
#import "TPlatCell.h"

#import "PropertyImageView.h"

#import "MJPhoto.h"
#import "LPhotoBrowser.h"

@interface GmyTtaiViewController ()<TMQuiltViewDataSource,WaterFlowDelegate>
{
    UIView *_backView_water;
    LWaterflowView *_waterFlow;
}
@end

@implementation GmyTtaiViewController

- (void)dealloc
{
    _waterFlow.waterDelegate = nil;
    _waterFlow.quitView.dataSource = nil;
    _waterFlow = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTitleLabel.text = @"我的T台";
    self.myTitleLabel.textColor = RGBCOLOR(252, 76, 139);
    self.rightString = @"编辑";
    
    [self creatWaterFlowView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserTtai) name:NOTIFICATION_TTAI_EDIT_SUCCESS object:nil];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 通知方法
-(void)updateUserTtai{
    _waterFlow.pageNum = 1;
    [_waterFlow.dataArray removeAllObjects];
    [self waterLoadNewData];
}


//初始化瀑布流
-(void)creatWaterFlowView{
    
    //瀑布流相关
    _waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64) waterDelegate:self waterDataSource:self noHeadeRefresh:NO noFooterRefresh:NO];
    _waterFlow.backgroundColor = RGBCOLOR(235, 235, 235);
    [self.view addSubview:_waterFlow];
    _waterFlow.pageNum = 1;
    [_waterFlow.dataArray removeAllObjects];
    [self waterLoadNewData];
}



-(void)rightButtonTap:(UIButton *)sender{
    GEditMyTtaiViewController *ccc = [[GEditMyTtaiViewController alloc]init];
    [self.navigationController pushViewController:ccc animated:YES];
}

//T台赞 或 取消

- (void)zanTTaiDetail:(UIButton *)zan_btn
{
    if (![LTools isLogin:self]) {
        return;
    }
    
    [LTools animationToBigger:zan_btn duration:0.2 scacle:1.5];
    
    
    NSString *authkey = [GMAPI getAuthkey];
    
    TPlatModel *detail_model = _waterFlow.dataArray[zan_btn.tag - 100];
    TPlatCell *cell = (TPlatCell *)[_waterFlow.quitView cellAtIndexPath:[NSIndexPath indexPathForRow:zan_btn.tag - 100 inSection:0]];
    
    NSString *t_id = detail_model.tt_id;
    NSString *post = [NSString stringWithFormat:@"tt_id=%@&authcode=%@",t_id,authkey];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url;
    
    BOOL zan = zan_btn.selected ? NO : YES;
    
    
    if (zan) {
        url = TTAI_ZAN;
    }else
    {
        url = TTAI_ZAN_CANCEL;
    }

    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        zan_btn.selected = !zan_btn.selected;
        
        int like_num = [detail_model.tt_like_num intValue];
        detail_model.tt_like_num = [NSString stringWithFormat:@"%d",zan ? like_num + 1 : like_num - 1];
        detail_model.is_like = zan ? 1 : 0;
        cell.like_label.text = detail_model.tt_like_num;

    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        detail_model.tt_like_num = NSStringFromInt([detail_model.tt_like_num intValue]);
        cell.like_label.text = detail_model.tt_like_num;
        
    }];
}


/**
 *  获取个人T台
 */
- (void)getUserTPlat
{
    
    NSString *userId = [GMAPI getUid];
    
    //请求网络数据
    NSString *api = [NSString stringWithFormat:@"%@&page=%d&count=%d&user_id=%@&authcode=%@",TTAi_LIST,_waterFlow.pageNum,L_PAGE_SIZE,userId,[GMAPI getAuthkey]];
    NSLog(@"请求的接口%@",api);
    
    LTools *cc = [[LTools alloc]initWithUrl:api isPost:NO postData:nil];
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
        
        [_waterFlow reloadData:arr pageSize:L_PAGE_SIZE];
        
        _waterFlow.isReloadData = NO;
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [_waterFlow loadFail];
    }];
    
}

#pragma mark - 事件处理

#pragma mark - _waterFlowDelegate

- (void)waterScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    NSLog(@"waterScrollViewDidEndDragging1");
    
    if (_waterFlow.isReloadData && _waterFlow.reloading == NO) {
        
        _waterFlow.pageNum = 1;
        [self waterLoadNewData];
        
        NSLog(@"waterScrollViewDidEndDragging1");
        
    }
}

- (void)waterLoadNewData
{
    [self getUserTPlat];
}
- (void)waterLoadMoreData
{
    [self getUserTPlat];
}

//点击方法
- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPlatCell *cell = (TPlatCell *)[_waterFlow.quitView cellAtIndexPath:indexPath];
    
    TPlatModel *aModel = (TPlatModel *)[_waterFlow.dataArray objectAtIndex:indexPath.row];
    NSDictionary *params = @{@"button":cell.like_btn,
                             @"label":cell.like_label,
                             @"model":aModel};
    [MiddleTools pushToTPlatDetailWithInfoId:aModel.tt_id fromViewController:self lastNavigationHidden:NO hiddenBottom:YES extraParams:params updateBlock:nil];
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
    
    return (DEVICE_WIDTH-30)/2.0*rate + 30;
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
    
    cell.needIconImage = NO;
    
    TPlatModel *aMode = _waterFlow.dataArray[indexPath.row];
    [cell setCellWithModel:aMode];
    
    [cell.like_btn addTarget:self action:@selector(zanTTaiDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *imageUrl = aMode.image[@"url"];
    
    [cell.photoView setImageUrls:@[imageUrl] infoId:aMode.tt_id aModel:aMode];
    
    cell.like_btn.tag = 100 + indexPath.row;
    
    return cell;
}

@end
