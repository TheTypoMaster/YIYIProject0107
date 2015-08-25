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



///**
// *  赞 取消赞 收藏 取消收藏
// */
//
//- (void)clickToZan:(UIButton *)sender
//{
//    if (![LTools isLogin:self]) {
//        
//        return;
//    }
//    //直接变状态
//    //更新数据
//    
//    [LTools animationToBigger:sender duration:0.2 scacle:1.5];
//    
//    TPlatCell *cell = (TPlatCell *)[_waterFlow.quitView cellAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 100 inSection:0]];
//    
//    __weak typeof(self)weakSelf = self;
//    
//    __block BOOL isZan = !sender.selected;
//    
//    NSString *api = sender.selected ? TTAI_ZAN_CANCEL : TTAI_ZAN;
//    
//    TPlatModel *detail_model = _waterFlow.dataArray[sender.tag - 100];
//    NSString *t_id = detail_model.tt_id;
//    NSString *post = [NSString stringWithFormat:@"tt_id=%@&authcode=%@",t_id,[GMAPI getAuthkey]];
//    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    
//    NSString *url = api;
//    
//    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
//    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
//        
//        NSLog(@"result %@",result);
//        sender.selected = isZan;
//        detail_model.is_like = isZan ? 1 : 0;
//        detail_model.tt_like_num = NSStringFromInt([detail_model.tt_like_num intValue] + (isZan ? 1 : -1));
//        cell.like_label.text = detail_model.tt_like_num;
//        
//    } failBlock:^(NSDictionary *failDic, NSError *erro) {
//        
//        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
//        [GMAPI showAutoHiddenMBProgressWithText:failDic[RESULT_INFO] addToView:weakSelf.view];
//        if ([failDic[RESULT_CODE] intValue] == -11) {
//            
//            [LTools showMBProgressWithText:failDic[RESULT_INFO] addToView:weakSelf.view];
//        }
//        detail_model.tt_like_num = NSStringFromInt([detail_model.tt_like_num intValue]);
//        cell.like_label.text = detail_model.tt_like_num;
//    }];
//}

//等到加载完图片之后再加载图片上的三个button

//-(void)createbuttonWithModel:(NSDictionary*)maodian_detail
//                   imageView:(UIView *)imageView
//          fromViewController:(UIViewController *)viewController{
//    
//    NSString *productId = maodian_detail[@"product_id"];
//    
//    NSInteger product_id = [productId integerValue];
//    
//    float dx=[maodian_detail[@"img_x"] floatValue];
//    float dy=[maodian_detail[@"img_y"] floatValue];
//    
//    
//    __weak typeof(self)weakSelf = self;
//    __weak typeof(viewController)weakVC = viewController;
//
//    if (product_id>0) {
//        //说明是单品
//        
//        NSString *title = maodian_detail[@"product_name"];
//        CGPoint point = CGPointMake(dx * imageView.width, dy * imageView.height);
//        AnchorPiontView *pointView = [[AnchorPiontView alloc]initWithAnchorPoint:point title:title];
//        [imageView addSubview:pointView];
//        pointView.infoId = productId;
//        pointView.infoName = title;
//        
//        
//        [pointView setAnchorBlock:^(NSString *infoId,NSString *infoName,ShopType shopType){
//            
////            [weakSelf turnToDanPinInfoId:infoId infoName:infoName];
//        }];
//        
//        //        NSLog(@"单品--title %@",title);
//        
//    }else{
//        
//        //说明是品牌店面
//        
//        NSString *title = maodian_detail[@"shop_name"];
//        int mall_type = [maodian_detail[@"mall_type"] intValue];
//        NSString *storeId;
//        
//        if (mall_type == ShopType_pinpaiDian) {
//            
//            storeId = maodian_detail[@"shop_id"];
//            
//        }else if (mall_type == ShopType_jingpinDian){
//            
//            storeId = maodian_detail[@"mall_id"];
//        }
//        
//        CGPoint point = CGPointMake(dx * imageView.width, dy * imageView.height);
//        AnchorPiontView *pointView = [[AnchorPiontView alloc]initWithAnchorPoint:point title:title];
//        [imageView addSubview:pointView];
//        
//        pointView.infoId = storeId;
//        pointView.infoName = title;
//        pointView.shopType = mall_type;
//        
//        [pointView setAnchorBlock:^(NSString *infoId,NSString *infoName,ShopType shopType){
//            
//            [MiddleTools pushToStoreDetailVcWithId:infoId guanzhuleixing:shopType name:infoName fromViewController:weakVC lastNavigationHidden:<#(BOOL)#> hiddenBottom:<#(BOOL)#>]
//        }];
//        
//    }
//    
//}


@end
