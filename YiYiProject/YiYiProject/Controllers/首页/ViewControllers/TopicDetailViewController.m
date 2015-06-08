//
//  TopicDetailViewController.m
//  YiYiProject
//
//  Created by soulnear on 14-12-27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "SNRefreshTableView.h"
#import "MatchTopicModel.h"
#import "TopicCommentsModel.h"
#import "TopicCommentsCell.h"
#import "TopicDetailBottomView.h"
#import "TopicModel.h"
#import "CustomInputView.h"

#import "TopicParseModel.h"

@interface TopicDetailViewController ()<UITableViewDataSource,SNRefreshDelegate>
{
    ///底部view
    TopicDetailBottomView * bottom_view;
    
    MBProgressHUD *loading;
}


@property(nonatomic,strong)SNRefreshTableView * myTableView;
///评论数据容器
@property(nonatomic,strong)NSMutableArray * array_comments;
///话题详情数据
@property(nonatomic,strong)TopicModel * topic_info;
///评论界面
@property(nonatomic,strong)CustomInputView * input_view;
///回复的回复的id
@property(nonatomic,strong)NSString * r_reply_uid;
///回复回复的昵称
@property(nonatomic,strong)NSString * r_reply_userName;
///如果是二级回复，那么我就存放主评论的id
@property(nonatomic,strong)NSString * parent_post;

@end

@implementation TopicDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_input_view addKeyBordNotification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_input_view deleteKeyBordNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTitle = @"话题详情";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    _array_comments = [NSMutableArray array];
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorInset = UIEdgeInsetsMake(0,15,0,0);
    [self.view addSubview:_myTableView];
    
    loading = [LTools MBProgressWithText:@"加载中..." addToView:self.view];
    
    [self createBottomView];
    [self getTopicComments];
    [self getTopicDetailData];
}

#pragma mark - 创建底部视图
-(void)createBottomView
{
    bottom_view = [[TopicDetailBottomView alloc] initWithFrame:CGRectMake(0,DEVICE_HEIGHT-50-64,DEVICE_WIDTH,50)];
    [self.view addSubview:bottom_view];
    __weak typeof(self)bself = self;
    [bottom_view setBottomBlock:^(int index) {
        switch (index) {
            case 0:///赞
            {
                [bself PraiseClick];
            }
                break;
            case 1:///评论
            {
                [bself.input_view showInputView:nil];
            }
                break;
            case 2:///转发
            {
                
            }
                break;
                
            default:
                break;
        }
    }];
    
    [bottom_view setZanButtonSelected:[_topic_info.is_like integerValue]];
    
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
        
        [bself topicCommentsWithUserName:bself.r_reply_userName WithUid:bself.r_reply_uid];
        
    }];
    
    [self.view addSubview:_input_view];
}

