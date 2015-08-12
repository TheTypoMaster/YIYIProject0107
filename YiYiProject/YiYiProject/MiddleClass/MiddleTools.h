//
//  MiddleTools.h
//  YiYiProject
//
//  Created by lichaowei on 15/5/6.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GmyMainViewController.h"//个人主页
#import "YIYIChatViewController.h"//聊天
#import "ZanListViewController.h" //赞列表
#import "ApiHeader.h"

@class PropertyImageView;

/**
 *  中间层工具 (连接)
 */
@interface MiddleTools : NSObject

/**
 *  跳转至个人页面
 *
 *  @param userId         用户id
 *  @param userType       用户类型,区分自己页面和他人页面 可以不写
 *  @param viewController push上一个页面
 */
+ (void)pushToPersonalId:(NSString *)userId
                userType:(GmainViewType)userType
       forViewController:(UIViewController *)viewController
    lastNavigationHidden:(BOOL)hidden;

/**
 *  跳转至个人页面 更新block
 *
 *  @param userId         用户id
 *  @param aBlock       数据更新block
 *  @param viewController push上一个页面
 */
+ (void)pushToPersonalId:(NSString *)userId
       forViewController:(UIViewController *)viewController
    lastNavigationHidden:(BOOL)hidden
        updateParmsBlock:(UpdateParamsBlock)aBlock;

/**
 *  提供一对一单聊(不包含单品详情聊天)
 *
 *  @param userId         聊天目标id
 *  @param userName       聊天目标name
 *  @param viewController push上一个页面
 */
+ (void)chatWithUserId:(NSString *)userId
                     userName:(NSString *)userName
            forViewController:(UIViewController *)viewController
        lastNavigationHidden:(BOOL)hidden;

/**
 *  跳转至赞人员列表
 *
 *  @param tt_model       t台model
 *  @param viewController push上一个页面
 *  @param hidden         上一个页面是否隐藏navigationBar
 *  @param aBlock         数据更新block
 */
+ (void)pushToZanListWithModel:(TPlatModel *)tt_model
             forViewController:(UIViewController *)viewController
          lastNavigationHidden:(BOOL)hidden
              updateParmsBlock:(UpdateParamsBlock)aBlock;

/**
 *  获取人员列表(关注列表、粉丝列表、店铺会员列表)
 *
 *  @param objectId       主题id,店铺列表时为店铺id\关注列表或者粉丝列表则为目标用户id
 *  @param listType       人员列表类型
 *  @param hidden         上个页面navigationBar是否隐藏
 *  @param aBlock         数据更新block
 */
+ (void)pushToUserListWithObjectId:(NSString *)objectId
                          listType:(UserListType)listType
                 forViewController:(UIViewController *)viewController
              lastNavigationHidden:(BOOL)hidden
                  updateParmsBlock:(UpdateParamsBlock)aBlock;

/**
 *  获取人员列表(关注列表、粉丝列表、店铺会员列表)
 *
 *  @param objectId       主题id,店铺列表时为店铺id\关注列表或者粉丝列表则为目标用户id
 *  @param listType       人员列表类型
 *  @param hidden         上个页面navigationBar是否隐藏
 *  @param hiddenBottom   底部导航是否隐藏
 *  @param aBlock         数据更新block
 */
+ (void)pushToUserListWithObjectId:(NSString *)objectId
                          listType:(UserListType)listType
                 forViewController:(UIViewController *)viewController
              lastNavigationHidden:(BOOL)hidden
                      hiddenBottom:(BOOL)hiddenBottom
                  updateParmsBlock:(UpdateParamsBlock)aBlock;

/**
 *  显示t台详情
 *
 *  @param aImageView      PropertyImageView
 *  @param withController  from视图
 *  @param cancelSingleTap 是否取消单击
 */
+ (void)showTPlatDetailFromPropertyImageView:(PropertyImageView *)aImageView
                              withController:(UIViewController *)withController
                             cancelSingleTap:(BOOL)cancelSingleTap;



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
                     isTPlatPush:(BOOL)isTPlatPush;


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
                     hiddenBottom:(BOOL)hiddenBottom;


@end
