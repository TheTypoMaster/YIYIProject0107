//
//  TTaiDetailController.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/6.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "TTaiDetailController.h"
#import "TDetailModel.h"
#import "RefreshTableView.h"

#import "LShareSheetView.h"

#import "CustomInputView.h"
#import "TopicCommentsModel.h"
#import "TopicCommentsCell.h"
@interface TTaiDetailController ()<RefreshDelegate,UITableViewDataSource>
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

@implementation TTaiDetailController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_input_view addKeyBordNotification];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_input_view deleteKeyBordNotification];
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
    self.view.backgroundColor = RGBCOLOR(246, 246, 246);
    
    self.myTitleLabel.text = @"T台详情";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    _comments_array = [NSMutableArray array];
    
    //店铺
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,DEVICE_HEIGHT-64-50)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorInset = UIEdgeInsetsMake(0,15,0,0);
    loading = [LTools MBProgressWithText:@"加载..." addToView:self.view];
    
    [self getTTaiDetail];
    [self getTTaiComments];
    [self createToolsView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理

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
        sender.selected = !sender.selected;
        [self zanTTaiDetail:sender.selected];
    }
}

- (void)clickToComment:(UIButton *)sender
{
    if ([LTools isLogin:self]) {
        [_input_view showInputView:nil];
    }
}

- (void)clickToZhuanFa:(UIButton *)sender
{
    [[LShareSheetView shareInstance] showShareContent:detail_model.tt_content title:@"衣加衣" shareUrl:@"http://www.alayy.com" shareImage:bigImageView.image targetViewController:self];
    [[LShareSheetView shareInstance]actionBlock:^(NSInteger buttonIndex, Share_Type shareType) {
        
        if (shareType == Share_QQ) {
            
            NSLog(@"Share_QQ");
            
        }else if (shareType == Share_QQZone){
            
            NSLog(@"Share_QQZone");
            
        }else if (shareType == Share_WeiBo){
            
            NSLog(@"Share_WeiBo");
            
        }else if (shareType == Share_WX_HaoYou){
            
            NSLog(@"Share_WX_HaoYou");
            
        }else if (shareType == Share_WX_PengYouQuan){
            
            NSLog(@"Share_WX_PengYouQuan");
            
        }
        
    }];
    
    [[LShareSheetView shareInstance]shareResult:^(Share_Result result, Share_Type type) {
        
        if (result == Share_Success) {
            
            //分享 + 1
            NSLog(@"分享成功");
            
            [self zhuanFaTTaiDetail];
            
        }else
        {
            //分享失败
            
            NSLog(@"分享失败");
        }
        
    }];
}

#pragma mark - 网络请求

///T台评论
-(void)getTTaiComments
{
    NSString * url = [NSString stringWithFormat:TTAI_COMMENTS_URL,_table.pageNum,_tt_id];
    NSLog(@"请求t台评论接口 --  %@",url);
    __weak typeof(self) bself = self;
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
        
        [_table reloadData:arr isHaveMore:haveMore];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
    }];
}

#pragma mark - 话题评论

-(void)tPlatCommentWithUserName:(NSString *)aName WithUid:(NSString *)aUid
{
    NSString *content = _input_view.text_input_view.text;
    
    NSString *post = [NSString stringWithFormat:@"authcode=%@&tt_id=%@&parent_post=%@&content=%@",[GMAPI getAuthkey],self.tt_id,_parent_post,content];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    __weak typeof(_table)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:TTAI_COMMENT];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    
    __weak typeof(self)bself = self;
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        [LTools showMBProgressWithText:result[RESULT_INFO] addToView:self.view];
        
        weakTable.pageNum = 1;
        weakTable.isReloadData = YES;
        [bself getTTaiComments];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
    }];
}


//T台详情

- (void)getTTaiDetail
{
    
    [loading show:YES];
    
    __weak typeof(self)weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:TTAI_DETAIL,self.tt_id,[GMAPI getAuthkey]];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        
        [loading hide:YES];
        
        detail_model = [[TDetailModel alloc]initWithDictionary:result];
        
        [self createViewsWithModel:detail_model];
        
        [self setViewWithModel:detail_model];
        
        
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
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        zan_btn.selected = zan;
        
        int like_num = [detail_model.tt_like_num intValue];
        detail_model.tt_like_num = [NSString stringWithFormat:@"%d",zan ? like_num + 1 : like_num - 1];
        zan_num_label.text = detail_model.tt_like_num;
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
    }];
}

