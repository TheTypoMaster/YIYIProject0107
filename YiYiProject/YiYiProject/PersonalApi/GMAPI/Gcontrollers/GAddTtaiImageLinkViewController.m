//
//  GAddTtaiImageLinkViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/4/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GAddTtaiImageLinkViewController.h"
#import "GsearchViewController.h"
#import "GmoveImv.h"

#import "GTTPublishViewController.h"
#import "NSDictionary+GJson.h"
#import "GmaodianModel.h"

@interface GAddTtaiImageLinkViewController ()
{
    UIImageView *_showImv;
    int _flagTag_gimv;
    int _flagTag;
}
@end

@implementation GAddTtaiImageLinkViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if (self.theTtaiModel && !self.isFirst && !self.delegate.GimvArray) {//编辑T台 把model数据放到锚点数组里
        NSArray *maodianArray = [self.theTtaiModel.image arrayValueForKey:@"img_detail"];
        NSInteger count = maodianArray.count;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        
        for (int i = 0;i<count;i++) {
            GmoveImv *imv = [[GmoveImv alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
            NSDictionary *dic = maodianArray[i];
            NSString *product_name = [dic stringValueForKey:@"product_name"];
            
            if (product_name.length > 0 && ![product_name isEqualToString:@" "]) {
                imv.type = @"单品";
                imv.shop_id = [dic stringValueForKey:@"shop_id"];
                imv.product_id = [dic stringValueForKey:@"product_id"];
                imv.product_name = product_name;
                imv.product_price = [dic stringValueForKey:@"product_price"];
                imv.shop_name = [dic stringValueForKey:@"shop_name"];
            }else{
                imv.type = @"店铺";
                imv.shop_name = [dic stringValueForKey:@"shop_name"];
                imv.shop_id = [dic stringValueForKey:@"shop_id"];
                imv.product_price = [dic stringValueForKey:@"address"];
            }
            
            CGFloat img_x = [[dic stringValueForKey:@"img_x"] floatValue];
            CGFloat img_y = [[dic stringValueForKey:@"img_y"] floatValue];
            
            
            
            CGFloat width = [[self.theTtaiModel.image stringValueForKey:@"width"]floatValue];
            CGFloat height = [[self.theTtaiModel.image stringValueForKey:@"height"]floatValue];
            
            
            NSArray *arr_bili = [self bilisuofangWithHeight:height withWidth:width];
            NSString *newheight = arr_bili[0];
            NSString *newwidth = arr_bili[1];
            width = [newwidth floatValue];
            height = [newheight floatValue];
            imv.center = CGPointMake(width *img_x, height * img_y);
            imv.location_x = imv.center.x;
            imv.location_y = imv.center.y;
            
            [arr addObject:imv];
            
            
        }
        
        self.maodianArray = arr;
        self.isFirst = YES;
        
    }
    
    
    //选择完成锚点之后返回上一个界面再进入
    if (self.delegate.GimvArray) {
        self.maodianArray = self.delegate.GimvArray;
    }
    
    
    
    
    
    //把锚点里的Gimv展示到showImv上
    for (GmoveImv *imv in self.maodianArray) {
        NSLog(@"imv.shopid = %@ imv.pid = %@",imv.shop_id,imv.product_id);
        NSLog(@"imv.shopName = %@  imv.pname = %@",imv.shop_name,imv.product_name);
        
        if (imv.shop_id == nil && !self.theTtaiModel) {
            continue;
        }
        
        for (UIView *view in imv.subviews) {
            [view removeFromSuperview];
        }
        
        
        
        if ([imv.type isEqualToString:@"单品"]) {
            //背景图
            [imv setImage:[UIImage imageNamed:@"gttailink_have.png"]];
            
            //产品名称
            UILabel *productName = [[UILabel alloc]initWithFrame:CGRectMake(17, 7, 85, 24)];
            productName.text = imv.product_name;
            productName.font = [UIFont systemFontOfSize:10];
            productName.numberOfLines = 2;
            productName.textColor = [UIColor whiteColor];
            [imv addSubview:productName];
            
            //单价
            UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(productName.frame), 90, 11)];
            priceLabel.text = [NSString stringWithFormat:@"￥%@",imv.product_price];
            priceLabel.font = [UIFont systemFontOfSize:10];
            priceLabel.textColor = [UIColor whiteColor];
            [imv addSubview:priceLabel];
            
            //地址：商场名
            UILabel *adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, CGRectGetMaxY(priceLabel.frame)+3, 97, 25)];
            adressLabel.text = imv.shop_name;
            adressLabel.font = [UIFont systemFontOfSize:10];
            adressLabel.textAlignment = NSTextAlignmentLeft;
            adressLabel.numberOfLines = 2;
            adressLabel.textColor = [UIColor whiteColor];
            [imv addSubview:adressLabel];
            
            
            CGPoint center = imv.center;
            CGRect r = imv.frame;
            r.size.height = 70;
            r.size.width = 105;
            [imv setFrame:r];
            imv.center = center;
        }else if ([imv.type isEqualToString:@"店铺"]){
            //背景图
            [imv setImage:[UIImage imageNamed:@"gttailink_have.png"]];
            
            //店铺名
            UILabel *productName = [[UILabel alloc]initWithFrame:CGRectMake(17, 7, 85, 35)];
            productName.text = imv.shop_name;
            productName.font = [UIFont systemFontOfSize:10];
            productName.numberOfLines = 3;
            productName.textColor = [UIColor whiteColor];
            [imv addSubview:productName];
            
            
            //地址
            UILabel *adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, CGRectGetMaxY(productName.frame)+3, 97, 25)];
            adressLabel.text = [NSString stringWithFormat:@"地址:%@",imv.product_price];
            adressLabel.font = [UIFont systemFontOfSize:10];
            adressLabel.textAlignment = NSTextAlignmentLeft;
            adressLabel.numberOfLines = 2;
            adressLabel.textColor = [UIColor whiteColor];
            [imv addSubview:adressLabel];
            
            CGPoint center = imv.center;
            CGRect r = imv.frame;
            r.size.height = 70;
            r.size.width = 105;
            [imv setFrame:r];
            imv.center = center;
        }
        
        
        
        imv.tag = (_flagTag_gimv+=1);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addProductLink:)];
        [imv addGestureRecognizer:tap];
        
        UIButton *deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deletBtn setFrame:CGRectMake(1, 1, 17, 17)];
        [deletBtn setImage:[UIImage imageNamed:@"g_linkdelete.png"] forState:UIControlStateNormal];
        [imv addSubview:deletBtn];
        [deletBtn addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
        deletBtn.tag = -imv.tag;
        
        [_showImv addSubview:imv];
        
    }
    
    
}


