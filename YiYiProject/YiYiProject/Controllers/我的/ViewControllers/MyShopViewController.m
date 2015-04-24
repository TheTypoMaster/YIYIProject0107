//
//  MyShopViewController.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/18.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyShopViewController.h"
#import "ParallaxHeaderView.h"
#import "GupClothesViewController.h"
#import "GupHuoDongViewController.h"

#import "TMQuiltViewCell.h"
#import "ProductModel.h"

#import "LWaterflowView.h"

#import "RefreshTableView.h"

#import "MessageDetailController.h"

#import "ProductDetailController.h"

#import "MailMessageCell.h"

#import "MessageModel.h"

#import "ActivityModel.h"

#import "MailInfoModel.h"

#import "NSDictionary+GJson.h"

#import "GmyproductsListViewController.h"

#import "GmyActivetiesViewController.h"

#import "GmyshopErweimaViewController.h"//二维码

#import "GmyShopHuiyuanViewController.h"//店铺会员

#import "GShopPhoneViewController.h"//店铺联系电话


@interface MyShopViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,WaterFlowDelegate,TMQuiltViewDataSource,RefreshDelegate>
{
    UITableView *_tableView;
    UIView *_backView;//banner
    LWaterflowView *waterFlow;
    
    RefreshTableView *rightTable;//活动
    
    CGFloat water_offset_y;
    CGFloat right_offset_y;
    
    MailInfoModel *aMailModel;
    
    BOOL scroll_OK;
    
    
    UILabel *_titleLabel;//标题店名
}

@property(nonatomic,strong)UIImageView *userFaceImv;//头像Imv

@property(nonatomic,strong)UIImage *userBanner;//banner
@property(nonatomic,strong)UIImage *userFace;//头像

@property(nonatomic,strong)UILabel *shop_mobile;//开店时获取验证码的手机号
@property(nonatomic,strong)UIButton *erweima;//二维码
@property(nonatomic,strong)UIButton *shop_huiyuan;//店铺会员

@property(nonatomic,strong)MailInfoModel *mallInfo;//店铺信息

@end

@implementation MyShopViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self creatTableViewHeaderView];
    _tableView.tableHeaderView.userInteractionEnabled = YES;
    [self.view addSubview:_tableView];
    _tableView.bounces = NO;
    
    [self getMailDetailInfo];//店铺详情
    
//    [self getMailProduct];//店铺产品列表
    
//    [self getMailActivity];//店铺活动列表
    
    [self creatManageView];//添加店铺管理界面
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gengxinDanpin) name:NOTIFICATION_FABUDANPIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gengxinHuodong) name:NOTIFICATION_FABUHUODONG_SUCCESS object:nil];
    
}



-(void)creatManageView{
    UIView *downManageView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT-40, DEVICE_WIDTH, 40)];
    downManageView.backgroundColor = [UIColor blackColor];
    downManageView.alpha = 0.6f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"店铺管理" forState:UIControlStateNormal];
    [btn setFrame:downManageView.bounds];
    [btn addTarget:self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [downManageView addSubview:btn];
    
    [self.view addSubview:downManageView];
}


-(void)gengxinDanpin{
    UIButton *btn1 = [self buttonForTag:100];
    [self clickToAction:btn1];
    [waterFlow showRefreshHeader:YES];
}

-(void)gengxinHuodong{
    UIButton *btn1 = [self buttonForTag:101];
    [self clickToAction:btn1];
    [rightTable showRefreshHeader:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求

/**
 *  获取店铺详情
 */
- (void)getMailDetailInfo
{
    NSString *key = [GMAPI getAuthkey];
    
    __weak typeof(self)weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:GET_MAIL_DETAIL_INFO,self.userInfo.shop_id];
    
    NSLog(@"%@",url);
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"获取店铺详情:%@",result);
        
        MailInfoModel *mail = [[MailInfoModel alloc]initWithDictionary:result];
        if (mail) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        self.mallInfo = mail;
        [weakSelf setViewWithModel:mail];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        
    }];
}


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
    
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[waterFlow.quitView cellAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 10000 inSection:0]];
    cell.like_label.text = @"";
    
    ProductModel *aMode = waterFlow.dataArray[sender.tag - 10000];
    
    NSString *productId = aMode.product_id;
    
    //    __weak typeof(self)weakSelf = self;
    
    NSString *api = HOME_PRODUCT_ZAN_ADD;
    
    NSString *post = [NSString stringWithFormat:@"product_id=%@&authcode=%@",productId,[GMAPI getAuthkey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url = api;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        sender.selected = YES;
        aMode.is_like = 1;
        aMode.product_like_num = NSStringFromInt([aMode.product_like_num intValue] + 1);
        cell.like_label.text = aMode.product_like_num;
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        cell.like_label.text = aMode.product_like_num;
        
        [GMAPI showAutoHiddenMBProgressWithText:failDic[RESULT_INFO] addToView:self.view];
        
        if ([failDic[RESULT_CODE] intValue] == -11) {
            
            [LTools showMBProgressWithText:failDic[RESULT_INFO] addToView:self.view];
        }
        
    }];
}


