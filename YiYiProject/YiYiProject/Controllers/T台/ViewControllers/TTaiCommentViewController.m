//
//  TTaiCommentViewController.m
//  YiYiProject
//
//  Created by lichaowei on 15/4/21.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "TTaiCommentViewController.h"
#import "TDetailModel.h"
#import "RefreshTableView.h"

#import "LShareSheetView.h"

#import "CustomInputView.h"
#import "TopicCommentsModel.h"

#import "GStorePinpaiViewController.h"

#import "TCommentHeadCell.h"//头部cell
//#import "TCommentCell.h"//评论新版cell
#import "TPlatCommentCell.h"

#import "ZanUserModel.h"//赞人员model

@interface TTaiCommentViewController ()<RefreshDelegate,UITableViewDataSource>
{
    TDetailModel *detail_model;
    RefreshTableView *_table;
    UILabel *comment_label;//评论
    UIButton *zan_btn;//赞
    UILabel *zhuan_num_label;//转发
    UILabel *zan_num_label;//赞 个数
    UILabel *comment_num_label;//底部评论个数
    MBProgressHUD *loading;
    
    UIImageView *bigImageView;
    
    NSArray *_zanListArray;//赞人员列表
    int _zanTotalNum;//赞人员总数
    
    TCommentHeadCell *_headCell;
    
    BOOL needRefreshZan;//是否刷新赞
}

///评论界面
@property(nonatomic,strong)CustomInputView * input_view;
///评论数据
@property(nonatomic,strong)NSMutableArray * comments_array;
///回复的回复的id
@property(nonatomic,strong)NSString * r_reply_uid;
///回复回复的昵称
@property(nonatomic,strong)NSString * r_reply_userName;
///如果是二级回复，那么我就存放主评论的id
@property(nonatomic,strong)NSString * parent_post;

@end

@implementation TTaiCommentViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_input_view addKeyBordNotification];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    if (needRefreshZan) {
        
        [self getZanList];
        
        needRefreshZan = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_input_view deleteKeyBordNotification];
    
    [self.navigationController setNavigationBarHidden:self.lastPageNavigationHidden animated:animated];
}


- (void)dealloc
{
    NSLog(@"---->%@",NSStringFromClass([self class]));
    _table.refreshDelegate = nil;
    _table.dataSource = nil;
    _table = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myTitleLabel.text = _commentType == COMMENTTYPE_TPlat ? @"T台评论" : @"单品评论";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    _comments_array = [NSMutableArray array];
    
    //头部赞人员
    
    NSString *content = nil;
    id amodel = nil;
    if (_commentType == COMMENTTYPE_TPlat) {
        
        content = self.t_model.tt_content;
        amodel = self.t_model;
        
    }else if(_commentType == COMMENTTYPE_Product)
    {
        content = self.aProduct.product_name;
        amodel = self.aProduct;
    }
    
    CGFloat height = [TCommentHeadCell cellHeightForString:content];

    NSString *identify = @"TCommentHeadCell";
    _headCell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
    _headCell.frame = CGRectMake(0, 0, DEVICE_WIDTH, height);
    
    [_headCell setCellWithModel:amodel];
    [_headCell.zanUserView addTaget:self action:@selector(clickToZanList:) tag:0];
    [self.view addSubview:_headCell];
    
    [self reloadZanUsers];
    
    //店铺
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, _headCell.bottom, DEVICE_WIDTH,DEVICE_HEIGHT-64 - height)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    _table.backgroundColor = [UIColor clearColor];
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    loading = [LTools MBProgressWithText:@"加载..." addToView:self.view];
    
    [self createToolsView];//创建底部工具
    
    [self getZanList];//赞列表

    [self getTTaiComments];//评论
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshZanlist) name:@"zanList" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理

/**
 *  需要更新的时候重新获取赞列表
 */
- (void)refreshZanlist
{
    needRefreshZan = YES;
}

- (void)reloadZanUsers
{
    [_headCell addZanList:_zanListArray total:_zanTotalNum];
}

/**
 *  跳转至赞列表
 *
 *  @param sender
 */
