//
//  GTtaiDetailViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/8/14.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GTtaiDetailViewController.h"

#import "LWaterflowView.h"//瀑布流
#import "CycleScrollView1.h"//上下滚动
#import "MessageDetailController.h"//活动详情
#import "TMPhotoQuiltViewCell.h"//瀑布流cell
#import "TPlatModel.h"//T台model
#import "LShareSheetView.h"//分享

@interface GTtaiDetailViewController ()<TMQuiltViewDataSource,WaterFlowDelegate,UIScrollViewDelegate>
{
    
    TPlatModel *_aModel;
    
    UIButton *_collectButton;//收藏 与 取消收藏
    UIButton *_heartButton;//赞 与 取消赞
    MBProgressHUD *_loading;
    
    UIScrollView *_headerView;
    LWaterflowView *_waterFlow;
    UILabel *_backLabel;//释放返回
    UILabel *_zanNumLabel;//赞数量label
    UILabel *_commentNumLabel;//评论数量label
    NSArray *_image_urls;//图片链接数组
    
    int _count;//网络请求完成个数
    NSArray *_sameStyleArray;//同款单品
    
    
    LTools *tool_detail;
}
@end

@implementation GTtaiDetailViewController


- (void)dealloc
{
    NSLog(@"dealloc %@",self);
    [tool_detail cancelRequest];
    _heartButton = nil;
    _collectButton = nil;
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
    
    //请求单品详情
    [self networkForDetail];
    
    //请求单品同款
    [self networkForDetailSameStyle];
    
    
    //瀑布流相关
    _waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64) waterDelegate:self waterDataSource:self noHeadeRefresh:YES noFooterRefresh:YES];
    _waterFlow.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_waterFlow];
    
    //下拉 返回上面内容
    _backLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40) title:@"下拉,返回单品详情" font:10 align:NSTextAlignmentCenter textColor:[UIColor colorWithHexString:@"8b8b8b"]];
    [_waterFlow addSubview:_backLabel];
    [_waterFlow bringSubviewToFront:_waterFlow.quitView];
    _waterFlow.hidden = YES;
    
    CGFloat aHeight = [LTools heightForImageHeight:42 imageWidth:375 showWidth:DEVICE_WIDTH];
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, aHeight)];
    lineImage.image = [UIImage imageNamed:@"danpinxq_tuijian"];
    lineImage.contentMode = UIViewContentModeCenter;
    _waterFlow.headerView = lineImage;
    
//    [self deserveBuyForSex:Sort_Sex_No discount:Sort_Discount_No page:1];
    
    
    
}



#pragma mark - MyMethod

//请求T台详情数据
-(void)networkForDetail{
    if (tool_detail) {
        [tool_detail cancelRequest];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self)weakSelf = self;
    
    self.tPlat_id = @"11";
    NSString *url = [NSString stringWithFormat:HOME_PRODUCT_DETAIL,self.tPlat_id,[GMAPI getAuthkey]];
    tool_detail = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool_detail requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = result[@"pinfo"];
            
            TPlatModel *aModel1 = [[TPlatModel alloc]initWithDictionary:dic];
            weakSelf.theModel = aModel1;
            _aModel = aModel1;
            [self setValue:[NSNumber numberWithInt:_count + 1] forKeyPath:@"_count"];
            
            NSLog(@"........................%d",_count);
            
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}

