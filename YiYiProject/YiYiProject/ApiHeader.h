//
//  ApiHeader.h
//  YiYiProject
//
//  Created by lichaowei on 14/12/11.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#ifndef YiYiProject_ApiHeader_h
#define YiYiProject_ApiHeader_h

//颜色相关
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

//屏幕尺寸相关
#define ALL_FRAME [UIScreen mainScreen].applicationFrame
//宽
#define ALL_FRAME_WIDTH ALL_FRAME.size.width
//高
#define ALL_FRAME_HEIGHT ALL_FRAME.size.height

//版本判断相关
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

//int 转 string

#define NSStringFromFloat(float) [NSString stringWithFormat:@"%f",(float)]
#define NSStringFromInt(int) [NSString stringWithFormat:@"%d",(int)]

//保存用户信息设备信息相关

#define USER_INFO @"userInfo"//用户信息
#define USER_FACE @"userface"
#define USER_NAME @"username"
#define USER_PWD @"userPw"
#define USER_UID @"useruid"
#define USER_LONGIN @"user_in" //no是未登陆  yes是已登陆
#define USER_AUTHOD @"user_authod"
#define USER_CHECKUSER @"checkfbuser"
#define USER_HEAD_IMAGEURL @"userHeadImageUrl"//头像url

#define USER_AUTHKEY_OHTER @"otherKey"//第三方key
#define USRR_AUTHKEY @"authkey"
#define USER_DEVICE_TOKEN @"DEVICE_TOKEN"

#define RONGCLOUD_TOKEN @"rongCloudToken"//融云对应的token


//通知 信息相关

#define NOTIFICATION_LOGIN @"loginin_success" //登录成功通知
#define NOTIFICATION_LOGOUT @"logout_success" //退出登录通知

#define NOTIFICATION_TTAI_PUBLISE_SUCCESS @"TTAI_PUBLISE_SUCCESS"//t台发布成功

//错误提示信息 

#define ALERT_ERRO_PHONE @"请输入有效手机号"
#define ALERT_ERRO_PASSWORD @"密码格式有误,请输入6~15位英文字母或数字"
#define ALERT_ERRO_SECURITYCODE @"验证码格式有误,请输入6位数字"
#define ALERT_ERRO_FINDPWD @"两次密码不一致"

#define L_PAGE_SIZE 20

//登录类型 normal为正常手机登陆，sweibo、qq、weixin分别代表新浪微博、qq、微信登陆
typedef enum{
    Login_Normal = 0,
    Login_Sweibo,
    Login_QQ,
    Login_Weixin
}Login_Type;

//性别
typedef enum{
    Gender_Girl = 1,
    Gender_Boy
}Gender;

//注册类型，1=》手机注册 2=》邮箱注册，默认为手机注册
typedef enum{
    Register_Phone = 1,
    Register_Email
}Register_Type;

//验证码用途 1=》注册 2=》商店短信验证 3=》找回密码 4⇒申请成为搭配师获取验证码 默认为1) int
typedef enum{
    SecurityCode_Register = 1,
    SecurityCode_Shop,
    SecurityCode_FindPWD,
    SecurityCode_Match
}SecurityCode_Type;

typedef enum {
    
    Sort_Sex_No = 0,//0 不按照性别 默认为0
    Sort_Sex_Women,//女
    Sort_Sex_Man  //男
    
}SORT_SEX_TYPE; //排序方式

typedef enum {
    
    Sort_Discount_No = 0,// discount 折扣排序 1 是 0 否 默认为0
    Sort_Discount_Yes
    
}SORT_Discount_TYPE; //排序方式

//接口地址

//融云 token

#define RONCLOUD_GET_TOKEN @"http://182.92.158.32/index.php?d=api&c=chat&m=get_token&user_id=%@&name=%@&portrait_uri=%@"//获取融云 token

//登录
#define USER_LOGIN_ACTION @"http://182.92.158.32/index.php?d=api&c=user_api&m=login&type=%@&password=%@&thirdid=%@&nickname=%@&thirdphoto=%@&gender=%d&devicetoken=%@&mobile=%@"