- (void)clickToZanList:(UIButton *)sender
{
    
    needRefreshZan = YES;
    
    if (_commentType == COMMENTTYPE_Product) {
        
        [MiddleTools pushToUserListWithObjectId:_aProduct.product_id listType:User_ProductZanList forViewController:self lastNavigationHidden:NO hiddenBottom:NO updateParmsBlock:^(NSDictionary *params) {
            
            
        }];
        
        return;
    }
    
    [MiddleTools pushToZanListWithModel:self.t_model forViewController:self lastNavigationHidden:NO updateParmsBlock:^(NSDictionary *params) {
        
        if (_aParmasBlock) {
            _aParmasBlock(params);
        }
    }];
}

- (void)updateCommentNum:(int)commentNum
{
    
    comment_label.text = NSStringFromInt(commentNum);
    comment_num_label.text = NSStringFromInt(commentNum);
    
    if (_aParmasBlock) {
        
        //更新评论
        _aParmasBlock(@{UPDATE_PARAM:UPDATE_TPLAT_COMENTNUM,
                        UPDATE_TPLAT_COMENTNUM:[NSNumber numberWithInt:commentNum]});
    }
}

-(void)leftButtonTap:(UIButton *)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    if (_commentType == COMMENTTYPE_TPlat) {
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.7f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"oglFlip";
        transition.subtype = kCATransitionFromLeft;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setViewWithModel:(TDetailModel *)aModel
{
    zan_num_label.text = aModel.tt_like_num;
    zhuan_num_label.text = aModel.tt_share_num;
    comment_label.text = aModel.tt_comment_num;
    comment_num_label.text = aModel.tt_comment_num;
    
    zan_btn.selected = aModel.is_like == 1 ? YES : NO;
}

- (void)clickToZan:(UIButton *)sender
{
    if ([LTools isLogin:self]) {
        
        [LTools animationToBigger:sender duration:0.2 scacle:1.5];
        
        sender.selected = !sender.selected;
        [self zanTTaiDetail:sender.selected];
    }
}

/**
 *  直接对T台进行评论
 */
- (void)clickToComment:(UIButton *)sender
{
    [self addCommentParentId:@"0" reply_uid:@"0" replyName:@"0"];
}

/**
 *  添加评论
 *
 *  @param parentId  上一级id,如果直接评论主题,则为 0
 *  @param reply_uid 评论的评论人id,评论主题时为空
 *  @param replyName 评论的评论人name,评论主题时为空
 */
- (void)addCommentParentId:(NSString *)parentId
                 reply_uid:(NSString *)reply_uid
                 replyName:(NSString *)replyName
{
    //评论
    self.parent_post = parentId;
    self.r_reply_uid = reply_uid;
    self.r_reply_userName = replyName;

    _input_view.text_input_view.text = [parentId isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"回复%@:",replyName];
    
    [self beiginComment];
}

/**
 *  弹出评论框
 */
- (void)beiginComment
{
    if ([LTools isLogin:self]) {
        [_input_view showInputView:nil];
    }
}

#pragma mark - 网络请求

/**
 *  获取赞人员列表
 */
- (void)getZanList
{
    __weak typeof(self)weakSelf = self;
    
    NSString *api = nil;
    
    if (_commentType == COMMENTTYPE_TPlat) {
        
        api = [NSString stringWithFormat:TPLat_ZanList,self.t_model.tt_id];
        
    }else if (_commentType == COMMENTTYPE_Product){
        
        api = [NSString stringWithFormat:PRODUCT_ZAN_LIST,self.aProduct.product_id];

    }
    
    NSString *url = [NSString stringWithFormat:@"%@&authcode=%@&page=%d&per_page=%d",api,[GMAPI getAuthkey],_table.pageNum,L_PAGE_SIZE];
    
    NSLog(@"%@",url);
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSArray *list = [result objectForKey:@"list"];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:list.count];
        for (NSDictionary *aDic in list) {
            
            ZanUserModel *zan = [[ZanUserModel alloc]initWithDictionary:aDic];
            [temp addObject:zan];
            
        }
        
        _zanListArray = [NSArray arrayWithArray:temp];
        
        _zanTotalNum = [[result objectForKey:@"total_num"]intValue];
        
        [weakSelf reloadZanUsers];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"获取赞列表failDic %@",failDic);
        
    }];
}