/**
 *  获取店铺活动
 */
- (void)getMailActivity
{
    NSString *key = [GMAPI getAuthkey];
    
//    key = @"WiVbIgF4BeMEvwabALBajQWgB+VUoVWkBShRYFUwXGkGOAAyB2FSZgczBjYAbAp6AjZSaQ==";
    
    NSString *url = [NSString stringWithFormat:GET_MAIL_ACTIVITY_LIST,key];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"");
        
        NSArray *data = result[@"activities"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
        for (NSDictionary *aDic in data) {
            ActivityModel *aModel = [[ActivityModel alloc]initWithDictionary:aDic];
            [arr addObject:aModel];
        }
        [rightTable reloadData:arr isHaveMore:NO];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        
    }];
}


- (void)getMailProduct
{
    //action=%@&mb_id=%@&page=%d&per_page=%d"
    
    
    NSString *url = [NSString stringWithFormat:GET_MAIL_PRODUCT_LIST,self.userInfo.shop_id,waterFlow.pageNum,L_PAGE_SIZE,[GMAPI getAuthkey]];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
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
        [waterFlow loadFail];
        
    }];
}

#pragma mark - 创建视图


///创建用户头像banner的view
-(UIView *)creatTableViewHeaderView{
    //底层view
    _backView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 150.00*DEVICE_WIDTH/320)];
    UIImageView *imv = [[UIImageView alloc]initWithFrame:_backView.bounds];
    imv.userInteractionEnabled = YES;
    [imv setImage:[GMAPI getUserBannerImage]];
    [_backView addSubview:imv];
    
    //标题
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, DEVICE_WIDTH-140, 17)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"";
    _titleLabel.textColor = [UIColor whiteColor];
    [_backView addSubview:_titleLabel];
    _titleLabel.center = CGPointMake(DEVICE_WIDTH / 2.f, _titleLabel.center.y);
    
    //返回按钮
    
    UIButton *button_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_back setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [button_back setImageEdgeInsets:UIEdgeInsetsMake(30, 15, 30, 50)];
    [button_back setFrame:CGRectMake(0, 0, 70, 80)];
    [button_back addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button_back setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
    [_backView addSubview:button_back];
    
    
    //头像
    self.userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake(30*GscreenRatio_320, _backView.frame.size.height - 75, 50, 50)];
    [self.userFaceImv setImage:[UIImage imageNamed:@"grzx150_150.png"]];
    self.userFaceImv.layer.cornerRadius = 25;
    self.userFaceImv.layer.masksToBounds = YES;
    
    
    NSLog(@"%@",NSStringFromCGRect(self.userFaceImv.frame));
    
    
    //手机号
    self.shop_mobile = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userFaceImv.frame)+30, self.userFaceImv.frame.origin.y, DEVICE_WIDTH - self.userFaceImv.right - 20, 20)];
    self.shop_mobile.tag = 50;
    self.shop_mobile.text = @"手机:";
//    self.shop_mobile.backgroundColor = [UIColor blackColor];
//    self.shop_mobile.alpha = 0.5f;
    self.shop_mobile.font = [UIFont systemFontOfSize:13*GscreenRatio_320];
    self.shop_mobile.textColor = [UIColor whiteColor];
    
    
    
    //二维码
    self.erweima = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.erweima setFrame:CGRectMake(self.shop_mobile.frame.origin.x, CGRectGetMaxY(self.shop_mobile.frame)+5, self.shop_mobile.frame.size.width, 20)];