//注册
#define USER_REGISTER_ACTION @"http://182.92.158.32/index.php?d=api&c=user_api&m=register&username=%@&password=%@&gender=%d&type=%d&code=%d&mobile=%@"
//获取验证码
#define USER_GET_SECURITY_CODE @"http://182.92.158.32/index.php?d=api&c=user_api&m=get_code&mobile=%@&type=%d"
//找回密码
#define USER_GETBACK_PASSWORD @"http://182.92.158.32/index.php?d=api&c=user_api&m=get_back_password&mobile=%@&code=%d&new_password=%@"

//首页--值得买
#define HOME_DESERVE_BUY @"http://182.92.158.32/?d=api&c=products&m=listWorthBuy&long=%@&lat=%@&sex=%d&discount=%d&page=%d&count=%d&authcode=%@"

//首页--衣加衣
//获取顶部scrollview图片
#define HOME_CLOTH_TOPSCROLLVIEW @"http://182.92.158.32/index.php?d=api&c=advertisement&m=get_advertisement"
//获取附近品牌
#define HOME_CLOTH_NEARBYPINPAI @"http://182.92.158.32/index.php?d=api&c=brand&m=get_nearby_brands"
//获取附近商铺
#define HOME_CLOTH_NEARBYSTORE @"http://182.92.158.32/?d=api&c=mall&m=gerNearMalls&long=116.33232544&lat=39.98189909"
//获取我关注的店铺
#define HOME_CLOTH_GUANZHUSTORE_MINE @"http://182.92.158.32/?d=api&c=friendship&m=listMall&authcode=%@&page=1&count=100"
//获取我关注的品牌
#define HOME_CLOTH_GUANZHUPINPAI_MINE @"http://182.92.158.32/index.php?d=api&c=brand&m=get_attend_brands&authcode=%@&page=%d"

//获取店铺详情
#define HOME_CLOTH_NEARBYSTORE_DETAIL @"http://182.92.158.32?d=api&c=mall&m=getMallDetail&mall_id=%@&authcode=123"

//点击品牌进入该品牌的商铺列表
#define HOME_CLOTH_PINPAI_STORELIST @"http://182.92.158.32/index.php?d=api&c=mall&m=get_mall_by_brand"
//某商场某一品牌下的单品列表
#define HOME_CLOTH_STORE_PINPAILIST @"http://182.92.158.32/index.php?d=api&c=products&m=getProductList"



//单品详情

#define HOME_PRODUCT_DETAIL @"http://182.92.158.32/api/products/getProductInfo?product_id=%@&authcode=%@"

//单品 - 添加赞
#define HOME_PRODUCT_ZAN_ADD @"http://182.92.158.32/?d=api&c=products&m=like"

//单品 - 取消赞
#define HOME_PRODUCT_ZAN_Cancel @"http://182.92.158.32/?d=api&c=products&m=cancelLike"

//单品 - 添加收藏
#define HOME_PRODUCT_COLLECT_ADD @"http://182.92.158.32/?d=api&c=products&m=favor&product_id=%@"

//单品 - 取消收藏
#define HOME_PRODUCT_COLLECT_Cancel @"http://182.92.158.32/?d=api&c=products&m=cancelFavor&product_id=%@"


//T 台
#define TTAI_LIST @"http://182.92.158.32/?d=api&c=tplat&m=listT&page=%d&count=%d&authcode=%@"


//添加T台
#define TTAI_ADD @"http://182.92.158.32/?d=api&c=tplat&m=addTplat"


//t台详情

#define TTAI_DETAIL @"http://182.92.158.32/?d=api&c=tplat&m=ttinfo&tt_id=%@&authcode=%@"



//T台点赞

#define TTAI_ZAN @"http://182.92.158.32/?d=api&c=tplat&m=like"

//T台取消赞
#define TTAI_ZAN_CANCEL @"http://182.92.158.32/?d=api&c=tplat&m=cancelLike"

//转发 + 1
#define TTAI_ZHUANFA_ADD @"http://182.92.158.32/?d=api&c=tplat&m=incrShare"


//个人信息相关
#define PERSON_CHANGEUSERBANNER @"http://182.92.158.32/index.php?d=api&c=user_api&m=update_user_banner"
#define PERSON_GETUSERINFO @"http://182.92.158.32/index.php?d=api&c=user_api&m=get_user_info"