// 转发 + 1

- (void)zhuanFaTTaiDetail
{
    NSString *authkey = [GMAPI getAuthkey];
    
    if (authkey.length == 0) {
        return;
    }
    
    NSString *post = [NSString stringWithFormat:@"tt_id=%@&authcode=%@",self.tt_id,authkey];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url = TTAI_ZHUANFA_ADD;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        int like_num = [detail_model.tt_share_num intValue];
        detail_model.tt_like_num = [NSString stringWithFormat:@"%d",like_num + 1];
        zhuan_num_label.text = detail_model.tt_like_num;
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
    }];
}

#pragma mark - 创建视图

/**
 *  底部工具条
 */
- (void)createToolsView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 64 - 50, DEVICE_WIDTH, 50)];
    view.backgroundColor = [UIColor colorWithHexString:@"252525"];
    [self.view addSubview:view];
    
    //喜欢
    zan_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(35, 0, 29, 50) normalTitle:nil image:[UIImage imageNamed:@"xq_love_up"] backgroudImage:nil superView:nil target:self action:@selector(clickToZan:)];
    [view addSubview:zan_btn];
    
    [zan_btn setImage:[UIImage imageNamed:@"xq_love_down"] forState:UIControlStateSelected];
    
    zan_num_label = [LTools createLabelFrame:CGRectMake(zan_btn.right + 5, 0, 50, 50) title:@"0" font:13 align:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
    [view addSubview:zan_num_label];
    
    //评论
    UIButton *comment_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(DEVICE_WIDTH/2.f - 20, 0, 26, 50) normalTitle:nil image:[UIImage imageNamed:@"xq_pinglun"] backgroudImage:nil superView:nil target:self action:@selector(clickToComment:)];
    [view addSubview:comment_btn];
    
    comment_num_label = [LTools createLabelFrame:CGRectMake(comment_btn.right + 5, 0, 50, 50) title:@"0" font:13 align:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
    [view addSubview:comment_num_label];
    
    //转发
    UIButton *zhuan_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(DEVICE_WIDTH - 85, 0, 26, 50) normalTitle:nil image:[UIImage imageNamed:@"fenxiangb"] backgroudImage:nil superView:nil target:self action:@selector(clickToZhuanFa:)];
    [view addSubview:zhuan_btn];
    
    zhuan_num_label = [LTools createLabelFrame:CGRectMake(zhuan_btn.right + 5, 0, 50, 50) title:@"0" font:13 align:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
    [view addSubview:zhuan_num_label];
    
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
        
        _parent_post = @"0";
        
        [weakSelf tPlatCommentWithUserName:weakSelf.r_reply_userName WithUid:weakSelf.r_reply_uid];
        
    }];
    
    [self.view addSubview:_input_view];
    
}

- (void)createViewsWithModel:(TDetailModel *)aModel
{
    UIView *head_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
    
    NSString *iconUrl = @"";
    NSString *userName = @"";
    if ([aModel.uinfo isKindOfClass:[NSDictionary class]]) {
        
        iconUrl = aModel.uinfo[@"photo"];
        userName = aModel.uinfo[@"user_name"];
    }
    
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 50, 50)];
    iconView.layer.cornerRadius = 25.f;
    iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconView.layer.borderWidth = 1.f;
    iconView.clipsToBounds = YES;
    [head_view addSubview:iconView];
    [iconView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:DEFAULT_HEADIMAGE];
    //名称 375 240
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconView.right + 12, 0, DEVICE_WIDTH - 135, 13)];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.text = userName;
    [head_view addSubview:nameLabel];
    nameLabel.center = CGPointMake(nameLabel.center.x, iconView.center.y);
    
    //时间
    
    NSString *time = aModel.add_time;
    time = [LTools timechange:time];
    CGFloat aWidth = [LTools widthForText:time font:10];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - 12 - aWidth, 0, aWidth, 10)];
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.text = time;
    timeLabel.textColor = [UIColor colorWithHexString:@"8c8c8c"];
    [head_view addSubview:timeLabel];
    timeLabel.center = CGPointMake(timeLabel.center.x, iconView.center.y);
    
    
    UIImageView *time_icon = [[UIImageView alloc]initWithFrame:CGRectMake(timeLabel.left - 5- 12, 0, 12, 12)];
    time_icon.image = [UIImage imageNamed:@"time_iocn"];