#pragma mark - 创建sectionView
-(void)createSectionView
{
//    CGFloat height = 77;
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,0)];
    sectionView.backgroundColor = RGBCOLOR(245,245,245);
    
    
    UIImageView * headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12,12,50,50)];
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius = 25;
    headerImageView.backgroundColor = [UIColor grayColor];
    [sectionView addSubview:headerImageView];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:_topic_info.t_user_photo] placeholderImage:nil];
    
    UILabel * userName_label = [[UILabel alloc] initWithFrame:CGRectMake(70,12,150,50)];
    userName_label.text = _topic_info.t_username;
    userName_label.textAlignment = NSTextAlignmentLeft;
    userName_label.textColor = [UIColor blackColor];
    userName_label.font = [UIFont systemFontOfSize:15];
    [sectionView addSubview:userName_label];
    
    
    UIImageView * date_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-60,31,12,12)];
    date_imageView.image = [UIImage imageNamed:@"clock_image"];
    [sectionView addSubview:date_imageView];
    
    UILabel * date_label = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-45,12,50,50)];
    date_label.text = [ZSNApi timechange:_topic_info.topic_create_time WithFormat:@"HH:mm"];
    date_label.textAlignment = NSTextAlignmentLeft;
    date_label.textColor = [UIColor grayColor];
    date_label.font = [UIFont systemFontOfSize:11];
    [sectionView addSubview:date_label];
    
    //话题标题
    
    NSString *title = self.topic_info.topic_title;
    
    //宽度
    
    CGFloat aWidth = DEVICE_WIDTH - 2 * headerImageView.left;
    
    UILabel *title_label = [LTools createLabelFrame:CGRectMake(headerImageView.left, headerImageView.bottom + 13,aWidth, 0) title:title font:17 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"010101"]];
    title_label.font = [UIFont boldSystemFontOfSize:17];
    CGFloat title_height = [LTools heightForText:title width:aWidth Boldfont:17];
    title_label.height = title_height;
    
    [sectionView addSubview:title_label];
    
    //话题内容
    
    NSArray *content_arr = (NSArray *)[self.topic_info.topic_content objectFromJSONString];
    
    CGFloat top = title_label.bottom + 14;//记录上一个 y坐标
    
    for (NSDictionary *aDic in content_arr) {
        
        //是图片创建imageView
        TopicParseModel *aImageModel = [[TopicParseModel alloc]initWithDictionary:aDic];
        if (aImageModel.IMAGE_ORIGINAL_URL.length > 0) {
            
            CGFloat imageHeight = aImageModel.CELL_NEW_HEIGHT * aWidth / aImageModel.CELL_NEW_WIDTH;
            
            UIImageView *aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, top, aWidth, imageHeight)];
            [sectionView addSubview:aImageView];
            
            [aImageView sd_setImageWithURL:[NSURL URLWithString:aImageModel.CELL_TEXT] placeholderImage:nil];
            
            top = aImageView.bottom + 10;
            
        }else   //文字的话创建label
        {
            
            NSString *text = aImageModel.CELL_TEXT;
            UILabel *content_label = [LTools createLabelFrame:CGRectMake(headerImageView.left, top,aWidth, 0) title:text font:14 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"3a3a3a"]];
            content_label.font = [UIFont systemFontOfSize:14];
            CGFloat c_height = [LTools heightForText:title width:aWidth font:14];
            content_label.height = c_height;
            [sectionView addSubview:content_label];
            
            top = content_label.bottom + 10;
        }
        
    }
    
    
    
    sectionView.height = top;
    _myTableView.tableHeaderView = sectionView;
    
}