//等比例缩放到一个屏幕内
-(NSArray*)bilisuofangWithHeight:(CGFloat)height withWidth:(CGFloat)width{
    //原图相关
    CGFloat image_width = 0.0f;//宽
    CGFloat image_height = 0.0f;//高
    CGFloat bili_wmw = 0.0f;//宽除以最大宽
    CGFloat bili_hmh = 0.0f;//高除以最大高
    CGFloat width_showImv_max = DEVICE_WIDTH;//最大宽
    CGFloat height_showImv_max =  DEVICE_HEIGHT-64-45;//最大高
    CGFloat new_width = 0.0f;//按比例缩放后的新宽
    CGFloat new_height = 0.0f;//按比例缩放后的新高
    
    //赋值与计算
    image_width = width;
    image_height = height;
    bili_wmw = image_width/width_showImv_max;
    bili_hmh = image_height/height_showImv_max;
    
    if (bili_wmw>bili_hmh) {//宽图
        new_width = image_width/bili_wmw;
        new_height = image_height/bili_wmw;
    }else{//长图或正方形图
        new_width = image_width/bili_hmh;
        new_height = image_height/bili_hmh;
    }
    
    NSString *newWidth = [NSString stringWithFormat:@"%f",new_width];
    NSString *newHeight = [NSString stringWithFormat:@"%f",new_height];
    NSArray *arr = @[newHeight,newWidth];
    
    return arr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    self.rightString = @"完成";
    self.view.backgroundColor = RGBCOLOR(235, 235, 235);
    self.editStyle = NO;
    _flagTag = 0;
    _flagTag_gimv = 10;
    self.maodianArray = [NSMutableArray arrayWithCapacity:1];
    
    //视图
    UIView *imv_downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64-45)];
    [self.view addSubview:imv_downView];
    
    _showImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [imv_downView addSubview:_showImv];
    _showImv.userInteractionEnabled = YES;
    
    //原图相关
    CGFloat image_width = 0.0f;//宽
    CGFloat image_height = 0.0f;//高
    CGFloat bili_wmw = 0.0f;//宽除以最大宽
    CGFloat bili_hmh = 0.0f;//高除以最大高
    CGFloat width_showImv_max = DEVICE_WIDTH;//最大宽
    CGFloat height_showImv_max =  DEVICE_HEIGHT-64-45;//最大高
    CGFloat new_width = 0.0f;//按比例缩放后的新宽
    CGFloat new_height = 0.0f;//按比例缩放后的新高
    
    //赋值与计算
    image_width = self.theImage.size.width;
    image_height = self.theImage.size.height;
    bili_wmw = image_width/width_showImv_max;
    bili_hmh = image_height/height_showImv_max;
    
    if (bili_wmw>bili_hmh) {//宽图
        new_width = image_width/bili_wmw;
        new_height = image_height/bili_wmw;
    }else{//长图或正方形图
        new_width = image_width/bili_hmh;
        new_height = image_height/bili_hmh;
    }
    
    //给imv重新设置frame
    [_showImv setFrame:CGRectMake(0, 0, new_width, new_height)];
    _showImv.center = imv_downView.center;
    [_showImv setImage:self.theImage];
    
    
    
    //创建提示语view
    UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(imv_downView.frame), DEVICE_WIDTH-10, 45)];
    tip1.text = @"提示: 点击图片添加锚点,可添加多个锚点,锚点可拖动,点击锚点选择链接,选择链接完成后点击右上角完成按钮返回发布界面";
    tip1.font = [UIFont systemFontOfSize:12];
    tip1.numberOfLines = 3;
    tip1.textColor = [UIColor grayColor];
    [self.view addSubview:tip1];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftButtonTap:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)rightButtonTap:(UIButton *)sender{
    
//    self.editStyle = NO;
    
    NSLog(@"添加锚点完成");
    
    NSMutableArray *shopNameArray = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *shopIdArray = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *productIdArray = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *locationxArray = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *locationyArray = [NSMutableArray arrayWithCapacity:1];
    
    for (GmoveImv *imv in self.maodianArray) {
        NSLog(@"shopName:%@ shopId:%@ productName:%@ productId:%@  x=%f y=%f",imv.shop_name,imv.shop_id,imv.product_name,imv.product_id,imv.location_x,imv.location_y);
        CGFloat locationxbili = imv.location_x/_showImv.frame.size.width;
        CGFloat locationybili = imv.location_y/_showImv.frame.size.height;
        if (!imv.shop_id) {
            continue;
        }
        
        if (imv.product_id.length == 0) {
            imv.product_id = @"0";
            imv.product_name = @"0";
        }
        
        
        [shopNameArray addObject:imv.shop_name];
        [shopIdArray addObject:imv.shop_id];
        [productIdArray addObject:imv.product_id];
        [locationxArray addObject:[NSString stringWithFormat:@"%f",locationxbili]];
        [locationyArray addObject:[NSString stringWithFormat:@"%f",locationybili]];
        
    }
    
    NSString *productIds = [productIdArray componentsJoinedByString:@","];//所有的产品id 以逗号隔开 没有为0
    NSString *shopIds = [shopIdArray componentsJoinedByString:@","];//所有的店铺id 以逗号隔开 没有为0
    NSString *locationXbilis = [locationxArray componentsJoinedByString:@","];//所有的锚点x比例 以逗号隔开 没有为0
    NSString *locationYbilis = [locationyArray componentsJoinedByString:@","];//所有的锚点y比例 以逗号隔开 没有为0
    
    self.maodianDic = @{
                        @"productid":productIds,
                        @"shopIds":shopIds,
                        @"locationxbili":locationXbilis,
                        @"locationybili":locationYbilis,
                        };
    
    
    self.delegate.maodianDic = self.maodianDic;
    self.delegate.GimvArray = self.maodianArray;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:_showImv];
    NSLog(@"x=%f y=%f",point.x,point.y);
    
    GmoveImv *gimv = [[GmoveImv alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    gimv.tag = (_flagTag_gimv+=1);
    [gimv setImage:[UIImage imageNamed:@"gTtai_dianwo.png"]];
    gimv.center = point;
    gimv.location_x = point.x;
    gimv.location_y = point.y;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addProductLink:)];
    [gimv addGestureRecognizer:tap];
    
    UIButton *deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deletBtn setFrame:CGRectMake(1, 1, 17, 17)];
    [deletBtn setImage:[UIImage imageNamed:@"g_linkdelete.png"] forState:UIControlStateNormal];
    [gimv addSubview:deletBtn];
    [deletBtn addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
    deletBtn.tag = -gimv.tag;
    
    
    if (self.maodianArray.count<5) {
        [_showImv addSubview:gimv];
        [self.maodianArray addObject:gimv];
    }
    
    
    
    
    NSLog(@"%@",NSStringFromCGRect(_showImv.frame));
    NSLog(@"%f",CGRectGetMaxX(_showImv.frame));
    
    //判断是否在图片上
    if (gimv.frame.origin.x<0||CGRectGetMaxX(gimv.frame)>_showImv.frame.size.width||gimv.frame.origin.y<0||CGRectGetMaxY(gimv.frame)>_showImv.frame.size.height) {
        [self removeSelf:deletBtn];
    }

    
    
    
}


