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
#import "TPlatModel.h"
#import "UserInfo.h"
#import "TTaiDetailController.h"
#import "YIYIChatViewController.h"//聊天
#import "ParallaxHeaderView.h"

#define NORMAL_TEXT @"上拉加载更多"
#define NOMORE_TEXT @"没有更多数据"
#define TABLEFOOTER_HEIGHT 50.f

#import "LWaterflowView.h"

#import "TPlatCell.h"

#import "GEditMyTtaiViewController.h"//编辑T台

@interface GmyMainViewController ()<TMQuiltViewDataSource,WaterFlowDelegate>
{
    //第一层
    ParallaxHeaderView *_upUserInfoView;//用户信息view
    UIImageView *_userFaceImv;//头像
    UIImageView *_userBannerImv;//banner
    UILabel *_userNameLabel;//用户名
    
    UILabel *_concernLabel;//关注label
    UILabel *_fansLabel;//关注
    
    //第二层 (自己的主页没有这一层)
    UIView *_jiaoliuGuanzhuView;//交流关注view
    
    UIView *_ttaiView;
    
    UIButton *_concernButton;//关注按钮
    
    UIView *_bottomView;//底部view
    
    UIView *_backView_water;
    LWaterflowView *_waterFlow;
    int _per_page;
    int _page;
    
    UserInfo *_currentUser;//当前用户信息
    
    BOOL _notFirst;//是否是第一次加载数据
    
    UIActivityIndicatorView *_refreshLoading;//刷新loading
    BOOL _isReload;//是否是刷新数据
    BOOL _reloading;//正在加载数据
    
    CGFloat _lastOffsetY;

}

@property(nonatomic,retain)UIActivityIndicatorView *loadingIndicator;
@property(nonatomic,retain)UILabel *normalLabel;
@property(nonatomic,retain)UILabel *loadingLabel;

@end

@implementation GmyMainViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_notFirst == NO) {
        
        [_refreshLoading startAnimating];
        
        [self getUserInfo];
        
        _notFirst = YES;
    }
}

- (void)dealloc
{
    _waterFlow.waterDelegate = nil;
    _waterFlow.quitView.dataSource = nil;
    _waterFlow = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.myTitleLabel.textColor = [UIColor whiteColor];
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }

    [self creatWaterFlowView];
    
    [self getUserTPlat];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserTtai) name:NOTIFICATION_TTAI_EDIT_SUCCESS object:nil];
    
    

}


#pragma mark - 通知方法
-(void)updateUserTtai{
    _waterFlow.pageNum = 1;
    [_waterFlow.dataArray removeAllObjects];
    [self waterLoadNewData];
}



#pragma - mark 网络请求

/**
 *  通过userId获取用户信息
 */
- (void)getUserInfo
{
    
    NSString *userId = self.userType == G_Default ? [GMAPI getUid] : self.userId;

    NSString *api = [NSString stringWithFormat:GET_PERSONINFO_WITHID,userId];
    
    NSString *url = [NSString stringWithFormat:@"%@&authcode=%@",api,[GMAPI getAuthkey]];
    
    __weak typeof(self)weakSelf = self;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        UserInfo *user = [[UserInfo alloc]initWithDictionary:result];
        
        [weakSelf setViewsWithUserInfo:user];
        
        [_refreshLoading stopAnimating];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"获取个人信息失败--->%@",failDic);
        [_refreshLoading stopAnimating];

    }];
}

/**
 *  获取个人T台
 */
