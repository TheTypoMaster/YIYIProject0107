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


@end
