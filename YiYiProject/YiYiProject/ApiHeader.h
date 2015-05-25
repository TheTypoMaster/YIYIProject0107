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

//数据更新状态

#define UPDATE_PARAM @"updateParam" //要更新的参数
#define UPDATE_TPLAT_ISLIKE @"tPlatIsLike" //是否喜欢标识
#define UPDATE_TPLAT_LIKENUM @"likeNum" //喜欢个数
#define UPDATE_TPLAT_COMENTNUM @"commentNum" //评论个数


//保存用户信息设备信息相关

#define USER_INFO @"userInfo"//用户信息
#define USER_FACE @"userface"
#define USER_NAME @"username"
#define USER_PWD @"userPw"
#define USER_UID @"useruid"

//两个登陆标识
#define LOGIN_SERVER_STATE @"user_login_state" //登陆衣加衣服务器 no是未登陆  yes是已登陆
#define LOGIN_RONGCLOUD_STATE @"rongcloudLoginState"//融云登陆状态

#define USER_AUTHOD @"user_authod"
#define USER_CHECKUSER @"checkfbuser"
#define USER_HEAD_IMAGEURL @"userHeadImageUrl"//头像url

#define USER_SHOP_ID @"shop_id"//店铺id

#define USER_AUTHKEY_OHTER @"otherKey"//第三方key
#define USRR_AUTHKEY @"authkey"
#define USER_DEVICE_TOKEN @"DEVICE_TOKEN"

#define USER_UNREADNUM @"unreadNum"//未读消息条数

#define RONGCLOUD_TOKEN @"rongCloudToken"//融云对应的token

//本地数据保存

#define CACHE_DESERVE_BUY @"deserveBuy"//值得买
#define CACHE_TPLAT @"tPlat"//t台

//错误提示信息 

#define ALERT_ERRO_PHONE @"请输入有效手机号"
#define ALERT_ERRO_PASSWORD @"密码格式有误,请输入6~15位英文字母或数字"
#define ALERT_ERRO_SECURITYCODE @"验证码格式有误,请输入6位数字"
#define ALERT_ERRO_FINDPWD @"两次密码不一致"

#define L_PAGE_SIZE 20

//通知 信息相关

#define NOTIFICATION_LOGIN @"loginin_success" //登录成功通知
#define NOTIFICATION_LOGOUT @"logout_success" //退出登录通知

#define NOTIFICATION_TTAI_PUBLISE_SUCCESS @"TTAI_PUBLISE_SUCCESS"//t台发布成功
#define NOTIFICATION_TTAI_EDIT_SUCCESS @"TTAI_EDIT_SUCCESS"//T台编辑成功

#define NOTIFICATION_SHENQINGDIANPU_SUCCESS @"GSHENQINGDIANPU_SUCCESS"//申请店铺成功

#define NOTIFICATION_SHENQINGDIANPU_STATE @"GSHENQINGDIANPU_STATE"//申请店铺成功状态 成功或者失败

#define NOTIFICATION_APPENTERFOREGROUND @"notification_appEnterForeground" //应用从后台转向前台

#define NOTIFICATION_EDIT_SHOP_PHONE_SUCCESS @" NOTIFICATION_EDIT_SHOP_PHONE_SUCCESS"//编辑店铺电话成功

//关注商场
#define NOTIFICATION_GUANZHU_STORE @"guanzhu_store"
//取消关注商场
#define NOTIFICATION_GUANZHU_STORE_QUXIAO @"guanzhu_store_quxiao"
//关注品牌
#define NOTIFICATION_GUANZHU_PINPAI @"guanzhu_pinpai"
//取消关注品牌
#define NOTIFICATION_GUANZHU_PINPAI_QUXIAO @"guanzhu_pinpai_quxiao"
//发布单品成功
#define NOTIFICATION_FABUDANPIN_SUCCESS @"fabudanpin_success"
//发布活动成功
#define NOTIFICATION_FABUHUODONG_SUCCESS @"fabuhuodong_success"

//取消红点
#define NOTIFICATION_CANCEL_HOTPOINT @"cancelHotPoint"

//推送消息
#define NOTIFICATION_REMOTE_MESSAGE @"remoteMessage"