//请求同款T台数据
-(void)networkForDetailSameStyle{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    self.tPlat_id = @"146";
    NSString *url = [NSString stringWithFormat:HOME_PRODUCT_DETAIL_SAME_STYLE,self.tPlat_id];
    tool_detail = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool_detail requestCompletion:^(NSDictionary *result, NSError *erro) {
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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


/*
 是否收藏
 */

- (void)clickToCollect:(UIButton *)sender
{
    if (sender.selected) {
        
        [self networkForActionType:Action_Collect_no];
    }else
    {
        [self networkForActionType:Action_Collect_yes];
    }
}



/*
 是否喜欢
 */
- (void)clickToLike:(UIButton *)sender
{
    
    if ([LTools isLogin:self]) {
        
        [LTools animationToBigger:_heartButton duration:0.2 scacle:1.5];
        
        if (_heartButton.selected) {
            
            [self networkForActionType:Action_like_no];
        }else
        {
            [self networkForActionType:Action_like_yes];
        }
    }
}







/**
 *  赞 取消赞 收藏 取消收藏
 *
 *  @param action_type
 */
- (void)networkForActionType:(ACTION_TYPE)action_type
{
    
    __weak typeof(self)weakSelf = self;
    
    NSString *api;
    if (action_type == Action_like_yes) {
        api = HOME_PRODUCT_ZAN_ADD;
    }else if (action_type == Action_Collect_yes){
        api = HOME_PRODUCT_COLLECT_ADD;
    }else if (action_type == Action_like_no){
        api = HOME_PRODUCT_ZAN_Cancel;
    }else if (action_type == Action_Collect_no){
        
        api = HOME_PRODUCT_COLLECT_Cancel;
    }
    
    NSString *post = [NSString stringWithFormat:@"product_id=%@&authcode=%@",self.tPlat_id,[GMAPI getAuthkey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *url = api;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        
        if (action_type == Action_like_yes) {
            
            [weakSelf updateZanState:YES];
            
            
        }else if (action_type == Action_Collect_yes){
            
            _collectButton.selected = YES;
            //关注单品通知
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_TTai object:nil userInfo:@{@"state":[NSNumber numberWithBool:YES]}];
            
        }else if (action_type == Action_like_no){
            
            [weakSelf updateZanState:NO];
            
        }else if (action_type == Action_Collect_no){
            _collectButton.selected = NO;
            //关注单品通知
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_TTai object:nil userInfo:@{@"state":[NSNumber numberWithBool:NO]}];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
    }];
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
            
            [self prepareViewWithModel:_aModel];
        }
    }
}

/**
 *  给view 赋值
 *
 *  @param aProductModel
 */
- (void)prepareViewWithModel:(TPlatModel *)aProductModel
{
    
    //解析 原图
    NSArray *arr = aProductModel.images;
    NSMutableArray *temp_arr = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSDictionary *aDic in arr) {
        
        NSDictionary *original = aDic[@"original"];
        NSString *src = original[@"src"];
        [temp_arr addObject:src];
    }
    _image_urls = [NSArray arrayWithArray:temp_arr];
    
    _aModel = aProductModel;
    
    //赞 与 收藏 状态
    _heartButton.selected = aProductModel.is_like == 1 ? YES : NO;
    _collectButton.selected = aProductModel.is_favor ==  1 ? YES : NO;
    
    //创建详情相关view 并赋值
    
    [self createDetailViewsWithModel:aProductModel];
    
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
 *  创建详情显示view 除了底部品牌推荐 其他的作为header
 *
 *  @param aProductModel 单品详情model
 */

- (void)createDetailViewsWithModel:(TPlatModel *)aProductModel
{
    //头部view
    _headerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64)];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.delegate = self;
    [self.view addSubview:_headerView];
    
    _waterFlow.hidden = NO;
    
    [self createBottomView];//底部
    
    //单品图片
    //图片高度
    CGFloat aHeight = [self thumbImageHeightForArr:aProductModel.images];
    CGFloat aWidth = DEVICE_WIDTH;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, aHeight)];
    [imageView l_setImageWithURL:[NSURL URLWithString:[self originalImageForArr:aProductModel.images]] placeholderImage:DEFAULT_YIJIAYI];
    [_headerView addSubview:imageView];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, imageView.bottom, DEVICE_WIDTH, 0.5)];
    line.backgroundColor = DEFAULT_VIEW_BACKGROUNDCOLOR;
    [_headerView addSubview:line];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, imageView.bottom + 10, DEVICE_WIDTH - 20, 18) title:aProductModel.tPlat_name font:15 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    [_headerView addSubview:titleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.numberOfLines = 0;
    aHeight = [LTools heightForText:aProductModel.tPlat_name width:titleLabel.width Boldfont:15];
    titleLabel.height = aHeight;
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom + 5, DEVICE_WIDTH, 0.5)];
    line2.backgroundColor = DEFAULT_VIEW_BACKGROUNDCOLOR;
    [_headerView addSubview:line2];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, line2.bottom + 55, DEVICE_WIDTH, 0.5)];
    line3.backgroundColor = DEFAULT_VIEW_BACKGROUNDCOLOR;
    [_headerView addSubview:line3];
    
