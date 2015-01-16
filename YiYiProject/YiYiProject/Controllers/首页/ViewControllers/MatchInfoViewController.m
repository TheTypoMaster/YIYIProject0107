//
//  MatchInfoViewController.m
//  YiYiProject
//
//  Created by soulnear on 14-12-28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "MatchInfoViewController.h"
#import "SNRefreshTableView.h"
#import "MatchInfoModel.h"
#import "MatchTopicModel.h"
#import "MatchTopicCell.h"
#import "MatchWaterflowView.h"
#import "HomeMatchController.h"
#import "MatchCaseCell.h"
#import "GShowStarsView.h"
#import "YIYIChatViewController.h"

@interface MatchInfoViewController ()<UITableViewDataSource,SNRefreshDelegate,WaterFlowDelegate,TMQuiltViewDataSource>
{
    int topic_data_page;
    int match_data_page;
    MatchWaterflowView * waterFlow;
    MatchSelectedType selected_type;
    UIView * sectionView;
    NSInteger current_page;
    UIView * sectionView2;
    UIImageView * navigation_view;
    CGFloat currentOffY;
    ///加关注取消关注
    UIButton * attention_button;
}

@property(nonatomic,strong)SNRefreshTableView * myTableView;
///用户信息
@property(nonatomic,strong)MatchInfoModel * theInfo;
///搭配师话题数据
@property(nonatomic,strong)NSMutableArray * array_topic;
///搭配师搭配数据
@property(nonatomic,strong)NSMutableArray * array_matchCase;

@end

@implementation MatchInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    current_page = 1000;
    topic_data_page = 1;
    match_data_page = 1;
    _array_topic = [NSMutableArray array];
    _array_matchCase = [NSMutableArray array];
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT) showLoadMore:YES];
    _myTableView.dataSource = self;
    _myTableView.refreshDelegate = self;
    [self.view addSubview:_myTableView];
    
    [_myTableView addObserver:self forKeyPath:@"offsetY" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    
    [self loadSectionView];
    [self getMatchInfo];
    [self getTopicData];
    
    [self setNavgationView];
}
#pragma mark - 导航栏
-(void)setNavgationView
{
    navigation_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,64)];
    navigation_view.image = [UIImage imageNamed:@"default_navigation_clear_image"];
    [self.view addSubview:navigation_view];
    navigation_view.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:navigation_view];
    
    UIButton * back_button = [UIButton buttonWithType:UIButtonTypeCustom];
    back_button.frame = CGRectMake(0,20,40,44);
    //    back_button.backgroundColor = [UIColor orangeColor];
    [back_button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [back_button setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [navigation_view addSubview:back_button];
    
    
    UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-100)/2,20,100,44)];
    title_label.text = @"搭配师主页";
    title_label.textAlignment = NSTextAlignmentCenter;
    title_label.textColor = [UIColor whiteColor];
    title_label.font = [UIFont systemFontOfSize:18];
    [navigation_view addSubview:title_label];
    
    
    UIButton * right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    right_button.frame = CGRectMake(DEVICE_WIDTH-70,20,60,44);
    [right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [right_button setTitle:@"邀请搭配" forState:UIControlStateNormal];
    right_button.titleLabel.font = [UIFont systemFontOfSize:15];
    right_button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigation_view addSubview:right_button];
}

