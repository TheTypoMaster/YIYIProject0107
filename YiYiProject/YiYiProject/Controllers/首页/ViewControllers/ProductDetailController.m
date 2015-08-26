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

#import "GAddTtaiImageLinkViewController.h"

#import "TMPhotoQuiltViewCell.h"

#import "LContactView.h"//联系view

#import "BottomToolsView.h"//底部工具

@interface ProductDetailController ()<MJPhotoBrowserDelegate>
{
    ProductModel *aModel;
    
    UIButton *heartButton;//赞 与 取消赞
    
    UIButton *collectButton;//收藏 与 取消收藏

    MBProgressHUD *loading;
    
    LTools *tool_detail;
    
    NSArray *image_urls;//图片链接数组
}

@property (strong, nonatomic) UILabel *brandName;

@property (strong, nonatomic) UILabel *shopNameLabel;
@property (strong, nonatomic) UIImageView *bigImageView;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *discountLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *xingHaoLabel;
@property (strong, nonatomic) UILabel *biaoQianLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UIButton *bugButton;
@property (strong, nonatomic) UIButton *shopButton;
@property (weak, nonatomic) UIButton *lianxiDianzhuBtn;

@property(nonatomic,strong)ProductModel *theModel;//单品model 给聊天界面传递


@end

@implementation ProductDetailController

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
    
    [self createNavigationbarTools];//导航条
    
    [self.bugButton addCornerRadius:3.f];
    
    [self addProductVisit];//添加单品浏览数
    
    //请求单品详情
    [self networkForDetail];
    
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

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self)weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:HOME_PRODUCT_DETAIL,self.product_id,[GMAPI getAuthkey]];
    tool_detail = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool_detail requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = result[@"pinfo"];
            
            ProductModel *aModel1 = [[ProductModel alloc]initWithDictionary:dic];
            weakSelf.theModel = aModel1;
            [weakSelf prepareViewWithModel:aModel1];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
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
        
        if (action_type == Action_like_yes) {
            
            [weakSelf updateZan:YES];
            
        }else if (action_type == Action_Collect_yes){
            
            collectButton.selected = YES;
            
            //关注单品通知
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_PRODUCT object:nil userInfo:@{@"state":[NSNumber numberWithBool:YES]}];
            
        }else if (action_type == Action_like_no){
            
            [weakSelf updateZan:NO];
            
        }else if (action_type == Action_Collect_no){
            
            collectButton.selected = NO;
            
            //关注单品通知
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GUANZHU_PRODUCT object:nil userInfo:@{@"state":[NSNumber numberWithBool:NO]}];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
    }];
}

/**
 *  添加单品浏览量
 */
- (void)addProductVisit
{
    //判断是否登录
    NSString *url = @" ";
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE]) {
        url = [NSString stringWithFormat:@"%@&product_id=%@&authcode=%@",LIULAN_NUM_PRODUCT,self.product_id,[GMAPI getAuthkey]];
        
    }else{
        url = [NSString stringWithFormat:@"%@&product_id=%@",LIULAN_NUM_PRODUCT,self.product_id];
    }
    LTools *ccc = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
}


#pragma mark - 事件处理
/**
 *  更新赞状态
 *
 *  @param isZan 是否是赞
 */
- (void)updateZan:(BOOL)isZan
{
    heartButton.selected = isZan;
    
    //更改上一个界面的状态  从我的店铺界面跳转
    if (self.theLastViewClickedCell) {
        
        //赞的红心状态
        self.theLastViewClickedCell.like_btn.selected = isZan;
        int zanNum = [self.theLastViewClickedCell.like_label.text intValue];
        zanNum = isZan ? zanNum + 1 : zanNum - 1;
        self.theLastViewClickedCell.like_label.text = [NSString stringWithFormat:@"%d",zanNum];
        //赞后面的数字
        self.theLastViewProductModel.is_like = isZan ? 1 : 0;
        int like_num = [self.theLastViewProductModel.product_like_num intValue];
        like_num = isZan ? like_num + 1 : like_num - 1;
        self.theLastViewProductModel.product_like_num = [NSString stringWithFormat:@"%d",like_num];
    }
}