- (void)getUserTPlat
{
    
    NSString *userId = self.userType == G_Default ? [GMAPI getUid] : self.userId;
    
    //请求网络数据
    NSString *api = [NSString stringWithFormat:@"%@&page=%d&count=%d&user_id=%@&authcode=%@",TTAi_LIST,_waterFlow.pageNum,L_PAGE_SIZE,userId,[GMAPI getAuthkey]];
    NSLog(@"请求的接口%@",api);
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result : %@",result);
        NSMutableArray *arr;
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *list = result[@"list"];
            arr = [NSMutableArray arrayWithCapacity:list.count];
            if ([list isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *aDic in list) {
                    
                    TPlatModel *aModel = [[TPlatModel alloc]initWithDictionary:aDic];
                    
                    [arr addObject:aModel];
                }
                
            }
        }
        
        [_waterFlow reloadData:arr pageSize:L_PAGE_SIZE];
        
        _waterFlow.isReloadData = NO;
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [_waterFlow loadFail];
    }];

}

#pragma - mark 事件处理

/**
 *  跳转到关注列表
 */
- (void)clickToConcernList:(UIButton *)sender
{
    NSString *userId = self.userId;
    if (self.userType == G_Default) {
        
        userId = [GMAPI getUid];
    }
    [MiddleTools pushToUserListWithObjectId:userId listType:User_MyConcernList forViewController:self lastNavigationHidden:YES updateParmsBlock:^(NSDictionary *params) {
        
    }];
}

/**
 *  跳转到粉丝列表
 */
- (void)clickToFansList
{
    NSString *userId = self.userId;
    if (self.userType == G_Default) {
        
        userId = [GMAPI getUid];
    }
    [MiddleTools pushToUserListWithObjectId:userId listType:User_MyFansList forViewController:self lastNavigationHidden:YES updateParmsBlock:^(NSDictionary *params) {
        
    }];
}

/**
 *  更新关注数
 *
 *  @param num 关注总数
 */
- (void)updateConcernNum:(int)num
{
    NSString *concernNum = [NSString stringWithFormat:@"关注 %d",num];
    _concernLabel.text = concernNum;
}

/**
 *  更新粉丝数
 *
 *  @param num 粉丝总数
 */
- (void)updateFansNum:(int)num
{
    NSString *concernNum = [NSString stringWithFormat:@"粉丝 %d",num];
    _fansLabel.text = concernNum;
}

/**
 *  控制底部view显示或者隐藏
 *
 *  @param isHidden 是否是隐藏
 */
- (void)bottomShowOrHidden:(BOOL)isHidden
{
    __weak typeof(UIView) *weakBottom = _bottomView;
    [UIView animateWithDuration:0.5 animations:^{
       
        weakBottom.top = isHidden == YES ? DEVICE_HEIGHT : DEVICE_HEIGHT - 49;
        
    }];
}

/**
 *  去关注或者取消关注
 *
 *  @param sender
 */
- (void)clickToConcern:(UIButton *)sender
{
    
    __weak typeof(self)weakSelf = self;
    
    __block BOOL isZan = !sender.selected;
    
    __block typeof(UserInfo) *weakUserInfo = _currentUser;
    
    NSString *api = sender.selected ? USER_CONCERN_CANCEL : USER_CONCERN_ADD;
    
    NSString *url = [NSString stringWithFormat:@"%@&friend_uid=%@&authcode=%@",api,self.userId,[GMAPI getAuthkey]];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        sender.selected = isZan;
        
        int fansNum = [weakUserInfo.fans_num intValue];
        
        weakUserInfo.fans_num = [NSString stringWithFormat:@"%d",isZan ? fansNum + 1 : fansNum - 1];
        
        [weakSelf updateFansNum:[weakUserInfo.fans_num intValue]];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [GMAPI showAutoHiddenMBProgressWithText:failDic[RESULT_INFO] addToView:weakSelf.view];
        if ([failDic[RESULT_CODE] intValue] == -11) {
            
            [LTools showMBProgressWithText:failDic[RESULT_INFO] addToView:weakSelf.view];
        }
    }];

}

- (void)clickToChat:(UIButton *)sender
{
    //聊天
    [MiddleTools chatWithUserId:self.userId userName:_currentUser.user_name forViewController:self lastNavigationHidden:YES];
}

