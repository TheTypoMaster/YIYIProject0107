//
//  GmyMainViewController.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GmyMainViewController.h"
#import "GShowStarsView.h"
#import "TMQuiltView.h"
#import "LWaterflowView.h"


@interface GmyMainViewController ()<TMQuiltViewDataSource,WaterFlowDelegate>
{
    
    
    //第一层
    UIView *_upUserInfoView;//用户信息view
    UIImageView *_userFaceImv;//头像
    UILabel *_userNameLabel;//用户名
    UILabel *_guanzhuLabel;//关注
    UILabel *_fensiLabel;//粉丝
    
    //第二层 (自己的主页没有这一层)
    UIView *_jiaoliuGuanzhuView;//交流关注view
    
    
    //第三层
    LWaterflowView *waterFlow;//瀑布流
    
    
    
    UIScrollView *_mainScrollView;//最底层scrollview
}
@end

@implementation GmyMainViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.myTitleLabel.textColor = [UIColor whiteColor];
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    if (self.theType == GMYSELF) {//自己的主页
        _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT+150);
    }else if (self.theType == GSOMEONE){//别人的主页
        _mainScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_WIDTH+150+58);
    }
    
    [self.view addSubview:_mainScrollView];
    
    //加载顶部信息
    [_mainScrollView addSubview:[self creatUpUserInfoView]];
    
    if (self.theType == GSOMEONE) {
        //加载交流关注view
        [_mainScrollView addSubview:[self creatJiaoliuGuanzhuView]];
        //加载瀑布流
        [_mainScrollView addSubview:[self creatPubuliu]];
    }else if (self.theType == GMYSELF){
        //加载瀑布流
        [_mainScrollView addSubview:[self creatPubuliu]];
    }
    
    
    
    
    
    
    
}




//请求网络数据
-(void)prepareNetData{
    [waterFlow showRefreshHeader:YES];
}


//瀑布流
-(UIView*)creatPubuliu{
    if (self.theType == GSOMEONE) {
        waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_jiaoliuGuanzhuView.frame), ALL_FRAME_WIDTH, DEVICE_HEIGHT - _jiaoliuGuanzhuView.frame.size.height) waterDelegate:self waterDataSource:self];
    }else if (self.theType == GMYSELF){
        waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_upUserInfoView.frame), ALL_FRAME_WIDTH, DEVICE_HEIGHT) waterDelegate:self waterDataSource:self];
    }
    waterFlow.backgroundColor = RGBCOLOR(240, 242, 242);
    
    return waterFlow;
}

//别人主页的 交流关注view
-(UIView*)creatJiaoliuGuanzhuView{
    _jiaoliuGuanzhuView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_upUserInfoView.frame), DEVICE_WIDTH, 58)];
    _jiaoliuGuanzhuView.backgroundColor = [UIColor whiteColor];
    
    //交流
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((DEVICE_WIDTH-100-100-10)*0.5, 12, 100, 34)];
    [btn setBackgroundColor:RGBCOLOR(252, 252, 252)];
    [btn setTitle:@"交流" forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(114, 114, 114) forState:UIControlStateNormal];
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 2;
    btn.layer.borderColor = [RGBCOLOR(204, 204, 204)CGColor];
    
    
    //关注
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(CGRectGetMaxX(btn.frame)+10, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)];
    [btn1 setTitle:@"+ 关注" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:RGBCOLOR(234, 95, 120)];
    
    
    [_jiaoliuGuanzhuView addSubview:btn];
    [_jiaoliuGuanzhuView addSubview:btn1];
    
    return _jiaoliuGuanzhuView;
}


//顶部用户信息view
-(UIView*)creatUpUserInfoView{
    
    //整个view
    _upUserInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 150)];
    _upUserInfoView.backgroundColor = RGBCOLOR_ONE;
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
//    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 15, 30, 55)];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 15, 30, 50)];
    [backBtn setFrame:CGRectMake(0, 0, 80, 80)];
    [backBtn addTarget:self action:@selector(gGoBackVc) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.backgroundColor = [UIColor redColor];
    [_upUserInfoView addSubview:backBtn];
    
    //头像
    _userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_WIDTH-50)*0.5, 50, 50, 50)];
    _userFaceImv.backgroundColor = RGBCOLOR_ONE;
    _userFaceImv.layer.cornerRadius = 25;
    _userFaceImv.layer.borderWidth = 1;
    _userFaceImv.layer.borderColor = [[UIColor whiteColor]CGColor];
    _userFaceImv.layer.masksToBounds = YES;
    [_upUserInfoView addSubview:_userFaceImv];
    
    //用户名
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(_userFaceImv.frame)+5, DEVICE_WIDTH, 20)];
    _userNameLabel.backgroundColor = RGBCOLOR_ONE;
    _userNameLabel.font = [UIFont systemFontOfSize:19];
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    [_upUserInfoView addSubview:_userNameLabel];
    
    //关注 粉丝
    _guanzhuLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_userNameLabel.frame)+10, DEVICE_WIDTH*0.5-1, 16)];
    _guanzhuLabel.font = [UIFont systemFontOfSize:15];
    _guanzhuLabel.textColor = [UIColor whiteColor];
    _guanzhuLabel.textAlignment = NSTextAlignmentRight;
    _guanzhuLabel.backgroundColor = RGBCOLOR_ONE;
    //分割线
    UIView *fenView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_guanzhuLabel.frame), _guanzhuLabel.frame.origin.y, 1, _guanzhuLabel.frame.size.height)];
    fenView.backgroundColor = [UIColor whiteColor];
    _fensiLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fenView.frame), fenView.frame.origin.y, _guanzhuLabel.frame.size.width, _guanzhuLabel.frame.size.height)];
    _fensiLabel.font = [UIFont systemFontOfSize:15];
    _fensiLabel.backgroundColor = RGBCOLOR_ONE;
    _fensiLabel.textColor = [UIColor whiteColor];
    _fensiLabel.textAlignment = NSTextAlignmentLeft;
    [_upUserInfoView addSubview:_guanzhuLabel];
    [_upUserInfoView addSubview:fenView];
    [_upUserInfoView addSubview:_fensiLabel];
    
    
    return _upUserInfoView;
    
    
}

-(void)gGoBackVc{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - WaterFlowDelegate

- (void)waterLoadNewData
{
    
}
- (void)waterLoadMoreData
{
    
}

- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"indexpath = %ld",(long)indexPath.row);
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    CGFloat aHeight = 0.f;
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    if (aMode.imagelist.count >= 1) {
        
        NSDictionary *imageDic = aMode.imagelist[0];
        NSDictionary *middleImage = imageDic[@"540Middle"];
        aHeight = [middleImage[@"height"]floatValue];
    }
    
    return aHeight / 2.0f + 33;
}
- (CGFloat)waterViewNumberOfColumns
{
    
    return 2;
}

#pragma mark - TMQuiltViewDataSource

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [waterFlow.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    
    cell.layer.cornerRadius = 3.f;
    
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    [cell setCellWithModel:aMode];
    
    
    return cell;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