-(void)leftButtonTap:(UIButton *)sender
{
    if (self.isPresent) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = (int)image_urls.count;
    
    UIImageView *aImageView = (UIImageView *)tap.view;
    
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        // 替换为中等尺寸图片
        NSString *url = image_urls[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = aImageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.delegate = self;
    [browser show];
}

/*
   是否喜欢
 */
- (void)clickToLike:(UIButton *)sender
{
    
    if ([LTools isLogin:self]) {
        
        [LTools animationToBigger:sender duration:0.2 scacle:1.5];
        
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
    NSString *productString = [NSString stringWithFormat:SHARE_PRODUCT_DETAIL,self.product_id];
    
    NSString *safeString = [LTools safeString:self.theModel.product_name];
    NSString *title = safeString.length > 0 ? safeString : @"衣加衣";
    
    [[LShareSheetView shareInstance] showShareContent:aModel.product_name title:title shareUrl:productString shareImage:self.bigImageView.image targetViewController:self];
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

#pragma mark--联系搭配师

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
    
    __weak typeof(self)weakSelf = self;
    
    [[LContactView shareInstance] show];
    
    [[LContactView shareInstance] setContactBlock:^ (CONTACTTYPE contactType,int extra){
        
        if (contactType == CONTACTTYPE_PHONE) {
            
            [weakSelf clickToPhone:nil];
        
        }else if (contactType == CONTACTTYPE_PRIVATECHAT){
            
            [weakSelf clickToPrivateChat:nil];
        }
        
    }];
}

/**
 *  私聊
 *
 *  @param sender
 */
- (void)clickToPhone:(UIButton *)sender
{
    NSString *phoneNum = aModel.mall_info[@"mobile"];
    
    if (phoneNum.length > 0) {
        
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"拨号" message:phoneNum delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [al show];
    }else
    {
        [LTools showMBProgressWithText:@"抱歉!该商家暂未填写有效联系方式" addToView:self.view];
    }
}

//打电话
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *phoneNum = aModel.mall_info[@"mobile"];

    //0取消    1确定
    if (buttonIndex == 1) {
        NSString *strPhone = [NSString stringWithFormat:@"tel://%@",phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];
    }
}

/**
 *  私聊
 *
 *  @param sender
 */
- (void)clickToPrivateChat:(UIButton *)sender
{
    BOOL rong_login = [LTools cacheBoolForKey:LOGIN_RONGCLOUD_STATE];
    
    //服务器登陆成功
    if ([LTools isLogin:self]) {
        
        //融云登陆成功
        if (rong_login) {
            
            NSString *useriId;
            NSString *userName;
            NSString *mall_type;
            NSString *brand_name;
            NSString *mall_name;
            YIYIChatViewController *contact = [[YIYIChatViewController alloc]init];
            
            
            if ([aModel.mall_info isKindOfClass:[NSDictionary class]]) {
                
                useriId = aModel.mall_info[@"uid"];
                userName = aModel.mall_info[@"mall_name"];
                mall_type = aModel.mall_info[@"mall_type"];
                if ([mall_type intValue] == 1) {//商场店
                    brand_name = aModel.brand_info[@"brand_name"];//品牌名
                    mall_name = aModel.mall_info[@"mall_name"];//商城名
                    NSString *aaa = [NSString stringWithFormat:@"%@.%@",brand_name,mall_name];
                    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:aaa];
                    NSInteger pinpaiNameLength = brand_name.length;
                    NSInteger storeNameLength = mall_name.length;
                    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,pinpaiNameLength+1)];
                    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17*GscreenRatio_320] range:NSMakeRange(0,pinpaiNameLength)];
                    [title addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(240, 173, 184) range:NSMakeRange(pinpaiNameLength+1, storeNameLength)];
                    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13*GscreenRatio_320] range:NSMakeRange(pinpaiNameLength+1, storeNameLength)];
                    contact.GTitleLabel.textAlignment = NSTextAlignmentCenter;
                    contact.GTitleLabel.attributedText = title;
                }else{
                    userName = userName;
                    contact.GTitleLabel.text = userName;
                    contact.GTitleLabel.textColor = RGBCOLOR(251, 108, 157);
                }
                
            }
            
            contact.currentTarget = useriId;
            contact.portraitStyle = RCUserAvatarCycle;
            contact.enableSettings = NO;
            contact.conversationType = ConversationType_PRIVATE;
            
            contact.theModel = self.theModel;
            contact.isProductDetailVcPush = YES;
            
            
            [self.navigationController pushViewController:contact animated:YES];
        }else
        {
            NSLog(@"服务器登陆成功了,融云未登陆");
            
            
            AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appdelegate loginToRongCloud];
            
        }
        
    }
}

#pragma mark--带你去买