///T台评论
-(void)getTTaiComments
{

    NSString * url = nil;
    if (_commentType == COMMENTTYPE_TPlat) {
        
        url = [NSString stringWithFormat:TTAI_COMMENTS_URL,_table.pageNum,_tt_id];
    }else if (_commentType == COMMENTTYPE_Product){
        
        url = [NSString stringWithFormat:PRODUCT_COMMENT_LIST,_tt_id];
        url = [NSString stringWithFormat:@"%@&page=%d&per_page=%d",url,1,10];

    }

    NSLog(@"请求评论接口 --  %@",url);
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(RefreshTableView) *weakTable = _table;
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"请求t台评论数据 ---  %@",result);
        
        int total = [[result objectForKey:@"total"] intValue];
        NSArray * commentsArray = [result objectForKey:@"list"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:commentsArray.count];
        
        for (NSDictionary * dic in commentsArray)
        {
            TopicCommentsModel * model = [[TopicCommentsModel alloc] initWithDictionary:dic];
            model.reply_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"post_id"]];
            model.repost_uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
            //            [bself.comments_array addObject:model];
            [arr addObject:model];
        }
        //        [_table finishReloadigData];
        
        int sum = (int)(arr.count + _table.dataArray.count);
        
        BOOL haveMore = NO;
        if (sum < total) {
            haveMore = YES;
        }
        
        [weakSelf updateCommentNum:total];//更新评论
        
        [weakTable reloadData:arr isHaveMore:haveMore];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
    }];
}

#pragma mark - 话题评论

/**
 *  评论的网络请求
 *
 *  @param r_replyId 对谁进行评论,为0时代表主题,不为0代表具体的评论
 */
-(void)commentNetworkWithParenetPostId:(NSString *)r_replyId
{
    NSString *content = _input_view.text_input_view.text;
    
    NSString *post = nil;
    NSData *postData = nil;
    NSString *url = nil;

    if (_commentType == COMMENTTYPE_TPlat) {
        
        url = [NSString stringWithFormat:TTAI_COMMENT];
        
        post = [NSString stringWithFormat:@"authcode=%@&tt_id=%@&parent_post=%@&content=%@",[GMAPI getAuthkey],self.tt_id,r_replyId,content];
        
    }else if (_commentType == COMMENTTYPE_Product){
        
        url = [NSString stringWithFormat:PRODUCT_COMMENT_ADD];
        post = [NSString stringWithFormat:@"authcode=%@&product_id=%@&parent_post=%@&content=%@",[GMAPI getAuthkey],self.tt_id,r_replyId,content];

    }
    
    postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];

    __weak typeof(_table)weakTable = _table;
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    
    __weak typeof(self)bself = self;
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        [LTools showMBProgressWithText:result[RESULT_INFO] addToView:bself.view];
        
        weakTable.pageNum = 1;
        weakTable.isReloadData = YES;
        [bself getTTaiComments];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
}


//T台详情

- (void)getTTaiDetail
{
    
    [loading show:YES];
    
    __weak typeof(self)weakSelf = self;
    
    NSString *url = nil;
    
    if (_commentType == COMMENTTYPE_TPlat) {
        
        url = [NSString stringWithFormat:TTAI_DETAIL,self.tt_id,[GMAPI getAuthkey]];
        
    }else if (_commentType == COMMENTTYPE_Product){
        
        url = [NSString stringWithFormat:HOME_PRODUCT_DETAIL,self.tt_id,[GMAPI getAuthkey]];
    }
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [loading hide:YES];
        
        detail_model = [[TDetailModel alloc]initWithDictionary:result];
        
        [weakSelf createViewsWithModel:detail_model];
        
        [weakSelf setViewWithModel:detail_model];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
        [loading hide:YES];
        
    }];
}

//T台赞 或 取消