#pragma mark - 返回
-(void)back:(UIButton *)button
{
    @try{
        [waterFlow removeObserver:self forKeyPath:@"isShowUp"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    
}
#pragma mark - 邀请搭配
-(void)rightButtonTap:(UIButton *)button
{
    
}

#pragma mark - Section View
-(void)loadSectionView
{
    float height = 150;
    
    sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView * background_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,150)];
    background_imageView.image = [UIImage imageNamed:@"dapeishi_bg"];
    background_imageView.userInteractionEnabled = YES;
    [sectionView addSubview:background_imageView];
    
    
    ///头像
    UIImageView * header_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30,74,50,50)];
    header_imageView.layer.masksToBounds = YES;
    header_imageView.layer.cornerRadius = 25;
    header_imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    header_imageView.layer.borderWidth = 0.5;
    [header_imageView sd_setImageWithURL:[NSURL URLWithString:_theInfo.photo] placeholderImage:nil];
    [background_imageView addSubview:header_imageView];
    
    ///昵称
    UILabel * userName_label = [[UILabel alloc] initWithFrame:CGRectMake(100,74,DEVICE_WIDTH-100-50,30)];
    userName_label.text = _theInfo.name;
    userName_label.textAlignment = NSTextAlignmentLeft;
    userName_label.textColor = [UIColor whiteColor];
    userName_label.font = [UIFont systemFontOfSize:15];
    [background_imageView addSubview:userName_label];
    
    ///评级
    GShowStarsView * show_stars_view = [[GShowStarsView alloc] initWithStartNum:5 Frame:CGRectMake(100,110,70,12) starBackName:@"stars_unselected_image.png" starWidth:12];
    show_stars_view.startNum = [_theInfo.grade intValue];
    show_stars_view.starNameStr = @"stars_selected_image.png";
    show_stars_view.star_halfNameStr = @"stars_half_image.png";
    [background_imageView addSubview:show_stars_view];
    ///重置星星
    [show_stars_view updateStartNum];
    
    
    
    ///交流按钮
    UIButton * chat_button = [UIButton buttonWithType:UIButtonTypeCustom];
    chat_button.frame = CGRectMake(DEVICE_WIDTH-23-50,100,50,26);
    chat_button.layer.masksToBounds = YES;
    chat_button.layer.cornerRadius = 12;
    chat_button.backgroundColor = RGBCOLOR(229,25,88);
    [chat_button setTitle:@"交流" forState:UIControlStateNormal];
    chat_button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [chat_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chat_button addTarget:self action:@selector(chatTap:) forControlEvents:UIControlEventTouchUpInside];
    [background_imageView addSubview:chat_button];
    
    
    attention_button = [UIButton buttonWithType:UIButtonTypeCustom];
    attention_button.frame = CGRectMake(DEVICE_WIDTH-150,100,60,26);
    attention_button.backgroundColor = RGBCOLOR(227,202,45);
    [attention_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    attention_button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    attention_button.layer.masksToBounds = YES;
    attention_button.layer.cornerRadius = 12;
    [attention_button addTarget:self action:@selector(attentionTap:) forControlEvents:UIControlEventTouchUpInside];
    [background_imageView addSubview:attention_button];
    
    if ([_theInfo.relation intValue] == 1)///已关注
    {
        [attention_button setTitle:@"-关注" forState:UIControlStateNormal];
    }else if ([_theInfo.relation intValue] == 2)///未关注
    {
        [attention_button setTitle:@"+关注" forState:UIControlStateNormal];
    }else if ([_theInfo.relation intValue] == 3)///已互相关注
    {
        [attention_button setTitle:@"-关注" forState:UIControlStateNormal];
    }
    
    
    
    if (_theInfo.t_intro.length > 0 || _theInfo.t_tags.count > 0)
    {
        UIImageView * jiantou_view = [[UIImageView alloc] initWithFrame:CGRectMake(12,height+6,DEVICE_WIDTH-24,9)];
        jiantou_view.image = [UIImage imageNamed:@"zhixiangjiantou"];
        [sectionView addSubview:jiantou_view];
        
        height += 26;
        
        if (_theInfo.t_tags.count > 0) {
            for (int i = 0;i < _theInfo.t_tags.count;i++)
            {
                NSDictionary * aDic = [_theInfo.t_tags objectAtIndex:i];
                
                UIButton * tag_button = [UIButton buttonWithType:UIButtonTypeCustom];
                tag_button.frame = CGRectMake(15+(50+11)*i,height,50,25);
                [tag_button setTitle:[aDic objectForKey:@"tag_name"] forState:UIControlStateNormal];
                tag_button.backgroundColor = RGBACOLOR(172,172,172,1);
                tag_button.titleLabel.font = [UIFont systemFontOfSize:15];
                tag_button.layer.masksToBounds = YES;
                tag_button.layer.cornerRadius = 5;
                [sectionView addSubview:tag_button];
            }
            height += 25;
        }
        
        if (_theInfo.t_intro.length > 0)
        {
            CGFloat string_height = [LTools heightForText:_theInfo.t_intro width:DEVICE_WIDTH-30 font:14];
            
            UILabel * intro_label = [[UILabel alloc] initWithFrame:CGRectMake(15,height + 18,DEVICE_WIDTH-30,string_height)];
            intro_label.text = _theInfo.t_intro;
            intro_label.textAlignment = NSTextAlignmentLeft;
            intro_label.textColor = RGBCOLOR(35,35,35);
            intro_label.font = [UIFont systemFontOfSize:14];
            [sectionView addSubview:intro_label];
            
            height = height + 18 + string_height + 23;
        }
    }
    
    sectionView.height = height + 20;
//    _myTableView.tableHeaderView = sectionView;
}

