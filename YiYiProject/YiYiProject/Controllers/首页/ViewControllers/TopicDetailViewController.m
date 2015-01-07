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

@interface TopicDetailViewController ()<UITableViewDataSource,SNRefreshDelegate>
{
    ///底部view
    TopicDetailBottomView * bottom_view;
}


@property(nonatomic,strong)SNRefreshTableView * myTableView;
///评论数据容器
@property(nonatomic,strong)NSMutableArray * array_comments;
///话题详情数据
@property(nonatomic,strong)TopicModel * topic_info;

@end

@implementation TopicDetailViewController

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
}

#pragma mark - 创建sectionView
-(void)createSectionView
{
    CGFloat height = 77;
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
    
    
    
    
    
    sectionView.height = height;
    _myTableView.tableHeaderView = sectionView;
    
}


#pragma mark - 获取数据
///获取话题详情
-(void)getTopicDetailData
{
    NSString * fullUrl = [NSString stringWithFormat:GET_TOPIC_DETAIL_URL,_topic_model.topic_id];
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
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        NSString * errocode = [allDic objectForKey:@"errorcode"];
        if ([errocode intValue] == 0)
        {
            [LTools showMBProgressWithText:isPraise?@"取消赞成功":@"已赞" addToView:self.view];
            self.topic_info.is_like = [NSString stringWithFormat:@"%d",!isPraise];
        }else
        {
            [LTools showMBProgressWithText:[allDic objectForKey:@"msg"] addToView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [LTools showMBProgressWithText:@"请求失败，请检查您当前网络" addToView:self.view];
    }];
    
    [request start];
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
    
    TopicCommentsModel * model = [_array_comments objectAtIndex:indexPath.row];
    
    [cell setInfoWithCommentsModel:model];
    
    return cell;
}




#pragma mark - Refresh Delegate
- (void)loadNewData
{
    
}
- (void)loadMoreData
{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