- (void)zanTTaiDetail:(BOOL)zan
{
    NSString *authkey = [GMAPI getAuthkey];
    NSString *post = [NSString stringWithFormat:@"tt_id=%@&authcode=%@",self.tt_id,authkey];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url;
    
    if (zan) {
        url = TTAI_ZAN;
    }else
    {
        url = TTAI_ZAN_CANCEL;
    }
    
    __weak typeof(self)weakSelf = self;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        zan_btn.selected = zan;
        
        int like_num = [detail_model.tt_like_num intValue];
        detail_model.tt_like_num = [NSString stringWithFormat:@"%d",zan ? like_num + 1 : like_num - 1];
        zan_num_label.text = detail_model.tt_like_num;
        
        weakSelf.t_model.tt_like_num = detail_model.tt_like_num;//喜欢个数更新
        weakSelf.t_model.is_like = zan ? 1 : 0;
        
        //更新赞的数字
        if (_aParmasBlock) {
            
            _aParmasBlock(@{UPDATE_PARAM:@"UpdateLike",
                            UPDATE_TPLAT_LIKENUM:[LTools safeString:weakSelf.t_model.tt_like_num],
                                         UPDATE_TPLAT_ISLIKE:[NSNumber numberWithBool:zan]});
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
}

#pragma mark - 创建视图

- (void)createheaderView
{
    NSString *identify = @"TCommentHeadCell";
    TCommentHeadCell *headCell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
    
    [headCell setCellWithModel:self.t_model];
    
//    [headCell addZanList:_zanListArray total:_zanTotalNum];
    
    [headCell.zanUserView addTaget:self action:@selector(clickToZanList:) tag:0];
    
//    _table.tableHeaderView = headCell;
}

/**
 *  底部工具条
 */
- (void)createToolsView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 64 - 40 - 16, DEVICE_WIDTH, 40 + 16)];
//    view.backgroundColor = [UIColor colorWithHexString:@"252525"];
//    view.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];

    [self.view addSubview:view];
    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, -1, DEVICE_WIDTH, 1)];
//    line.backgroundColor = [UIColor colorWithHexString:@"dcdcdc"];
//    [view addSubview:line];
    
    UIButton *comment = [LTools createButtonWithType:UIButtonTypeRoundedRect frame:CGRectMake(10, 5 + 8, view.width - 20  - 70, 30) normalTitle:@"  我也说一句..." image:nil backgroudImage:nil superView:nil target:self action:@selector(clickToComment:)];
    [view addSubview:comment];
    comment.backgroundColor = [UIColor clearColor];
    [comment addCornerRadius:5.f];
    comment.layer.borderColor = [UIColor whiteColor].CGColor;
    comment.layer.borderWidth = 0.5f;
    [comment.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [comment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comment setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    UIButton *send_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    send_button.frame = CGRectMake(DEVICE_WIDTH - 80 + 10,comment.top,60,30);
    
    [send_button setTitle:@"发送" forState:UIControlStateNormal];
    
    [send_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    send_button.backgroundColor = RGBCOLOR(213,77,125);
    
    send_button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [send_button addTarget:self action:@selector(clickToComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [send_button addCornerRadius:5.f];
    
    [view addSubview:send_button];
    
    __weak typeof(self)weakSelf = self;
    
    _input_view = [[CustomInputView alloc] initWithFrame:CGRectMake(0,DEVICE_HEIGHT,DEVICE_WIDTH,44)];
    
    _input_view.userInteractionEnabled = NO;
    
    [_input_view loadAllViewWithPinglunCount:@"0" WithType:0 WithPushBlock:^(int type){
        
        if (type == 0)
        {
            NSLog(@"跳到评论");
            
        }else
        {
            NSLog(@"分类按钮");
        }
        
    } WithSendBlock:^(NSString *content, BOOL isForward) {
        
        NSLog(@"发表评论 ---  %@",[GMAPI getAuthkey]);
        
        [weakSelf commentNetworkWithParenetPostId:weakSelf.parent_post];
    }];
    
    [self.view addSubview:_input_view];
    
}

- (void)createViewsWithModel:(TDetailModel *)aModel
{
    UIView *head_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
    
    
    NSString *iconUrl = @"";
    NSString *userName = @"";
    NSString *desString = @"";//描述
    NSString *addtime = @"";
    
    if(_commentType == COMMENTTYPE_TPlat){
        
        TPlatModel *model = (TPlatModel *)aModel;
        desString = model.tt_content;//描述
        addtime = model.add_time;
        if ([model.uinfo isKindOfClass:[NSDictionary class]]) {
            
            iconUrl = model.uinfo[@"photo"];
            userName = model.uinfo[@"user_name"];
        }
        
    }else if (_commentType == COMMENTTYPE_Product)
    {
        
        ProductModel *model = (ProductModel *)aModel;
        desString = model.product_name;
        addtime = model.product_add_time;
        
        if ([model.brand_info isKindOfClass:[NSDictionary class]]) {
            
            iconUrl = model.brand_info[@"brand_logo"];
            userName = model.brand_info[@"brand_name"];
        }
    }
    
    //头像
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 50, 50)];
    iconView.layer.cornerRadius = 25.f;
    iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconView.layer.borderWidth = 1.f;
    iconView.clipsToBounds = YES;
    [head_view addSubview:iconView];
    [iconView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:DEFAULT_HEADIMAGE];
    
    //名称 375 240
    
    UIColor *textColor1 = [UIColor colorWithHexString:@"333333"];//深色
    UIColor *textColor2 = [UIColor colorWithHexString:@"8c8c8c"];//浅色
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconView.right + 12, iconView.top, DEVICE_WIDTH - 135, 13)];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.text = userName;
    nameLabel.textColor = textColor1;
    [head_view addSubview:nameLabel];
    
    //时间
    
    NSString *time = aModel.add_time;
    time = [LTools timechange:time];
    CGFloat aWidth = [LTools widthForText:time font:10];
    
    UILabel *timeLabel = [LTools createLabelFrame:CGRectMake(nameLabel.left, iconView.bottom - 10, aWidth, 10) title:time font:10 align:NSTextAlignmentLeft textColor:textColor2];
    [head_view addSubview:timeLabel];
    
    //t台描述
    
    NSString *descriptionString = aModel.tt_content;
    
    aWidth = DEVICE_WIDTH - 12 - timeLabel.left;//描述label宽度
    
    CGFloat aHeight = [LTools heightForText:descriptionString width:aWidth font:14];
   
    UILabel *descriptionLabel = [LTools createLabelFrame:CGRectMake(timeLabel.left, timeLabel.bottom + 10, aWidth, aHeight) title:descriptionString font:14 align:NSTextAlignmentLeft textColor:textColor1];
    [head_view addSubview:descriptionLabel];
    
    //工具条 赞 和 评论
    
    UIView *toolsView = [[UIView alloc]initWithFrame:CGRectMake(0, descriptionLabel.bottom + 10, DEVICE_WIDTH, 25)];
    toolsView.backgroundColor = [UIColor orangeColor];
    [head_view addSubview:toolsView];
    
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(10, iconView.bottom + 10, DEVICE_WIDTH - 10 * 2, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [head_view addSubview:line];
    
    head_view.height = line.bottom;
    _table.tableHeaderView = head_view;
}


#pragma mark - 代理

#pragma - mark RefreshDelegate

- (void)loadNewData
{
//    [self getTTaiDetail];
    
    [self getZanList];
    [self getTTaiComments];
}
- (void)loadMoreData
{
    [self getZanList];
    [self getTTaiComments];
}

//新加
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if (indexPath.row == 0) {
        return;
    }
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    TopicCommentsModel * model = [_table.dataArray objectAtIndex:indexPath.row];
    
//    /数字一次代表距离顶部距离、头像高度、内容离头像距离、底部距离、评论的回复高度
    return [TPlatCommentCell heightForCellWithModel:model];
    
}

