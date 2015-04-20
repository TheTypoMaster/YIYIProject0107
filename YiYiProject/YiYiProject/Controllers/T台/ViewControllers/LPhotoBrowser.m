//
//  LPhotoBrowser.m
//  YiYiProject
//
//  Created by lichaowei on 15/4/20.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "LPhotoBrowser.h"
#import "LShareSheetView.h"
#import "TDetailModel.h"
#import "MJPhotoView.h"

@implementation LPhotoBrowser
{
    TDetailModel *detail_model;
    MBProgressHUD *loading;
    //红心
    UIButton *zan_btn;
    
    //评论button
    UIButton *commentButton;
    //喜欢button (显示数字)
    UIButton *likeNumButton;
    
    
    UIView *topView;//顶部view
    UIView *bottomView;//底部view
    UIView *bottom;
    BOOL isShowTool;//是否显示tools
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    isShowTool = YES;
    
    loading = [LTools MBProgressWithText:@"加载中..." addToView:self.view];
    
    [self getTTaiDetail];//获取t台详情
}

#pragma - mark 创建视图

/**
 *  工具栏
 */
- (void)createToolbar
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 49)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    //顶部
    UIButton *closeButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 49, 49) normalTitle:nil image:BACK_DEFAULT_IMAGE backgroudImage:nil superView:self.view target:self action:@selector(clickToClose:)];
    [topView addSubview:closeButton];
    
    //转发
    UIButton *zhuan_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(DEVICE_WIDTH - 10 - 26, 0, 26, 50) normalTitle:nil image:[UIImage imageNamed:@"fenxiangb"] backgroudImage:nil superView:nil target:self action:@selector(clickToZhuanFa:)];
    [topView addSubview:zhuan_btn];
}

- (void)createBottomTools
{
    //底部
    
    bottom = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 49, DEVICE_WIDTH, 49)];
    [self.view addSubview:bottom];
    bottom.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.9];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 49, DEVICE_WIDTH, 49)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor clearColor];
    
    NSString *iconUrl = @"";
    NSString *userName = @"";
    if ([detail_model.uinfo isKindOfClass:[NSDictionary class]]) {
        
        iconUrl = detail_model.uinfo[@"photo"];
        userName = detail_model.uinfo[@"user_name"];
    }

    
    //头像
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 35, 35)];
    iconImageView.layer.cornerRadius = 35/2.f;
    iconImageView.clipsToBounds = YES;
//    iconImageView.backgroundColor = [UIColor redColor];
    [bottomView addSubview:iconImageView];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:DEFAULT_HEADIMAGE];
    
    //红心
    zan_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(DEVICE_WIDTH - 10 - 50, 0, 50, 50) normalTitle:nil image:[UIImage imageNamed:@"xq_love_up"] backgroudImage:nil superView:nil target:self action:@selector(clickToZan:)];
    [bottomView addSubview:zan_btn];
    [zan_btn setImage:[UIImage imageNamed:@"xq_love_down"] forState:UIControlStateSelected];
    
    zan_btn.selected = detail_model.is_like == 1 ? YES : NO;

    //喜欢的数字
    
    NSString *likeNum = [NSString stringWithFormat:@"%@人喜欢",detail_model.tt_like_num];
    CGFloat likeWidth = [LTools widthForText:likeNum font:14];
    
    likeNumButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(zan_btn.left - likeWidth - 20, 0, likeWidth, bottomView.height) normalTitle:likeNum image:nil backgroudImage:nil superView:nil target:self action:@selector(clickToCommentPage:)];
    [likeNumButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [bottomView addSubview:likeNumButton];
    
    //评论数字
    
    NSString *commentNum = [NSString stringWithFormat:@"%@条评论",detail_model.tt_like_num];
    likeWidth = [LTools widthForText:commentNum font:14];
    
    commentButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(likeNumButton.left - likeWidth - 20, 0, likeWidth, bottomView.height) normalTitle:commentNum image:nil backgroudImage:nil superView:nil target:self action:@selector(clickToCommentPage:)];
    [commentButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [bottomView addSubview:commentButton];
}

#pragma - mark 事件处理
/**
 *  显示或隐藏tools
 */
- (void)showOrHiddenTool
{
    BOOL show = isShowTool = !isShowTool;
    __block UIView *top = topView;
    __block UIView *bBottomV = bottomView;
    __block UIView *bBottom = bottom;
    [UIView animateWithDuration:0.2 animations:^{
       
        top.top = show ? 0 : -49;
        bBottom.top = show ? DEVICE_HEIGHT - 49 : DEVICE_HEIGHT;
        bBottomV.top = show ? DEVICE_HEIGHT - 49 : DEVICE_HEIGHT;
    }];
}

#pragma mark - MJPhotoView代理

/**
 *  重写父类代理方法
 *
 */
- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    [self showOrHiddenTool];
}

/**
 *  更新喜欢数
 */
- (void)updateLikeNum
{
    NSString *likeNum = [NSString stringWithFormat:@"%@人喜欢",detail_model.tt_like_num];
    [likeNumButton setTitle:likeNum forState:UIControlStateNormal];
}
/**
 *  更新评论数
 */
- (void)updateCommentNum
{
    NSString *commentNum = [NSString stringWithFormat:@"%@条评论",detail_model.tt_like_num];
    [commentButton setTitle:commentNum forState:UIControlStateNormal];
}

- (void)clickToCommentPage:(UIButton *)sender
{
    //评论页面
}

- (void)clickToZan:(UIButton *)sender
{
    if ([LTools isLogin:self]) {
        sender.selected = !sender.selected;
        [self zanTTaiDetail:sender.selected];
    }
}

- (void)clickToZhuanFa:(UIButton *)sender
{
    [[LShareSheetView shareInstance] showShareContent:detail_model.tt_content title:@"衣加衣" shareUrl:@"http://www.alayy.com" shareImage:self.showImageView.image targetViewController:self];
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


- (void)clickToClose:(UIButton *)sender
{
    [self hide];
}

#pragma - mark 网络请求

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

        [weakSelf updateLikeNum];
        
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
        
//        [weakSelf createViewsWithModel:detail_model];
//        
//        [weakSelf setViewWithModel:detail_model];
        
        [weakSelf createBottomTools];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        
        [loading hide:YES];
        
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
        
//        int like_num = [detail_model.tt_share_num intValue];
//        detail_model.tt_like_num = [NSString stringWithFormat:@"%d",like_num + 1];
//        zhuan_num_label.text = detail_model.tt_like_num;
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
    }];
}


@end