#pragma - mark 评论相关
    //评论
    
    NSArray *commentArray = @[@"张三:评论的内容在这里",@"李四:评论的内容比较长评论的内容比较长评论的内容比较长评论的内容比较长评论的内容比较长kkkkk荣荣荣",@"王二:呃逆荣在轮播滚动"];
    NSMutableArray *viewsArray1 = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH - 105, 55)];
        view.backgroundColor = [UIColor whiteColor];
        [viewsArray1 addObject:view];
        
        NSString *content = commentArray[i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 12.5, view.width - 20, 30) title:content font:12 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"6d6d6d"]];
        [view addSubview:label];
        label.numberOfLines = 2;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    CycleScrollView1 * topScrollView1 = [[CycleScrollView1 alloc] initWithFrame:CGRectMake(0, line2.bottom, DEVICE_WIDTH - 105, 55) animationDuration:2];
    topScrollView1.isPageControlHidden = YES;
    topScrollView1.scrollView.showsHorizontalScrollIndicator = FALSE;
    [_headerView addSubview:topScrollView1];
    
    topScrollView1.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray1[pageIndex];
    };
    
    NSInteger count1 = viewsArray1.count;
    topScrollView1.totalPagesCount = ^NSInteger(void){
        return count1;
    };
    
    //    __weak typeof (self)bself = self;
    topScrollView1.TapActionBlock = ^(NSInteger pageIndex){
        //        [bself cycleScrollDidClickedWithIndex:pageIndex];
    };
    
    //点赞、评论
    
    UIButton *zanBtn = [[UIButton alloc]initWithframe:CGRectMake(DEVICE_WIDTH - 10 - 40,line2.bottom + 8, 40, 40) buttonType:UIButtonTypeCustom nornalImage:nil selectedImage:nil target:self action:@selector(clickToLike:)];
    [_headerView addSubview:zanBtn];
    [zanBtn addCornerRadius:20];
    [zanBtn setBorderWidth:.5 borderColor:DEFAULT_TEXTCOLOR];
    
    _heartButton = [[UIButton alloc]initWithframe:CGRectMake(0, 5, 40, 20) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"Ttai_zan_normal"] selectedImage:[UIImage imageNamed:@"Ttai_zan_selected"] target:self action:nil];
    [zanBtn addSubview:_heartButton];
    _heartButton.userInteractionEnabled = NO;
    _heartButton.selected = aProductModel.is_like == 1 ? YES : NO;
    
    NSString *zanString = [self zanNumStringForNum:aProductModel.tPlat_like_num];
    _zanNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _heartButton.bottom, 40, 10) title:zanString font:10 align:NSTextAlignmentCenter textColor:DEFAULT_TEXTCOLOR];
    [zanBtn addSubview:_zanNumLabel];
    
    
    UIButton *commentBtn = [[UIButton alloc]initWithframe:CGRectMake(zanBtn.left - 14 - 40, zanBtn.top, 40, 40) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"Ttaixq_pinglun2"] selectedImage:[UIImage imageNamed:@"Ttaixq_pinglun2"] target:self action:@selector(clickToComment:)];
    [_headerView addSubview:commentBtn];
    NSString *commentString = [self zanNumStringForNum:@"1235"];
    _commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 40, 10) title:commentString font:10 align:NSTextAlignmentCenter textColor:DEFAULT_TEXTCOLOR];
    [commentBtn addSubview:_commentNumLabel];
    