#pragma mark - 获取数据
///获取搭配师个人信息
-(void)getMatchInfo
{
    NSString * fullUrl = [NSString stringWithFormat:GET_MATCH_INFOMATION_URL,_match_uid,[GMAPI getAuthkey]];
    
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary * allDic = [operation.responseString objectFromJSONString];
            
            if ([[allDic objectForKey:@"errorcode"] intValue] == 0) {
                
                bself.theInfo = [[MatchInfoModel alloc] initWithDic:allDic];
                
                
                [bself.myTableView finishReloadigData];
                NSLog(@"我勒个擦 -----   %@",bself.theInfo.t_tags);
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
///获取搭配师话题数据
-(void)getTopicData
{
    NSString * fullUrl = [NSString stringWithFormat:GET_TOPIC_DATA_URL,_match_uid,topic_data_page,20];
    NSLog(@"获取话题数据接口 -----   %@",fullUrl);
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self) bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        NSString * errorcode = [allDic objectForKey:@"errorcode"];
        if ([errorcode intValue] == 0)
        {
            if (topic_data_page == 1)
            {
                [bself.array_topic removeAllObjects];
            }
            
            NSArray * array = [allDic objectForKey:@"topics"];
            for (NSDictionary * dic in array) {
                MatchTopicModel * model = [[MatchTopicModel alloc] initWithDictionary:dic];
                [bself.array_topic addObject:model];
            }
            
            [bself.myTableView finishReloadigData];
        }else
        {
            if (topic_data_page !=1) {
                topic_data_page--;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (topic_data_page !=1) {
            topic_data_page--;
        }
    }];
    
    [request start];
}
///获取搭配数据
-(void)getMatchData
{
    NSString * fullUrl = [NSString stringWithFormat:GET_MATCH_DATA_URL,_match_uid,match_data_page,20];
    NSLog(@"获取搭配接口 ------  %@",fullUrl);
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            NSDictionary * allDic = [operation.responseString objectFromJSONString];
            
            NSLog(@"allDic -------  %@",allDic);
            NSString * errcode = [allDic objectForKey:@"errorcode"];
            if ([errcode intValue] == 0)
            {
                NSArray * array = [allDic objectForKey:@"tt_list"];
                if (match_data_page == 1) {
                    [bself.array_matchCase removeAllObjects];
                    if ([array isKindOfClass:[NSArray class]] && array.count == 0) {
                        [LTools showMBProgressWithText:@"该搭配师暂无搭配数据" addToView:self.view];
                    }
                }
                
                for (NSDictionary * dic in array) {
                    MatchCaseModel * model = [[MatchCaseModel alloc] initWithDictionary:dic];
                    [bself.array_matchCase addObject:model];
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
///加关注
-(void)attentionTap:(UIButton *)sender
{
    NSString * fullUrl;
    BOOL isAttention;
    if ([_theInfo.relation intValue] == 1)///已关注
    {
        isAttention = YES;
    }else if ([_theInfo.relation intValue] == 2)///未关注
    {
        isAttention = NO;
    }else if ([_theInfo.relation intValue] == 3)///已互相关注
    {
        isAttention = YES;
    }
    
    MBProgressHUD * hud;
    if ([LTools isLogin:self])
    {
        hud = [LTools MBProgressWithText:isAttention?@"取消关注...":@"关注..." addToView:self.view];
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    fullUrl = [NSString stringWithFormat:ATTENTTION_SOMEBODY_URL,[GMAPI getAuthkey],isAttention?@"can_friend":@"at_friend",_theInfo.uid];
    
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        NSString * errcode = [allDic objectForKey:@"errorcode"];
        if ([errcode intValue] == 0)
        {
            [hud hide:YES];
            
            [LTools showMBProgressWithText:isAttention?@"成功取消关注":@"关注成功" addToView:self.view];
            [attention_button setTitle:isAttention?@"+关注":@"-关注" forState:UIControlStateNormal];
        }else
        {
            [LTools showMBProgressWithText:[allDic objectForKey:@"msg"] addToView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [LTools showMBProgressWithText:@"请求失败，请检查您当前网络" addToView:self.view];
    }];
    
    [request start];
}
///交流
-(void)chatTap:(UIButton *)button
{
    if ([LTools isLogin:self]) {
        
        YIYIChatViewController *contact = [[YIYIChatViewController alloc]init];
        contact.currentTarget = self.theInfo.uid;
        contact.currentTargetName = self.theInfo.name;
        contact.portraitStyle = RCUserAvatarCycle;
        contact.enableSettings = NO;
        contact.conversationType = ConversationType_PRIVATE;
        
        [self.navigationController pushViewController:contact animated:YES];
    }
}


#pragma mark - UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else
    {
        if (selected_type == MatchSelectedTypeTopic) {
            return _array_topic.count;
        }else
        {
            return 1;
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selected_type == MatchSelectedTypeTopic)
    {
        static NSString * identifier = @"identifier";
        MatchTopicCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MatchTopicCell" owner:nil options:nil] objectAtIndex:0];
        }
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0,80,0,0);
        
        MatchTopicModel * model = [_array_topic objectAtIndex:indexPath.row];
        
        
        cell.user_name_label.hidden = YES;
        cell.header_imageView.layer.cornerRadius = 5;
        cell.jiantou_imageView.hidden = YES;
        cell.line_view.hidden = YES;
        
        cell.header_imageView.frame = CGRectMake(12,10,52,52);
        cell.title_label.frame = CGRectMake(80,18,DEVICE_WIDTH-80-12,15);
        cell.date_imageView.left = 80;
        cell.date_imageView.top = 42;
        cell.date_label.top = 30;
        cell.pinglun_imageView.top = 42;
        cell.pinglun_label.top = 30;
        cell.date_label.left = cell.date_imageView.right + 5;
        cell.pinglun_imageView.left = cell.date_label.right + 10;
        cell.pinglun_label.left = cell.pinglun_imageView.right+5;

        
        [cell.header_imageView sd_setImageWithURL:[NSURL URLWithString:model.t_user_photo] placeholderImage:nil];
        cell.date_label.text = [ZSNApi timechange:model.topic_last_post WithFormat:@"HH:mm"];
        cell.pinglun_label.text = model.topic_repost_num;
        cell.title_label.text = model.topic_title;

        
        return cell;
    }else
    {
        NSString * identifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        waterFlow = [[MatchWaterflowView alloc]initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64) waterDelegate:self waterDataSource:self];
        waterFlow.backgroundColor = RGBCOLOR(240, 230, 235);
        [cell.contentView addSubview:waterFlow];
        [waterFlow removeHeaderView];
        [waterFlow showRefreshHeader:NO];
        [waterFlow reloadData:_array_matchCase total:100];
        
        [waterFlow addObserver:self forKeyPath:@"isShowUp" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        
        return cell;
    }
}

// 只要MatchWaterflowView类的"offSet_string"属性发生的变化都会触发到以下的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isShowUp"])
    {
        float isShowUp = [[change objectForKey:@"new"] intValue];
        NSLog(@"wilage ----   %f",isShowUp);
        if (isShowUp)
        {
            // 输出改变后的值
            [_myTableView setContentOffset:CGPointMake(0,0) animated:YES];
        }else
        {
            [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        
        [UIView animateWithDuration:0.5f animations:^{
            navigation_view.top = isShowUp?0:-64;
        } completion:^(BOOL finished) {
            
        }];
    }else if ([keyPath isEqualToString:@"offsetY"])
    {
        NSString * new = [change objectForKey:@"new"];
        
        if (50 < [new floatValue])
        {
            [self setNavigationViewHiddenWith:YES];
        }else
        {
            [self setNavigationViewHiddenWith:NO];
        }
    }
    
}


#pragma mark - Refresh View Delegate
- (void)loadNewData
{
    if (selected_type == MatchSelectedTypeTopic) {
        [self getTopicData];
    }else
    {
        [self getMatchData];
    }
}
- (void)loadMoreData
{
    if (selected_type == MatchSelectedTypeTopic)
    {
        topic_data_page++;
        [self getTopicData];
    }else
    {
        match_data_page++;
        [self getMatchData];
    }
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    if (selected_type == MatchSelectedTypeTopic) {
        return 72;
    }else
    {
        return DEVICE_HEIGHT-60;
    }
}
- (UIView *)viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return sectionView;
    }else
    {
        sectionView2 = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,64)];
        sectionView2.backgroundColor = RGBCOLOR(242,242,242);
        
        UIView * segment_view = [[UIView alloc] initWithFrame:CGRectMake(12,20,DEVICE_WIDTH-24,34)];
        segment_view.layer.masksToBounds = YES;
        segment_view.layer.cornerRadius = 8;
        segment_view.layer.borderColor = RGBCOLOR(235,77,104).CGColor;
        segment_view.layer.borderWidth = 1;
        [sectionView2 addSubview:segment_view];
        
        for (int i = 0;i < 2;i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((DEVICE_WIDTH-24)/2*i,0,(DEVICE_WIDTH-24)/2,34);
            button.tag = 1000 + i;
            [button addTarget:self action:@selector(clickForChange:) forControlEvents:UIControlEventTouchUpInside];
            [segment_view addSubview:button];
            
            
            [button setBackgroundImage:[UIImage imageNamed:@"match_segment_unselected_image"] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"match_segment_selected_image"] forState:UIControlStateNormal];
            [button setTitleColor:RGBCOLOR(235,77,104) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

            
            if (i == 0)
            {
                [button setTitle:@"话题" forState:UIControlStateNormal];
                button.selected = YES;
            }else
            {
                [button setTitle:@"搭配" forState:UIControlStateNormal];
                button.selected = NO;
            }
            
            if (current_page == 1000+i)
            {
                button.selected = YES;
            }else
            {
                button.selected = NO;
            }
        }
        
        
        return sectionView2;
    }
}
- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        [self loadSectionView];
        return sectionView.height;
    }else
    {
        return 74;
    }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    
    if (offset > currentOffY) {
        
        [self setNavigationViewHiddenWith:YES];
        
    }else
    {
        [self setNavigationViewHiddenWith:NO];
    }
    
    currentOffY = offset;
}


