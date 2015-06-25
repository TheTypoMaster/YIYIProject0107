//
//  BigProductViewController.m
//  YiYiProject
//
//  Created by lichaowei on 15/6/9.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BigProductViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "ProductModel.h"
#import "ProductDetailController.h"

#import "FilterView.h"
#import "DataManager.h"

/**
 *  修改成大图模式
 */
#import "RefreshTableView.h"
#import "BigProductCell.h"
@interface BigProductViewController ()<GgetllocationDelegate,RefreshDelegate,UITableViewDataSource>
{
    //    LWaterflowView *waterFlow;
    
    SORT_SEX_TYPE sex_type;
    SORT_Discount_TYPE discount_type;
    
    GMAPI *mapApi;
    
    NSString *_longtitud;//经度
    NSString *_latitude;//维度
    
    RefreshTableView *_tableView;
}

@end

@implementation BigProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBCOLOR(235, 235, 235);
    
    //创建tableView
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,DEVICE_HEIGHT - 64)];
    _tableView.refreshDelegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //读取本地缓存数据
    NSDictionary *result = [DataManager getCacheDataForType:Cache_DeserveBuy];
    if (result) {
        
        [self parseDataWithResult:result];
    }
    
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(17, 17, 38, 38);
    [filterButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [filterButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [filterButton setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
    
    [self.view addSubview:filterButton];
    [filterButton addTarget:self action:@selector(clickToFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加滑动到顶部按钮
    [self addScroll:_tableView topButtonPoint:CGPointMake(DEVICE_WIDTH - 40 - 10, DEVICE_HEIGHT - 10 - 40 - 49 - 64)];
    
    //更新位置
    [self updateLocation];
    
    //10分钟更新一次位置
    [NSTimer scheduledTimerWithTimeInterval:10 * 60 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
    
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
    
    [_tableView showRefreshHeader:YES];
    
}

#pragma mark 事件处理

- (void)updateLocation
{
    NSLog(@"updateLocation-----");
    
    __weak typeof(self)weakSelf = self;
    [[GMAPI appDeledate]startDingweiWithBlock:^(NSDictionary *dic) {
        
        [weakSelf theLocationDictionary:dic];
    }];
}


/**
 *  赞 取消赞 收藏 取消收藏
 */

- (void)clickToZan:(UIButton *)zan
{
    if (![LTools isLogin:self.rootViewController]) {
        
        return;
    }
    //直接变状态
    //更新数据
    
    BigProductCell *cell = (BigProductCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:zan.tag - 100 inSection:0]];

    ProductModel *aMode = _tableView.dataArray[zan.tag - 100];
    
    NSString *productId = aMode.product_id;

    [LTools animationToBigger:cell.xinButton duration:0.2 scacle:1.5];

    UIButton *sender = cell.xinButton;
    
//    __weak typeof(self)weakSelf = self;

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
        cell.zanNumLable.text = aMode.product_like_num;

    } failBlock:^(NSDictionary *failDic, NSError *erro) {

        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);

        aMode.product_like_num = NSStringFromInt([aMode.product_like_num intValue]);
        cell.zanNumLable.text = aMode.product_like_num;
    }];
}

/**
 *  筛选
 *
 *  @param sender
 */
- (void)clickToFilter:(UIButton *)sender
{
    __weak typeof(_tableView)weakTable = _tableView;
//    [[FilterView shareInstance] showFilterBlock:^(SORT_SEX_TYPE sextType1, SORT_Discount_TYPE discountType1) {
//        sex_type = sextType1;
//        discount_type = discountType1;
//        
//        [weakTable showRefreshHeader:NO];
//        
//    }];
    
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
            
            
            [_tableView reloadData:arr pageSize:L_PAGE_SIZE];
        }
        
    }
    
}


#pragma mark---------网络请求

/**
 *  long 经度 非空
 lat 维度 非空
 sex 性别 1 女士 2男士 0 不按照性别 默认为0
 discount 折扣排序 1 是 0 否 默认为0
 */
- (void)deserveBuyForSex:(SORT_SEX_TYPE)sortType
                discount:(SORT_Discount_TYPE)discountType
                    page:(int)pageNum
{
    //    NSString *longtitud = @"116.42111721";
    //    NSString *latitude = @"39.90304099";
    
    
    //金领时代 40.041951,116.33934
    
    NSString *longtitud = _longtitud ? _longtitud : @"116.33934";
    NSString *latitude = _latitude ? _latitude : @"40.041951";
    
    NSString *url = [NSString stringWithFormat:HOME_DESERVE_BUY,longtitud,latitude,sortType,discountType,pageNum,L_PAGE_SIZE,[GMAPI getAuthkey]];
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(RefreshTableView *)weakTable = _tableView;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [weakSelf parseDataWithResult:result];
        
        if (pageNum == 1) {
            
            //本地存储
            
            //            [LTools cache:result ForKey:CACHE_DESERVE_BUY];
            
            [DataManager cacheDataType:Cache_DeserveBuy content:result];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [weakTable loadFail];
        
    }];
}

#pragma mark - 代理

#pragma - mark RefreshDelegate

-(void)loadNewData
{
    [self deserveBuyForSex:sex_type discount:discount_type page:_tableView.pageNum];
}

-(void)loadMoreData
{
    [self deserveBuyForSex:sex_type discount:discount_type page:_tableView.pageNum];
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    //调转至老版本 详情页
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProductModel *aMode = _tableView.dataArray[indexPath.row];

    //    [LTools alertText:aMode.product_name];

    ProductDetailController *detail = [[ProductDetailController alloc]init];
    detail.product_id = aMode.product_id;
    detail.hidesBottomBarWhenPushed = YES;
//    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell*)[waterFlow.quitView cellAtIndexPath:indexPath];
//    detail.theHomeBuyVcModel = aMode;
//    detail.theHomeBuyVcProductCell = cell;

    [self.rootViewController.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    CGFloat imageH = 0.f;
    ProductModel *aMode = _tableView.dataArray[indexPath.row];
    if (aMode.imagelist.count >= 1) {
        
        NSDictionary *imageDic = aMode.imagelist[0];
        NSDictionary *middleImage = imageDic[@"540Middle"];
        float image_width = [middleImage[@"width"]floatValue];
        float image_height = [middleImage[@"height"]floatValue];
        
        imageH = [LTools heightForImageHeight:image_height imageWidth:image_width originalWidth:DEVICE_WIDTH];
    }
    
    return imageH;
}

#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"BigProductCell";
    BigProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        
        cell = [[BigProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    ProductModel *aModel = [_tableView.dataArray objectAtIndex:indexPath.row];
    
    [cell setCellWithModel:aModel];
    
    cell.zanButton.tag = 100 + indexPath.row;
    [cell.zanButton addTarget:self action:@selector(clickToZan:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}


@end