//    self.erweima.backgroundColor = [UIColor blackColor];
//    self.erweima.alpha = 0.5f;
    [self.erweima addTarget:self action:@selector(erweimaClicked) forControlEvents:UIControlEventTouchUpInside];
    self.erweima.titleLabel.font = [UIFont systemFontOfSize:13*GscreenRatio_320];
    [self.erweima setTitle:@"店铺二维码" forState:UIControlStateNormal];
    self.erweima.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.erweima setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    //店铺会员
    
    self.shop_huiyuan = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shop_huiyuan setFrame:CGRectMake(self.shop_mobile.frame.origin.x, CGRectGetMaxY(self.erweima.frame)+5, self.shop_mobile.frame.size.width, 20)];
    [self.shop_huiyuan setTitle:@"店铺会员" forState:UIControlStateNormal];
    self.shop_huiyuan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.shop_huiyuan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shop_huiyuan.titleLabel.font = [UIFont systemFontOfSize:13*GscreenRatio_320];
    [self.shop_huiyuan addTarget:self action:@selector(shophuiyuanClicked) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    
    //添加视图
    [_backView addSubview:self.userFaceImv];
    [_backView addSubview:self.shop_mobile];
    [_backView addSubview:self.erweima];
//    [_backView addSubview:self.shop_huiyuan];
    
    
    
    
    
    return _backView;
}


-(void)lableClicked:(UITapGestureRecognizer*)ttt{
    
    if (ttt.view.tag == 50) {//手机号
        
    }else if (ttt.view.tag == 51){//店铺二维码
        GmyshopErweimaViewController *ccc = [[GmyshopErweimaViewController alloc]init];
        ccc.lastPageNavigationHidden = YES;
        [self.navigationController pushViewController:ccc animated:YES];
        
        
    }else if (ttt.view.tag == 51){//店铺会员
        GmyShopHuiyuanViewController *ccc = [[GmyShopHuiyuanViewController alloc]init];
        ccc.lastPageNavigationHidden = YES;
        [self.navigationController pushViewController:ccc animated:YES];
    }
}

//店铺二维码点击
-(void)erweimaClicked{
    GmyshopErweimaViewController *ccc = [[GmyshopErweimaViewController alloc]init];
    ccc.mallInfo = self.mallInfo;
    ccc.shop_id = self.userInfo.shop_id;
    
    ccc.lastPageNavigationHidden = YES;
    [self.navigationController pushViewController:ccc animated:YES];
}

//店铺会员点击
-(void)shophuiyuanClicked{
    GmyShopHuiyuanViewController *ccc = [[GmyShopHuiyuanViewController alloc]init];
    ccc.mallInfo = self.mallInfo;
    [self.navigationController pushViewController:ccc animated:YES];
    
    self.navigationController.navigationBarHidden = NO;
}



-(void)manageBtnClicked{
    
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"管理单品",@"管理活动", nil];
    act.tag = 17;
    [act showInView:self.view];
    
}




#pragma mark - 事件处理

- (void)setViewWithModel:(MailInfoModel *)aModel
{
    aMailModel = aModel;
    [self.userFaceImv sd_setImageWithURL:[NSURL URLWithString:aModel.logo] placeholderImage:nil];
    self.shop_mobile.text = [NSString stringWithFormat:@"手机:%@",aModel.shop_mobile];
    _titleLabel.text = aModel.shop_name;
    
}



- (void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)updateStatusBarColor:(BOOL)isWhite
{
    if (isWhite) {
        if (IOS7_OR_LATER) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    }else
    {
        if (IOS7_OR_LATER) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    }
    
}

- (UIButton *)buttonForTag:(int)tag
{
    return (UIButton *)[self.view viewWithTag:tag];
}

- (void)clickToAction:(UIButton *)sender
{
    UIButton *btn1 = [self buttonForTag:100];
    UIButton *btn2 = [self buttonForTag:101];
    sender.selected = YES;
    
    sender.backgroundColor = [UIColor colorWithHexString:@"eb4d68"];
    
    if (sender == btn1) {
        
        btn2.selected = NO;
        btn2.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        
        waterFlow.hidden = NO;
        rightTable.hidden = YES;
    }else
    {
        btn1.selected = NO;
        btn1.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        waterFlow.hidden = YES;
        rightTable.hidden = NO;
    }
}