#pragma mark - 获取数据
///获取话题详情
-(void)getTopicDetailData
{
    NSString * fullUrl = [NSString stringWithFormat:GET_TOPIC_DETAIL_URL,_topic_model.topic_id,[GMAPI getAuthkey]];
    NSLog(@"话题详情接口 ----   %@",fullUrl);
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        @try {
            NSString * errorcode = [allDic objectForKey:@"errorcode"];
            
            if ([errorcode intValue] == 0)
            {
                NSDictionary * topic_info = [allDic objectForKey:@"topic_info"];
                bself.topic_info = [[TopicModel alloc] initWithDictionary:topic_info];
                [bottom_view setTitleWithTopicModel:bself.topic_info];
                
                [bself createSectionView];
                [bottom_view setZanButtonSelected:[bself.topic_info.is_like integerValue]];
            }else
            {
                [LTools showMBProgressWithText:[allDic objectForKey:@"msg"] addToView:self.view];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [request start];
}

///获取话题评论
-(void)getTopicComments
{
    NSString * fullUrl = [NSString stringWithFormat:GET_TOPIC_COMMENTS_URL,_topic_model.topic_id,_myTableView.pageNum];
    NSLog(@"获取话题评论接口 -----   %@",fullUrl);
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self) bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary * allDic = [operation.responseString objectFromJSONString];
            NSLog(@"allDic --- - -- - --   %@",allDic);
            
            if (bself.myTableView.pageNum == 1)
            {
                [bself.array_comments removeAllObjects];
                bself.myTableView.hiddenLoadMore = NO;
            }
            
            NSString * errorcode = [allDic objectForKey:@"errorcode"];
            if ([errorcode intValue] == 0)
            {
                NSArray * array = [allDic objectForKey:@"list"];
                
                for (NSDictionary * dic in array) {
                    TopicCommentsModel * model = [[TopicCommentsModel alloc] initWithDictionary:dic];
                    [bself.array_comments addObject:model];
                }
                
                if (bself.myTableView.pageNum == 1 && array.count < 20) {
                    bself.myTableView.hiddenLoadMore = YES;
                }
                
                [bself.myTableView finishReloadigData];
            }            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [request start];
}

#pragma mark - 话题点赞取消赞
-(void)PraiseClick
{
    BOOL isPraise = [self.topic_info.is_like intValue];
    NSString * fullUrl;
    if (isPraise) {
        fullUrl = [NSString stringWithFormat:TOPIC_DELFAV_URL,_topic_model.topic_id,[GMAPI getAuthkey]];
    }else
    {
        fullUrl = [NSString stringWithFormat:TOPIC_ADDFAV_URL,[GMAPI getAuthkey],_topic_model.topic_id];
    }
    
    NSLog(@"点赞取消点赞接口----  %@",fullUrl);
    
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        NSString * errocode = [allDic objectForKey:@"errorcode"];
        if ([errocode intValue] == 0)
        {
            [LTools showMBProgressWithText:isPraise?@"取消赞成功":@"已赞" addToView:self.view];
            bself.topic_info.is_like = [NSString stringWithFormat:@"%d",!isPraise];
            [bottom_view setZanButtonSelected:!isPraise];
            
        }else
        {
            [LTools showMBProgressWithText:[allDic objectForKey:@"msg"] addToView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [LTools showMBProgressWithText:@"请求失败，请检查您当前网络" addToView:self.view];
    }];
    
    [request start];
}

#pragma mark - 话题评论
-(void)topicCommentsWithUserName:(NSString *)aName WithUid:(NSString *)aUid
{
    NSString * level = @"1";
    NSString * reply_id = @"0";
    if (aName.length)
    {
        level = @"2";
        reply_id = _parent_post;
    }
    
    NSString *post = [NSString stringWithFormat:@"authcode=%@&topic_id=%@&repost_content=%@&level=%@&r_reply_id=%@&parent_post=%@",[GMAPI getAuthkey],_topic_model.topic_id,_input_view.text_input_view.text,level,aUid,reply_id];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url = [NSString stringWithFormat:TOPIC_COMMENTS_URL];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    __weak typeof(self)bself = self;
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        [bself getTopicComments];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
    
    _r_reply_uid = @"";
    _r_reply_userName = @"";
    _parent_post = @"";
}



#pragma mark - UITableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array_comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    TopicCommentsCell * cell = (TopicCommentsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopicCommentsCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TopicCommentsModel * model = [_array_comments objectAtIndex:indexPath.row];
    
    [cell setInfoWithCommentsModel:model];
    
    __weak typeof(self)bself = self;
    [cell setTopicCommentsCellBlock:^(TopicCommentsCellClickType aType, NSString *userName, NSString *uid, NSString *reply_id) {
        [bself clickWithType:aType WithUserName:userName WithUid:uid WithReplyId:reply_id];
    }];
    [cell.second_view setSeconForwardViewBlock:^(TopicCommentsCellClickType aType, NSString *userName, NSString *uid, NSString *reply_id) {
        [bself clickWithType:aType WithUserName:userName WithUid:uid WithReplyId:reply_id];
    }];
    
    
    return cell;
}




#pragma mark - Refresh Delegate
- (void)loadNewData
{
    [self getTopicComments];
}
- (void)loadMoreData
{
    [self getTopicComments];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCommentsModel * model = [_array_comments objectAtIndex:indexPath.row];
    [self clickWithType:TopicCommentsCellClickTypeComment WithUserName:model.user_name WithUid:model.repost_uid WithReplyId:model.reply_id];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    
    TopicCommentsModel * model = [_array_comments objectAtIndex:indexPath.row];
    NSString * content_string = model.repost_content;
    
    CGFloat string_height = [LTools heightForText:content_string width:DEVICE_WIDTH-60-12 font:14];
    
    
    SecondForwardView * _second_view = [[SecondForwardView alloc] initWithFrame:CGRectMake(60,string_height+46,DEVICE_WIDTH-60-12,0)];
    CGFloat second_height = [_second_view setupWithArray:model.child_array] + 10;

    
        ///数字一次代表距离顶部距离、头像高度、内容离头像距离、底部距离、评论的回复高度
    return string_height + 12 + 36 + 10 + 12 + second_height;
}



#pragma mark - 判断跳转方向
-(void)clickWithType:(TopicCommentsCellClickType)aType WithUserName:(NSString *)aName WithUid:(NSString *)aUid WithReplyId:(NSString *)aREplyId
{
    if (aType == TopicCommentsCellClickTypeComment)///跳评论的
    {
        NSLog(@"评论 ------   %@ ----  %@",aName,aUid);
        _r_reply_userName = aName;
        _r_reply_uid = aUid;
        _parent_post = aREplyId;
        _input_view.text_input_view.text = [NSString stringWithFormat:@"回复 %@:",aName];
        [_input_view showInputView:nil];
        
    }else///跳个人的
    {
        NSLog(@"这里要调到个人界面 uid----  %@",aUid);
    }
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
