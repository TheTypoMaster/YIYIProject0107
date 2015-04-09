//
//  GScrollView.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GScrollView.h"

#import "NSDictionary+GJson.h"
#import "HomeClothController.h"
#import "UIView+Gstring.h"
#import "GBtn.h"
#import "GCustomNearByView.h"

@implementation GScrollView



//block的set方法

-(void)setPinpaiViewBlock:(pinpaiViewBlock)pinpaiViewBlock{
    _pinpaiViewBlock = pinpaiViewBlock;
}


-(void)gReloadData{
    
    if (self.gtype == GNEARBYPINPAI) {//附近的品牌
        
        
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        
        
        NSInteger countNum = self.dataArray.count;
        
        self.contentSize = CGSizeMake(countNum *115, self.contentSize.height);
        
        for (int i = 0; i<countNum; i++) {
            NSDictionary *dic = self.dataArray[i];
            NSString *imvStr = [dic stringValueForKey:@"product_logo"];
            NSString *nameStr = [dic stringValueForKey:@"brand_name"];
            
            UIView *pinpaiView = [[GView alloc]initWithFrame:CGRectMake(0+i*115, 10, 108, 143)];
            pinpaiView.tag = [[dic stringValueForKey:@"id"]intValue]+10;
            pinpaiView.gString = nameStr;
            pinpaiView.userInteractionEnabled = YES;
            
            //手势
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ggdoTap:)];
            [pinpaiView addGestureRecognizer:tap];
            
            //品牌图片view
            UIImageView *pinpai_pic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 108, 143)];
            pinpai_pic.layer.cornerRadius = 10;
            pinpai_pic.layer.masksToBounds = YES;
            pinpai_pic.userInteractionEnabled = YES;
            [pinpai_pic sd_setImageWithURL:[NSURL URLWithString:imvStr] placeholderImage:nil];
            [pinpaiView addSubview:pinpai_pic];
            
            //品牌名称
            UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(15, 110, pinpai_pic.frame.size.width-30, 25)];
            nameView.alpha = 0.5;
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:nameView.bounds];
            nameLabel.backgroundColor = RGBCOLOR(48, 47, 52);
            nameLabel.text = nameStr;
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.userInteractionEnabled = YES;
            nameLabel.font = [UIFont systemFontOfSize:12];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [nameView addSubview:nameLabel];
            [pinpaiView addSubview:nameView];
            
            [self addSubview:pinpaiView];
            
        }
        
    }else if (self.gtype == GNEARBYSTORE){//附近的商店

        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        
        NSInteger countNum = self.dataArray.count;
        self.contentSize = CGSizeMake(countNum*81, self.contentSize.height);
        
        for (int i = 0; i<countNum; i++) {
            NSDictionary *dic = self.dataArray[i];
            GCustomNearByView *view = [[GCustomNearByView alloc]initWithFrame:CGRectMake(0+i*81, 10, 80, self.frame.size.height)];
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *tt = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goNearbyStore:)];
            [view addGestureRecognizer:tt];
            
            view.dataDic = dic;
            view.tag = [[dic stringValueForKey:@"mall_id"]integerValue]+10;;
            
            
            [self addSubview:view];
            
            if (i%2 == 0) {//偶数 红点在前
                view.theType = GjiaoyaTypeDown;
                [view loadCustomView];
            }else{//奇数 红点在后
                view.theType = GjiaoyaTypeUp;
                [view loadCustomView];
            }
            
            
        }
        
        
        
    }
    
    
    
    
    
    
}



//点击商城 Gbtn
-(void)goNearbyStoreVC:(GBtn*)sender{
    NSString *ssidStr = [NSString stringWithFormat:@"%d",sender.tag-10];
    
    NSLog(@"%@",sender.titleLabel.text);
    [self.delegate1 pushToNearbyStoreVCWithIdStr:ssidStr theStoreName:sender.titleLabel.text theType:sender.shopType];
}

//点击商城 GCustomNearbyView
-(void)goNearbyStore:(UIGestureRecognizer *)sender{
    GCustomNearByView *view = (GCustomNearByView*)sender.view;
    NSString *ssidStr = [NSString stringWithFormat:@"%d",sender.view.tag-10];
    [self.delegate1 pushToNearbyStoreVCWithIdStr:ssidStr theStoreName:view.titleLabel.text theType:view.shopType];
}



//点击品牌
-(void)ggdoTap:(UITapGestureRecognizer *)sender{
//    if (self.pinpaiViewBlock) {
//        self.pinpaiViewBlock(sender.view.tag);
//    }
    
    NSString *ssidstr = [NSString stringWithFormat:@"%d",sender.view.tag-10];
    NSString *pinpaiName = sender.view.gString;
    [self.delegate1 pushToPinpaiDetailVCWithIdStr:ssidstr pinpaiName:pinpaiName];
    
    
}

@end
