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

+(void)pushToStoreDetailVcWithId:(NSString *)theStoreId
                  guanzhuleixing:(ShopType)theLeixing
                            name:(NSString *)theName
              fromViewController:(UIViewController *)viewController
            lastNavigationHidden:(BOOL)hidden
                    hiddenBottom:(BOOL)hiddenBottom{
    
    
    if (theLeixing == ShopType_mall) {
        //商场首页
        GnearbyStoreViewController *ccc = [[GnearbyStoreViewController alloc]init];
        ccc.storeIdStr = theStoreId;
        ccc.storeNameStr = theName;
        ccc.lastPageNavigationHidden = hidden;
        ccc.hidesBottomBarWhenPushed = hiddenBottom;
        [viewController.navigationController pushViewController:ccc animated:YES];
        return;
    }
    
    //店铺首页
    GStorePinpaiViewController *ccc = [[GStorePinpaiViewController alloc]init];
    ccc.storeIdStr = theStoreId;
    ccc.storeNameStr = theName;
    ccc.lastPageNavigationHidden = hidden;
    ccc.hidesBottomBarWhenPushed = hiddenBottom;
    if (theLeixing == ShopType_jingpinDian) {
        ccc.guanzhuleixing = @"精品店";
    }else if (theLeixing == ShopType_pinpaiDian){
        ccc.guanzhuleixing = @"品牌店";
    }
    [viewController.navigationController pushViewController:ccc animated:YES];
    
    
    
    
    
    
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



@end