//获取坐标
//#define NOTIFICATION_REMOTE_MESSAGE @"remoteMessage"

//修改单品完成
#define GEDITPRODUCT_SUCCESS @"GeditProduct_success"

//更新赞数字
#define NOTIFICATION_UPDATE_ZANNUM @"updateZanNum"
//更新评论数字
#define NOTIFICATION_UPDATE_COMMENTNUM @"updateCommentNum"

//隐藏t台详情状态栏和导航栏
#define NOTIFICATION_TPLATDETAIL_HIDDEN @"TPlatDetailhiddenAction"

//显示t台详情状态栏和导航栏
#define NOTIFICATION_TPLATDETAIL_SHOW @"TPlatDetailShowAction"




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

/**
 *  商家消息列表
 */
//action= yy(衣加衣) shop（商家） dynamic（动态）

typedef enum{
    Message_List_Yy = 0,
    Message_List_Shop,
    Message_List_Dynamic
}Message_List_Type;


/**
 * 消息类型
 * 1 衣加衣通知消息 2 关注用户通知消息 3 回复主题消息 4 回复主题回复
 * 5 回复T台通知消息 6 回复T台回复通知消息 7 品牌促销通知消息 8 商场促销通知
 * 9 申请店铺成功  10 申请店铺失败
 * 11 修改活动
 * 12关注商家通知消息
 */
typedef enum {
    
    MessageType_yiyiTeam = 1,//衣衣团队消息
    MessageType_concernUser = 2,//关注用户消息
    MessageType_concernShop = 12,//关注商家通知消息
    MessageType_replyTopic = 3,//回复主题
    MessageType_replyTopicReply = 4,//回复主题的回复
    MessageType_replyTPlat = 5,//评论t台
    MessageType_replyTPlatReply = 6,//回复t台评论
    MessageType_promotionBrand = 7,//店铺促销
    MessageType_promotionMarket = 8,//商场促销
    MessageType_applyShopSuccess = 9,//申请店铺成功
    MessageType_applyShopFail = 10,//申请店铺失败
    
}MessageType;


typedef enum {
    
    relation_concern_no = 0,//未关注
    relation_concern_yes = 1,//已关注对方
    relation_concern_yes_otherSide = 2,//被对方关注
    relation_concern_all = 3 //相互关注
    
}RelationConcernType;//关注关系

//接口地址

//融云 token

#define RONCLOUD_GET_TOKEN @"http://www.alayy.com/index.php?d=api&c=chat&m=get_token&user_id=%@&name=%@&portrait_uri=%@"//获取融云 token

//登录
#define USER_LOGIN_ACTION @"http://www.alayy.com/index.php?d=api&c=user_api&m=login&type=%@&password=%@&thirdid=%@&nickname=%@&third_photo=%@&gender=%d&devicetoken=%@&mobile=%@&login_source=%@"

//退出登录

#define USER_LOGOUT_ACTION @"http://www.alayy.com/index.php?d=api&c=user_api&m=login_out&authcode=%@"

//注册
#define USER_REGISTER_ACTION @"http://www.alayy.com/index.php?d=api&c=user_api&m=register&username=%@&password=%@&gender=%d&type=%d&code=%d&mobile=%@"
//获取验证码
#define USER_GET_SECURITY_CODE @"http://www.alayy.com/index.php?d=api&c=user_api&m=get_code&mobile=%@&type=%d"
//找回密码
#define USER_GETBACK_PASSWORD @"http://www.alayy.com/index.php?d=api&c=user_api&m=get_back_password&mobile=%@&code=%d&new_password=%@&confirm_password=%@"

//首页--值得买
#define HOME_DESERVE_BUY @"http://www.alayy.com/?d=api&c=products&m=listWorthBuy&long=%@&lat=%@&sex=%d&discount=%d&page=%d&count=%d&authcode=%@"