-(void)clickToBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickToAdd:(UIButton *)sender
{
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发布单品",@"发布活动",@"管理单品",@"管理活动",@"联系电话", nil];
    sheet.tag = 18;
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate <NSObject>

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag ==18){
        
        if (buttonIndex == 0) {
            NSLog(@"发布单品");
            GupClothesViewController *ccc = [[GupClothesViewController alloc]init];
            ccc.userInfo = self.userInfo;
            ccc.mallInfo = self.mallInfo;
            [self.navigationController pushViewController:ccc animated:YES];
        }else if (buttonIndex == 1){
            NSLog(@"发布活动");
            GupHuoDongViewController *ccc = [[GupHuoDongViewController alloc]init];
            ccc.mallInfo = self.mallInfo;
            ccc.userInfo = self.userInfo;
            [self.navigationController pushViewController:ccc animated:YES];
        }else if (buttonIndex == 2){
            NSLog(@"管理单品");
            GmyproductsListViewController *ccc = [[GmyproductsListViewController alloc]init];
            ccc.userInfo = self.userInfo;
            ccc.mallInfo = self.mallInfo;
            [self.navigationController pushViewController:ccc animated:YES];
            
        }else if (buttonIndex == 3){
            NSLog(@"管理活动");
            
            GmyActivetiesViewController *ccc = [[GmyActivetiesViewController alloc]init];
            ccc.userInfo = self.userInfo;
            ccc.mallInfo = self.mallInfo;
            [self.navigationController pushViewController:ccc animated:YES];
        }else if (buttonIndex == 4){
            NSLog(@"联系电话");
            GShopPhoneViewController *ccc = [[GShopPhoneViewController alloc]init];
            ccc.shop_id = self.userInfo.shop_id;
            [self.navigationController pushViewController:ccc animated:YES];
            
        }
    }
    
    
}

#pragma mark -
#pragma mark UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == _tableView)
    {
        
    }
    NSLog(@"---->%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 130) {
        
        [self updateStatusBarColor:YES];
    }else
    {
        [self updateStatusBarColor:NO];
    }
    
    if (scrollView.contentOffset.y >= 20 && scrollView.contentOffset.y <= 190) {
        
        waterFlow.quitView.scrollEnabled = NO;
        rightTable.scrollEnabled = NO;
    }else
    {
        waterFlow.quitView.scrollEnabled = YES;
        rightTable.scrollEnabled = YES;
    }
}

#pragma mark - WaterFlowDelegate
- (void)waterScrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset = scrollView.contentOffset.y;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (offset < 0 && offset < water_offset_y) {
            
            [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        if (offset > 20 && offset > water_offset_y) {
            
            _tableView.contentOffset = CGPointMake(0, 194);
        }else if (offset > 100 && offset < water_offset_y){
            
            _tableView.contentOffset = CGPointMake(0, 0);
        }
        
    }];
    
    if (scrollView.contentOffset.y <= ((scrollView.contentSize.height - scrollView.frame.size.height-40))) {
        
        water_offset_y = scrollView.contentOffset.y;
    }
    
    
    NSLog(@"water--> %f",scrollView.contentOffset.y);
}

#pragma mark - RefreshDelegate
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView %f",scrollView.contentOffset.y);
    if (scrollView == rightTable) {
        
        
        CGFloat offset = scrollView.contentOffset.y;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            if (offset < 0 && offset < water_offset_y) {
                
                [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            
            if (offset > 20 && offset > water_offset_y) {
                
                _tableView.contentOffset = CGPointMake(0, 194);
            }else if (offset > 100 && offset < water_offset_y){
                
                _tableView.contentOffset = CGPointMake(0, 0);
            }
            
        }];
        
        if (scrollView.contentOffset.y <= ((scrollView.contentSize.height - scrollView.frame.size.height-40))) {
            
            water_offset_y = scrollView.contentOffset.y;
        }
        
    }
    
}

#pragma mark - RefreshDelegate

- (void)loadNewData
{
    [self getMailActivity];
}
- (void)loadMoreData
{
    
}