//    time_icon.backgroundColor = [UIColor orangeColor];
    [head_view addSubview:time_icon];
    time_icon.center = CGPointMake(time_icon.center.x, iconView.center.y);
    
    //正文
    CGFloat content_width = DEVICE_WIDTH - 10 * 2;
    CGFloat content_height = [LTools heightForText:aModel.tt_content width:content_width font:13];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, iconView.bottom + 15, content_width, content_height)];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    contentLabel.textColor = [UIColor colorWithHexString:@"9f9f9f"];
    contentLabel.textColor = [UIColor blackColor];
    [head_view addSubview:contentLabel];
    contentLabel.text = aModel.tt_content;

    //图片
    CGFloat image_height;
    CGFloat image_width;
    NSString *image_url = @"";
    
    if ([aModel.image isKindOfClass:[NSDictionary class]]) {
        
        image_height = [aModel.image[@"height"]floatValue];
        image_width = [aModel.image[@"width"]floatValue];
        image_url = aModel.image[@"url"];
    }
    image_height = image_height * (DEVICE_WIDTH - 10 * 2) / image_width;
    
    CGFloat content_top = 0.f;
    if ([LTools isEmpty:aModel.tt_content]) {
        
        content_top = contentLabel.top;
    }else
    {
        content_top = contentLabel.bottom + 15;
    }
    
    bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, content_top, DEVICE_WIDTH - 10*2, image_height)];
    [bigImageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:nil];
    [head_view addSubview:bigImageView];
    
    //======= 品牌、型号、价格 ===========
    
    NSString *brand_text = @"";
    NSString *model_text = @"";
    NSString *price_text = @"";
    
    if (aModel.tt_detail.count > 0) {
        NSDictionary *aDic = aModel.tt_detail[0];
        brand_text = [LTools NSStringNotNull:aDic[@"品牌"]];
        model_text = [LTools NSStringNotNull:aDic[@"型号"]];
        price_text = [LTools NSStringNotNull:aDic[@"价格"]];
    }
    brand_text = brand_text.length > 0 ? brand_text : @"未填写";
    model_text = model_text.length > 0 ? model_text : @"未填写";
    price_text = price_text.length > 0 ? [NSString stringWithFormat:@"%@元",price_text] : @"未填写";
    
    
    UIColor *color = [UIColor colorWithHexString:@"b9b9b9"];
    UIColor *color2 = [UIColor colorWithHexString:@"262626"];
    //品牌
    UILabel *brand = [[UILabel alloc]initWithFrame:CGRectMake(10, bigImageView.bottom + 20, 35, 15)];
    brand.font = [UIFont systemFontOfSize:15];
    brand.text = @"品牌:";
    brand.textColor = color;
    [head_view addSubview:brand];
    
    UILabel *brand_label = [[UILabel alloc]initWithFrame:CGRectMake(brand.right + 10, bigImageView.bottom + 20, 200, 15)];
    brand_label.font = [UIFont systemFontOfSize:15];
    brand_label.text = brand_text;
    brand_label.textColor = color2;
    [head_view addSubview:brand_label];
    
    //型号
    UILabel *model = [[UILabel alloc]initWithFrame:CGRectMake(10, brand.bottom + 10, 35, 15)];
    model.font = [UIFont systemFontOfSize:15];
    model.text = @"型号:";
    model.textColor = color;
    [head_view addSubview:model];
    
    UILabel *model_label = [[UILabel alloc]initWithFrame:CGRectMake(model.right + 10, model.top, 200, 15)];
    model_label.font = [UIFont systemFontOfSize:15];
    model_label.text = model_text;
    model_label.textColor = color2;
    [head_view addSubview:model_label];
    
    //价格
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(10, model.bottom + 10, 35, 15)];
    price.font = [UIFont systemFontOfSize:15];
    price.text = @"价格:";
    price.textColor = color;
    [head_view addSubview:price];
    
    UILabel *price_label = [[UILabel alloc]initWithFrame:CGRectMake(price.right + 10, price.top, 200, 15)];
    price_label.font = [UIFont systemFontOfSize:15];
    price_label.text = price_text;
    price_label.textColor = color2;
    [head_view addSubview:price_label];
    
    //评论
    
    UIImageView *comment_icon = [[UIImageView alloc]initWithFrame:CGRectMake(29, price_label.bottom+ 19, 17, 17)];
    comment_icon.image = [UIImage imageNamed:@"pinglun_icon"];
    [head_view addSubview:comment_icon];
    
    UILabel *comment = [LTools createLabelFrame:CGRectMake(comment_icon.right + 12, comment_icon.top, 34, 17) title:@"评论" font:17 align:NSTextAlignmentLeft textColor:color];
    [head_view addSubview:comment];
    
    comment_label = [LTools createLabelFrame:CGRectMake(comment.right + 10, comment.top, 100, 17) title:@"(10)" font:17 align:NSTextAlignmentLeft textColor:color];
    [head_view addSubview:comment_label];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(10, comment_icon.bottom + 10, DEVICE_WIDTH - 10 * 2, 17/2.f)];
    line.image = [UIImage imageNamed:@"zhixiangjiantou"];
    [head_view addSubview:line];
    
    head_view.height = line.bottom;
    _table.tableHeaderView = head_view;
}