//首页--衣加衣
//获取顶部scrollview图片
#define HOME_CLOTH_TOPSCROLLVIEW @"http://www.alayy.com/index.php?d=api&c=advertisement&m=get_advertisement"
//获取附近品牌
#define HOME_CLOTH_NEARBYPINPAI @"http://www.alayy.com/index.php?d=api&c=brand&m=get_nearby_brands"
//获取附近商铺
#define HOME_CLOTH_NEARBYSTORE @"http://www.alayy.com/index.php?d=api&c=mall&m=getNearMalls"
//获取我关注的店铺
#define HOME_CLOTH_GUANZHUSTORE_MINE @"http://www.alayy.com/?d=api&c=friendship&m=listMall"
//获取我关注的品牌
#define HOME_CLOTH_GUANZHUPINPAI_MINE @"http://www.alayy.com/index.php?d=api&c=brand&m=get_attend_brands&authcode=%@&page=%d&lat=%@&long=%@"

//店铺详情  mall_id  精品店
#define HOME_CLOTH_NEARBYSTORE_DETAIL @"http://www.alayy.com?d=api&c=mall&m=getMallDetail"
//店铺详情 shop_id   品牌店
#define GET_MAIL_DETAIL_INFO @"http://www.alayy.com/index.php?d=api&c=mall&m=get_shop_info"

//点击品牌进入该品牌的商铺列表
#define HOME_CLOTH_PINPAI_STORELIST @"http://www.alayy.com/index.php?d=api&c=mall&m=get_mall_by_brand"
//某商场某一品牌下的单品列表
#define HOME_CLOTH_STORE_PINPAILIST @"http://www.alayy.com/index.php?d=api&c=products&m=getProductList"



//单品详情

#define HOME_PRODUCT_DETAIL @"http://www.alayy.com/api/products/getProductInfo?product_id=%@&authcode=%@"

//单品 - 添加赞
#define HOME_PRODUCT_ZAN_ADD @"http://www.alayy.com/?d=api&c=products&m=like"

//单品 - 取消赞
#define HOME_PRODUCT_ZAN_Cancel @"http://www.alayy.com/?d=api&c=products&m=cancelLike"

//单品 - 添加收藏
#define HOME_PRODUCT_COLLECT_ADD @"http://www.alayy.com/?d=api&c=products&m=favor&product_id=%@"

//单品 - 取消收藏
#define HOME_PRODUCT_COLLECT_Cancel @"http://www.alayy.com/?d=api&c=products&m=cancelFavor&product_id=%@"


//T 台

#define TTAi_LIST @"http://www.alayy.com/?d=api&c=tplat&m=listT"

//添加T台
#define TTAI_ADD @"http://www.alayy.com/?d=api&c=tplat&m=addTplat"


//t台详情

#define TTAI_DETAIL @"http://www.alayy.com/?d=api&c=tplat&m=ttinfo&tt_id=%@&authcode=%@"

///t台评论接口
#define TTAI_COMMENTS_URL @"http://www.alayy.com/?d=api&c=tplat&m=listReply&page=%d&count=20&tt_id=%@"
//T台评论

#define TTAI_COMMENT @"http://www.alayy.com/?d=api&c=tplat&m=comment"

//T台点赞

#define TTAI_ZAN @"http://www.alayy.com/?d=api&c=tplat&m=like"

//T台取消赞
#define TTAI_ZAN_CANCEL @"http://www.alayy.com/?d=api&c=tplat&m=cancelLike"

//转发 + 1
#define TTAI_ZHUANFA_ADD @"http://www.alayy.com/?d=api&c=tplat&m=incrShare"


//个人信息相关
#define PERSON_CHANGEUSERBANNER @"http://www.alayy.com/index.php?d=api&c=user_api&m=update_user_banner"

//加额外参数extra  extra=tt_num时代表需要返回t台总数
#define PERSON_GETUSERINFO @"http://www.alayy.com/index.php?d=api&c=user_api&m=get_user_info"
#define PERSON_CHANGEUSERFACE @"http://www.alayy.com/index.php?d=api&c=user_api&m=update_user_info"

//根据id获取用户信息
#define GET_PERSONINFO_WITHID @"http://www.alayy.com/index.php?d=api&c=user_api&m=get_user_by_uid&uid=%@"