#pragma - mark UItableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"TPlatCommentCell";
    
    TPlatCommentCell * cell = (TPlatCommentCell *)[LTools cellForIdentify:@"llll" cellName:identifier forTable:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TopicCommentsModel * model = [_table.dataArray objectAtIndex:indexPath.row];
    
    [cell setInfoWithCommentsModel:model];
    
    __weak typeof(self)bself = self;
    [cell setTopicCommentsCellBlock:^(TPlatCommentCellClickType aType, NSString *userName, NSString *uid, NSString *reply_id) {
        
        if (aType == TPlatCommentCellClickType_UserCenter) {
            
            //调到个人主页
            
            NSLog(@"个人主页");
            
            [MiddleTools pushToPersonalId:uid forViewController:self lastNavigationHidden:NO updateParmsBlock:^(NSDictionary *params) {
                
            }];
            
        }else if(aType == TPlatCommentCellClickType_Comment){

            
            [bself addCommentParentId:reply_id reply_uid:uid replyName:userName];
            
            NSLog(@"进行评论 userName %@",userName);

        }
        
    }];
    
    [cell.second_view setSeconForwardViewBlock:^(TPlatCommentCellClickType aType, NSString *userName, NSString *uid, NSString *reply_id) {
        
        if (aType == TPlatCommentCellClickType_UserCenter) {
            
            //调到个人主页
            
            NSLog(@"个人主页");
            
            [MiddleTools pushToPersonalId:uid forViewController:self lastNavigationHidden:NO updateParmsBlock:^(NSDictionary *params) {
                
            }];
            
        }else if(aType == TPlatCommentCellClickType_Comment){
            
            
            [bself addCommentParentId:reply_id reply_uid:uid replyName:userName];
            
            NSLog(@"进行评论 userName %@",userName);
            
        }
        
    }];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count;
}

@end
