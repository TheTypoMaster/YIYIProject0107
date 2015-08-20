//
//  GTtaiDetailViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/8/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GTtaiDetailViewController.h"

#import "CycleScrollView1.h"//上下滚动
#import "MessageDetailController.h"//活动详情
#import "TMPhotoQuiltViewCell.h"//瀑布流cell
#import "TPlatModel.h"//T台model
#import "LShareSheetView.h"//分享
#import "LWaterFlow2.h"//瀑布流

@interface GTtaiDetailViewController ()<UIScrollViewDelegate,PSWaterFlowDelegate,PSCollectionViewDataSource>
{
    
    TPlatModel *_aModel;
    
    UIButton *_collectButton;//收藏 与 取消收藏
    UIButton *_heartButton;//赞 与 取消赞
    MBProgressHUD *_loading;
    
    UIScrollView *_headerView;
    UILabel *_backLabel;//释放返回
    UILabel *_zanNumLabel;//赞数量label
    UILabel *_commentNumLabel;//评论数量label
    NSArray *_image_urls;//图片链接数组
    
    int _count;//网络请求完成个数
    NSArray *_sameStyleArray;//同款单品
    
    
    LTools *tool_detail;
    
    LWaterFlow2 *_collectionView;//瀑布流
    
    
    
}
@end

@implementation GTtaiDetailViewController


- (void)dealloc
{
    NSLog(@"dealloc %@",self);
    [tool_detail cancelRequest];
    _heartButton = nil;
    _collectButton = nil;
    
    _collectionView.waterDelegate = nil;
    _collectionView.quitView = nil;
    _collectionView = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (self.isTPlatPush) {
        
        self.navigationController.navigationBarHidden = YES;
        
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
    }
    
    self.navigationController.navigationBarHidden = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:self.lastPageNavigationHidden animated:animated];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    [self createNavigationbarTools];//导航条
    
    
    [self addObserver:self forKeyPath:@"_count" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    ;
    
    _collectionView = [[LWaterFlow2 alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64 - 46) waterDelegate:self waterDataSource:self noHeadeRefresh:NO noFooterRefresh:NO];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [_collectionView showRefreshHeader:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MyMethod

#pragma mark - 请求网络数据
//请求T台详情数据
-(void)prepareNetDataForTtaiDetail{
    if (tool_detail) {
        [tool_detail cancelRequest];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self)weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:@"%@&authcode=%@&tt_id=%@",TTAI_DETAIL_V2,[GMAPI getAuthkey],self.tPlat_id];
    
    //测试
    url = @"http://www119.alayy.com/index.php?d=api&c=tplat_v2&m=get_tt_info&page=1&count=20&authcode=An1XLlEoBuBR6gSZVeUI31XwBOZXolanAi9SY1cyUWZVa1JhVDRQYwE2AzYAbQ19CTg=&tt_id=26";
    
    tool_detail = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool_detail requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            TPlatModel *aModel1 = [[TPlatModel alloc]initWithDictionary:result];
            weakSelf.theModel = aModel1;
            _aModel = aModel1;
            [self setValue:[NSNumber numberWithInt:_count + 1] forKeyPath:@"_count"];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}

//请求T台关联的商场
-(void)prepareNetDataForStore{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *longitude = [self.locationDic stringValueForKey:@"long"];
    NSString *latitude = [self.locationDic stringValueForKey:@"lat"];
    
    NSString *url = [NSString stringWithFormat:@"%@&authcode=%@&longitude=%@&latitude=%@&tt_id=%@",TTAI_STORE,[GMAPI getAuthkey],longitude,latitude,self.tPlat_id];
    //测试
    url = @"http://www119.alayy.com/index.php?d=api&c=tplat_v2&m=get_relation_tts&page=1&count=20&authcode=An1XLlEoBuBR6gSZVeUI31XwBOZXolanAi9SY1cyUWZVa1JhVDRQYwE2AzYAbQ19CTg=&longitude=116.402982&latitude=39.912950&tt_id=26";
    
    
    tool_detail = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool_detail requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSLog(@"result %@",result);
        NSArray *list = result[@"list"];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:list.count];
        for (NSDictionary *aDic in list) {
            ProductModel *aModel = [[ProductModel alloc]initWithDictionary:aDic];
            [temp addObject:aModel];
        }
        _sameStyleArray = [NSArray arrayWithArray:temp];
        
        [self setValue:[NSNumber numberWithInt:_count + 1] forKeyPath:@"_count"];
        NSLog(@"........................%d",_count);

        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}