-(void)gGoBackVc{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  给headview赋值
 *
 *  @param userInfo 当前用户信息model
 */
- (void)setViewsWithUserInfo:(UserInfo *)userInfo
{
    _currentUser = userInfo;
    
    //banner背景图
    
//    [_userBannerImv sd_setImageWithURL:[NSURL URLWithString:userInfo.user_banner] placeholderImage:DEFAULT_BANNER_IMAGE];
    
    [_upUserInfoView.imageView sd_setImageWithURL:[NSURL URLWithString:userInfo.user_banner] placeholderImage:DEFAULT_BANNER_IMAGE completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            _upUserInfoView.headerImage = image;

        }else
        {
            _upUserInfoView.headerImage = DEFAULT_BANNER_IMAGE;
        }
    }];
    
    //用户头像
    
    [_userFaceImv sd_setImageWithURL:[NSURL URLWithString:userInfo.photo] placeholderImage:DEFAULT_HEADIMAGE];
    
    //用户名
    
    _userNameLabel.text = userInfo.user_name;

    //创建底部工具
    
    //是自己的时候不需要
    
    if (![self.userId isEqualToString:[GMAPI getUid]] && self.userId.length > 0) {
        
        [self create_bottomView];

    }
    
    [self updateConcernNum:[userInfo.attend_num intValue]];//更新关注数
    [self updateFansNum:[userInfo.fans_num intValue]];//更新粉丝数
}

#pragma - mark 创建视图