//关注商场或精品店
#define GUANZHUSHANGCHANG @"http://www.alayy.com/?d=api&c=friendship&m=mallShipCreate"
//取消关注商场
#define QUXIAOGUANZHU_SHANGCHANG @"http://www.alayy.com/?d=api&c=friendship&m=mallDestory"

//关注品牌
#define GUANZHUPINPAI @"http://www.alayy.com/index.php?d=api&c=brand&m=attend_brand"
//取消关注品牌
#define QUXIAOGUANZHUPINPAI @"http://www.alayy.com/index.php?d=api&c=brand&m=cancel_attend_brand"
//查询品牌是否关注
#define GUANZHUPINPAI_ISORNO @"http://www.alayy.com/index.php?d=api&c=brand&m=isBrandFriend"

#define ZPOSTDEVICETOKEN @"http://www.alayy.com/index.php?d=api&c=user_api&m=update_user_info"

//申请店铺界面 
//根据省市区获取商城列表
#define STORELISTWITHPROVINCEANDCITY @"http://www.alayy.com/api/mall/listMall?province_id=%@&city_id=%@"
//某商场所有楼层的品牌列表
#define STOREALLFLOORPINPAI @"http://www.alayy.com/?d=api&c=mall&m=listBrandFromMall&mall_id=%@"

//获取手机验证码
#define PHONE_YANZHENGMA_SHENQINGSHANGCHANGDIAN @"http://www.alayy.com/index.php?d=api&c=user_api&m=get_code&mobile=%@&type=5"
//获取手机验证码
#define GPHONECODE @"http://www.alayy.com/index.php?d=api&c=user_api&m=get_code"

//申请店铺
#define SHENQINGJINGPINDIAN @"http://www.alayy.com/?d=api&c=mall&m=addMall"
//申请商场店
#define SHENQINGSHANGCHANGDIAN @"http://www.alayy.com/?d=api&c=mall&m=addShop"

//我是店主 发布单品
#define GFABUDIANPIN @"http://www.alayy.com/?d=api&c=products&m=addProducts"
//编辑单品
//#define GEDITPRODUCT_MANAGE @"http://www.alayy.com/index.php?d=api&c=products&m=edit_product"
#define GEDITPRODUCT_MANAGE @"http://www.alayy.com/index.php?d=api&c=products&m=edit_product_v2"

//我是店主 发布活动
#define GFABUHUODONG @"http://www.alayy.com/index.php?d=api&c=mall&m=publish_activity"
//修改活动
#define GEDITHUODONG @"http://www.alayy.com/index.php?d=api&c=mall&m=edit_activity"



#pragma mark - 搭配师相关接口 ******************************add by sn
/*
 action(该参数有两个值，等于my时表示获取我的搭配师，当popu时表示获取人气搭配师，默认为my)
 authcode(uid加密串，当action参数为my时需要该参数，不是my时不用传)
 tagid(搭配师标签的id，当action参数为popu时并需要做筛选时需要该参数，不是popu时不用传 ，当不做筛选时刻不传该参数或者传0)
 page(页数 默认1)
 perpage(每页显示数量 默认10)
 */
#define GET_DAPEISHI_URL @"http://www.alayy.com/index.php?d=api&c=division_t&m=get_division_teachers&action=%@&authcode=%@&tagid=%d&page=%d&perpage=%d"
///搭配师界面获取话题接口
#define GET_TOPIC_DATA_URL @"http://www.alayy.com/index.php?d=api&c=topic&m=get_topics&uid=%@&page=%d&per_page=%d"
///搭配师界面获取搭配师搭配接口
/*
 t_uid（搭配师uid，若传该参数表示获取该搭配师的搭配列表，若不传则返回所有搭配师的搭配列表）
 page(页数 默认1)
 per_page(每页显示数量 默认10)
 */
#define GET_MATCH_DATA_URL @"http://www.alayy.com/index.php?d=api&c=division_t&m=get_division_tts&t_uid=%@&page=%d&per_page=%d"

///申请搭配师
/*
 authcode(uid加密串) string
 mobile（手机号码）string
 code(验证码) int
 qq(qq号码) int
 weixin(微信号码，可不填) int
 pic(身份证照片) string
 */
#define APPLY_MATCH_URL @"http://www.alayy.com/index.php?d=api&c=division_t&m=apply_division_teacher"