-(void)removeSelf:(UIButton *)sender{
    
    GmoveImv *imv = (GmoveImv*)[self.view viewWithTag:(-sender.tag)];
    [self.maodianArray removeObject:imv];
    [imv removeFromSuperview];
}


-(void)addProductLink:(UITapGestureRecognizer *)sender{
    
    _flagTag = (int)sender.view.tag;
    GsearchViewController *cc = [[GsearchViewController alloc]init];
    cc.isChooseProductLink = YES;
    [self.navigationController pushViewController:cc animated:YES];
}


//当锚点为店铺的时候 shopName为店铺名 price为地址
-(void)setGmoveImvProductId:(NSString *)productId shopid:(NSString*)theShopId productName:(NSString *)theProductName shopName:(NSString *)theShopName price:(NSString *)thePrice type:(NSString *)theType{
    
    if (!productId) {
        productId = @"0";
    }
    if (!theShopId) {
        theShopId = @"0";
    }
    
    for (GmoveImv *imv in self.maodianArray) {
        if (imv.tag == _flagTag) {
            [imv setImage:[UIImage imageNamed:@"GTtailj_bg.png"]];
            imv.shop_id = theShopId;
            imv.product_id = productId;
            imv.shop_name = theShopName;
            imv.product_name = theProductName;
            imv.product_price = thePrice;
            imv.type = theType;
        }
    }
    
    
}

@end