#pragma - mark 标签相关
    //标签
    NSArray *tags = aProductModel.tag;
    int count = (int)tags.count;
    CGFloat left = 10;
    for (int i = 0; i < count; i ++) {
        NSString *name = tags[i][@"tag_name"];
        CGFloat width = [LTools widthForText:name font:10];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(left, 7 + line3.bottom, width + 10, 15) title:name font:10 align:NSTextAlignmentCenter textColor:DEFAULT_TEXTCOLOR];
        [_headerView addSubview:label];
        [label addCornerRadius:7.5];
        [label setBorderWidth:0.5 borderColor:DEFAULT_TEXTCOLOR];
        left = label.right + 10;
        [label addTaget:self action:@selector(clickToTagList:) tag:100 + i];
    }
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, line3.bottom + 30, DEVICE_WIDTH, 0.5)];
    line4.backgroundColor = DEFAULT_VIEW_BACKGROUNDCOLOR;
    [_headerView addSubview:line4];
    
#pragma - mark 固定介绍图
    
    CGFloat top = line4.bottom;
    
    //有固定介绍图
    NSDictionary *official_pic = aProductModel.official_pic;
    if (official_pic && [official_pic isKindOfClass:[NSDictionary class]]) {
        
        //固定的图片
        CGFloat imageHeight = [official_pic[@"height"] floatValue];
        CGFloat imageWidth = [official_pic[@"width"] floatValue];
        NSString *imageUrl = official_pic[@"url"];
        aHeight = [LTools heightForImageHeight:imageHeight imageWidth:imageWidth showWidth:DEVICE_WIDTH];
        UIImageView *constImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, line4.bottom + 5, DEVICE_WIDTH, aHeight)];
        [_headerView addSubview:constImageView];
        [constImageView l_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:DEFAULT_YIJIAYI];
        UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, constImageView.bottom + 5, DEVICE_WIDTH, 0.5)];
        line5.backgroundColor = DEFAULT_VIEW_BACKGROUNDCOLOR;
        [_headerView addSubview:line5];
        
        top = line5.bottom;
    }
#pragma - mark 相似单品及所在商场
    //所在商场
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, top, DEVICE_WIDTH, 40) title:@"所在商场" font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    [_headerView addSubview:label];
    
    UIView *line6 = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom, DEVICE_WIDTH, 0.5)];
    line6.backgroundColor = DEFAULT_VIEW_BACKGROUNDCOLOR;
    [_headerView addSubview:line6];
    
    //大于3个显示更多
    if (count > 3) {
        
        UIButton *more_btn = [[UIButton alloc]initWithframe:CGRectMake(DEVICE_WIDTH - 35 - 10,top + 6, 35, 16.5) buttonType:UIButtonTypeRoundedRect normalTitle:@"更多" selectedTitle:nil target:self action:@selector(clickToMoreMall:)];
        [_headerView addSubview:more_btn];
        [more_btn addCornerRadius:8];
        [more_btn setBorderWidth:.5 borderColor:DEFAULT_TEXTCOLOR];
        [more_btn setTitleColor:DEFAULT_TEXTCOLOR forState:UIControlStateNormal];
        [more_btn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        
        top = more_btn.bottom + 6;
    }
    
#pragma - mark 官方活动
    
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, top, DEVICE_WIDTH, 0.5)];
    line5.backgroundColor = DEFAULT_VIEW_BACKGROUNDCOLOR;
    [_headerView addSubview:line5];
    
    NSDictionary *official_activity = aProductModel.official_activity;
    if (official_activity && [official_activity isKindOfClass:[NSDictionary class]]) {
        
        //固定的图片
        CGFloat imageHeight = [official_activity[@"height"] floatValue];
        CGFloat imageWidth = [official_activity[@"width"] floatValue];
        NSString *imageUrl = official_activity[@"url"];
        
        aHeight = [LTools heightForImageHeight:imageHeight imageWidth:imageWidth showWidth:DEVICE_WIDTH];
        UIImageView *constImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, line5.bottom, DEVICE_WIDTH, aHeight)];
        [_headerView addSubview:constImageView];
        [constImageView l_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:DEFAULT_YIJIAYI];
        [constImageView addTaget:self action:@selector(clickToActivity:) tag:0];
        
        top = constImageView.bottom;
    }
    