#pragma mark - 代理

#pragma - mark RefreshDelegate

- (void)loadNewData
{
    [self getTTaiDetail];
    [self getTTaiComments];
}
- (void)loadMoreData
{
    [self getTTaiDetail];
    [self getTTaiComments];
}

//新加
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    TopicCommentsModel * model = [_table.dataArray objectAtIndex:indexPath.row];
    _parent_post = model.reply_id;
    _r_reply_uid = model.repost_uid;
    _r_reply_userName = model.user_name;
    
    _input_view.text_input_view.text = [NSString stringWithFormat:@"回复 %@:",model.user_name];
    
    [self clickToComment:nil];
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    TopicCommentsModel * model = [_table.dataArray objectAtIndex:indexPath.row];
    NSString * content_string = model.repost_content;
    
    CGFloat string_height = [LTools heightForText:content_string width:DEVICE_WIDTH-60-12 font:14];
    
    
    SecondForwardView * _second_view = [[SecondForwardView alloc] initWithFrame:CGRectMake(60,string_height+46,DEVICE_WIDTH-60-12,0)];
    CGFloat second_height = [_second_view setupWithArray:model.child_array] + 10;
    
    
    ///数字一次代表距离顶部距离、头像高度、内容离头像距离、底部距离、评论的回复高度
    return string_height + 12 + 36 + 10 + 12 + second_height;

}

#pragma - mark UItableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    TopicCommentsCell * cell = (TopicCommentsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopicCommentsCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    
    TopicCommentsModel * model = [_table.dataArray objectAtIndex:indexPath.row];
    
    [cell setInfoWithCommentsModel:model];
    
    __weak typeof(self)bself = self;
    [cell setTopicCommentsCellBlock:^(TopicCommentsCellClickType aType, NSString *userName, NSString *uid, NSString *reply_id) {
        bself.parent_post = reply_id;
        bself.r_reply_uid = uid;
        bself.r_reply_userName = userName;
        
        _input_view.text_input_view.text = [NSString stringWithFormat:@"回复 %@:",userName];
        [bself clickToComment:nil];
        
        NSLog(@"userName %@",userName);
    }];
    [cell.second_view setSeconForwardViewBlock:^(TopicCommentsCellClickType aType, NSString *userName, NSString *uid, NSString *reply_id) {
        bself.parent_post = reply_id;
        bself.r_reply_uid = uid;
        bself.r_reply_userName = userName;
        _input_view.text_input_view.text = [NSString stringWithFormat:@"回复 %@:",userName];
        [bself clickToComment:nil];
        NSLog(@"userName2 %@",userName);
    }];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count;
}

@end
