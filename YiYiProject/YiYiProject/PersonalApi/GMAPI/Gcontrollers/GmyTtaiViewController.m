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
#import "TTaiDetailController.h"
#import "TPlatCell.h"

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
    _waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) waterDelegate:self waterDataSource:self noHeadeRefresh:NO noFooterRefresh:NO];
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



/**
 *  获取个人T台
 */
- (void)getUserTPlat
{
    
    NSString *userId = [GMAPI getUid];
    
    //请求网络数据
    NSString *api = [NSString stringWithFormat:@"%@&page=%d&count=%d&user_id=%@&authcode=%@",TTAi_LIST,_waterFlow.pageNum,L_PAGE_SIZE,userId,[GMAPI getAuthkey]];
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
        
        [_waterFlow reloadData:arr pageSize:L_PAGE_SIZE];
        
        _waterFlow.isReloadData = NO;
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [_waterFlow loadFail];
    }];
    
}




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
    
    cell.like_btn.tag = 100 + indexPath.row;
    
    return cell;
}

@end
