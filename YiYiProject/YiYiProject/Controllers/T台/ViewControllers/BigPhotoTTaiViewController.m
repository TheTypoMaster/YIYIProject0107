//
//  BigPhotoTTaiViewController.m
//  YiYiProject
//
//  Created by lichaowei on 15/4/20.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BigPhotoTTaiViewController.h"

#import "LoginViewController.h"

#import "GTTPublishViewController.h" //t台发布

#import "RefreshTableView.h"

#import "TTaiBigPhotoCell.h" //t台样式一

#import "TTaiBigPhotoCell2.h"//t台样式二

#import "TPlatModel.h"
#import "DataManager.h"
#import "LPhotoBrowser.h"
#import "MJPhoto.h"

#import "TTaiDetailController.h"//t台详情


@interface BigPhotoTTaiViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    LPhotoBrowser *browser;
    BOOL isFirst;
}

@end

@implementation BigPhotoTTaiViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTitleLabel.text = @"T台";
    [self createNavigationbarTools];
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,DEVICE_HEIGHT - 64)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
//    _table.hidden = YES;
    
    NSDictionary *dic = [DataManager getCacheDataForType:Cache_TPlat];
    if (dic) {
        [self parseDataWithResult:dic];
    }
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.2];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTTai:) name:NOTIFICATION_TTAI_PUBLISE_SUCCESS object:nil];
    
}

- (void)loadData
{
    [_table showRefreshHeader:YES];
    
//    [self loadNewData];
    
}

- (void)createNavigationbarTools
{
    
    UIButton *rightView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightView.backgroundColor=[UIColor clearColor];
    
    UIButton *heartButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [heartButton addTarget:self action:@selector(clickToPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [heartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [heartButton setImage:[UIImage imageNamed:@"gcamera.png"] forState:UIControlStateNormal];
    [heartButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    [rightView addSubview:heartButton];
    
    UIBarButtonItem *comment_item=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = comment_item;
}

#pragma mark 数据解析

- (void)parseDataWithResult:(NSDictionary *)result
{
    NSMutableArray *arr;
    int total;
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSArray *list = result[@"list"];
        
        total = [result[@"total"]intValue];
        arr = [NSMutableArray arrayWithCapacity:list.count];
        if ([list isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *aDic in list) {
                
                TPlatModel *aModel = [[TPlatModel alloc]initWithDictionary:aDic];
                
                [arr addObject:aModel];
            }
            
        }
        
        [_table reloadData:arr total:L_PAGE_SIZE];
        
//        [self animation];
    }
}

- (void)animation
{

    _table.contentOffset = CGPointMake(0, DEVICE_HEIGHT * 3);

    
    [UIView animateWithDuration:2.f animations:^{
        
        _table.hidden = NO;

        
    } completion:^(BOOL finished) {
        _table.contentOffset = CGPointMake(0, 0);

        
    }];
    
}

#pragma mark 网络请求

//T台赞 或 取消

- (void)zanTTaiDetail:(UIButton *)zan_btn
{
    if (![LTools isLogin:self]) {
        return;
    }
    
    NSString *authkey = [GMAPI getAuthkey];
    
    TPlatModel *detail_model = _table.dataArray[zan_btn.tag - 100];
    NSString *t_id = detail_model.tt_id;
    NSString *post = [NSString stringWithFormat:@"tt_id=%@&authcode=%@",t_id,authkey];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString * url = TTAI_ZAN;
    
    
    TTaiBigPhotoCell *cell = (TTaiBigPhotoCell *)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:zan_btn.tag - 100 inSection:0]];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"-->%@",result);
        
        zan_btn.selected = YES;
        
        int like_num = [detail_model.tt_like_num intValue];
        detail_model.tt_like_num = [NSString stringWithFormat:@"%d",like_num + 1];
        cell.zanNumLabel.text = detail_model.tt_like_num;
        detail_model.is_like = 1;
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        if ([failDic[RESULT_CODE] intValue] == -11 || [failDic[RESULT_CODE] intValue] == 2003) {
            [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
        }
        
    }];
}


