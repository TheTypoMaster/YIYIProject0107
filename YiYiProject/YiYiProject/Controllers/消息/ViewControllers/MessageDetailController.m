//
//  MessageDetailController.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/18.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MessageDetailController.h"
#import "MailMessageCell.h"

#import "ActivityModel.h"

@interface MessageDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    
    id detail_model;
    ActivityModel *_activityModel;
//    NSArray *_activityInfo;//活动详情
}

@end

@implementation MessageDetailController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
//
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:self.lastPageNavigationHidden animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myTitleLabel.text = self.isActivity ? @"活动详情" : @"消息详情";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,DEVICE_HEIGHT - 64) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    _table.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getMessageInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 创建视图

/**
 *  活动时创建活动基本信息头部分
 *
 *  @return
 */
- (UIView *)activityTableViewHeaderWithModel:(ActivityModel *)aModel
{
    _activityModel = aModel;
    
    UIView *head = [[UIView alloc]init];
    head.backgroundColor = [UIColor whiteColor];
    
    //是否有封面
    CGFloat imageWidth = DEVICE_WIDTH - 20;
    CGFloat imageHeight = 0.f;//封面高度
    //有封面
    if (aModel.cover_pic.length > 0) {
        
        imageHeight = (imageWidth * 10) / 16;
        
        UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:aModel.cover_pic] placeholderImage:DEFAULT_BANNER_IMAGE];
        [head addSubview:coverImageView];
    }
    CGFloat textHeight = [LTools heightForText:aModel.activity_title width:imageWidth font:15];
    UILabel *titleLabel = [LTools createLabelFrame:CGRectMake(10, imageHeight + 10, imageWidth, textHeight) title:aModel.activity_title font:15 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"ef3c42"]];
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.numberOfLines = 0;
    [head addSubview:titleLabel];
    
    //时间
    UIImageView *timeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, titleLabel.bottom + 8, 13, 13)];
    timeIcon.image = [UIImage imageNamed:@"activity_time"];
    [head addSubview:timeIcon];
    
    NSString *timeString = [NSString stringWithFormat:@"活动时间:%@ - %@",[LTools timeString:aModel.start_time withFormat:@"YYYY.MM.dd"],[LTools timeString:aModel.end_time withFormat:@"YYYY.MM.dd"]];
    CGFloat left = timeIcon.right + 5;
    UILabel *timeLabel = [LTools createLabelFrame:CGRectMake(left, timeIcon.top, imageWidth - left, 13) title:timeString font:13 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"b9b9b9"]];
    [head addSubview:timeLabel];
    
    //地点
    UIImageView *addressIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, timeIcon.bottom + 8, 13, 13)];
    addressIcon.image = [UIImage imageNamed:@"activity_location"];
    [head addSubview:addressIcon];
    
    NSString *addressString = [NSString stringWithFormat:@"活动地点:%@",aModel.address];
    left = addressIcon.right + 5;
    UILabel *addressLabel = [LTools createLabelFrame:CGRectMake(left, addressIcon.top, imageWidth - left, 13) title:addressString font:13 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"b9b9b9"]];
    [head addSubview:addressLabel];
    
    
    head.frame = CGRectMake(0, 0, DEVICE_WIDTH, addressIcon.bottom + 10);
    
    return head;
}

#pragma mark - 网络请求

//action= yy(衣加衣) shop（商家） dynamic（动态）
- (void)getMessageInfo
{
    NSString *key = [GMAPI getAuthkey];
    
    NSString *url = [NSString stringWithFormat:MESSAGE_GET_DETAIL,self.msg_id,key];
    
    if (self.isActivity) {
        
        _msg_id = @"189";
        url = [NSString stringWithFormat:GET_MAIL_ACTIVITY_DETAIL,self.msg_id];
    }
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"");
        
        
        if ([LTools isDictinary:result]) {
            
            if (self.isActivity) {
                
                detail_model = [[ActivityModel alloc]initWithDictionary:result];
            }else
            {
                detail_model = [[MessageModel alloc]initWithDictionary:result];

            }
            
            _table.tableHeaderView = [self activityTableViewHeaderWithModel:detail_model];
            
            [_table reloadData];
        }
    
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
    }];
}

#pragma mark - RefreshDelegate

- (void)loadNewData
{
    
}
- (void)loadMoreData
{
    
}

//新加
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    NSLog(@"详情");
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if (self.isActivity) {
        
        return 100.f;
    }
    return [MailMessageCell heightForModel:detail_model cellType:icon_Yes seeAll:NO];
}

#pragma mark - UITableDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isActivity) {
        
        NSDictionary *info = _activityModel.activity_info[indexPath.row];
        int type = [info[@"type"] intValue];
        if (type == 1) { //文字
            
            NSString *content = info[@"content"];
            
            CGFloat height = [LTools heightForText:content width:DEVICE_WIDTH - 20 font:14];
            
            return height;
            
        }else if (type == 2){ //图片
            
            CGFloat width = [info[@"width"] floatValue];
            CGFloat height = [info[@"height"] floatValue];
            
            height = [LTools heightForImageHeight:height/2.f imageWidth:width/2.f originalWidth:DEVICE_WIDTH - 20];
            
            return height;
        }

    }
    
    return [MailMessageCell heightForModel:detail_model cellType:icon_Yes seeAll:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isActivity) {
        
        return _activityModel.activity_info.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //活动
    if (_isActivity) {
        
        static NSString *identifyText = @"activityText";
        static NSString *identifyImage = @"activityImage";
        
        
        NSDictionary *info = _activityModel.activity_info[indexPath.row];
        int type = [info[@"type"] intValue];
        if (type == 1) { //文字
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyText];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyText];
            }
            NSString *content = info[@"content"];
            cell.textLabel.text = content;
            cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.numberOfLines = 0;
//            cell.backgroundColor = [UIColor orangeColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if (type == 2){ //图片
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyImage];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyImage];
            }
            
            for (UIView *aView in cell.contentView.subviews) {
                
                [aView removeFromSuperview];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            NSString *content = info[@"src"];
            CGFloat width = [info[@"width"] floatValue];
            CGFloat height = [info[@"height"] floatValue];
            
            height = [LTools heightForImageHeight:height/2.f imageWidth:width/2.f originalWidth:DEVICE_WIDTH - 20];

            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, DEVICE_WIDTH - 20, height)];
            [cell.contentView addSubview:imageView];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:content] placeholderImage:DEFAULT_BANNER_IMAGE];
            return cell;
        }
    }
    
    //消息
    static NSString *identify = @"MailMessageCell";
    MailMessageCell *cell = (MailMessageCell *)[LTools cellForIdentify:identify cellName:identify forTable:tableView];
    
    [cell setCellWithModel:detail_model cellType:icon_Yes seeAll:NO timeType:Time_AddTime];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



@end