#pragma mark - 搭配师相关接口 ******************************add by sn
/*
 action(该参数有两个值，等于my时表示获取我的搭配师，当popu时表示获取人气搭配师，默认为my)
 authcode(uid加密串，当action参数为my时需要该参数，不是my时不用传)
 tagid(搭配师标签的id，当action参数为popu时并需要做筛选时需要该参数，不是popu时不用传 ，当不做筛选时刻不传该参数或者传0)
 page(页数 默认1)
 perpage(每页显示数量 默认10)
 */
#define GET_DAPEISHI_URL @"http://182.92.158.32/index.php?d=api&c=division_t&m=get_division_teachers&action=%@&authcode=%@&tagid=%d&page=%d&perpage=%d"
///搭配师界面获取话题接口
#define GET_TOPIC_DATA_URL @"http://182.92.158.32/index.php?d=api&c=topic&m=get_topics&uid=%@&page=%d&per_page=%d"
///搭配师界面获取搭配师搭配接口
/*
 t_uid（搭配师uid，若传该参数表示获取该搭配师的搭配列表，若不传则返回所有搭配师的搭配列表）
 page(页数 默认1)
 per_page(每页显示数量 默认10)
 */
#define GET_MATCH_DATA_URL @"http://182.92.158.32/index.php?d=api&c=division_t&m=get_division_tts&t_uid=%@&page=%d&per_page=%d"

///话题详情接口
#define GET_TOPIC_DETAIL_URL @"http://182.92.158.32/index.php?d=api&c=topic&m=get_topic_info&topic_id=%@&authcode=%@"
///获取话题评论接口
#define GET_TOPIC_COMMENTS_URL @"http://182.92.158.32/index.php?d=api&c=topic&m=get_replies&topic_id=%@&page=%d&per_page=20"
///获取搭配师个人信息
#define GET_MATCH_INFOMATION_URL @"http://182.92.158.32/index.php?d=api&c=division_t&m=get_division_t_info&t_uid=%@"
///话题点赞接口
#define TOPIC_ADDFAV_URL @"http://182.92.158.32/index.php?d=api&c=topic&m=like_topic&authcode=%@&topic_id=%@"
///话题取消赞接口
#define TOPIC_DELFAV_URL @"http://182.92.158.32/index.php?d=api&c=topic&m=cancel_like&topic_id=%@&authcode=%@"

///话题评论接口
/*
 参数解释依次为:
 authcode（uid加密串）
 topic_id(话题id)
 repost_content(回复内容)
 level（回复的评论是主评论还是子评论，1=》主评论 2=》子评论） parent_post(回复的主评论id，若level=1则值为0)
 r_reply_id(回复的回复id，当为二级评论的时候需要该参数，若level=1则值为0)
 */
#define TOPIC_COMMENTS_URL @"http://182.92.158.32/index.php?d=api&c=topic&m=reply_topic"


#pragma mark - 搭配师相关接口 ******************************add by sn


#pragma mark--我的衣橱接口


#define GET_MYYICHU_LIST_URL @"http://182.92.158.32/index.php?d=api&c=wardrobe&m=get_my_wardrobe&authcode=%@"





#pragma mark--我的衣橱接口


#define GET_MYYICHU_LIST_URL @"http://182.92.158.32/index.php?d=api&c=wardrobe&m=get_my_wardrobe&authcode=%@"




#pragma mark--我的衣橱接口


#define GET_MYYICHU_LIST_URL @"http://182.92.158.32/index.php?d=api&c=wardrobe&m=get_my_wardrobe&authcode=%@"




#pragma mark--我的衣橱接口


#define GET_MYYICHU_LIST_URL @"http://182.92.158.32/index.php?d=api&c=wardrobe&m=get_my_wardrobe&authcode=%@"



#pragma mark--我的衣橱接口


#define GET_MYYICHU_LIST_URL @"http://182.92.158.32/index.php?d=api&c=wardrobe&m=get_my_wardrobe&authcode=%@"

#define GET_MY_CILLECTION @"http://182.92.158.32/?d=api&c=products&m=listFavors&long=%@&lat=%@&page=%d&count=%d&authcode=%@"//我的收藏（只有单品）


#pragma mark--我的衣橱接口


#define GET_MYYICHU_LIST_URL @"http://182.92.158.32/index.php?d=api&c=wardrobe&m=get_my_wardrobe&authcode=%@"

#define UPLOAD_IMAGE_URL @"http://182.92.158.32/index.php?d=api&c=upload&m=upload_pic"//action(等于topic_pic为上传话题图片，等于ttinfo为上传T台图片)

