//
//  MyShopViewController.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/18.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyShopViewController.h"
#import "ParallaxHeaderView.h"

#import "TMQuiltViewCell.h"
#import "ProductModel.h"

#import "LWaterflowView.h"

#import "RefreshTableView.h"

#import "MessageDetailController.h"

#import "ProductDetailController.h"

#import "MailMessageCell.h"

#import "MessageModel.h"

@interface MyShopViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,WaterFlowDelegate,TMQuiltViewDataSource,RefreshDelegate>
{
    UITableView *_tableView;
    ParallaxHeaderView *_backView;//banner
    LWaterflowView *waterFlow;
    
    RefreshTableView *rightTable;//活动
}

@property(nonatomic,strong)UIImageView *userFaceImv;//头像Imv

@property(nonatomic,strong)UIImage *userBanner;//banner
@property(nonatomic,strong)UIImage *userFace;//头像

@property(nonatomic,strong)UILabel *userNameLabel;//昵称label
@property(nonatomic,strong)UILabel *userScoreLabel;//积分

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
    [self.view addSubview:_tableView];
    
    [self deserveBuyForSex:Sort_Sex_No discount:Sort_Discount_No page:1];
    
    [self getMailInfo];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求

#pragma mark - 网络请求

//action= yy(衣加衣) shop（商家） dynamic（动态）
- (void)getMailInfo
{
    NSString *key = [GMAPI getAuthkey];
    
    key = @"WiVbIgF4BeMEvwabALBajQWgB+VUoVWkBShRYFUwXGkGOAAyB2FSZgczBjYAbAp6AjZSaQ==";
    
    NSString *url = [NSString stringWithFormat:MESSAGE_GET_LIST,@"dynamic",key];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"");
        
        NSArray *data = result[@"data"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
        for (NSDictionary *aDic in data) {
            MessageModel *aModel = [[MessageModel alloc]initWithDictionary:aDic];
            [arr addObject:aModel];
        }
        [rightTable reloadData:arr isHaveMore:NO];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        
    }];
}


- (void)deserveBuyForSex:(SORT_SEX_TYPE)sortType
                discount:(SORT_Discount_TYPE)discountType
                    page:(int)pageNum
{
    NSString *longtitud = @"116.42111721";
    NSString *latitude = @"39.90304099";
    NSString *url = [NSString stringWithFormat:HOME_DESERVE_BUY,longtitud,latitude,sortType,discountType,pageNum,L_PAGE_SIZE,[GMAPI getAuthkey]];
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
            
        }
        
        [waterFlow reloadData:arr total:100];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [waterFlow loadFail];
        
    }];
}

#pragma mark - 创建视图


///创建用户头像banner的view
-(UIView *)creatTableViewHeaderView{
    //底层view
    _backView = [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(DEVICE_WIDTH, 150.00*DEVICE_WIDTH/320)];
    _backView.headerImage = [UIImage imageNamed:@"my_bg"];
    
    NSLog(@"%@",NSStringFromCGRect(_backView.frame));
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, 70, 17)];
    titleLabel.font = [UIFont systemFontOfSize:16*GscreenRatio_320];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我是店主";
    titleLabel.textColor = [UIColor whiteColor];
    [_backView addSubview:titleLabel];
    titleLabel.center = CGPointMake(DEVICE_WIDTH / 2.f, titleLabel.center.y);
    
    //返回按钮
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(12,20,40,44)];
    [button_back addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button_back setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [_backView addSubview:button_back];
    
    //小齿轮设置按钮 设置
    UIButton *chilunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chilunBtn setFrame:CGRectMake(DEVICE_WIDTH - 40, 30, 25, 25)];
    [chilunBtn setBackgroundImage:[UIImage imageNamed:@"dz_tianjia"] forState:UIControlStateNormal];
    [chilunBtn addTarget:self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    //头像
    self.userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake(30*GscreenRatio_320, _backView.frame.size.height - 75, 50, 50)];
    self.userFaceImv.backgroundColor = RGBCOLOR_ONE;
    self.userFaceImv.layer.cornerRadius = 25;
    self.userFaceImv.layer.masksToBounds = YES;
    self.userFaceImv.image = [GMAPI getUserFaceImage];
    
    
    NSLog(@"%@",NSStringFromCGRect(self.userFaceImv.frame));
    
    //昵称
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userFaceImv.frame)+10, self.userFaceImv.frame.origin.y+6, 120*GscreenRatio_320, 14)];
    self.userNameLabel.text = @"昵称";
    self.userNameLabel.font = [UIFont systemFontOfSize:14*GscreenRatio_320];
    self.userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.text = [GMAPI getUsername];
    
    //地址
    self.userScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLabel.frame.origin.x, CGRectGetMaxY(self.userNameLabel.frame)+10, self.userNameLabel.frame.size.width, self.userNameLabel.frame.size.height)];
    self.userScoreLabel.font = [UIFont systemFontOfSize:14*GscreenRatio_320];
    self.userScoreLabel.text = @"地址";
    self.userScoreLabel.textColor = [UIColor whiteColor];

    //    //添加视图
    //    [backView addSubview:self.userBannerImv];
    [_backView addSubview:self.userFaceImv];
    [_backView addSubview:self.userNameLabel];
    [_backView addSubview:self.userScoreLabel];
    [_backView addSubview:chilunBtn];
    
    return _backView;
}

