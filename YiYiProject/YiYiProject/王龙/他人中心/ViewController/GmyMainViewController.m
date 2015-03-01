//
//  GmyMainViewController.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GmyMainViewController.h"
#import "GShowStarsView.h"
#import "TMQuiltView.h"
#import "LWaterflowView.h"
#import "TPlatModel.h"

#import "TTaiDetailController.h"

#define NORMAL_TEXT @"上拉加载更多"
#define NOMORE_TEXT @"没有更多数据"
#define TABLEFOOTER_HEIGHT 50.f


@interface GmyMainViewController ()<TMQuiltViewDataSource,WaterFlowDelegate>
{
    //第一层
    UIView *_upUserInfoView;//用户信息view
    UIImageView *_userFaceImv;//头像
    UILabel *_userNameLabel;//用户名
    UILabel *_guanzhuLabel;//关注
    UILabel *_fensiLabel;//粉丝
    
    //第二层 (自己的主页没有这一层)
    UIView *_jiaoliuGuanzhuView;//交流关注view
    
    UIView *ttaiView;
    
    BOOL _isHaveMore;
    int pageNum;
    
    UIActivityIndicatorView *refreshLoading;//刷新loading
    
    BOOL isReload;
}

@property(nonatomic,retain)UIActivityIndicatorView *loadingIndicator;
@property(nonatomic,retain)UILabel *normalLabel;
@property(nonatomic,retain)UILabel *loadingLabel;

@end

@implementation GmyMainViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)dealloc
{
    self.waterfall.delegate = nil;
    self.waterfall.collectionView.delegate = nil;
    self.waterfall.collectionView.dataSource = nil;
//    self.waterfall = nil;
    [self.waterfall.collectionView removeObserver:self forKeyPath:@"contentSize" context:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.myTitleLabel.textColor = [UIColor whiteColor];
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    //
    [self initWaterFlowView];
    [self initHeadBackView];
    [self createFooterView];
    
    pageNum = 1;
    [self deserveBuyForPage:1];
    
}


///初始化头部的view
-(void)initHeadBackView{
    
    float mid_height = 0.0f;
    if (self.theType == GSOMEONE) {
        mid_height = 58.0f;
    }
    headerView = [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(DEVICE_WIDTH, 150.00)];
    
    [headerView.imageView sd_setImageWithURL:[NSURL URLWithString:_bannerUrl] placeholderImage:[UIImage imageNamed:@"my_bg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    self.waterfall.headerView = headerView;
    
    headerView.userInteractionEnabled = YES;
    
//    headerView.headerImage = [UIImage imageNamed:@"guserbannerdefaul.png"];
    
    if (self.theType == GSOMEONE) {
        [headerView addSubview:[self creatUpUserInfoView]];
        [headerView addSubview:[self creatJiaoliuGuanzhuView]];
        [headerView addSubview:[self createTtaiView]];
        ttaiView.frame = CGRectMake(0, _jiaoliuGuanzhuView.frame.size.height+_jiaoliuGuanzhuView.frame.origin.y, DEVICE_WIDTH, 25);
    }else{
        [headerView addSubview:[self creatUpUserInfoView]];
        [headerView addSubview:[self createTtaiView]];
        ttaiView.frame = CGRectMake(0, _upUserInfoView.frame.size.height+_upUserInfoView.frame.origin.y, DEVICE_WIDTH, 25);
    }
    [self.waterfall.collectionView addSubview:headerView];
    
    
    //刷新loading
    
    refreshLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    refreshLoading.hidden = YES;
    refreshLoading.backgroundColor = [UIColor clearColor];
    refreshLoading.hidesWhenStopped = YES;
    refreshLoading.frame = CGRectMake(50,50, 24, 24);
    [self.view addSubview:refreshLoading];
    
    refreshLoading.center = CGPointMake(DEVICE_WIDTH/4.f, headerView.height/2.f);
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 15, 30, 50)];
    [backBtn setFrame:CGRectMake(0, 0, 80, 80)];
    [backBtn addTarget:self action:@selector(gGoBackVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

//RGBCOLOR(240, 242, 242);
//别人主页的 交流关注view
-(UIView*)creatJiaoliuGuanzhuView{
    _jiaoliuGuanzhuView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_upUserInfoView.frame), DEVICE_WIDTH, 58)];
    _jiaoliuGuanzhuView.backgroundColor = [UIColor whiteColor];
    
    //交流
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((DEVICE_WIDTH-100-100-10)*0.5, 12, 100, 34)];
    [btn setBackgroundColor:RGBCOLOR(252, 252, 252)];
    [btn setTitle:@"交流" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btn setTitleColor:RGBCOLOR(114, 114, 114) forState:UIControlStateNormal];
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 2;
    btn.layer.borderColor = [RGBCOLOR(204, 204, 204)CGColor];
    
    
    //关注
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(CGRectGetMaxX(btn.frame)+10, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)];
    btn1.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btn1 setTitle:@"+ 关注" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:RGBCOLOR(234, 95, 120)];
    
    
    [_jiaoliuGuanzhuView addSubview:btn];
    [_jiaoliuGuanzhuView addSubview:btn1];
    
    return _jiaoliuGuanzhuView;
}


