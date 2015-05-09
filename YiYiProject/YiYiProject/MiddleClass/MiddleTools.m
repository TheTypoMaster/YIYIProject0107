//
//  MiddleTools.m
//  YiYiProject
//
//  Created by lichaowei on 15/5/6.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MiddleTools.h"

@implementation MiddleTools

+ (void)pushToPersonalId:(NSString *)userId
                userType:(GmainViewType)userType
       forViewController:(UIViewController *)viewController
    lastNavigationHidden:(BOOL)hidden

{
    GmyMainViewController *main = [[GmyMainViewController alloc]init];
    main.userType = userType;
    main.userId = userId;
    
    if ([userId isEqualToString:[GMAPI getUid]]) {
        
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

@end