#pragma mark - 事件处理

//更新状态栏颜色

- (void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
    
    self.navigationController.navigationBarHidden = NO;

}

- (void)updateStatusBarColor:(BOOL)isWhite
{
    if (isWhite) {
        if (IOS7_OR_LATER) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
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
    NSLog(@"添加商品 或者 单品");
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发布单品",@"发布活动", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate <NSObject>

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSLog(@"发布活动");

    }else if (buttonIndex == 0){
        
        NSLog(@"发布单品");

    }
}

#pragma mark -
#pragma mark UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == _tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)_tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }else
    {
        
        
        if (scrollView.contentOffset.y <= -50)
        {
            
            // 输出改变后的值
            [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
            
        }else if(scrollView.contentOffset.y > 50)
        {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
    }
    
    NSLog(@"---->%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 130) {
        
        [self updateStatusBarColor:YES];
    }else
    {
        [self updateStatusBarColor:NO];
    }
}

#pragma mark - WaterFlowDelegate
- (void)waterScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= -50)
    {
        
        // 输出改变后的值
        [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
        
    }else if(scrollView.contentOffset.y > 50)
    {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
    
    NSLog(@"water-->");
}

#pragma mark - RefreshDelegate
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView %f",scrollView.contentOffset.y);
    if (scrollView == rightTable) {
        
        if (scrollView.contentOffset.y <= -50)
        {
            
            // 输出改变后的值
            [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
            
        }else if(scrollView.contentOffset.y > 50)
        {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }
    }
    
}

#pragma mark - RefreshDelegate

- (void)loadNewData
{
    [self getMailInfo];
}
- (void)loadMoreData
{
    
}

//新加
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    NSLog(@"详情");
    MessageModel *aModel = rightTable.dataArray[indexPath.row];
    MessageDetailController *detail = [[MessageDetailController alloc]init];
    detail.msg_id = aModel.msg_id;
//    [self.navigationController pushViewController:detail animated:YES];
    
    [self pushViewController:detail];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    MessageModel *aModel = rightTable.dataArray[indexPath.row];
    return [MailMessageCell heightForModel:aModel cellType:icon_Yes seeAll:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == rightTable) {
        
        return rightTable.dataArray.count;
    }
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DEVICE_HEIGHT - 57;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 47 + 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
        
        static NSString *waterIdentify = @"waterFlow";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:waterIdentify];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:waterIdentify];
        }
        
        waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT - 57) waterDelegate:self waterDataSource:self];
        waterFlow.backgroundColor = RGBCOLOR(240, 230, 235);
        [cell.contentView addSubview:waterFlow];

        
        rightTable = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,DEVICE_HEIGHT - 57)];
        rightTable.refreshDelegate = self;
        rightTable.dataSource = self;
        [cell.contentView addSubview:rightTable];
        rightTable.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        rightTable.hidden = YES;
        
        return cell;
    }
    
    if (tableView == rightTable) {
        
        static NSString *identify = @"MailMessageCell";
        MailMessageCell *cell = (MailMessageCell *)[LTools cellForIdentify:identify cellName:identify forTable:tableView];
        
        MessageModel *aModel = rightTable.dataArray[indexPath.row];
        [cell setCellWithModel:aModel cellType:icon_Yes seeAll:YES];
        
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
    [self deserveBuyForSex:Sort_Sex_No discount:Sort_Discount_No page:1];
}
- (void)waterLoadMoreData
{
}

- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    ProductDetailController *detail = [[ProductDetailController alloc]init];
    detail.product_id = aMode.product_id;
    detail.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detail animated:YES];
    
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
    
    cell.like_btn.tag = 1000 + indexPath.row;
    [cell.like_btn addTarget:self action:@selector(clickToZan:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



@end