//顶部用户信息view
-(UIView*)creatUpUserInfoView{
    
    //整个view
    _upUserInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 150)];
    _upUserInfoView.backgroundColor = [UIColor clearColor];

    //头像
    _userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_WIDTH-60)*0.5, 35, 60, 60)];
    _userFaceImv.backgroundColor = RGBCOLOR_ONE;
    _userFaceImv.layer.cornerRadius = 30;
    _userFaceImv.layer.borderWidth = 1;
    _userFaceImv.layer.borderColor = [[UIColor whiteColor]CGColor];
    _userFaceImv.layer.masksToBounds = YES;
    [_userFaceImv sd_setImageWithURL:[NSURL URLWithString:_headImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    [_upUserInfoView addSubview:_userFaceImv];
    
    //用户名
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(_userFaceImv.frame)+5, DEVICE_WIDTH, 20)];
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.font = [UIFont systemFontOfSize:18];
    _userNameLabel.text = [GMAPI getUsername];
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    [_upUserInfoView addSubview:_userNameLabel];
    
//    //关注 粉丝
//    _guanzhuLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_userNameLabel.frame)+10, DEVICE_WIDTH*0.5-10, 16)];
//    _guanzhuLabel.font = [UIFont systemFontOfSize:14];
//    _guanzhuLabel.textColor = [UIColor whiteColor];
//    _guanzhuLabel.textAlignment = NSTextAlignmentRight;
//    _guanzhuLabel.text = @"关注 300";
//    _guanzhuLabel.backgroundColor = [UIColor clearColor];
//    //分割线
//    UIView *fenView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_guanzhuLabel.frame)+10, _guanzhuLabel.frame.origin.y, 1, _guanzhuLabel.frame.size.height)];
//    fenView.backgroundColor = [UIColor whiteColor];
//    _fensiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fenView.frame)+10, fenView.frame.origin.y, _guanzhuLabel.frame.size.width, _guanzhuLabel.frame.size.height)];
//    _fensiLabel.font = [UIFont systemFontOfSize:14];
//    _fensiLabel.backgroundColor = [UIColor clearColor];
//    _fensiLabel.textColor = [UIColor whiteColor];
//    _fensiLabel.text = @"粉丝 300";
//    _fensiLabel.textAlignment = NSTextAlignmentLeft;
//    [_upUserInfoView addSubview:_guanzhuLabel];
//    [_upUserInfoView addSubview:fenView];
//    [_upUserInfoView addSubview:_fensiLabel];
    
    
    return _upUserInfoView;
    
    
}

///T台
-(UIView *)createTtaiView{
    //整个view
    ttaiView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 25)];
    ttaiView.backgroundColor = RGBCOLOR(239, 239, 239);
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 2, 25)];
    lineView.backgroundColor = RGBCOLOR(239, 47, 48);
    lineView.layer.cornerRadius = 3;
    [ttaiView addSubview:lineView];
    
    UILabel *titaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineView.frame.size.width+lineView.frame.origin.x+5, 0,150,25)];
    titaiLabel.font = [UIFont systemFontOfSize:15];
    titaiLabel.backgroundColor = [UIColor clearColor];
    titaiLabel.textAlignment = NSTextAlignmentLeft;
    [ttaiView addSubview:titaiLabel];
    if (self.theType == GSOMEONE) {
        titaiLabel.text = @"她的T台";
    }else{
        titaiLabel.text = @"我的T台";
    }
    return ttaiView;
}

