//
//  MiddleTools.m
//  YiYiProject
//
//  Created by lichaowei on 15/5/6.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MiddleTools.h"
#import "PropertyImageView.h"
#import "MJPhoto.h"
#import "LPhotoBrowser.h"
#import "GStorePinpaiViewController.h"
#import "GnearbyStoreViewController.h"
#import "AnchorPiontView.h"

#import "ProductDetailController.h" //单品详情
#import "ProductDetailControllerNew.h"//单品详情新版
#import "GTtaiDetailViewController.h"//T台详情
#import "TPlatModel.h"

@implementation MiddleTools

+ (void)pushToPersonalId:(NSString *)userId
                userType:(GmainViewType)userType
       forViewController:(UIViewController *)viewController
    lastNavigationHidden:(BOOL)hidden

{
    GmyMainViewController *main = [[GmyMainViewController alloc]init];
    main.userType = userType;
    main.userId = userId;
    
    if (([userId isKindOfClass:[NSString class]] && [userId isEqualToString:[GMAPI getUid]]) || [userId integerValue] == [[GMAPI getUid]integerValue]) {
        
        main.userType = G_Default;
    }else
    {
        main.userType = G_Other;
    }
    
    main.lastPageNavigationHidden = hidden;
    [viewController.navigationController pushViewController:main animated:YES];
}

+ (void)pushToPersonalId:(NSString *)userId
       forViewController:(UIViewController *)viewController
    lastNavigationHidden:(BOOL)hidden
        updateParmsBlock:(UpdateParamsBlock)aBlock

{
    GmyMainViewController *main = [[GmyMainViewController alloc]init];
    main.userId = userId;
    
    if ([userId isEqualToString:[GMAPI getUid]]) {
        
        main.userType = G_Default;
    }else
    {
        main.userType = G_Other;
    }
    
    main.updateParamsBlock = aBlock;
    
    main.lastPageNavigationHidden = hidden;
    [viewController.navigationController pushViewController:main animated:YES];
}


+ (void)chatWithUserId:(NSString *)userId
                     userName:(NSString *)userName
            forViewController:(UIViewController *)viewController
         lastNavigationHidden:(BOOL)hidden
{
    if ([LTools isLogin:viewController]) {
        
        YIYIChatViewController *contact = [[YIYIChatViewController alloc]init];
        contact.currentTarget = userId;
        contact.currentTargetName = userName;
        contact.portraitStyle = RCUserAvatarCycle;
        contact.enableSettings = NO;
        contact.conversationType = ConversationType_PRIVATE;
        contact.lastPageNavigationHidden = YES;
        [viewController.navigationController pushViewController:contact animated:YES];
    }
}


+ (void)pushToZanListWithModel:(TPlatModel *)tt_model
       forViewController:(UIViewController *)viewController
    lastNavigationHidden:(BOOL)hidden
        updateParmsBlock:(UpdateParamsBlock)aBlock

{
    ZanListViewController *main = [[ZanListViewController alloc]init];
    main.t_model = tt_model;
    
    main.updateParamsBlock = aBlock;
    
    main.lastPageNavigationHidden = hidden;
    [viewController.navigationController pushViewController:main animated:YES];
}

+ (void)pushToUserListWithObjectId:(NSString *)objectId
                          listType:(UserListType)listType
             forViewController:(UIViewController *)viewController
          lastNavigationHidden:(BOOL)hidden
              updateParmsBlock:(UpdateParamsBlock)aBlock

{
    ZanListViewController *main = [[ZanListViewController alloc]init];

    main.objectId = objectId;
    main.listType = listType;
    main.updateParamsBlock = aBlock;
    main.lastPageNavigationHidden = hidden;
    [viewController.navigationController pushViewController:main animated:YES];
}

+ (void)pushToUserListWithObjectId:(NSString *)objectId
                          listType:(UserListType)listType
                 forViewController:(UIViewController *)viewController
              lastNavigationHidden:(BOOL)hidden
                      hiddenBottom:(BOOL)hiddenBottom
                  updateParmsBlock:(UpdateParamsBlock)aBlock

{
    ZanListViewController *main = [[ZanListViewController alloc]init];
    main.hidesBottomBarWhenPushed = hiddenBottom;
    main.objectId = objectId;
    main.listType = listType;
    main.updateParamsBlock = aBlock;
    main.lastPageNavigationHidden = hidden;
    [viewController.navigationController pushViewController:main animated:YES];
}

/**
 *  显示t台详情
 *
 *  @param aImageView      PropertyImageView
 *  @param withController  from视图
 *  @param cancelSingleTap 是否取消单击
 */
