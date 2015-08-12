//
//  GTtaiListViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/8/12.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GTtaiListViewController.h"
#import "LoginViewController.h"

#import "GTTPublishViewController.h" //t台发布

#import "RefreshTableView.h"

#import "TTaiBigPhotoCell.h" //t台样式一

#import "TTaiBigPhotoCell2.h"//t台样式二

#import "TPlatModel.h"
#import "DataManager.h"
#import "LPhotoBrowser.h"
#import "MJPhoto.h"

#import "TDetailModel.h"
#import "AnchorPiontView.h"//锚点view

#import "GStorePinpaiViewController.h"
#import "ProductDetailController.h"


#import "CycleScrollView.h"

@interface GTtaiListViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    LPhotoBrowser *browser;
    BOOL isFirst;
    
    CGFloat lastContenOffsetY;
}

@property (nonatomic ,strong) CycleScrollView *topScrollView;

@end

@implementation GTtaiListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"BigPhotoTTaiViewController viewWillAppear");
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTitleLabel.text = @"T台";
    [self createNavigationbarTools];
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,DEVICE_HEIGHT - 64)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    
    [self creatUpscrollView];
    _table.tableHeaderView = self.topScrollView;
    
    
    NSDictionary *dic = [DataManager getCacheDataForType:Cache_TPlat];
    if (dic) {
        [self parseDataWithResult:dic];
    }
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.2];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTTai:) name:NOTIFICATION_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTTai:) name:NOTIFICATION_LOGOUT object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTTai:) name:NOTIFICATION_TTAI_PUBLISE_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiverNotify2:) name:NOTIFICATION_TPLATDETAIL_SHOW object:nil];
    
    
    //添加滑动到顶部按钮
    [self addScroll:_table topButtonPoint:CGPointMake(DEVICE_WIDTH - 40 - 10, DEVICE_HEIGHT - 10 - 40 - 49 - 64)];
}



#pragma mark - MyMethod
-(void)creatUpscrollView{
    NSArray *colorArry = @[[UIColor orangeColor],[UIColor purpleColor],[UIColor redColor]];
    NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 125)];
        view.backgroundColor = colorArry[i];
        [viewsArray addObject:view];
    }
    
    
    self.topScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 125) animationDuration:2];
    self.topScrollView.scrollView.showsHorizontalScrollIndicator = FALSE;
    
    self.topScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    
    NSInteger count = viewsArray.count;
    self.topScrollView.totalPagesCount = ^NSInteger(void){
        return count;
    };
    
    __weak typeof (self)bself = self;
    self.topScrollView.TapActionBlock = ^(NSInteger pageIndex){
        [bself cycleScrollDidClickedWithIndex:pageIndex];
    };
    
}



-(void)cycleScrollDidClickedWithIndex:(NSInteger)index{
    NSLog(@"%ld",index);
}





- (void)receiverNotify:(NSNotification *)notify
{
    NSLog(@"隐藏");
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)receiverNotify2:(NSNotification *)notify
{
    NSLog(@"显示");
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)loadData
{
    [_table showRefreshHeader:YES];
}

- (void)createNavigationbarTools
{
    
    UIButton *rightView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightView.backgroundColor=[UIColor clearColor];
    
    UIButton *heartButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [heartButton addTarget:self action:@selector(clickToPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [heartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [heartButton setImage:[UIImage imageNamed:@"gcamera.png"] forState:UIControlStateNormal];
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
        
        [_table reloadData:arr pageSize:L_PAGE_SIZE];
        
    }
}

- (void)animation
{
    
    _table.contentOffset = CGPointMake(0, DEVICE_HEIGHT * 3);
    
    
    [UIView animateWithDuration:2.f animations:^{
        
        _table.hidden = NO;
        
        
    } completion:^(BOOL finished) {
        _table.contentOffset = CGPointMake(0, 0);
        
        
    }];
    
}

#pragma mark 网络请求


//T台赞 或 取消

- (void)zanTTaiDetail:(UIButton *)zan_btn
{
    if (![LTools isLogin:self]) {
        return;
    }
    
    [LTools animationToBigger:zan_btn duration:0.2 scacle:1.5];
    
    
    NSString *authkey = [GMAPI getAuthkey];
    
    TPlatModel *detail_model = _table.dataArray[zan_btn.tag - 100];
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
    
    
    //    TTaiBigPhotoCell *cell = (TTaiBigPhotoCell *)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:zan_btn.tag - 100 inSection:0]];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        zan_btn.selected = !zan_btn.selected;
        
        int like_num = [detail_model.tt_like_num intValue];
        detail_model.tt_like_num = [NSString stringWithFormat:@"%d",zan ? like_num + 1 : like_num - 1];
        detail_model.is_like = zan ? 1 : 0;
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        if ([failDic[RESULT_CODE] intValue] == -11 || [failDic[RESULT_CODE] intValue] == 2003) {
            [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
        }
        
    }];
}


- (void)getTTaiData
{
    
    __weak typeof(self)weakSelf = self;
    
    __weak typeof(RefreshTableView)*weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:@"%@&page=%d&count=%d&authcode=%@",TTAi_LIST,_table.pageNum,L_PAGE_SIZE,[GMAPI getAuthkey]];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [weakSelf parseDataWithResult:result];
        
        if (_table.pageNum == 1) {
            
            [DataManager cacheDataType:Cache_TPlat content:result];
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
        [weakTable loadFail];
        
    }];
}


