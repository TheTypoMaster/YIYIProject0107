//
//  MineViewController.h
//  YiYiProject
//
//  Created by lichaowei on 14/12/10.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "MyViewController.h"

@interface MineViewController : MyViewController

//@property(nonatomic,strong)UIImageView *userBannerImv;//bannerImv
@property(nonatomic,strong)UIImageView *userFaceImv;//头像Imv

@property(nonatomic,strong)UIImage *userBanner;//banner
@property(nonatomic,strong)UIImage *userFace;//头像

@property(nonatomic,strong)UILabel *userNameLabel;//昵称label
@property(nonatomic,strong)UILabel *userScoreLabel;//积分

@property(nonatomic,strong)NSData *userUploadImagedata;//需要上传的二进制图片

@end