///话题详情接口
#define GET_TOPIC_DETAIL_URL @"http://www.alayy.com/index.php?d=api&c=topic&m=get_topic_info&topic_id=%@&authcode=%@"
///获取话题评论接口
#define GET_TOPIC_COMMENTS_URL @"http://www.alayy.com/index.php?d=api&c=topic&m=get_replies&topic_id=%@&page=%d&per_page=20"
///获取搭配师个人信息
#define GET_MATCH_INFOMATION_URL @"http://www.alayy.com/index.php?d=api&c=division_t&m=get_division_t_info&t_uid=%@&authcode=%@"
///话题点赞接口
#define TOPIC_ADDFAV_URL @"http://www.alayy.com/index.php?d=api&c=topic&m=like_topic&authcode=%@&topic_id=%@"
///话题取消赞接口
#define TOPIC_DELFAV_URL @"http://www.alayy.com/index.php?d=api&c=topic&m=cancel_like&topic_id=%@&authcode=%@"

///话题评论接口
/*
 参数解释依次为:
 authcode（uid加密串）
 topic_id(话题id)
 repost_content(回复内容)
 level（回复的评论是主评论还是子评论，1=》主评论 2=》子评论） parent_post(回复的主评论id，若level=1则值为0)
 r_reply_id(回复的回复id，当为二级评论的时候需要该参数，若level=1则值为0)
 */
#define TOPIC_COMMENTS_URL @"http://www.alayy.com/index.php?d=api&c=topic&m=reply_topic"

///关注取消关注接口
/*
 参数解释依次为:
 authcode(uid的加密串) string
 action(取消还是关注 at_friend⇒关注某人 can_friend⇒取消关注某人) str
 friend_uid(操作的对象uid) int
 */
#define ATTENTTION_SOMEBODY_URL @"http://www.alayy.com/index.php?d=api&c=my_api&m=attention&authcode=%@&action=%@&friend_uid=%@"

#pragma mark - 搭配师相关接口 ******************************add by sn

#pragma mark--我的衣橱接口

#define GET_MY_CILLECTION @"http://www.alayy.com/?d=api&c=products&m=listFavors&long=%@&lat=%@&page=%d&count=%d&authcode=%@"//我的收藏（只有单品）


#pragma mark--我的衣橱接口


#define GET_MYYICHU_LIST_URL @"http://www.alayy.com/index.php?d=api&c=wardrobe&m=get_wardrobe&authcode=%@"

#define UPLOAD_IMAGE_URL @"http://www.alayy.com/index.php?d=api&c=upload&m=upload_pic"//action(等于topic_pic为上传话题图片，等于ttinfo为上传T台图片)

//添加分类
#define GET_ADDCLASSICATION_URL @"http://www.alayy.com/index.php?d=api&c=wardrobe&m=add_sort&sort_name=%@&authcode=%@"
//删除分类
#define GET_DELETECLASSICATION_URL @"http://www.alayy.com/index.php?d=api&c=wardrobe&m=del_sort&sort_id=%@&authcode=%@"

//编辑分类
#define GET_EDITCLASSICATION_URL @"http://www.alayy.com/index.php?d=api&c=wardrobe&m=update_sort&sort_id=%@&sort_name=%@&authcode=%@"
//获取分类
#define GET_GETCLASSTCATION_URL @"http://www.alayy.com/index.php?d=api&c=wardrobe&m=get_sort&authcode=%@"
//衣橱里面添加衣服
#define POST_ADDCLOTHES_URL     @"http://www.alayy.com/index.php?d=api&c=wardrobe&m=add_clothes"
//获取某个分类下的衣服
#define GET_CLASSICATIONCLOTHES_URL @"http://www.alayy.com/index.php?d=api&c=wardrobe&m=get_clothes&sort_id=%@&authcode=%@"

#define MY_CONCERN_BRAND @"http://www.alayy.com/index.php?d=api&c=brand&m=get_attend_brands&authcode=%@&page=%d"//我关注品牌
#define MY_CONCERN_BRAND_CANCEL @"http://www.alayy.com/index.php?d=api&c=brand&m=cancel_attend_brand"//取消品牌关注

