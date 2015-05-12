//
//  MyShopViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/5/7.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyShopViewController.h"
#import "MailInfoModel.h"
#import "GmyShopHuiyuanViewController.h"
#import "GupClothesViewController.h"
#import "GupHuoDongViewController.h"
#import "GmyproductsListViewController.h"
#import "GmyActivetiesViewController.h"
#import "GShopPhoneViewController.h"
#import "GmyshopErweimaViewController.h"//二维码
#import "GfangkeViewController.h"//访客


@interface MyShopViewController ()
{
    UIView *_backView;//上方headerview背景
    UILabel *_titleLabel;//店铺名
    UILabel *_fangkeLabel;//访客
    UILabel *_huiyuanLabel;//会员label
    NSMutableArray *_btnArray;//店铺管理按钮数组
    NSMutableArray *_animationArray;//动画数组
    int _theTurn;//顺序标示
    CATransition *_transtion_upinfoview;//uPInfoView
}
@end



@implementation MyShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _theTurn = 0;
    
    
    [self creatShopInfoView];
    [self getMailDetailInfo];
    [self creatEditBtnView];
    [self creatAnimationArray];
//    [self performSelector:@selector(animationStart) withObject:self afterDelay:0.5];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getMailDetailInfo
{
    
    __weak typeof(self)weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@",GET_MAIL_DETAIL_INFO,self.userInfo.shop_id];
    
    NSLog(@"%@",url);
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"获取店铺详情:%@",result);
        MailInfoModel *mail = [[MailInfoModel alloc]initWithDictionary:result];
        self.mallInfo = mail;
        [weakSelf setViewWithModel:mail];
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
}


- (void)setViewWithModel:(MailInfoModel *)aModel
{
    [self.userFaceImv sd_setImageWithURL:[NSURL URLWithString:aModel.logo] placeholderImage:nil];
    _titleLabel.text = aModel.shop_name;
    _fangkeLabel.text = aModel.shop_view_num;
    _huiyuanLabel.text = aModel.attend_num;
    
}


