//
//  ProductDetailController.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "ProductDetailController.h"
#import "ProductModel.h"
#import "LShareSheetView.h"
#import "YIYIChatViewController.h"
#import "GLeadBuyMapViewController.h"
#import "LoginViewController.h"

#import "HomeMatchController.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface ProductDetailController ()
{
    ProductModel *aModel;
    
    UIButton *heartButton;//赞 与 取消赞
    
    UIButton *collectButton;//收藏 与 取消收藏

    MBProgressHUD *loading;
    
    LTools *tool_detail;
    
    NSArray *image_urls;//图片链接数组
}

@end

@implementation ProductDetailController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7DAOHANGLANBEIJING_PUSH2] forBarMetrics: UIBarMetricsDefault];
    }
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)dealloc
{
    NSLog(@"dealloc %@",self);
    [tool_detail cancelRequest];
    heartButton = nil;
    collectButton = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    [self createNavigationbarTools];
    
    self.bugButton.layer.cornerRadius = 5.0f;
    self.bugButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.bugButton.layer.borderWidth = 1.f;
    
    loading = [LTools MBProgressWithText:@"加载..." addToView:self.view];
    
    [self networkForDetail];
}

- (void)viewWillLayoutSubviews NS_AVAILABLE_IOS(5_0)
{
    NSLog(@"viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews NS_AVAILABLE_IOS(5_0)
{
    NSLog(@"viewDidLayoutSubviews");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求

- (void)networkForDetail
{
    
    if (tool_detail) {
        [tool_detail cancelRequest];
    }
    [loading show:YES];
    __weak typeof(self)weakSelf = self;
    
    __weak typeof(loading)weakLoading = loading;
        
    NSString *url = [NSString stringWithFormat:HOME_PRODUCT_DETAIL,self.product_id,[GMAPI getAuthkey]];
    tool_detail = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool_detail requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        
        [weakLoading hide:YES];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = result[@"pinfo"];
            
            ProductModel *aModel1 = [[ProductModel alloc]initWithDictionary:dic];
            
            [weakSelf prepareViewWithModel:aModel1];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
        [weakLoading hide:YES];
        
        [LTools showMBProgressWithText:failDic[RESULT_INFO] addToView:weakSelf.view];
        
    }];
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
    
    NSString *post = [NSString stringWithFormat:@"product_id=%@&authcode=%@",self.product_id,[GMAPI getAuthkey]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url = api;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        
//        [LTools alertText:result[@"msg"] viewController:self];
        
        if (action_type == Action_like_yes) {
            
            heartButton.selected = YES;
            
        }else if (action_type == Action_Collect_yes){
            
            collectButton.selected = YES;
            
        }else if (action_type == Action_like_no){
            
            heartButton.selected = NO;
            
        }else if (action_type == Action_Collect_no){
            
            collectButton.selected = NO;
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
    }];
}


#pragma mark - 事件处理

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = image_urls.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        // 替换为中等尺寸图片
        NSString *url = image_urls[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = self.bigImageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

/*
   是否喜欢
 */
- (void)clickToLike:(UIButton *)sender
{
    
    if ([LTools isLogin:self]) {
        
        if (sender.selected) {
            
            [self networkForActionType:Action_like_no];
        }else
        {
            [self networkForActionType:Action_like_yes];
        }
    }
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
  分享
 */

- (void)clickToShare:(UIButton *)sender
{
    [[LShareSheetView shareInstance] showShareContent:aModel.product_name title:@"衣加衣" shareUrl:@"http://www.alayy.com" shareImage:self.bigImageView.image targetViewController:self];
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

- (IBAction)clickToDaPeiShi:(id)sender {
    
    HomeMatchController *dapei = [[HomeMatchController alloc]init];
    dapei.isNormal = YES;
    dapei.rootViewController = self;
    [self.navigationController pushViewController:dapei animated:YES];
}


/**
 *  联系商家
 *
 *  @param sender
 */
- (IBAction)clickToContact:(id)sender {
    
    BOOL rong_login = [LTools cacheBoolForKey:LOGIN_RONGCLOUD_STATE];
    
    //服务器登陆成功
    if ([LTools isLogin:self]) {
        
        //融云登陆成功
        if (rong_login) {
            
            NSString *useriId;
            NSString *userName;
            if ([aModel.mall_info isKindOfClass:[NSDictionary class]]) {
                
                useriId = aModel.mall_info[@"uid"];
                userName = aModel.mall_info[@"mall_name"];
            }
            
            //test
            
//            useriId = @"38";
            
            YIYIChatViewController *contact = [[YIYIChatViewController alloc]init];
            contact.currentTarget = useriId;
            contact.currentTargetName = userName;
            contact.portraitStyle = RCUserAvatarCycle;
            contact.enableSettings = NO;
            contact.conversationType = ConversationType_PRIVATE;
            
            [self.navigationController pushViewController:contact animated:YES];
        }else
        {
            NSLog(@"服务器登陆成功了,融云未登陆");
        }
        
    }
}

- (IBAction)clickToBuy:(id)sender {
    
    GLeadBuyMapViewController *ll = [[GLeadBuyMapViewController alloc]init];
    ll.aModel = aModel;
    
    ll.theType = LEADYOUTYPE_STORE;
    
//    ////商城相关
//    @property(nonatomic,strong)NSString *storeName;
//    @property(nonatomic,assign)CLLocationCoordinate2D coordinate_store;
//    
//    
//    //产品相关
//    @property(nonatomic,strong)NSString *chanpinName;
//    @property(nonatomic,assign)CLLocationCoordinate2D coordinate_chanpin;
    if ([LTools isDictinary:aModel.mall_info]) {
        
        ll.storeName = aModel.mall_info[@"mall_name"];
        ll.coordinate_store = CLLocationCoordinate2DMake([aModel.mall_info[@"latitude"]floatValue], [aModel.mall_info[@"longitude"]floatValue]);
    }
    
//    UINavigationController *rrr = [[UINavigationController alloc]initWithRootViewController:ll];
    
    [self presentViewController:ll animated:YES completion:nil];
    
//    [self.navigationController pushViewController:ll animated:YES];
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

- (NSString *)thumbImageForArr:(NSArray *)imagesArr
{
    if (imagesArr.count >= 1) {
        
        NSDictionary *imageDic = imagesArr[0];
        NSDictionary *originalImage = imageDic[@"540Middle"];
        
        
        return originalImage[@"src"];
    }
    
    return @"";
}

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
 *  给view 赋值
 *
 *  @param aProductModel
 */
- (void)prepareViewWithModel:(ProductModel *)aProductModel
{
    
    //解析 原图
    NSArray *arr = aProductModel.images;
    NSMutableArray *temp_arr = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSDictionary *aDic in arr) {
        
        NSDictionary *original = aDic[@"original"];
        NSString *src = original[@"src"];
        [temp_arr addObject:src];
    }
    image_urls = [NSArray arrayWithArray:temp_arr];
    
    aModel = aProductModel;
    //赞 与 收藏 状态
    
    heartButton.selected = aProductModel.is_like == 1 ? YES : NO;
    
    collectButton.selected = aProductModel.is_favor ==  1 ? YES : NO;
    
    //精品店商品 和 商场店商品 的品牌名字
    
    NSString *brandName = aProductModel.product_brand_name;
    
    if (brandName == nil || [brandName isEqualToString:@"(null)"] || [brandName isEqualToString:@"null"]) {
        
        self.brandName.hidden = YES;
    }else
    {
        self.brandName.hidden = NO;
    }
    
    self.brandName.text = [NSString stringWithFormat:@" %@ ",brandName];
    
    
    CGFloat aHeight = [self thumbImageHeightForArr:aProductModel.images];
    
    self.bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, aHeight)];
    [self.view addSubview:_bigImageView];
    
    [self.view insertSubview:_bigImageView atIndex:0];
    
//    self.bigImageView.height = aHeight;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:[self thumbImageForArr:aProductModel.images]] placeholderImage:[UIImage imageNamed:nil]];
    
    //点击图片
    self.bigImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [_bigImageView addGestureRecognizer:tap];
    
    
    self.priceLabel.text = [NSString stringWithFormat:@" %.2f  ",[aProductModel.product_price floatValue]];
    
    if (aProductModel.discount_num * 10 == 10) {
        
        self.discountLabel.hidden = YES;
        
    }else
    {
        self.discountLabel.text = [NSString stringWithFormat:@"%.1f折",aProductModel.discount_num * 10];
    }
    
    
    self.titleLabel.text = aProductModel.product_name;
    self.xingHaoLabel.text = [NSString stringWithFormat:@"型号: %@",aProductModel.product_sku];
    self.biaoQianLabel.text = [NSString stringWithFormat:@"标签: %@",aProductModel.product_tag];
    
    NSString *mallName = aProductModel.mall_info[@"mall_name"];
    self.shangChangLabel.text = [NSString stringWithFormat:@"商场: %@",mallName];
    
    NSString *address = aProductModel.mall_info[@"street"];
    self.addressLabel.text = [NSString stringWithFormat:@"地址: %@",address];

}


#pragma mark - 创建视图

- (void)createNavigationbarTools
{
    
    UIButton *rightView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    rightView.backgroundColor=[UIColor clearColor];
    
    heartButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [heartButton addTarget:self action:@selector(clickToLike:) forControlEvents:UIControlEventTouchUpInside];
//    [heartButton setTitle:@"喜欢" forState:UIControlStateNormal];
    [heartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [heartButton setImage:[UIImage imageNamed:@"xihuanb"] forState:UIControlStateNormal];
    [heartButton setImage:[UIImage imageNamed:@"xihuanb_down"] forState:UIControlStateSelected];
    [heartButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    //收藏的
    
    collectButton =[[UIButton alloc]initWithFrame:CGRectMake(74,0, 44,42.5)];
    [collectButton addTarget:self action:@selector(clickToCollect:) forControlEvents:UIControlEventTouchUpInside];
    [collectButton setImage:[UIImage imageNamed:@"shoucangb"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"shoucangb_down"] forState:UIControlStateSelected];
    [collectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    collectButton.center = CGPointMake(rightView.width / 2.f, collectButton.center.y);
    [collectButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    UIButton *shareButton =[[UIButton alloc]initWithFrame:CGRectMake(rightView.width - 44,0, 44,44)];
//    [shareButton setTitle:@"评论" forState:UIControlStateNormal];
    shareButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [shareButton addTarget:self action:@selector(clickToShare:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImage:[UIImage imageNamed:@"product_share"] forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    [rightView addSubview:shareButton];
    [rightView addSubview:heartButton];
    [rightView addSubview:collectButton];
    
    UIBarButtonItem *comment_item=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    
    self.navigationItem.rightBarButtonItem = comment_item;
}


@end