#define MY_CONCERN_SHOP @"http://www.alayy.com/?d=api&c=friendship&m=listMall&authcode=%@&page=%d&count=%d"//我关注商家

#define MY_CONCERN_MAIL_CANCEL @"http://www.alayy.com/?d=api&c=friendship&m=mallDestory"//取消关注商家

#define POST_EDITMYBODY_URL @"http://www.alayy.com/index.php?d=api&c=user_api&m=update_user_body_info"//修改我的体型

#define GET_GETMYBODY_URL @"http://www.alayy.com/index.php?d=api&c=user_api&m=get_user_body_info&authcode=%@"//获取我的体型信息

#define GET_GETMYSTYLE_URL @"http://www.alayy.com/index.php?d=api&c=division&m=get_my_styles&authcode=%@"//获取我的搭配风格

#define GET_ADDSTYLE_URL @"http://www.alayy.com/index.php?d=api&c=division&m=add_style&style_pid=%@&style_name=%@&authcode=%@"//添加搭配风格

#define GET_EDITSTYLENAME_URL @"http://www.alayy.com/index.php?d=api&c=division&m=update_style&style_id=%@&style_name=%@&authcode=%@"//修改搭配风格名字

#define GET_DELETESTYLENAME_URL @"http://www.alayy.com/index.php?d=api&c=division&m=del_style&style_id=%@&authcode=%@"//删除搭配风格

#define POST_ADDDAPEISTYLE_URL @"http://www.alayy.com/index.php?d=api&c=division&m=add_division"//添加我的搭配
#define GET_DIVISION_INFO @"http://www.alayy.com/index.php?d=api&c=division&m=get_division_info&division_id=%@&authcode=%@"

#define GET_DIVISOINBYSTYLE_URL @"http://www.alayy.com/index.php?d=api&c=division&m=get_divisions_by_style&style_id=%@&authcode=%@"
#define POST_MYBODY_URL @"http://www.alayy.com/index.php?d=api&c=user_api&m=update_user_body_info"//修改我的体型


#pragma - mark 搭配师话题

#define TOPIC_ADD @"http://www.alayy.com/index.php?d=api&c=topic&m=publish_topic"//添加话题


#pragma mark-----设置
#define	APP_RATING_URL	 @"itms-apps://itunes.apple.com/app/id951259287"

#pragma mark-------------编辑个人资料

#define POST_UPDATEMYINFO_URL @"http://www.alayy.com/index.php?d=api&c=user_api&m=update_user_info"  //修改个人资料

#pragma mark - 消息

#define MESSAGE_GET_MINE @"http://www.alayy.com/index.php?d=api&c=msg&m=get_my_msg&authcode=%@"//我的消息

#define MESSAGE_GET_LIST @"http://www.alayy.com/index.php?d=api&c=msg&m=get_special_msg&action=%@&authcode=%@"//action= yy(衣加衣) shop（商家） dynamic（动态）

#define MESSAGE_GET_DETAIL @"http://www.alayy.com/index.php?d=api&c=msg&m=get_msg_info&msg_id=%@&authcode=%@"

//店主活动列表
#define GET_MAIL_ACTIVITY_LIST @"http://www.alayy.com/index.php?d=api&c=mall&m=get_activities&authcode=%@"
//店主单品列表
#define GET_MAIL_PRODUCT_LIST @"http://www.alayy.com/index.php?d=api&c=products&m=getProductList&mb_id=%@&page=%d&per_page=%d&authcode=%@"


//活动详情
#define GET_MAIL_ACTIVITY_DETAIL @"http://www.alayy.com/index.php?d=api&c=mall&m=get_activity_info&activity_id=%@"

//发起活动
#define GADD_MAIL_ACTIVITY @"http://www.alayy.com/index.php?d=api&c=mall&m=publish_activity"


//上架下架单品  参数：authcode  单品id字符串逗号隔开：product_ids   上架或下架action down/up
#define GUPDOWNPRODUCTS @"http://www.alayy.com/index.php?d=api&c=products&m=product_shelf"

//删除单品  参数：authcode  单品id字符串逗号隔开：product_ids
#define GDELETPRODUCTS @"http://www.alayy.com/index.php?d=api&c=products&m=del_product"