#pragma mark - 定位

- (void)getCurrentLocation
{
    __weak typeof(self)weakSelf = self;
    [[GMAPI appDeledate]startDingweiWithBlock:^(NSDictionary *dic) {
        
        [weakSelf theLocationDictionary:dic];
    }];
    
}
- (void)theLocationDictionary:(NSDictionary *)dic{
    
    NSLog(@"当前坐标-->%@",dic);
    
    
}

#pragma mark - 创建视图


//创建收藏分享按钮
- (void)createNavigationbarTools
{
    
    UIButton *rightView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    rightView.backgroundColor=[UIColor clearColor];
    
    //收藏的
    _collectButton = [[UIButton alloc]initWithframe:CGRectMake(74, 0, 44, 44) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"productDetail_collect_normal"] selectedImage:[UIImage imageNamed:@"productDetail_collect_selected"] target:self action:@selector(clickToCollect:)];
    _collectButton.center = CGPointMake(rightView.width / 2.f, _collectButton.center.y);
    [_collectButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    
    //分享
    
    UIButton *shareButton = [[UIButton alloc] initWithframe:CGRectMake(rightView.width - 44, 0, 44, 44) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"product_share"] selectedImage:nil target:self action:@selector(clickToShare:)];
    [shareButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    [rightView addSubview:shareButton];
    [rightView addSubview:_collectButton];
    
    UIBarButtonItem *comment_item=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    
    self.navigationItem.rightBarButtonItem = comment_item;
    
}

//收藏
-(void)clickToCollect:(UIButton*)sender{
    
}


/*
 分享
 */

- (void)clickToShare:(UIButton *)sender
{
    NSString *productString = [NSString stringWithFormat:SHARE_PRODUCT_DETAIL,self.tPlat_id];
    
    NSString *safeString = [LTools safeString:self.theModel.tPlat_name];
    NSString *title = safeString.length > 0 ? safeString : @"衣加衣";
    
    [[LShareSheetView shareInstance] showShareContent:_aModel.tPlat_name title:title shareUrl:productString shareImage:self.bigImageView.image targetViewController:self];
    [[LShareSheetView shareInstance]actionBlock:^(NSInteger buttonIndex, Share_Type shareType) {
        
        if (shareType == Share_QQ) {
            
            NSLog(@"Share_QQ");
            
        }else if (shareType == Share_QQZone){
            
            NSLog(@"Share_QQZone");
            
        }else if (shareType == Share_WeiBo){
            
            NSLog(@"Share_WeiBo");
            
        }else if (shareType == Share_WX_HaoYou){
            
            NSLog(@"Share_WX_HaoYou");
            
        }else if (shareType == Share_WX_PengYouQuan){
            
            NSLog(@"Share_WX_PengYouQuan");
            
        }
        
    }];
}




/**
 *  监控 单品详情 和 相似单品都请求完再显示
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"keyPath %@",change);
    
    NSNumber *num = [change objectForKey:@"new"];
    if ([num intValue] == 2) {
        
        if (_aModel) {
            _aModel.sameStyleArray = _sameStyleArray;
        }
    }
}




//图片高度
- (CGFloat)thumbImageHeightForArr:(NSArray *)imagesArr
{
    CGFloat aHeight = 0.f;
    CGFloat aWidth = 0.f;
    if (imagesArr.count >= 1) {
        
        NSDictionary *imageDic = imagesArr[0];
        NSDictionary *originalImage = imageDic[@"540Middle"];
        
        aHeight = [originalImage[@"height"] floatValue];
        aWidth = [originalImage[@"width"] floatValue];
    }
    
    return aHeight * (DEVICE_WIDTH / aWidth);
}

/**
 *  底部工具栏
 */
- (void)createBottomView
{
    //导航按钮
    
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 64 - 60, DEVICE_WIDTH, 60)];
    bottom.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:bottom];

    
}


/*
 原图
 */