#pragma - mark 单品详情
    //商品详情
    //单品的其他图片
    NSArray *images = aProductModel.images;
    count = (int)images.count;
    if (count > 1) {
        
        aHeight = [LTools heightForImageHeight:42 imageWidth:375 showWidth:DEVICE_WIDTH];
        UIImageView *detailImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, top, DEVICE_WIDTH, aHeight)];
        detailImage.image = [UIImage imageNamed:@"danpinxq_xq"];
        [_headerView addSubview:detailImage];
        
        top = detailImage.bottom;
        
        //从第二张开始
        for (int i = 1; i < count; i ++) {
            
            NSDictionary *imageDic = images[i];
            NSDictionary *originalImage = imageDic[@"540Middle"];
            
            aHeight = [originalImage[@"height"] floatValue];
            aWidth = [originalImage[@"width"] floatValue];
            
            NSString *imageUrl = originalImage[@"src"];
            //图片高度
            aHeight = [LTools heightForImageHeight:aHeight imageWidth:aWidth showWidth:DEVICE_WIDTH];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, top, DEVICE_WIDTH, aHeight)];
            [imageView l_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:DEFAULT_YIJIAYI];
            [_headerView addSubview:imageView];
            
            top = imageView.bottom + 5;
        }
    }
    
    //继续拖动查看 品牌推荐
    
    UILabel *moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, top + 10, DEVICE_WIDTH, 60) title:@"继续拖动,查看品牌推荐" font:10 align:NSTextAlignmentCenter textColor:[UIColor colorWithHexString:@"8b8b8b"]];
    [_headerView addSubview:moreLabel];
    
    _headerView.contentSize = CGSizeMake(DEVICE_WIDTH, moreLabel.bottom);
    
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


#pragma mark - @protocol UIScrollViewDelegate<NSObject>

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 下拉到最底部时显示更多数据
    
    if(scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height + 60 + 30)))
    {
        [self moveToUp:YES];
    }
}

#pragma mark - WaterFlowDelegate

- (void)waterScrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < -40)
    {
        _backLabel.text = @"释放,返回单品详情";
    }else
    {
        _backLabel.text = @"下拉,返回单品详情";
    }
    
}

- (void)waterScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < -40)
    {
        [self moveToUp:NO];
    }
}

- (void)waterLoadNewData
{
    
}
- (void)waterLoadMoreData
{
    
}

- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *aMode = _waterFlow.dataArray[indexPath.row];
    [MiddleTools pushToProductDetailWithId:aMode.product_id fromViewController:self lastNavigationHidden:NO hiddenBottom:YES];
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    CGFloat imageH = 0.f;
    ProductModel *aMode = _waterFlow.dataArray[indexPath.row];
    if (aMode.imagelist.count >= 1) {
        
        
        NSDictionary *imageDic = aMode.imagelist[0];
        NSDictionary *middleImage = imageDic[@"540Middle"];
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
    return [_waterFlow.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    
    cell.layer.cornerRadius = 3.f;
    
    ProductModel *aMode = _waterFlow.dataArray[indexPath.row];
    [cell setCellWithModel:aMode];
    
    cell.likeBackBtn.tag = 100 + indexPath.row;
    [cell.likeBackBtn addTarget:self action:@selector(clickToZan:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



/**
 *  上拉下拉移动视图
 *
 *  @param up 是否上拉
 */
- (void)moveToUp:(BOOL)up
{
    if (up) {
        _waterFlow.top = _headerView.height;
    }
    [UIView animateWithDuration:1 animations:^{
        
        _headerView.top = up ? - _headerView.height : 0;
        _waterFlow.top = up ? 0 : _headerView.height;
    }];
}



@end