//搜索接口 品牌 商铺 单品
#define GSEARCH @"http://www.alayy.com/index.php?d=api&c=search"

//签到
#define GQIANDAO @"http://www.alayy.com/index.php?d=api&c=user_api&m=sign"

//获取店铺二维码
#define GMYSHOPERWEIMA @"http://www.alayy.com/index.php?d=api&c=mall&m=get_qrcode_v2"

//获取店铺会员 也就是关注该店铺的人
#define GMYSHOPHUIYUANLIST @"http://www.alayy.com/index.php?d=api&c=mall&m=get_attention_list"

//修改店铺联系方式 telephone

#define GCHANGESHOPTELEPHONE @"http://www.alayy.com/index.php?d=api&c=mall&m=set_shop_phone"

//绑定手机
#define GBANGDINGPHONE @"http://www119.alayy.com/index.php?d=api&c=user_api&m=bind_mobile"

//关注品牌店
#define GGUANZHUPINPAIDIAN @"http://www.alayy.com/index.php?d=api&c=friendship&m=attend_shop"

//取消关注品牌店
#define GQUXIAOGUANZHUPINPAIDIAN @"http://www.alayy.com/index.php?d=api&c=friendship&m=cancel_attend_shop"


#pragma - mark T台相关接口

//获取赞的列表(relation 是关注关系 0代表未关注  1代表已关注 3代表以互相关注)

#define TPLat_ZanList @"http://www.alayy.com/index.php?d=api&c=tplat&m=get_like_user&tt_id=%@"

//关注/取消关注某用户

//关注某用户 &friend_uid=%@&authcode=%@
#define USER_CONCERN_ADD @"http://www.alayy.com/index.php?d=api&c=my_api&m=attention&action=at_friend"

//取消关注某用户 &friend_uid=%@&authcode=%@
#define USER_CONCERN_CANCEL @"http://www.alayy.com/index.php?d=api&c=my_api&m=attention&action=can_friend"

//d=api&c=my_api&m=get_friend_list&action=get_my_attend&friend_uid=21&authcode=VCsAeVsiBeMAuwyRArIM21P2UbMH8lKjUXwGNwdiUWcBMFBhVzUCNgQzVmNSNAx8BTFXaQ==

//action=get_fans 获取粉丝
#define USER_FANS_LIST @"http://www.alayy.com/index.php?d=api&c=my_api&m=get_friend_list&action=get_fans"

//action=get_my_attend 获取我关注的
#define USER_CONCERN_LIST @"http://www.alayy.com/index.php?d=api&c=my_api&m=get_friend_list&action=get_my_attend"

//action=get_friends 获取好友
#define USER_FRIENDS_LIST @"http://www.alayy.com/index.php?d=api&c=my_api&m=get_friend_list&action=get_friends"


//统计功能
//店铺浏览量加1
#define LIULAN_NUM_SHOP @"http://www.alayy.com/index.php?d=api&c=statistic&m=add_shop_view"
//商场浏览量+1
#define LIULAN_NUM_STORE @"http://www.alayy.com/index.php?d=api&c=statistic&m=add_mall_view"
//单品浏览量+1
#define LIULAN_NUM_PRODUCT @"http://www.alayy.com/index.php?d=api&c=statistic&m=add_product_view"

//店铺访客
#define FANGKE_MYSHOP @"http://www.alayy.com/index.php?d=api&c=mall&m=get_track_to_shop&shop_id=2711"

//删除T台
#define DELETE_TTAI @"http://www.alayy.com/index.php?d=api&c=tplat&m=del_tt"


//编辑T台
#define EDIT_TTAI @"http://www.alayy.com/index.php?d=api&c=tplat&m=edit_tt"

//分享地址

//T台详情wap
#define SHARE_TPLAT_DETAIL @"http://www.alayy.com/index.php?d=wap&c=tplat&m=getttinfo&tt_id=%@"

//单品产品详情
#define SHARE_PRODUCT_DETAIL @"http://www.alayy.com/index.php?d=wap&c=products&m=getProductInfo&product_id=%@"

#endif