- (IBAction)clickToBuy:(id)sender {
    
    GLeadBuyMapViewController *ll = [[GLeadBuyMapViewController alloc]init];
    ll.aModel = aModel;
    
    ll.theType = LEADYOUTYPE_STORE;
    
    if ([LTools isDictinary:aModel.mall_info]) {
        
        ll.storeName = aModel.mall_info[@"mall_name"];
        ll.coordinate_store = CLLocationCoordinate2DMake([aModel.mall_info[@"latitude"]floatValue], [aModel.mall_info[@"longitude"]floatValue]);
    }
    
//    UINavigationController *rrr = [[UINavigationController alloc]initWithRootViewController:ll];
    
    [self presentViewController:ll animated:YES completion:nil];
    
//    [self.navigationController pushViewController:ll animated:YES];
}

- (IBAction)clickToStore:(id)sender {
    
    
    if (self.isChooseProductLink) {
        GAddTtaiImageLinkViewController *cc = self.navigationController.viewControllers[0];
        
        NSString *shopId = aModel.product_shop_id;
        NSString *productName = aModel.product_name;
        NSString *shopName = aModel.mall_info[@"mall_name"];
        NSString *price = [NSString stringWithFormat:@"%@",aModel.product_price];

        [cc setGmoveImvProductId:self.product_id shopid:shopId productName:productName shopName:shopName price:price type:@"单品"];
        [self.navigationController popToViewController:cc animated:YES];
        return;
    }
    
//    int mall_type = [aModel.mall_info[@"mall_type"] intValue];
    int shop_type = [aModel.shop_type intValue];
    NSString *storeId;
    NSString *storeName;
    
    if (shop_type == ShopType_pinpaiDian) {
        
        storeId = aModel.product_shop_id;
        storeName = aModel.product_brand_name;
        NSString *brandName = aModel.product_brand_name;//品牌店需要brandName
        
        [MiddleTools pushToStoreDetailVcWithId:storeId shopType:shop_type storeName:storeName brandName:brandName fromViewController:self lastNavigationHidden:NO hiddenBottom:NO isTPlatPush:NO];
        
    }else if (shop_type == ShopType_jingpinDian || shop_type == ShopType_mall){
        
        storeId = aModel.mall_info[@"mall_id"];
        storeName = aModel.mall_info[@"mall_name"];
        
        [MiddleTools pushToStoreDetailVcWithId:storeId shopType:shop_type storeName:storeName brandName:@" " fromViewController:self lastNavigationHidden:NO hiddenBottom:NO isTPlatPush:NO];
    }
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
    
    //创建详情相关view 并赋值
    
    [self createDetailViewsWithModel:aProductModel];

}


#pragma mark - 创建视图
/**
 *  创建详情显示view
 *
 *  @param aProductModel 单品详情model
 */

- (void)createDetailViewsWithModel:(ProductModel *)aProductModel
{
    //底部scrollView
    UIScrollView *contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64)];
    [self.view addSubview:contentScroll];
    contentScroll.showsVerticalScrollIndicator = NO;
    contentScroll.backgroundColor = DEFAULT_VIEW_BACKGROUNDCOLOR;
    
    //图片高度
    CGFloat aHeight = [self thumbImageHeightForArr:aProductModel.images];
    contentScroll.contentSize = CGSizeMake(DEVICE_WIDTH, aHeight > DEVICE_HEIGHT ? aHeight : DEVICE_HEIGHT);
    
    //图片
    self.bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, aHeight)];
    [contentScroll addSubview:_bigImageView];