- (void)getTTaiData
{
    
    __weak typeof(self)weakSelf = self;
    
    __weak typeof(RefreshTableView)*weakTable = _table;
    NSString *url = [NSString stringWithFormat:TTAI_LIST,_table.pageNum,L_PAGE_SIZE,[GMAPI getAuthkey]];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [weakSelf parseDataWithResult:result];
        
        if (_table.pageNum == 1) {
            
            [DataManager cacheDataType:Cache_TPlat content:result];
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [weakTable loadFail];
        
    }];
}


#pragma mark 事件处理

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    
    PropertyImageView *aImageView = (PropertyImageView *)tap.view;

    NSInteger count = aImageView.imageUrls.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        // 替换为中等尺寸图片
        NSString *url = aImageView.imageUrls[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = aImageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }

    
    // 2.显示相册
    browser = [[LPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.showImageView = aImageView;
    browser.tt_id = aImageView.infoId;//详情id
    browser.cancelSingleTap = YES;
    browser.lastViewController = self;
    [browser showWithController:self.tabBarController];
    
//    self.tabBarController.tabBar.top = DEVICE_HEIGHT;
}


- (void)updateTTai:(NSNotification *)noti
{
    [_table showRefreshHeader:YES];
}

/**
 *  发布 T 台
 *
 *  @param sender <#sender description#>
 */
- (void)clickToPhoto:(UIButton *)sender
{
    
    //判断是否登录
    if ([LTools cacheBoolForKey:LOGIN_SERVER_STATE] == NO) {
        
        LoginViewController *login = [[LoginViewController alloc]init];
        
        UINavigationController *unVc = [[UINavigationController alloc]initWithRootViewController:login];
        
        [self presentViewController:unVc animated:YES completion:nil];
        
        return;
    }
    
    GTTPublishViewController *publishT = [[GTTPublishViewController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:publishT];
    [self presentViewController:navc animated:YES completion:^{
        
    }];
}

#pragma - mark RefreshDelegate

-(void)loadNewData
{
    [self getTTaiData];
}

-(void)loadMoreData
{
    [self getTTaiData];
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"---->%f",scrollView.contentOffset.y);
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    //调转至老版本 详情页
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TPlatModel *aModel = _table.dataArray[indexPath.row];
    TTaiDetailController *t_detail = [[TTaiDetailController alloc]init];
    t_detail.tt_id = aModel.tt_id;
    t_detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:t_detail animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    TPlatModel *aModel = (TPlatModel *)[_table.dataArray objectAtIndex:indexPath.row];
    
    CGFloat image_width = [aModel.image[@"width"]floatValue];
    CGFloat image_height = [aModel.image[@"height"]floatValue];
    
//    return 50 + 36 + [LTools heightForImageHeight:image_height imageWidth:image_width originalWidth:DEVICE_WIDTH];
    
    
    return 75 + [LTools heightForImageHeight:image_height imageWidth:image_width originalWidth:DEVICE_WIDTH] - 35/2.f;
}

//- (UIView *)viewForHeaderInSection:(NSInteger)section tableView:(UITableView *)tableView
//{
//    
//}
//- (CGFloat)heightForHeaderInSection:(NSInteger)section tableView:(UITableView *)tableView
//{
//    
//}

#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identify = @"TTaiBigPhotoCell";
//    
//    TTaiBigPhotoCell *cell = (TTaiBigPhotoCell *)[LTools cellForIdentify:identify cellName:identify forTable:tableView];
//    
//    [cell setCellWithModel:[_table.dataArray objectAtIndex:indexPath.row]];
//    cell.zanButton.tag = 100 + indexPath.row;
//    [cell.zanButton addTarget:self action:@selector(zanTTaiDetail:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //是否开启 新版本 模式
//    [cell.bigImageView.tapGesture addTarget:self action:@selector(tapImage:)];
//
////    cell.bigImageView.userInteractionEnabled = NO;
//    
//    return cell;
    
    static NSString *identify = @"TTaiBigPhotoCell2";
    
    TTaiBigPhotoCell2 *cell = (TTaiBigPhotoCell2 *)[LTools cellForIdentify:identify cellName:identify forTable:tableView];
    
    [cell setCellWithModel:[_table.dataArray objectAtIndex:indexPath.row]];
//    cell.bigImageView.userInteractionEnabled = NO;
    
    [cell.bigImageView.tapGesture addTarget:self action:@selector(tapImage:)];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}



@end