-(void)gGoBackVc{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//////初始化瀑布流
-(void)initWaterFlowView{
    WaterFLayout* flowLayout = [[WaterFLayout alloc]init];
    
    if (self.theType == GSOMEONE) {
        flowLayout.headerHeight = 150+58+25;

    }else{
        flowLayout.headerHeight = 150+25;
    }
    
//    flowLayout.footerHeight = 100;
    
    
    self.waterfall = [[WaterF alloc]initWithCollectionViewLayout:flowLayout];
    
    
    self.waterfall.delegate  = self;
    
    //    flowLayout.minimumInteritemSpacing = 20.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.waterfall.sectionNum = 2;
    
    self.waterfall.collectionView.frame = CGRectMake(0,0, DEVICE_WIDTH, DEVICE_HEIGHT);
    
    self.waterfall.collectionView.showsVerticalScrollIndicator = NO;
    
    self.waterfall.collectionView.backgroundColor = RGBCOLOR(239, 239, 239);
    
    [self.waterfall.collectionView setAlwaysBounceVertical:YES];
    
    [self.view addSubview:self.waterfall.collectionView];
    
    [self.waterfall.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}


#pragma mark 监听UIScrollView的属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([@"contentSize" isEqualToString:keyPath]) {
        [self adjustFrame];
    }
}

#pragma mark 重写调整frame
- (void)adjustFrame
{
    UICollectionView *collection = self.waterfall.collectionView;
    // 内容的高度
    CGFloat contentHeight = collection.contentSize.height;
    // 表格的高度
    CGFloat scrollHeight = collection.frame.size.height;
    CGFloat y = MAX(contentHeight, scrollHeight);
    // 设置边框
    tableFooterView.top = y;
}

#pragma mark-----------------获取数据

/**
 * 获取T台列表
 */
- (void)deserveBuyForPage:(int)page
{
    NSString *url;
    if (self.theType == GSOMEONE) {
        
        //TODO:修改uid
       url = [NSString stringWithFormat:@"%@&page=%d&count=%d&user_id=%@&authcode=%@",POST_TLIST_URL,1,L_PAGE_SIZE,@"user_id",[GMAPI getAuthkey]];
    }else{
        url = [NSString stringWithFormat:@"%@&page=%d&count=%d&authcode=%@&user_id=%@",POST_TLIST_URL,pageNum,L_PAGE_SIZE,[GMAPI getAuthkey],[GMAPI getUid]];
        
//         url = [NSString stringWithFormat:@"%@&page=%d&count=%d&authcode=%@",POST_TLIST_URL,page,5,[GMAPI getAuthkey]];
    }


    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
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
        
        [refreshLoading stopAnimating];
        
        if (arr.count >= L_PAGE_SIZE) {
            _isHaveMore = YES;
            
            [self stopLoading:1];
            
        }else
        {
            _isHaveMore = NO;
            [self stopLoading:2];
        }
        
        if (isReload) {
            
            self.waterfall.imagesArr = [[NSArray alloc] initWithArray:arr];
        }else
        {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.waterfall.imagesArr];
            [temp addObjectsFromArray:arr];
            self.waterfall.imagesArr = [[NSArray alloc] initWithArray:temp];
        }
        
        [self.waterfall.collectionView reloadData];
    
            
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [refreshLoading stopAnimating];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - waterDelegate

-(void)itemCick:(id)aModel andCount:(int)mcount
{
    TPlatModel *model = (TPlatModel *)aModel;
    
    TTaiDetailController *t_detail = [[TTaiDetailController alloc]init];
    t_detail.tt_id = model.tt_id;
    [self.navigationController pushViewController:t_detail animated:YES];
}

- (void)waterScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -85) {
        
        isReload = YES;
        [refreshLoading startAnimating];
    }
}