//    [self.bigImageView setImageWithURL:[NSURL URLWithString:[self thumbImageForArr:aProductModel.images]] placeHolderText:@"抱歉,图片加载失败" backgroundColor:RGBCOLOR(235, 235, 235) holderTextColor:[UIColor whiteColor]];
    
    [_bigImageView l_setImageWithURL:[NSURL URLWithString:[self originalImageForArr:aProductModel.images]] placeholderImage:DEFAULT_YIJIAYI];
    
    //点击图片
    self.bigImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [_bigImageView addGestureRecognizer:tap];
    
    
    //底部详情 view
    
    CGFloat aDis = 10.f;//titleLable 距离透明部分顶部距离
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 64 - (232 + aDis), DEVICE_WIDTH, 232 + aDis)];
    bottomView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:bottomView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, aDis, DEVICE_WIDTH - 40, 18) title:aProductModel.product_name font:15 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    [bottomView addSubview:titleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    

//    CGFloat top = titleLabel.bottom + 11 + (11 + 15) * i
    aDis = 11 + 15;
    CGFloat top = titleLabel.bottom + 11;
    for (int i = 0; i < 6; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, top, DEVICE_WIDTH - 20 * 2, 15) title:nil font:12 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"323232"]];
        [bottomView addSubview:label];
        
        NSString *content = nil;
        NSString *tag = nil;
        if (i == 0) {
            
            //精品店商品 和 商场店商品 的品牌名字
            
            content = [LTools NSStringNotNull:aProductModel.product_brand_name];
            tag = @"品牌";
            
        }else if (i == 1){
            
            //型号
            content = [LTools NSStringNotNull:aProductModel.product_sku];
            tag = @"型号";
            
        }else if (i == 2){
            
            content = [NSString stringWithFormat:@"%@",aProductModel.product_price];
            tag = @"价格";
            
            if (aProductModel.discount_num == 1) {
                
                //无折扣
                NSString *price_now = [NSString stringWithFormat:@"%@",aProductModel.product_price];

                NSString *price = [NSString stringWithFormat:@"价格: ￥%@",[price_now stringByRemoveTrailZero]];
                NSAttributedString *temp = [LTools attributedString:price keyword:price_now color:[UIColor colorWithHexString:@"df102e"]];
                [label setAttributedText:temp];
                
            }else
            {
                NSString *price_now = [[NSString stringWithFormat:@"%@",aProductModel.product_price] stringByRemoveTrailZero];
                NSString *price_discount = [[NSString stringWithFormat:@"%@",aProductModel.original_price]stringByRemoveTrailZero];
                //价格
                NSString *price = [NSString stringWithFormat:@"价格: ￥%@ %@",price_now,price_discount];
                
                NSAttributedString *temp = [LTools attributedString:price keyword:price_now color:[UIColor colorWithHexString:@"df102e"]];
                
                NSMutableAttributedString *priceAttString = [[NSMutableAttributedString alloc]initWithAttributedString:temp];
                
                //中间加横线
                NSRange range = [price rangeOfString:price_discount];
                
                [priceAttString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
                [priceAttString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"767676"] range:range];
                
                [label setAttributedText:priceAttString];
                
            }
            
            
        }else if (i == 3){
            
            //折扣
            if (aProductModel.discount_num == 1) {
                
                content = nil;
                
            }else
            {
                NSString *discount = [NSString stringWithFormat:@"%.1f",aProductModel.discount_num * 10];

                content = [NSString stringWithFormat:@"%@折",[discount stringByRemoveTrailZero]];
                tag = @"折扣";
            }
            
            
        }else if (i == 4){
            
            //标签
            content = [NSString stringWithFormat:@"%@",aProductModel.product_tag];
            tag = @"标签";
            
            
        }else if (i == 5){
            
            //商场
            content = aProductModel.mall_info[@"mall_name"];
            tag = @"商场";
        }
        
        //当内容为空的时候,不显示此label
        
        if ([self isValidateForText:content withLabel:label]) {
            
            //当i==2此时显示的是价格,不用text赋值,而是用attributeText
            if (i != 2) {
                label.text = [NSString stringWithFormat:@"%@: %@ ",tag,content];
            }
            top += aDis;
        }
        
    }
    
    //是否是选择单品链接
    
    if (self.isChooseProductLink) {
        UIButton *chooseBtn = [[UIButton alloc]initWithframe:CGRectMake(DEVICE_WIDTH - 14 - 60, 10, 60, 30) buttonType:UIButtonTypeCustom normalTitle:@"选择" selectedTitle:nil target:self action:@selector(clickToStore:)];
        [bottomView addSubview:chooseBtn];
        chooseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        chooseBtn.backgroundColor = RGBCOLOR(240, 62, 126);
        [chooseBtn addCornerRadius:15];
        
    }else
    {
        UIButton *shopButton = [[UIButton alloc]initWithframe:CGRectMake(DEVICE_WIDTH - 14 - 52, bottomView.height - 120, 52, 52) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"productDetail_dianpu"] selectedImage:nil target:self action:@selector(clickToStore:)];
        [bottomView addSubview:shopButton];
    }
    
    __weak typeof(self)weakself = self;
    BottomToolsView *tools = [[BottomToolsView alloc]initWithSuperViewHeight:bottomView.height address:aProductModel.mall_info[@"street"] isYYChatVcPush:self.isYYChatVcPush actionBlock:^(ACTIONTYPE aType) {
        if (aType == ACTIONTYPE_CHAT) { //聊天
            
            [weakself clickToPrivateChat:nil];
            
        }else if (aType == ACTIONTYPE_NAVIGATION){ //导航
            
            [weakself clickToBuy:nil];
            
        }else if (aType == ACTIONTYPE_PHONE){ //电话
            
            [weakself clickToPhone:nil];
        }
        
    }];
    [bottomView addSubview:tools];
    
