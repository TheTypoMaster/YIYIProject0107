//
//  ProductDetailController.h
//  YiYiProject
//
//  Created by lichaowei on 14/12/20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "MyViewController.h"

@class TMPhotoQuiltViewCell;
@class ProductModel;

typedef void(^ViewDidDisappearBlock)(BOOL success);//消失block

typedef enum {
    
    Action_like_yes = 0,//添加赞
    Action_like_no,//取消赞
    Action_Collect_yes,//添加收藏
    Action_Collect_no//取消收藏
    
}ACTION_TYPE; //网络请求类型

@interface ProductDetailController : MyViewController

@property(nonatomic,assign)ViewDidDisappearBlock disappearBlock;

@property (nonatomic,retain)NSString *product_id;//产品id
@property(nonatomic,strong)NSString *gShop_id;//商家id

@property(nonatomic,strong)ProductModel *theModel;//单品model 给聊天界面传递

@property(nonatomic,assign)BOOL isPresent;//是否是模态出来得

@property (strong, nonatomic) IBOutlet UILabel *brandName;

@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *discountLabel;
- (IBAction)clickToDaPeiShi:(id)sender;
- (IBAction)clickToContact:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *xingHaoLabel;
@property (strong, nonatomic) IBOutlet UILabel *biaoQianLabel;
@property (strong, nonatomic) IBOutlet UILabel *shangChangLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *bugButton;
@property (strong, nonatomic) IBOutlet UIButton *shopButton;


@property(nonatomic,assign)BOOL isYYChatVcPush;//是否从聊天界面push过来的

- (IBAction)clickToBuy:(id)sender;
- (IBAction)clickToStore:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *lianxiDianzhuBtn;

@property(nonatomic,assign)BOOL isChooseProductLink;//是否为发布T台商品链接


//用于修改赞的状态

//从我的店铺页面跳转过来的时候这两个属性会有  取消赞之后返回上级页面更新界面数据
@property(nonatomic,retain)TMPhotoQuiltViewCell *theLastViewClickedCell;//上一个界面需要更改点赞状态的自定义cell
@property(nonatomic,retain)ProductModel *theLastViewProductModel;//上一个界面的数据源

//从首页单品标签跳转过来的
@property(nonatomic,retain)TMPhotoQuiltViewCell *theHomeBuyVcProductCell;//首页单品跳转
@property(nonatomic,retain)ProductModel *theHomeBuyVcModel;//首页单品标签中的单品数据model


//从我的收藏跳转过来的
@property(nonatomic,retain)TMPhotoQuiltViewCell *theMyshoucangProductCell;//收藏单品跳转
@property(nonatomic,retain)ProductModel *theMyshoucangProductModel;//收藏单品界面数据model


//从店铺详情页跳转过来
@property(nonatomic,retain)TMPhotoQuiltViewCell *theStorePinpaiProductCell;//店铺详情单品跳转
@property(nonatomic,retain)ProductModel *theStorePinpaiProductModel;//店铺详情页跳转



@end