//添加分类
#define GET_ADDCLASSICATION_URL @"http://182.92.158.32/index.php?d=api&c=wardrobe&m=add_sort&sort_name=%@&authcode=%@"
//删除分类
#define GET_DELETECLASSICATION_URL @"http://182.92.158.32/index.php?d=api&c=wardrobe&m=del_sort&sort_id=%@&authcode=%@"

//编辑分类
#define GET_EDITCLASSICATION_URL @"http://182.92.158.32/index.php?d=api&c=wardrobe&m=update_sort&sort_id=%@&sort_name=%@&authcode=%@"
//获取分类
#define GET_GETCLASSTCATION_URL @"http://182.92.158.32/index.php?d=api&c=wardrobe&m=get_my_sort&authcode=%@"
//衣橱里面添加衣服
#define POST_ADDCLOTHES_URL     @"http://182.92.158.32/index.php?d=api&c=wardrobe&m=add_clothes"
//获取某个分类下的衣服
#define GET_CLASSICATIONCLOTHES_URL @"http://182.92.158.32/index.php?d=api&c=wardrobe&m=get_clothes&sort_id=%@&authcode=%@"

#define MY_CONCERN_BRAND @"http://182.92.158.32/index.php?d=api&c=brand&m=get_attend_brands&authcode=%@&page=%d"//我关注品牌
#define MY_CONCERN_BRAND_CANCEL @"http://182.92.158.32/index.php?d=api&c=brand&m=cancel_attend_brand"//取消品牌关注

#define MY_CONCERN_SHOP @"http://182.92.158.32/?d=api&c=friendship&m=listMall&authcode=%@&page=%d&count=%d"//我关注商家

#define MY_CONCERN_MAIL_CANCEL @"http://182.92.158.32/?d=api&c=friendship&m=mallDestory"//取消关注商家

#define POST_EDITMYBODY_URL @"http://182.92.158.32/index.php?d=api&c=user_api&m=update_user_body_info"//修改我的体型

#define GET_GETMYBODY_URL @"http://182.92.158.32/index.php?d=api&c=user_api&m=get_user_body_info&authcode=%@"//获取我的体型信息

#define GET_GETMYSTYLE_URL @"http://182.92.158.32/index.php?d=api&c=division&m=get_my_styles&authcode=%@"//获取我的搭配风格

#define GET_ADDSTYLE_URL @"http://182.92.158.32/index.php?d=api&c=division&m=add_style&style_pid=%@&style_name=%@&authcode=%@"//添加搭配风格

#define GET_EDITSTYLENAME_URL @"http://182.92.158.32/index.php?d=api&c=division&m=update_style&style_id=%@&style_name=%@&authcode=%@"//修改搭配风格名字

#define GET_DELETESTYLENAME_URL @"http://182.92.158.32/index.php?d=api&c=division&m=del_style&style_id=%@&authcode=%@"//删除搭配风格

#define POST_ADDDAPEISTYLE_URL @"http://182.92.158.32/index.php?d=api&c=division&m=add_division"//添加我的搭配
#define GET_DIVISION_INFO @"http://182.92.158.32/index.php?d=api&c=division&m=get_division_info&division_id=%@&authcode=%@"

#define GET_DIVISOINBYSTYLE_URL @"http://182.92.158.32/index.php?d=api&c=division&m=get_divisions_by_style&style_id=%@&authcode=%@"
#define POST_MYBODY_URL @"http://182.92.158.32/index.php?d=api&c=user_api&m=update_user_body_info"//修改我的体型





#define KAITONG_DIANPU_URL @"http://182.92.158.32/?d=api&c=mall&m=addMall"

#pragma - mark 搭配师话题

#define TOPIC_ADD @"http://182.92.158.32/index.php?d=api&c=topic&m=publish_topic"//添加话题





#pragma mark-----设置
#define	APP_RATING_URL	 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=951259287"

#pragma mark-------------编辑个人资料
#define POST_UPDATEMYINFO_URL @"http://182.92.158.32/index.php?d=api&c=user_api&m=update_user_info"  //修改个人资料

#define POST_GETMYINFO_URL @"http://182.92.158.32/index.php?d=api&c=user_api&m=get_user_info"  //获取个人资料

#endif