#pragma mark 事件处理

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    
    PropertyImageView *aImageView = (PropertyImageView *)tap.view;
    
    [MiddleTools showTPlatDetailFromPropertyImageView:aImageView withController:self.tabBarController cancelSingleTap:YES];
}


- (void)tapCell:(UITableViewCell *)cell
{
    
    PropertyImageView *aImageView = ((TTaiBigPhotoCell2 *)cell).bigImageView;
    
    [MiddleTools showTPlatDetailFromPropertyImageView:aImageView withController:self.tabBarController cancelSingleTap:YES];
}


- (void)updateTTai:(NSNotification *)noti
{
    [_table showRefreshHeader:YES];
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
    
    GTTPublishViewController *publishT = [[GTTPublishViewController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:publishT];
    [self presentViewController:navc animated:YES completion:^{
        
    }];
}



/**
 *  添加锚点
 */
- (void)addMaoDian:(TPlatModel *)aModel imageView:(UIView *)imageView
{
    //史忠坤修改
    
    int image_have_detail=0;
    
    NSArray *img_detail=[NSArray array];
    
    if ([aModel.image isKindOfClass:[NSDictionary class]]) {
        
        image_have_detail=[aModel.image[@"have_detail"]intValue ];
        
        img_detail=aModel.image[@"img_detail"];
        
    }
    if (image_have_detail>0) {
        //代表有锚点，0代表没有锚点
        
        for (int i=0; i<img_detail.count; i++) {
            
            /*{
             dateline = 1427958416;
             "img_x" = "0.2000";
             "img_y" = "0.4000";
             "product_id" = 100;
             "shop_id" = 2654;
             "tt_id" = 26;
             "tt_img_id" = 0;
             "tt_img_info_id" = 1;
             },*/
            NSDictionary *maodian_detail=(NSDictionary *)[img_detail objectAtIndex:i];
            
            [self createbuttonWithModel:maodian_detail imageView:imageView];
            
        }}
    
}

//等到加载完图片之后再加载图片上的三个button

-(void)createbuttonWithModel:(NSDictionary*)maodian_detail imageView:(UIView *)imageView{
    
    NSString *productId = maodian_detail[@"product_id"];
    
    NSInteger product_id = [productId integerValue];
    
    float dx=[maodian_detail[@"img_x"] floatValue];
    float dy=[maodian_detail[@"img_y"] floatValue];
    
    
    __weak typeof(self)weakSelf = self;
    if (product_id>0) {
        //说明是单品
        
        NSString *title = maodian_detail[@"product_name"];
        CGPoint point = CGPointMake(dx * imageView.width, dy * imageView.height);
        AnchorPiontView *pointView = [[AnchorPiontView alloc]initWithAnchorPoint:point title:title];
        [imageView addSubview:pointView];
        pointView.infoId = productId;
        pointView.infoName = title;
        
        [pointView setAnchorBlock:^(NSString *infoId,NSString *infoName,ShopType shopType){
            
            [weakSelf turnToDanPinInfoId:infoId infoName:infoName];
        }];
        
        //        NSLog(@"单品--title %@",title);
        
    }else{
        
        //说明是品牌店面
        
        NSString *title = maodian_detail[@"shop_name"];
        int mall_type = [maodian_detail[@"mall_type"] intValue];
        NSString *storeId;
        
        if (mall_type == ShopType_pinpaiDian) {
            
            storeId = maodian_detail[@"shop_id"];
            
        }else if (mall_type == ShopType_jingpinDian){
            
            storeId = maodian_detail[@"mall_id"];
        }
        
        CGPoint point = CGPointMake(dx * imageView.width, dy * imageView.height);
        AnchorPiontView *pointView = [[AnchorPiontView alloc]initWithAnchorPoint:point title:title];
        [imageView addSubview:pointView];
        
        pointView.infoId = storeId;
        pointView.infoName = title;
        pointView.shopType = mall_type;
        
        [pointView setAnchorBlock:^(NSString *infoId,NSString *infoName,ShopType shopType){
            
            [weakSelf turnToShangChangInfoId:infoId infoName:infoName shopType:shopType];
        }];
        
    }
    
}

//移除锚点
- (void)removeMaoDianForCell:(UITableViewCell *)cell
{
    PropertyImageView *imageView = ((TTaiBigPhotoCell2 *)cell).bigImageView;
    
    for (int i = 0; i < imageView.subviews.count; i ++) {
        
        UIView *aView = [[imageView subviews]objectAtIndex:i];
        [aView removeFromSuperview];
        aView = nil;
    }
    
}

#pragma mark---锚点的点击方法
//到商场的
-(void)turnToShangChangInfoId:(NSString *)infoId
                     infoName:(NSString *)infoName
                     shopType:(ShopType)shopType
{
    
    [MiddleTools pushToStoreDetailVcWithId:infoId shopType:shopType storeName:infoName brandName:@" " fromViewController:self lastNavigationHidden:NO hiddenBottom:YES isTPlatPush:NO];
    
}
//到单品的
-(void)turnToDanPinInfoId:(NSString *)infoId
                 infoName:(NSString *)infoName
{
    
    ProductDetailController *detail = [[ProductDetailController alloc]init];
    detail.product_id = infoId;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}



#pragma - mark RefreshDelegate

-(void)loadNewData
{
    [self getTTaiData];
}

-(void)loadMoreData
{
    [self getTTaiData];
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"---->%f",scrollView.contentOffset.y);
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    //调转至老版本 详情页
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self tapCell:[tableView cellForRowAtIndexPath:indexPath]];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    TPlatModel *aModel = (TPlatModel *)[_table.dataArray objectAtIndex:indexPath.row];
    
    CGFloat image_width = [aModel.image[@"width"]floatValue];
    CGFloat image_height = [aModel.image[@"height"]floatValue];
    
    //    return 50 + 36 + [LTools heightForImageHeight:image_height imageWidth:image_width originalWidth:DEVICE_WIDTH];
    
    
    return [LTools heightForImageHeight:image_height imageWidth:image_width originalWidth:DEVICE_WIDTH];
}
//将要显示
- (void)refreshTableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
    });
    
    
    
    
}