//    //底部工具条
//    
//    UIView *bottomTools = [[UIView alloc]initWithFrame:CGRectMake(0, bottomView.height - 46, DEVICE_WIDTH, 46)];
//    bottomTools.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
//    [bottomView addSubview:bottomTools];
//    
//    //导航按钮
//    
//    UIButton *navigationBtn = [[UIButton alloc]initWithframe:CGRectMake(0, 0, 46, 46) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"productDetail_nav"] selectedImage:nil target:self action:@selector(clickToBuy:)];
//    [bottomTools addSubview:navigationBtn];
//    
//    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(navigationBtn.right,11.5, 1, bottomTools.height/2.f)];
//    line.image = [UIImage imageNamed:@"productDetail_line"];
//    [bottomTools addSubview:line];
//    
//    //地址
//    NSString *address = [NSString stringWithFormat:@"地址: %@",aProductModel.mall_info[@"street"]];
//    
//    CGFloat left = line.right + 10;
//    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(left, 0, DEVICE_WIDTH - left - 46 * 2 - 10, bottomTools.height) title:address font:14 align:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
//    [bottomTools addSubview:addressLabel];
//    
//    //电话
//    UIButton *phoneBtn = [[UIButton alloc]initWithframe:CGRectMake(DEVICE_WIDTH - 46 * 2, 0, 46, bottomTools.height) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"productDetail_phone"] selectedImage:nil target:self action:@selector(clickToPhone:)];
//    [bottomTools addSubview:phoneBtn];
//    
//    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(phoneBtn.right, 11.5, 1, bottomTools.height/2.f)];
//    line2.image = [UIImage imageNamed:@"productDetail_line"];
//    [bottomTools addSubview:line2];
//    
//    //聊天
//    UIButton *chatBtn = [[UIButton alloc]initWithframe:CGRectMake(phoneBtn.right, 0, 46, bottomTools.height) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"productDetail_chat"] selectedImage:nil target:self action:@selector(clickToPrivateChat:)];
//    [bottomTools addSubview:chatBtn];
//    
//    if (self.isYYChatVcPush) {//从聊天界面跳转过来的
//        
//        //聊天按钮为灰色,并不可点击
//        
//        chatBtn.alpha = 0.5f;
//        chatBtn.userInteractionEnabled = NO;
//        
//    }
}

/**
 *  判断内容是否为空,内容为空时label移除
 *
 *  @param text  内容
 *  @param label 对应label
 *
 *  @return
 */
- (BOOL)isValidateForText:(NSString *)text
                withLabel:(UILabel *)label
{
    if ([LTools isEmpty:text]) {
        
        [label removeFromSuperview];
        label = nil;
        return NO;
    }
    return YES;
}


- (void)createNavigationbarTools
{
    
    UIButton *rightView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    rightView.backgroundColor=[UIColor clearColor];
    
    //是否赞
    heartButton = [[UIButton alloc]initWithframe:CGRectMake(0, 0, 44, 44) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"productDetail_zan_normal"] selectedImage:[UIImage imageNamed:@"productDetail_zan_selected"] target:self action:@selector(clickToLike:)];
    [heartButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    
    //收藏的
    
    collectButton = [[UIButton alloc]initWithframe:CGRectMake(74, 0, 44, 44) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"productDetail_collect_normal"] selectedImage:[UIImage imageNamed:@"productDetail_collect_selected"] target:self action:@selector(clickToCollect:)];
    collectButton.center = CGPointMake(rightView.width / 2.f, collectButton.center.y);
    [collectButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    
    //分享
    
    UIButton *shareButton = [[UIButton alloc] initWithframe:CGRectMake(rightView.width - 44, 0, 44, 44) buttonType:UIButtonTypeCustom nornalImage:[UIImage imageNamed:@"product_share"] selectedImage:nil target:self action:@selector(clickToShare:)];
    [shareButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    [rightView addSubview:shareButton];
    [rightView addSubview:heartButton];
    [rightView addSubview:collectButton];
    
    UIBarButtonItem *comment_item=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    
    self.navigationItem.rightBarButtonItem = comment_item;
}

#pragma - mark MJPhotoBrowserDelegate <NSObject>

// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    
}

- (void)photoBrowserDidHidden:(MJPhotoBrowser *)photoBrowser
{
    CGFloat top = self.view.top;
    if (top == 44) {
        self.view.top = 64;
    }
}

@end