- (void)waterScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    NSLog(@"1: %f 2: %f 3: %f",scrollView.contentOffset.y,scrollView.contentSize.height,scrollView.frame.size.height-40);
    
    CGFloat aHeight = 0.f;
    if (self.theType == GSOMEONE) {
        aHeight = 150+58+25;
        
    }else{
        aHeight = 150+25;
    }
    
    if(_isHaveMore && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height-40)))
    {
        
        [self startLoading];
        
        isReload = NO;
        pageNum ++;
        
        [self deserveBuyForPage:pageNum];
    }
    
    if (isReload) {
        
        pageNum = 1;
        [self deserveBuyForPage:1];
    }

}


#pragma - mark ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 下拉到最底部时显示更多数据
    
}


- (void)createFooterView
{
    CGFloat height = MAX(self.waterfall.collectionView.contentSize.height, self.waterfall.collectionView.frame.size.height);
    
    NSLog(@"waterfall %f || %f",self.waterfall.collectionView.contentSize.height,self.waterfall.collectionView.frame.size.height);
    
    NSLog(@"maxHeight %f",height);
    
    if (tableFooterView && [tableFooterView superview]) {
        
        tableFooterView.frame = CGRectMake(0.0f,height,self.waterfall.collectionView.frame.size.width,self.view.bounds.size.height);
    }else
    {
        tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, height, DEVICE_WIDTH, TABLEFOOTER_HEIGHT)];
        
        [tableFooterView addSubview:self.loadingIndicator];
        [tableFooterView addSubview:self.loadingLabel];
        [tableFooterView addSubview:self.normalLabel];
        
//        tableFooterView.backgroundColor = [UIColor orangeColor];
        
        [self.waterfall.collectionView addSubview:tableFooterView];
    }
}


#pragma - mark 创建所需label 和 UIActivityIndicatorView

- (UIActivityIndicatorView*)loadingIndicator
{
    if (!_loadingIndicator) {
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingIndicator.hidden = YES;
        _loadingIndicator.backgroundColor = [UIColor clearColor];
        _loadingIndicator.hidesWhenStopped = YES;
        _loadingIndicator.frame = CGRectMake(self.view.width/2 - 70 ,6+2 + (TABLEFOOTER_HEIGHT - 40)/2.0, 24, 24);
    }
    return _loadingIndicator;
}

- (UILabel*)normalLabel
{
    if (!_normalLabel) {
        _normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8 + (TABLEFOOTER_HEIGHT - 40)/2.0, self.view.width, 20)];
        _normalLabel.text = NSLocalizedString(NORMAL_TEXT, nil);
        _normalLabel.backgroundColor = [UIColor clearColor];
        [_normalLabel setFont:[UIFont systemFontOfSize:14]];
        _normalLabel.textAlignment = NSTextAlignmentCenter;
        [_normalLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    return _normalLabel;
    
}

- (UILabel*)loadingLabel
{
    if (!_loadingLabel) {
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(320.f/2-80,8 + (TABLEFOOTER_HEIGHT - 40)/2.0, self.view.width/2+30, 20)];
        _loadingLabel.text = NSLocalizedString(@"加载中...", nil);
        _loadingLabel.backgroundColor = [UIColor clearColor];
        [_loadingLabel setFont:[UIFont systemFontOfSize:14]];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        [_loadingLabel setTextColor:[UIColor darkGrayColor]];
        [_loadingLabel setHidden:YES];
    }
    
    return _loadingLabel;
}


- (void)startLoading
{
    [self.loadingIndicator startAnimating];
    [self.loadingLabel setHidden:NO];
    [self.normalLabel setHidden:YES];
}

- (void)stopLoading:(int)loadingType
{
//    _isHaveMore = NO;
    
    [self.loadingIndicator stopAnimating];
    switch (loadingType) {
        case 1:
            [self.normalLabel setHidden:NO];
            [self.normalLabel setText:NSLocalizedString(NORMAL_TEXT, nil)];
            [self.loadingLabel setHidden:YES];
            break;
        case 2:
            [self.normalLabel setHidden:NO];
            [self.normalLabel setText:NSLocalizedString(NOMORE_TEXT, nil)];
            [self.loadingLabel setHidden:YES];
            break;
        default:
            break;
    }
}

@end