#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"TTaiBigPhotoCell2";
    
    TPlatModel *aModel = (TPlatModel *)[_table.dataArray objectAtIndex:indexPath.row];
    
    TTaiBigPhotoCell2 *cell = (TTaiBigPhotoCell2 *)[LTools cellForIdentify:identify cellName:identify forTable:tableView];
    
    [cell setCellWithModel:aModel];
    
    cell.bigImageView.aModel = aModel;
    cell.bigImageView.userInteractionEnabled = NO;
    cell.bigImageView.tapGesture.enabled = NO;
    //    [cell.bigImageView.tapGesture addTarget:self action:@selector(tapImage:)];
    
    if (cell.maoDianView) {
        
        for (int i = 0; i < cell.maoDianView.subviews.count; i ++) {
            
            UIView *sub = [[cell.maoDianView subviews] objectAtIndex:i];
            [sub removeFromSuperview];
            sub = nil;
        }
        [cell.maoDianView removeFromSuperview];
        cell.maoDianView = nil;
    }
    
    cell.maoDianView = [[UIView alloc]initWithFrame:cell.bigImageView.frame];
    cell.maoDianView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:cell.maoDianView];
    
    //    [self removeMaoDianForCell:cell];
    
    [self addMaoDian:aModel imageView:cell.maoDianView];
    
    //赞按钮
    
    cell.zanBtn.tag = 100 + indexPath.row;
    [cell.contentView bringSubviewToFront:cell.zanBackView];
    [cell.zanBtn addTarget:self action:@selector(zanTTaiDetail:) forControlEvents:UIControlEventTouchUpInside];
    
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