//新加
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    NSLog(@"详情");
    ActivityModel *aModel = rightTable.dataArray[indexPath.row];
    MessageDetailController *detail = [[MessageDetailController alloc]init];
    detail.msg_id = aModel.id;
    detail.isActivity = YES;
    detail.shopName = aMailModel.shop_name;
    detail.shopImageUrl = aMailModel.logo;
    detail.lastPageNavigationHidden = YES;
    [self pushViewController:detail];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    ActivityModel *aModel = rightTable.dataArray[indexPath.row];
    return [MailMessageCell heightForModel:aModel cellType:icon_No seeAll:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == rightTable) {
        return 1;
    }
    
    return 1 + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == rightTable) {
        
        return rightTable.dataArray.count;
    }
    
    if (section == 0) {
        
        return 0;
    }
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DEVICE_HEIGHT - 57 + 20;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }
    return 47 + 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return [UIView new];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 47 + 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(10, 12 + 10, DEVICE_WIDTH - 10 * 2, 47 - 12)];
    sectionView.layer.cornerRadius = 5.f;
    sectionView.layer.borderWidth = 1.f;
    sectionView.layer.borderColor = [UIColor colorWithHexString:@"eb4d68"].CGColor;
    sectionView.clipsToBounds = YES;
    
    NSArray *titles = @[@"单品",@"活动"];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(sectionView.width / 2.f * i, 0, sectionView.width / 2.f, sectionView.height) normalTitle:titles[i] image:nil backgroudImage:nil superView:nil target:self action:@selector(clickToAction:)];
        [sectionView addSubview:btn];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"eb4d68"] forState:UIControlStateNormal];
        
        [btn setTitleShadowColor:[UIColor colorWithHexString:@"f2f2f2"] forState:UIControlStateNormal];
        [btn setTitleShadowColor:[UIColor colorWithHexString:@"eb4d68"] forState:UIControlStateSelected];
        
        btn.tag = 100 + i;
        
        //默认 i=0 选中
        
        if (i == 0) {
            btn.selected = YES;
            btn.backgroundColor = [UIColor colorWithHexString:@"eb4d68"];
        }else
        {
            btn.selected = NO;
            btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        }
    }
    [view addSubview:sectionView];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView) {
        
        if (indexPath.section == 1) {
            static NSString *waterIdentify = @"waterFlow";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:waterIdentify];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:waterIdentify];
            }
            
            waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT - 57 + 20) waterDelegate:self waterDataSource:self];
            waterFlow.pageNum = 1;
            waterFlow.backgroundColor = RGBCOLOR(235, 235, 235);
            [cell.contentView addSubview:waterFlow];
            
            [waterFlow showRefreshHeader:YES]; //加载数据

            waterFlow.quitView.scrollEnabled = NO;
            
            rightTable = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,DEVICE_HEIGHT - 57 + 20)];
            rightTable.refreshDelegate = self;
            rightTable.dataSource = self;
            [cell.contentView addSubview:rightTable];
            rightTable.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
            rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            rightTable.hidden = YES;
            
            rightTable.scrollEnabled = NO;
            
            [rightTable showRefreshHeader:YES];//加载数据
            
            return cell;
        }
    }
    
    if (tableView == rightTable) {
        
        static NSString *identify = @"MailMessageCell";
        MailMessageCell *cell = (MailMessageCell *)[LTools cellForIdentify:identify cellName:identify forTable:tableView];
        
        ActivityModel *aModel = rightTable.dataArray[indexPath.row];
        [cell setCellWithModel:aModel cellType:icon_No seeAll:YES];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - WaterFlowDelegate

- (void)waterLoadNewData
{
    [self getMailProduct];
}
- (void)waterLoadMoreData
{
    [self getMailProduct];
}

- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    ProductDetailController *detail = [[ProductDetailController alloc]init];
    detail.product_id = aMode.product_id;
    
    detail.lastPageNavigationHidden = YES;
    
    detail.hidesBottomBarWhenPushed = YES;
    
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *) [waterFlow.quitView cellAtIndexPath:indexPath];
//    cell.like_btn.selected = aModel.is_like == 1 ? YES : NO;
    detail.theLastViewClickedCell = cell;
    detail.theLastViewProductModel = aMode;
    
    [self pushViewController:detail];
    
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    CGFloat imageH = 0.f;
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    if (aMode.imagelist.count >= 1) {
        
        
        NSDictionary *imageDic = aMode.imagelist[0];
        NSDictionary *middleImage = imageDic[@"540Middle"];
        float image_width = [middleImage[@"width"]floatValue];
        float image_height = [middleImage[@"height"]floatValue];
        
        if (image_width == 0.0) {
            image_width = image_height;
        }
        float rate = image_height/image_width;
        
        imageH = (DEVICE_WIDTH-30)/2.0*rate+33;
        
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
    [cell setCellWithModel:aMode];
    
    cell.like_btn.tag = 10000 + indexPath.row;
    [cell.like_btn addTarget:self action:@selector(clickToZan:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.titleView.hidden = YES;
    
    return cell;
}



@end

