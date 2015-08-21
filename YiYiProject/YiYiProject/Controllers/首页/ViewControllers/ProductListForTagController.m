//
//  ProductListForTagController.m
//  YiYiProject
//
//  Created by lichaowei on 15/8/13.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ProductListForTagController.h"

#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"
#import "LWaterflowView.h"
#import "RegisterViewController.h"
#import "ProductModel.h"

@interface ProductListForTagController ()<TMQuiltViewDataSource,WaterFlowDelegate,GgetllocationDelegate>
{
    LWaterflowView *waterFlow;
    
    SORT_SEX_TYPE _sex_type;
    SORT_Discount_TYPE _discount_type;
    NSString *_lowPrice;//低位价格
    NSString *_hightPrice;//高位价格
    int _fenleiIndex;//分类index
    
    GMAPI *mapApi;
    
    NSString *_longtitud;//经度
    NSString *_latitude;//维度
}

@end

@implementation ProductListForTagController

- (void)dealloc
{
    waterFlow.waterDelegate = nil;
    waterFlow.quitView = nil;
    waterFlow = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBCOLOR(235, 235, 235);
    self.myTitleLabel.text = self.tag_name;
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT- 44) waterDelegate:self waterDataSource:self];
    waterFlow.backgroundColor = RGBCOLOR(235, 235, 235);
    [self.view addSubview:waterFlow];
    
    //添加滑动到顶部按钮
//    [self addScroll:waterFlow.quitView topButtonPoint:CGPointMake(DEVICE_WIDTH - 40 - 10, DEVICE_HEIGHT - 10 - 40 - 64)];
//
//    //更新位置
    [self updateLocation];
}

- (void)updateLocation
{
    __weak typeof(self)weakSelf = self;
    [[GMAPI appDeledate]startDingweiWithBlock:^(NSDictionary *dic) {
        
        [weakSelf theLocationDictionary:dic];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[waterFlow.quitView cellAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 100 inSection:0]];
    
    ProductModel *aMode = waterFlow.dataArray[sender.tag - 100];
    
    [LTools animationToBigger:cell.like_btn duration:0.2 scacle:1.5];
    
    NSString *productId = aMode.product_id;
    
    //    __weak typeof(self)weakSelf = self;
    
    __block BOOL isZan = !cell.like_btn.selected;
    
    NSString *api = cell.like_btn.selected ? HOME_PRODUCT_ZAN_Cancel : HOME_PRODUCT_ZAN_ADD;
    
    NSString *post = [NSString stringWithFormat:@"product_id=%@&authcode=%@",productId,[GMAPI getAuthkey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url = api;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        cell.like_btn.selected = isZan;
        aMode.is_like = isZan ? 1 : 0;
        aMode.product_like_num = NSStringFromInt([aMode.product_like_num intValue] + (isZan ? 1 : -1));
        cell.like_label.text = aMode.product_like_num;
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
        aMode.product_like_num = NSStringFromInt([aMode.product_like_num intValue]);
        cell.like_label.text = aMode.product_like_num;
    }];
}

#pragma mark --解析数据

- (void)parseDataWithResult:(NSDictionary *)result
{
    NSMutableArray *arr;
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSArray *list = result[@"list"];
        arr = [NSMutableArray arrayWithCapacity:list.count];
        if ([list isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *aDic in list) {
                
                ProductModel *aModel = [[ProductModel alloc]initWithDictionary:aDic];
                
                [arr addObject:aModel];
            }
            
            
            [waterFlow reloadData:arr pageSize:L_PAGE_SIZE];
        }
        
    }
    
}


#pragma mark---------网络请求

/**
 *  根据标签获取单品列表
 */
- (void)getProductListForTag
{
    //金领时代 40.041951,116.33934
    
    NSString *longtitud = _longtitud ? _longtitud : @"116.33934";
    NSString *latitude = _latitude ? _latitude : @"40.041951";
    
    NSString *url = [NSString stringWithFormat:PRODUCT_LIST_FORTAG,longtitud,latitude,self.tag_id,waterFlow.pageNum,L_PAGE_SIZE,[GMAPI getAuthkey]];
    
    __weak typeof(self)weakSelf = self;
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [weakSelf parseDataWithResult:result];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [waterFlow loadFail];
        
    }];
}


#pragma mark - WaterFlowDelegate

- (void)waterScrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)waterLoadNewData
{
    [self getProductListForTag];
}
- (void)waterLoadMoreData
{
    [self getProductListForTag];
}

- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    [MiddleTools pushToProductDetailWithId:aMode.product_id fromViewController:self lastNavigationHidden:NO hiddenBottom:YES];
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat imageH = 0.f;
//    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
//    if (aMode.images.count >= 1) {
//        
//        
//        NSDictionary *imageDic = aMode.imagelist[0];
//        NSDictionary *middleImage = imageDic[@"540Middle"];
//        float image_width = [middleImage[@"width"]floatValue];
//        float image_height = [middleImage[@"height"]floatValue];
//        
//        if (image_width == 0.0) {
//            image_width = image_height;
//        }
//        float rate = image_height/image_width;
//        
//        imageH = (DEVICE_WIDTH - 6)/2.0*rate + 45;
//        
//    }
//    
//    return imageH;
    
    CGFloat imageH = 0.f;
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    
    NSDictionary *images = (NSDictionary *)aMode.images;
    if (images && [images isKindOfClass:[NSDictionary class]]) {
        
        
        NSDictionary *middleImage = [images objectForKey:@"540Middle"];
        float image_width = [middleImage[@"width"]floatValue];
        float image_height = [middleImage[@"height"]floatValue];
        
        if (image_width == 0.0) {
            image_width = image_height;
        }
        float rate = image_height/image_width;
        
        imageH = (DEVICE_WIDTH - 6)/2.0*rate + 45;
        
    }
    
    return imageH;
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
    [cell setCellWithModel222:aMode];
    
    cell.likeBackBtn.tag = 100 + indexPath.row;
    [cell.likeBackBtn addTarget:self action:@selector(clickToZan:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

@end
