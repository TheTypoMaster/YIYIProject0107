//
//  MyCollectionController.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyCollectionController.h"

#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"

#import "LWaterflowView.h"

#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "ProductModel.h"

#import "ProductDetailController.h"


@interface MyCollectionController ()<TMQuiltViewDataSource,WaterFlowDelegate,UIScrollViewDelegate>
{
    LWaterflowView *waterFlow;
    
    SORT_SEX_TYPE sex_type;
    SORT_Discount_TYPE discount_type;

    LTools *tool_collection_list;//收藏列表
    
    NSString *_latitude;//维度
    NSString *_longtitud;//经度
}

@end

@implementation MyCollectionController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBCOLOR(200, 200, 200);
    
    self.myTitleLabel.text = @"我的收藏——old";
    
    //单品、商家、品牌
    
    UIScrollView *backScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 90)];
    backScroll.delegate = self;
    [self.view addSubview:backScroll];
    backScroll.contentSize = CGSizeMake(DEVICE_WIDTH * 3, DEVICE_HEIGHT);
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, 0, backScroll.width, backScroll.height) waterDelegate:self waterDataSource:self];
    waterFlow.backgroundColor = RGBCOLOR(235, 235, 235);
    [backScroll addSubview:waterFlow];
    
//    [waterFlow showRefreshHeader:YES];
    
    __weak typeof(self)weakSelf = self;
    [[GMAPI appDeledate]startDingweiWithBlock:^(NSDictionary *dic) {
        
        [weakSelf theLocationDictionary:dic];
    }];
    
}


#pragma - mark 地图坐标

- (void)theLocationDictionary:(NSDictionary *)dic{
    
    NSLog(@"当前坐标-->%@",dic);
    
    CGFloat lat = [dic[@"lat"]doubleValue];;
    CGFloat lon = [dic[@"long"]doubleValue];
    
    _latitude = NSStringFromFloat(lat);
    _longtitud = NSStringFromFloat(lon);
    
    [waterFlow showRefreshHeader:YES];
    
}


- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
    waterFlow.waterDelegate = nil;
    waterFlow = nil;
    [tool_collection_list cancelRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 事件处理

/**
 *  赞 取消赞 收藏 取消收藏
 */

- (void)clickToZan:(UIButton *)sender
{
    if (![LTools isLogin:self]) {
        
        return;
    }
    //直接变状态
    //更新数据
    
    [LTools animationToBigger:sender duration:0.2 scacle:1.5];
    
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[waterFlow.quitView cellAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 100 inSection:0]];
    //    cell.like_label.text = @"";
    
    ProductModel *aMode = waterFlow.dataArray[sender.tag - 100];
    
    NSString *productId = aMode.product_id;
    
    __weak typeof(self)weakSelf = self;
    
    __block BOOL isZan = !sender.selected;
    
    NSString *api = sender.selected ? HOME_PRODUCT_ZAN_Cancel : HOME_PRODUCT_ZAN_ADD;
    
    NSString *post = [NSString stringWithFormat:@"product_id=%@&authcode=%@",productId,[GMAPI getAuthkey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url = api;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        sender.selected = isZan;
        aMode.is_like = isZan ? 1 : 0;
        aMode.product_like_num = NSStringFromInt([aMode.product_like_num intValue] + (isZan ? 1 : -1));
        cell.like_label.text = aMode.product_like_num;
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [GMAPI showAutoHiddenMBProgressWithText:failDic[RESULT_INFO] addToView:weakSelf.view];
        if ([failDic[RESULT_CODE] intValue] == -11) {
            
            [LTools showMBProgressWithText:failDic[RESULT_INFO] addToView:weakSelf.view];
        }
        aMode.product_like_num = NSStringFromInt([aMode.product_like_num intValue]);
        cell.like_label.text = aMode.product_like_num;
    }];
}


/**
 *  我的收藏
 */
- (void)getMyCollection
{
    if (tool_collection_list) {
        [tool_collection_list cancelRequest];
    }
    
    NSString *longtitud = _longtitud ? _longtitud : @"116.42111721";
    NSString *latitude = _latitude ? _latitude : @"39.90304099";
    
    NSString *url = [NSString stringWithFormat:GET_MY_CILLECTION,longtitud,latitude,waterFlow.pageNum,L_PAGE_SIZE,[GMAPI getAuthkey]];
    tool_collection_list = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool_collection_list requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSMutableArray *arr;
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *list = result[@"list"];
            arr = [NSMutableArray arrayWithCapacity:list.count];
            if ([list isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *aDic in list) {
                    
                    ProductModel *aModel = [[ProductModel alloc]initWithDictionary:aDic];
                    
                    [arr addObject:aModel];
                }
                
            }
            
            [waterFlow reloadData:arr pageSize:L_PAGE_SIZE];
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
        [GMAPI showAutoHiddenMBProgressWithText:failDic[RESULT_INFO] addToView:self.view];
        
        [waterFlow loadFail];
        
    }];
}


#pragma mark - WaterFlowDelegate

- (void)waterLoadNewData
{
    [self getMyCollection];
}
- (void)waterLoadMoreData
{
    [self getMyCollection];
}

- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    
    //    [LTools alertText:aMode.product_name];
    
    ProductDetailController *detail = [[ProductDetailController alloc]init];
    detail.product_id = aMode.product_id;
    detail.hidesBottomBarWhenPushed = YES;
    
    
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell*)[waterFlow.quitView cellAtIndexPath:indexPath];
    detail.theMyshoucangProductModel = aMode;
    detail.theMyshoucangProductCell = cell;
    
    
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    CGFloat aHeight = 0.f;
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    if (aMode.imagelist.count >= 1) {
        
        NSDictionary *imageDic = aMode.imagelist[0];
        NSDictionary *middleImage = imageDic[@"540Middle"];
        //        CGFloat aWidth = [middleImage[@"width"]floatValue];
        aHeight = [middleImage[@"height"]floatValue];
    }
    
    return aHeight / 2.f + 33;
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
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    
    cell.layer.cornerRadius = 3.f;
    
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    [cell setCellWithModel:aMode];
    
    cell.like_btn.tag = 100 + indexPath.row;
    [cell.like_btn addTarget:self action:@selector(clickToZan:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

@end