- (NSString *)originalImageForArr:(NSArray *)imagesArr
{
    if (imagesArr.count >= 1) {
        
        NSDictionary *imageDic = imagesArr[0];
        NSDictionary *originalImage = imageDic[@"original"];
        
        
        return originalImage[@"src"];
    }
    
    return @"";
}


/**
 *  赞数量大于1000显示 k
 *
 *  @param zanNum
 *
 *  @return
 */
- (NSString *)zanNumStringForNum:(NSString *)zanNum
{
    int num = [zanNum intValue];
    if (num >= 1000) {
        
        return [NSString stringWithFormat:@"%.1fk",num * 0.001];
    }
    return zanNum;
}

/**
 *  更新赞的状态
 *
 *  @param isZan 是否赞
 */
- (void)updateZanState:(BOOL)isZan
{
    if (isZan) {
        _heartButton.selected = YES;
        _aModel.tPlat_like_num = NSStringFromInt([_aModel.tPlat_like_num intValue] + 1);
    }else
    {
        _heartButton.selected = NO;
        _aModel.tPlat_like_num = NSStringFromInt([_aModel.tPlat_like_num intValue] - 1);
    }
    _zanNumLabel.text = [self zanNumStringForNum:_aModel.tPlat_like_num];
    
}







/**
 *  跳转活动详情页
 */
- (void)clickToActivity:(UIButton *)sender
{
    NSString *activityId = _aModel.official_activity[@"id"];
    MessageDetailController *detail = [[MessageDetailController alloc]init];
    detail.isActivity = YES;
    detail.msg_id = activityId;
    [self.navigationController pushViewController:detail animated:YES];
}

/**
 *  评论页面
 *
 *  @param sender
 */
- (void)clickToComment:(UIButton *)sender
{
    
}





#pragma - mark PSWaterFlowDelegate <NSObject>
- (void)waterLoadNewDataForWaterView:(PSCollectionView *)waterView
{
    //请求单品详情
    [self prepareNetDataForTtaiDetail];
    
    //请求关联商场
    [self prepareNetDataForStore];
    _count = 0;
    [self getCurrentLocation];
    
}
- (void)waterLoadMoreDataForWaterView:(PSCollectionView *)waterView
{
    [self prepareNetDataForTtaiDetail];
}

- (void)waterDidSelectRowAtIndexPath:(NSInteger)index
{
    ProductModel *aMode = _collectionView.dataArray[index];
    [MiddleTools pushToProductDetailWithId:aMode.product_id fromViewController:self lastNavigationHidden:NO hiddenBottom:YES];
}

- (void)waterScrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)waterScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    
}

#pragma mark - PSCollectionViewDataSource <NSObject>

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return _collectionView.dataArray.count;
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView1 cellForRowAtIndex:(NSInteger)index
{
//    ProductCell *cell = (ProductCell *)[collectionView1 dequeueReusableViewForClass:[ProductCell class]];
//    
//    if(cell == nil) {
//        
//        cell = [[ProductCell alloc]init];
//    }
//    
//    cell.cellStyle = CELLSTYLE_BrandRecommendList;
//    cell.photoView.userInteractionEnabled = NO;
//    ProductModel *aMode = _collectionView.dataArray[index];
//    [cell setCellWithModel222:aMode];
    
    
    PSCollectionViewCell *cell = [collectionView1 dequeueReusableViewForClass:[PSCollectionViewCell class]];
    if (!cell) {
        cell = [[PSCollectionViewCell alloc]init];
    }
    
    
    
    return cell;
}
- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    CGFloat imageH = 0.f;
    ProductModel *aMode = _collectionView.dataArray[index];
    
    NSDictionary *images = (NSDictionary *)aMode.images;
    if (images && [images isKindOfClass:[NSDictionary class]]) {
        
        
        NSDictionary *middleImage = [images objectForKey:@"540Middle"];
        float image_width = [middleImage[@"width"]floatValue];
        float image_height = [middleImage[@"height"]floatValue];
        
        if (image_width == 0.0) {
            image_width = image_height;
        }
        float rate = image_height/image_width;
        
        imageH = (DEVICE_WIDTH - 6)/2.0*rate + 25;
        
    }
    
    
    return imageH;
}









@end