//创建上方infoView
-(void)creatShopInfoView{
    //底层view
    _backView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 150*GscreenRatio_320)];
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 150*GscreenRatio_320)];
    imv.userInteractionEnabled = YES;
    [imv setImage:[GMAPI getUserBannerImage]];
    [_backView addSubview:imv];
    _transtion_upinfoview = [CATransition animation];
    _transtion_upinfoview.duration = 0.2;
    _transtion_upinfoview.type = kCATransitionMoveIn;
    _transtion_upinfoview.subtype = kCATransitionFromBottom;
    _transtion_upinfoview.timingFunction = UIViewAnimationCurveEaseInOut;
    _transtion_upinfoview.delegate = self;
    [_backView.layer addAnimation:_transtion_upinfoview forKey:nil];
    
    [self.view addSubview:_backView];
    
    
    
    //返回按钮
    
    UIButton *button_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_back setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [button_back setImageEdgeInsets:UIEdgeInsetsMake(30, 15, 30, 50)];
    [button_back setFrame:CGRectMake(0, 0, 70, 80)];
    [button_back addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button_back setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
    [_backView addSubview:button_back];
    
    
    //头像
    self.userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.userFaceImv setImage:[UIImage imageNamed:@"grzx150_150.png"]];
    self.userFaceImv.center = CGPointMake(_backView.center.x, _backView.center.y-30);
    self.userFaceImv.layer.cornerRadius = 25;
    self.userFaceImv.layer.masksToBounds = YES;
    [_backView addSubview:self.userFaceImv];
    
    
    
    //店铺名
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userFaceImv.frame)+5, DEVICE_WIDTH, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"";
    _titleLabel.textColor = [UIColor whiteColor];
    [_backView addSubview:_titleLabel];
    
    
    
    //今日访客 店铺会员
    UIView *theBlackBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _backView.frame.size.height-45, DEVICE_WIDTH, 45)];
    theBlackBackView.backgroundColor = [UIColor blackColor];
    theBlackBackView.alpha = 0.65;
    [_backView addSubview:theBlackBackView];
    
    //分割线
    UIView *fen = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.5, 35)];
    fen.backgroundColor = [UIColor whiteColor];
    fen.center = theBlackBackView.center;
    [_backView addSubview:fen];
    
    //今日访客
    UIView *fangkeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH*0.5, theBlackBackView.frame.size.height)];
    UITapGestureRecognizer *fangkeClicked = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToFangkeVC)];
    [fangkeView addGestureRecognizer:fangkeClicked];
    [theBlackBackView addSubview:fangkeView];
    
    _fangkeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, DEVICE_WIDTH*0.5, 13)];
    _fangkeLabel.font = [UIFont systemFontOfSize:12];
    _fangkeLabel.textColor = [UIColor whiteColor];
    _fangkeLabel.textAlignment = NSTextAlignmentCenter;
    [fangkeView addSubview:_fangkeLabel];
    
    UILabel *jinrifangke = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_fangkeLabel.frame)+6, _fangkeLabel.frame.size.width, 12)];
    jinrifangke.textColor = [UIColor whiteColor];
    jinrifangke.textAlignment = NSTextAlignmentCenter;
    jinrifangke.font = [UIFont systemFontOfSize:12];
    jinrifangke.text = @"我的访客";
    [fangkeView addSubview:jinrifangke];
    
    
    //店铺会员
    UIView *huiyuanView = [[UIView alloc]initWithFrame:CGRectMake(theBlackBackView.frame.size.width*0.5, 0, DEVICE_WIDTH*0.5, theBlackBackView.frame.size.height)];
    UITapGestureRecognizer *huiyuanClicked = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToHuiyuanVC)];
    [huiyuanView addGestureRecognizer:huiyuanClicked];
    [theBlackBackView addSubview:huiyuanView];
    
    _huiyuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, _fangkeLabel.frame.size.width, _fangkeLabel.frame.size.height)];
    _huiyuanLabel.font = [UIFont systemFontOfSize:12];
    _huiyuanLabel.textAlignment = NSTextAlignmentCenter;
    _huiyuanLabel.textColor = [UIColor whiteColor];
    [huiyuanView addSubview:_huiyuanLabel];
    
    UILabel *dianpuhuiyuan = [[UILabel alloc]initWithFrame:CGRectMake(0, jinrifangke.frame.origin.y, jinrifangke.frame.size.width, jinrifangke.frame.size.height)];
    dianpuhuiyuan.font = [UIFont systemFontOfSize:12];
    dianpuhuiyuan.text = @"店铺会员";
    dianpuhuiyuan.textColor = [UIColor whiteColor];
    dianpuhuiyuan.textAlignment = NSTextAlignmentCenter;
    [huiyuanView addSubview:dianpuhuiyuan];
    
    
    
    
    
    
}

//返回上一个界面
-(void)clickToBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//跳转访客
-(void)pushToFangkeVC{
    GfangkeViewController *ccc = [[GfangkeViewController alloc]init];
    ccc.shop_id = self.userInfo.shop_id;
    ccc.lastPageNavigationHidden = YES;
    [self.navigationController pushViewController:ccc animated:YES];
    
    
}

//跳转店铺会员
-(void)pushToHuiyuanVC{
    
    [MiddleTools pushToUserListWithObjectId:self.mallInfo.id listType:User_ShopMember forViewController:self lastNavigationHidden:YES updateParmsBlock:^(NSDictionary *params) {
        
    }];
}





//创建编辑按钮
-(void)creatEditBtnView{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_backView.frame), DEVICE_WIDTH, DEVICE_HEIGHT-_backView.frame.size.height)];
    [self.view addSubview:backView];
    
    if (!_btnArray) {
        _btnArray = [NSMutableArray arrayWithCapacity:1];
    }
    
    
    NSArray *picArray = @[[UIImage imageNamed:@"dianzhu_01.png"],[UIImage imageNamed:@"dianzhu_02.png"],[UIImage imageNamed:@"dianzhu_03.png"],[UIImage imageNamed:@"dianzhu_04.png"],[UIImage imageNamed:@"dianzhu_05.png"],[UIImage imageNamed:@"dianzhu_06.png"]];
    
    CGFloat btnWidth = (DEVICE_WIDTH-60)/3.0;
    CGFloat btnHeight = btnWidth/208*262;
    
    for (int i = 0; i<6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        if (i<3) {
            [btn setFrame:CGRectMake(15+i*(btnWidth+15), 15, btnWidth, btnHeight)];
        }else if (i>=3){
            [btn setFrame:CGRectMake(15+(i-3)*(btnWidth+15), 30+btnHeight, btnWidth, btnHeight)];
        }
        
        [btn setImage:picArray[i] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
        btn.alpha = 0;
        
        [_btnArray addObject:btn];
        
    }

    
}