-(void)setNavigationViewHiddenWith:(BOOL)isHidden
{
    [UIView animateWithDuration:0.3 animations:^{
        navigation_view.top = isHidden?-64:0;
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - 点击按钮切换搭配、话题
-(void)clickForChange:(UIButton *)button
{
    if (button.tag == current_page) {
        return;
    }
    
    UIButton * aButton;
    
    if (button.tag == 1000)///点击的话题
    {
        aButton = (UIButton *)[sectionView2 viewWithTag:1001];
        
        selected_type = MatchSelectedTypeTopic;
        self.myTableView.tableFooterView.hidden = NO;
        
        if (_array_topic.count == 0)
        {
            [self getTopicData];
        }else
        {
            [self.myTableView finishReloadigData];
        }
        
    }else///点击的搭配
    {
        aButton = (UIButton *)[sectionView2 viewWithTag:1000];
        
        selected_type = MatchSelectedTypeMatch;
        self.myTableView.tableFooterView.hidden = YES;
        if (_array_matchCase.count == 0)
        {
            [self getMatchData];
        }else
        {
            [self.myTableView finishReloadigData];
        }
    }
    
    aButton.selected = NO;
    button.selected = YES;
    
    current_page = button.tag;
}

#pragma mark - WaterFlowDelegate

- (void)waterLoadNewData
{
    
}
- (void)waterLoadMoreData
{
    match_data_page++;
    [self getMatchData];
}

- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    //    CGFloat aHeight = 0.f;
    //    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    //    if (aMode.imagelist.count >= 1) {
    //
    //        NSDictionary *imageDic = aMode.imagelist[0];
    //        NSDictionary *middleImage = imageDic[@"504Middle"];
    //        //        CGFloat aWidth = [middleImage[@"width"]floatValue];
    //        aHeight = [middleImage[@"height"]floatValue];
    //    }
    
    
    MatchCaseModel * model = waterFlow.dataArray[indexPath.row];
    return [model.tt_img_height floatValue] / 2.f;
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
    
    MatchCaseCell * cell = (MatchCaseCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"identifier"];
    if (!cell)
    {
        cell = [[MatchCaseCell alloc] initWithReuseIdentifier:@"identifier"];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 3;
    }
    
    cell.userName_label.hidden = YES;
    cell.header_imageView.hidden = YES;
    cell.pic_imageView.top = 0;
    MatchCaseModel * model = waterFlow.dataArray[indexPath.row];
    
    [cell setContentWithModel:model];
    
    return cell;
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