- (void)create_bottomView
{
    if (_bottomView) {
        
        return;
    }
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 49, DEVICE_WIDTH, 49)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    //上横线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, -0.5, DEVICE_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_bottomView addSubview:line];
    
    //中间竖线
    UIView *lineMiddle = [[UIView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH/2.f - 0.5, 5 + 5 + 5, 0.5, _bottomView.height - 30)];
    lineMiddle.backgroundColor = [UIColor lightGrayColor];
    [_bottomView addSubview:lineMiddle];
    
    //关注按钮
    _concernButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_concernButton setFrame:CGRectMake(0, 0, DEVICE_WIDTH /2.f - 0.5, _bottomView.height)];
    [_concernButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_concernButton addTarget:self action:@selector(clickToConcern:) forControlEvents:UIControlEventTouchUpInside];
    [_concernButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_concernButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    [_concernButton setTitle:@"已关注" forState:UIControlStateSelected];

    [_concernButton setTitleColor:RGBCOLOR(226, 102, 127) forState:UIControlStateNormal];
    [_concernButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    [_bottomView addSubview:_concernButton];
    
    //0 互相未关注 1关注了别人 2别人关注你 3互相关注
    
    if (_currentUser.relation == 1 || _currentUser.relation == 3) {
        
        _concernButton.selected = YES;

    }else
    {
        _concernButton.selected = NO;
    }
    
    
    //关注按钮
    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [chatButton setFrame:CGRectMake(lineMiddle.right, 0, DEVICE_WIDTH /2.f - 0.5, _bottomView.height)];
    [chatButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [chatButton addTarget:self action:@selector(clickToChat:) forControlEvents:UIControlEventTouchUpInside];
    [chatButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [chatButton setTitle:@"私聊" forState:UIControlStateNormal];
    [chatButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_bottomView addSubview:chatButton];
}


///初始化头部的view
-(UIView *)headView{
    
    //整个view
    
    _upUserInfoView = [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(DEVICE_WIDTH, 150 +25)];
    _upUserInfoView.headerImage = DEFAULT_BANNER_IMAGE;
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 15, 30, 50)];
    [backBtn setFrame:CGRectMake(0, 0, 80, 80)];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
    [backBtn addTarget:self action:@selector(gGoBackVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    //刷新loading
    
    _refreshLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _refreshLoading.backgroundColor = [UIColor clearColor];
    _refreshLoading.hidesWhenStopped = YES;
    _refreshLoading.frame = CGRectMake(DEVICE_WIDTH - 30 - 24,50, 24, 24);
    [self.view addSubview:_refreshLoading];
    
    _refreshLoading.center = CGPointMake(_refreshLoading.center.x, backBtn.center.y);
    
    
    //头像
    _userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_WIDTH-60)*0.5, 30, 60, 60)];
    _userFaceImv.backgroundColor = RGBCOLOR_ONE;
    _userFaceImv.layer.cornerRadius = 30;
    _userFaceImv.layer.borderWidth = 1;
    _userFaceImv.layer.borderColor = [[UIColor whiteColor]CGColor];
    _userFaceImv.layer.masksToBounds = YES;
    _userFaceImv.image = DEFAULT_HEADIMAGE;
    [_upUserInfoView addSubview:_userFaceImv];
    
    //用户名
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(_userFaceImv.frame)+5, DEVICE_WIDTH, 20)];
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.font = [UIFont systemFontOfSize:14];
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    [_upUserInfoView addSubview:_userNameLabel];
    
    
    
    
    
    
    
    //关注 | 粉丝
    UIView *concernBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _userNameLabel.bottom, DEVICE_WIDTH, 150 - _userNameLabel.bottom)];
    concernBackView.backgroundColor = [UIColor clearColor];
    [_upUserInfoView addSubview:concernBackView];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH/2.f - 0.5, 5 + 5, 1, concernBackView.height - 20)];
    line.backgroundColor = [UIColor whiteColor];
    [concernBackView addSubview:line];
    
    //关注的数字
    
    NSString *concernNum = [NSString stringWithFormat:@"关注 %d",0];
    _concernLabel = [LTools createLabelFrame:CGRectMake(line.left - 100 - 10, 0, 100, concernBackView.height) title:concernNum font:14 align:NSTextAlignmentRight textColor:[UIColor whiteColor]];
    [concernBackView addSubview:_concernLabel];
    [_concernLabel addTaget:self action:@selector(clickToConcernList:) tag:0];
    
    //粉丝的数字
    concernNum = [NSString stringWithFormat:@"粉丝 %d",0];
    _fansLabel = [LTools createLabelFrame:CGRectMake(line.right + 10, 0, 100, concernBackView.height) title:concernNum font:14 align:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
    [concernBackView addSubview:_fansLabel];
    [_fansLabel addTaget:self action:@selector(clickToFansList) tag:0];
    
    
//    //编辑T台
//    UILabel *editTtai = [LTools createLabelFrame:CGRectMake(concernBackView.frame.size.width - 50, 0, 40, concernBackView.frame.size.height) title:@"编辑" font:14 align:NSTextAlignmentCenter textColor:[UIColor whiteColor]];
//    [concernBackView addSubview:editTtai];
//    [editTtai addTaget:self action:@selector(editMyTtai) tag:0];
    
    
    //整个view
    _ttaiView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, DEVICE_WIDTH, 25)];
    _ttaiView.backgroundColor = RGBCOLOR(235, 235, 235);
    [_upUserInfoView addSubview:_ttaiView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 2, 25)];
    lineView.backgroundColor = RGBCOLOR(239, 47, 48);
    lineView.layer.cornerRadius = 3;
    [_ttaiView addSubview:lineView];
    
    UILabel *titaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineView.frame.size.width+lineView.frame.origin.x+5, 0,150,25)];
    titaiLabel.font = [UIFont systemFontOfSize:15];
    titaiLabel.backgroundColor = [UIColor clearColor];
    titaiLabel.textAlignment = NSTextAlignmentLeft;
    titaiLabel.text = @"我的T台";
    [_ttaiView addSubview:titaiLabel];
    
    return _upUserInfoView;
    
}

////编辑T台
//-(void)editMyTtai{
//    GEditMyTtaiViewController *ccc = [[GEditMyTtaiViewController alloc]init];
//    ccc.lastPageNavigationHidden = YES;
//    [self.navigationController pushViewController:ccc animated:YES];
//    
//    
//}