//创建动画
-(void)creatAnimationArray{
    _animationArray = [NSMutableArray arrayWithCapacity:1];

    
    //按钮动画
    NSInteger gong = _btnArray.count;
    for (int i = 0; i<gong; i++) {
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.15;
        transtion.timingFunction = UIViewAnimationCurveEaseInOut;
        transtion.startProgress = 0.5;
        transtion.endProgress = 1.0;
        transtion.type = @"oglFlip";
        transtion.delegate = self;
        transtion.subtype = kCATransitionFromLeft;
        [_animationArray addObject:transtion];
    }
    
    
    
}



-(void)animationDidStart:(CAAnimation *)anim{
    
    
    if (anim == _transtion_upinfoview) {
        
    }else{
        NSLog(@"+++++++++%@",anim);
        if (_theTurn-1<_btnArray.count && _theTurn!=0){
            UIView *view = _btnArray[_theTurn-1];
            [UIView animateWithDuration:0.3 animations:^{
                view.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }
    
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        NSLog(@"-----------%@",anim);
        if (_theTurn<_btnArray.count) {
            CATransition *transtion = _animationArray[_theTurn];
            UIView *view = _btnArray[_theTurn];
            [view.layer addAnimation:transtion forKey:nil];
            _theTurn++;
        }
        
    }
}


-(void)editBtnClicked:(UIButton *)sender{
    switch (sender.tag) {
        case 100://发布单品
        {
            GupClothesViewController *ccc = [[GupClothesViewController alloc]init];
            ccc.userInfo = self.userInfo;
            ccc.mallInfo = self.mallInfo;
            ccc.lastPageNavigationHidden = YES;
            [self.navigationController pushViewController:ccc animated:YES];
        }
            break;
        case 101://发布活动
        {
            GupHuoDongViewController *ccc = [[GupHuoDongViewController alloc]init];
            ccc.mallInfo = self.mallInfo;
            ccc.userInfo = self.userInfo;
            ccc.lastPageNavigationHidden = YES;
            [self.navigationController pushViewController:ccc animated:YES];
        }
            break;
        case 102://管理单品
        {
            GmyproductsListViewController *ccc = [[GmyproductsListViewController alloc]init];
            ccc.userInfo = self.userInfo;
            ccc.mallInfo = self.mallInfo;
            ccc.lastPageNavigationHidden = YES;
            [self.navigationController pushViewController:ccc animated:YES];
        }
            break;
        case 103://管理活动
        {
            GmyActivetiesViewController *ccc = [[GmyActivetiesViewController alloc]init];
            ccc.userInfo = self.userInfo;
            ccc.mallInfo = self.mallInfo;
            ccc.lastPageNavigationHidden = YES;
            [self.navigationController pushViewController:ccc animated:YES];
        }
            break;
        case 104://联系电话
        {
            GShopPhoneViewController *ccc = [[GShopPhoneViewController alloc]init];
            ccc.shop_id = self.userInfo.shop_id;
            ccc.lastPageNavigationHidden = YES;
            [self.navigationController pushViewController:ccc animated:YES];
        }
            break;
        case 105://店铺资料
        {
            GmyshopErweimaViewController *ccc = [[GmyshopErweimaViewController alloc]init];
            ccc.mallInfo = self.mallInfo;
            ccc.shop_id = self.userInfo.shop_id;
            
            ccc.lastPageNavigationHidden = YES;
            [self.navigationController pushViewController:ccc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