+ (void)showTPlatDetailFromPropertyImageView:(PropertyImageView *)aImageView
                              withController:(UIViewController *)withController
                             cancelSingleTap:(BOOL)cancelSingleTap
{
    
    NSInteger count = aImageView.imageUrls.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        // 替换为中等尺寸图片
        NSString *url = aImageView.imageUrls[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = aImageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    LPhotoBrowser *browser = [[LPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.showImageView = aImageView;
    browser.tt_id = aImageView.infoId;//详情id
    
    browser.t_model = aImageView.aModel;//传递一个model
    
    browser.cancelSingleTap = YES;
    [browser showWithController:withController];

}


/**
 *  跳转至精品店、品牌店和商场
 *
 *  @param storeId              商场、精品店（mall_id） 品牌店（shop_id）
 *  @param shopType             区分店铺类型
 *  @param storeName            商场（mall_name）精品店（shop_name） 品牌店（brand_name mall_name)
 *  @param brandName            品牌店时必须传 brandName 其他类型可不填
 *  @param viewController
 *  @param lastNavigationHidden 上个页面是否隐藏导航栏
 *  @param hiddenBottom         是否隐藏底部tabbar
 *  @param isTPlatPush         是否是T台push过来的,需要特殊处理
 */
+(void)pushToStoreDetailVcWithId:(NSString *)storeId
                        shopType:(ShopType)shopType
                       storeName:(NSString *)storeName
                       brandName:(NSString *)brandName
              fromViewController:(UIViewController *)viewController
            lastNavigationHidden:(BOOL)lastNavigationHidden
                    hiddenBottom:(BOOL)hiddenBottom
                     isTPlatPush:(BOOL)isTPlatPush{
    
    //商场首页
    if (shopType == ShopType_mall) {
        GnearbyStoreViewController *ccc = [[GnearbyStoreViewController alloc]init];
        ccc.storeIdStr = storeId;
        ccc.storeNameStr = storeName;
        ccc.lastPageNavigationHidden = lastNavigationHidden;
        ccc.hidesBottomBarWhenPushed = hiddenBottom;
        [viewController.navigationController pushViewController:ccc animated:YES];
        return;
    }
    
    //店铺首页
    GStorePinpaiViewController *ccc = [[GStorePinpaiViewController alloc]init];
    ccc.storeIdStr = storeId;
    ccc.storeNameStr = storeName;
    ccc.lastPageNavigationHidden = lastNavigationHidden;
    ccc.hidesBottomBarWhenPushed = hiddenBottom;
    ccc.isTPlatPush = isTPlatPush;
    if (shopType == ShopType_jingpinDian) {
        ccc.guanzhuleixing = @"精品店";
    }else if (shopType == ShopType_pinpaiDian){
        ccc.guanzhuleixing = @"品牌店";
        ccc.pinpaiNameStr = brandName;
    }
    [viewController.navigationController pushViewController:ccc animated:YES];
}

/**
 *  跳转至单品详情
 *
 *  @param infoId               单品id
 *  @param viewController       从哪个视图push
 *  @param lastNavigationHidden 本页面是否隐藏NavigationBar
 *  @param hiddenBottom         是否隐藏底部tabbar
 */
+ (void)pushToProductDetailWithId:(NSString *)infoId
               fromViewController:(UIViewController *)viewController
             lastNavigationHidden:(BOOL)lastNavigationHidden
                     hiddenBottom:(BOOL)hiddenBottom
{
    ProductDetailControllerNew *detail = [[ProductDetailControllerNew alloc]init];
    detail.product_id = infoId;
    detail.lastPageNavigationHidden = lastNavigationHidden;
    detail.hidesBottomBarWhenPushed = hiddenBottom;
    [viewController.navigationController pushViewController:detail animated:YES];
    
//    ProductDetailController *detail = [[ProductDetailController alloc]init];
//    detail.product_id = infoId;
//    detail.lastPageNavigationHidden = lastNavigationHidden;
//    detail.hidesBottomBarWhenPushed = hiddenBottom;
//    [viewController.navigationController pushViewController:detail animated:YES];
}

/**
 *  跳转至单品详情、加拓展参数
 *
 *  @param infoId               单品id
 *  @param viewController       从哪个视图push
 *  @param lastNavigationHidden 本页面是否隐藏NavigationBar
 *  @param hiddenBottom         是否隐藏底部tabbar
 *  @param extraParams          额外参数
 *  @param updateBlock          数据同步更新block(选填)
 */
+ (void)pushToProductDetailWithId:(NSString *)infoId
               fromViewController:(UIViewController *)viewController
             lastNavigationHidden:(BOOL)lastNavigationHidden
                     hiddenBottom:(BOOL)hiddenBottom
                      extraParams:(NSDictionary *)extraParams
                      updateBlock:(UpdateParamsBlock)updateBlock
{
    ProductDetailControllerNew *detail = [[ProductDetailControllerNew alloc]init];
    detail.product_id = infoId;
    detail.lastPageNavigationHidden = lastNavigationHidden;
    detail.hidesBottomBarWhenPushed = hiddenBottom;
    if (updateBlock) {
        detail.updateParamsBlock = updateBlock;
    }
    if (extraParams) {
        id cell = extraParams[@"cell"];
        id model = extraParams[@"model"];
        BOOL isYYChat = [extraParams[@"isYYChat"]boolValue];
        detail.theLastViewClickedCell = cell;
        detail.theLastViewProductModel = model;
        detail.isYYChatVcPush = isYYChat;
    }
    [viewController.navigationController pushViewController:detail animated:YES];
}

/**
 *  跳转至T台详情、加拓展参数
 *
 *  @param aModel               TPlatModel实例
 *  @param viewController       从哪个视图push
 *  @param lastNavigationHidden 本页面是否隐藏NavigationBar
 *  @param hiddenBottom         是否隐藏底部tabbar
 *  @param extraParams          额外参数
 *  @param updateBlock          数据同步更新block(选填)
 */
+ (void)pushToTPlatDetailWithInfoId:(NSString *)infoId
                fromViewController:(UIViewController *)viewController
              lastNavigationHidden:(BOOL)lastNavigationHidden
                      hiddenBottom:(BOOL)hiddenBottom
                       extraParams:(NSDictionary *)extraParams
                       updateBlock:(UpdateParamsBlock)updateBlock
{
    //新版
    GTtaiDetailViewController *detail = [[GTtaiDetailViewController alloc]init];
    detail.tPlat_id = infoId;
    detail.lastPageNavigationHidden = lastNavigationHidden;
    detail.hidesBottomBarWhenPushed = hiddenBottom;
    if (updateBlock) {
        detail.updateParamsBlock = updateBlock;
    }
    if (extraParams) {
        id label = extraParams[@"label"];
        id model = extraParams[@"model"];
        id button = extraParams[@"button"];
        detail.likeBtn = button;
        detail.likeNumLabel = label;
        detail.theModel = model;
    }
    detail.hidesBottomBarWhenPushed = hiddenBottom;
    [viewController.navigationController pushViewController:detail animated:YES];
}


/**
 *  T台赞或者取消
 *
 *  @param params   需要改变的对象组成字典如:
 *                  @{@"button":likeBtn,
 *                    @"label":cell.likeLabel,
 *                    @"model":aModel};
 *  @param viewController 目标视图
 */
+ (void)zanTPlatWithParams:(NSDictionary *)params
            viewController:(UIViewController *)viewController
               resultBlock:(RESULTBLOCK)resultBlock
{
    if (![LTools isLogin:viewController]) {
        
        return;
    }

    if (!params || ![params isKindOfClass:[NSDictionary class]]) {
        
        return;
    }
    
    UIButton *btn = params[@"button"];
    UILabel *label = params[@"label"];
    TPlatModel *aModel = params[@"model"];
    
    [LTools animationToBigger:btn duration:0.2 scacle:1.5];
    
    NSString *tt_id = aModel.tt_id;
    
    NSString *authkey = [GMAPI getAuthkey];
    NSString *post = [NSString stringWithFormat:@"tt_id=%@&authcode=%@",tt_id,authkey];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url;
    
    BOOL zan = btn.selected ? NO : YES;
    
    if (zan) {
        url = TTAI_ZAN;
    }else
    {
        url = TTAI_ZAN_CANCEL;
    }
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        btn.selected = zan ? YES : NO;
        int like_num = [aModel.tt_like_num intValue];
        aModel.tt_like_num = [NSString stringWithFormat:@"%d",zan ? like_num + 1 : like_num - 1];
        aModel.is_like = zan ? 1 : 0;
        label.text = aModel.tt_like_num;
        
        if (resultBlock) {
            
            resultBlock(@{@"result":[NSNumber numberWithBool:YES]});
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
        aModel.tt_like_num = NSStringFromInt([aModel.tt_like_num intValue]);
        label.text = aModel.tt_like_num;
        if (resultBlock) {
            
            resultBlock(@{@"result":[NSNumber numberWithBool:NO]});
        }
    }];
}


@end