//初始化瀑布流
-(void)creatWaterFlowView{
    
    //瀑布流相关
    _waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) waterDelegate:self waterDataSource:self noHeadeRefresh:YES noFooterRefresh:NO];
    _waterFlow.backgroundColor = RGBCOLOR(235, 235, 235);
    [self.view addSubview:_waterFlow];
    
    _waterFlow.headerView = [self headView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - _waterFlowDelegate

- (void)waterScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    NSLog(@"waterScrollViewDidEndDragging1");

    
    if (_waterFlow.isReloadData && _waterFlow.reloading == NO) {
        
        _waterFlow.pageNum = 1;
        [self waterLoadNewData];
        
        NSLog(@"waterScrollViewDidEndDragging1");

    }
    
}


- (void)waterScrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView %f",scrollView.contentOffset.y);
    
    //头部下拉动画
    
    [(ParallaxHeaderView *)_waterFlow.headerView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    
    //控制底部工具条的显示状态
    
    CGFloat currentOffset = scrollView.contentOffset.y;
    
    CGFloat dis = scrollView.contentSize.height - DEVICE_HEIGHT; //控制滑动到底部时 bottom隐藏
    
    
    CGFloat contentHeight = _waterFlow.quitView.contentSize.height;//waterFlow contentSize高度
    CGFloat frameHeight = _waterFlow.quitView.frame.size.height;//waterFlow frame的高度
    
    //条件一:只有当content高度大于frame高度时需要隐藏底部
    //条件二:判断上拉还是下拉
    //条件三:判断是否滑到了最底部
    if (contentHeight > frameHeight && ( (currentOffset > 20 && currentOffset > _lastOffsetY) || currentOffset - dis >= 0)) {
        
        [self bottomShowOrHidden:YES];
    }else
    {
        [self bottomShowOrHidden:NO];
    }
    
    //加载数据菊花 偏移量<-85 并且是下拉
    if (scrollView.contentOffset.y < -80 && currentOffset < _lastOffsetY) {
        

        _waterFlow.isReloadData = YES;
        [_refreshLoading startAnimating];
    }
    
    _lastOffsetY = currentOffset;
}

- (void)waterLoadNewData
{
    [self getUserTPlat];
    
    [self getUserInfo];
}
- (void)waterLoadMoreData
{
    [self getUserTPlat];
    
    [self getUserInfo];

}

//点击方法
- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPlatModel *model = (TPlatModel *)_waterFlow.dataArray[indexPath.row];
    
    TTaiDetailController *t_detail = [[TTaiDetailController alloc]init];
    t_detail.tt_id = model.tt_id;
    
    t_detail.lastPageNavigationHidden = YES;
    [self.navigationController pushViewController:t_detail animated:YES];
    
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    TPlatModel *aModel = _waterFlow.dataArray[indexPath.row];
    CGFloat image_height = [aModel.image[@"height"]floatValue];
    CGFloat image_width = [aModel.image[@"width"]floatValue];
    
    if (image_width == 0.0) {
        image_width = image_height;
    }
    float rate = image_height/image_width;
    
    return (DEVICE_WIDTH-30)/2.0*rate + 55 + 36;
}
- (CGFloat)waterViewNumberOfColumns
{
    
    return 2;
}

#pragma mark - TMQuiltViewDataSource

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [_waterFlow.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TPlatCell *cell = (TPlatCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"TPlatCell"];
    if (!cell) {
        cell = [[TPlatCell alloc] initWithReuseIdentifier:@"TPlatCell"];
    }
    
    cell.layer.cornerRadius = 3.f;
    
    
    TPlatModel *aMode = _waterFlow.dataArray[indexPath.row];
    [cell setCellWithModel:aMode];
    
    cell.like_btn.tag = 100 + indexPath.row;
    
    return cell;
}


@end
