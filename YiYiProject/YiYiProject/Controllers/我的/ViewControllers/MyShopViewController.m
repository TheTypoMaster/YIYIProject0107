//
//  MyShopViewController.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/18.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyShopViewController.h"
#import "ParallaxHeaderView.h"
#import "GupClothesViewController.h"
#import "GupHuoDongViewController.h"

@interface MyShopViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    UITableView *_tableView;
    ParallaxHeaderView *_backView;//banner
}

@property(nonatomic,strong)UIImageView *userFaceImv;//头像Imv

@property(nonatomic,strong)UIImage *userBanner;//banner
@property(nonatomic,strong)UIImage *userFace;//头像

@property(nonatomic,strong)UILabel *userNameLabel;//昵称label
@property(nonatomic,strong)UILabel *userScoreLabel;//积分

@end

@implementation MyShopViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self creatTableViewHeaderView];
    [self.view addSubview:_tableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建视图


///创建用户头像banner的view
-(UIView *)creatTableViewHeaderView{
    //底层view
    _backView = [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(DEVICE_WIDTH, 150.00*DEVICE_WIDTH/320)];
    _backView.headerImage = [UIImage imageNamed:@"my_bg"];
    
    NSLog(@"%@",NSStringFromCGRect(_backView.frame));
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, 70, 17)];
    titleLabel.font = [UIFont systemFontOfSize:16*GscreenRatio_320];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我是店主";
    titleLabel.textColor = [UIColor whiteColor];
    [_backView addSubview:titleLabel];
    titleLabel.center = CGPointMake(DEVICE_WIDTH / 2.f, titleLabel.center.y);
    
    //返回按钮
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(12,20,40,44)];
    [button_back addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button_back setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [_backView addSubview:button_back];
    
    //小齿轮设置按钮 设置
    UIButton *chilunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chilunBtn setFrame:CGRectMake(DEVICE_WIDTH - 40, 30, 25, 25)];
    [chilunBtn setBackgroundImage:[UIImage imageNamed:@"dz_tianjia"] forState:UIControlStateNormal];
    [chilunBtn addTarget:self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    //头像
    self.userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake(30*GscreenRatio_320, _backView.frame.size.height - 75, 50, 50)];
    self.userFaceImv.backgroundColor = RGBCOLOR_ONE;
    self.userFaceImv.layer.cornerRadius = 25;
    self.userFaceImv.layer.masksToBounds = YES;
    self.userFaceImv.image = [GMAPI getUserFaceImage];
    
    
    NSLog(@"%@",NSStringFromCGRect(self.userFaceImv.frame));
    
    //昵称
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userFaceImv.frame)+10, self.userFaceImv.frame.origin.y+6, 120*GscreenRatio_320, 14)];
    self.userNameLabel.text = @"昵称";
    self.userNameLabel.font = [UIFont systemFontOfSize:14*GscreenRatio_320];
    self.userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.text = [GMAPI getUsername];
    
    //地址
    self.userScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLabel.frame.origin.x, CGRectGetMaxY(self.userNameLabel.frame)+10, self.userNameLabel.frame.size.width, self.userNameLabel.frame.size.height)];
    self.userScoreLabel.font = [UIFont systemFontOfSize:14*GscreenRatio_320];
    self.userScoreLabel.text = @"地址";
    self.userScoreLabel.textColor = [UIColor whiteColor];

    //    //添加视图
    //    [backView addSubview:self.userBannerImv];
    [_backView addSubview:self.userFaceImv];
    [_backView addSubview:self.userNameLabel];
    [_backView addSubview:self.userScoreLabel];
    [_backView addSubview:chilunBtn];
    
    return _backView;
}

#pragma mark - 事件处理

- (UIButton *)buttonForTag:(int)tag
{
    return (UIButton *)[self.view viewWithTag:tag];
}

- (void)clickToAction:(UIButton *)sender
{
    UIButton *btn1 = [self buttonForTag:100];
    UIButton *btn2 = [self buttonForTag:101];
}

-(void)clickToBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickToAdd:(UIButton *)sender
{
    NSLog(@"添加商品 或者 单品");
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发布单品",@"发布活动", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate <NSObject>

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSLog(@"发布活动");
        
        GupHuoDongViewController *ccc = [[GupHuoDongViewController alloc]init];
        [self.navigationController pushViewController:ccc animated:YES];

    }else if (buttonIndex == 0){
        
        NSLog(@"发布单品");
        

        GupClothesViewController *ccc = [[GupClothesViewController alloc]init];
        [self.navigationController pushViewController:ccc animated:YES];
        
    }
}

#pragma mark -
#pragma mark UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == _tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)_tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 47;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 47)];
    view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(13, 12, DEVICE_WIDTH - 13 * 2, 47 - 12)];
    sectionView.layer.cornerRadius = 5.f;
    sectionView.layer.borderWidth = 1.f;
    sectionView.layer.borderColor = [UIColor colorWithHexString:@"eb4d68"].CGColor;
    sectionView.clipsToBounds = YES;
    
    NSArray *titles = @[@"单品",@"活动"];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(sectionView.width / 2.f * i, 0, sectionView.width / 2.f, sectionView.height) normalTitle:titles[i] image:nil backgroudImage:nil superView:nil target:self action:@selector(clickToAction:)];
        [sectionView addSubview:btn];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"eb4d68"] forState:UIControlStateNormal];
        
        [btn setTitleShadowColor:[UIColor colorWithHexString:@"f2f2f2"] forState:UIControlStateNormal];
        [btn setTitleShadowColor:[UIColor colorWithHexString:@"eb4d68"] forState:UIControlStateSelected];
        
        btn.tag = 100 + i;
        
        //默认 i=0 选中
        
        if (i == 0) {
            btn.selected = YES;
            btn.backgroundColor = [UIColor colorWithHexString:@"eb4d68"];
        }else
        {
            btn.selected = NO;
            btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        }
    }
    [view addSubview:sectionView];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSLog(@"indexpath.section:%ld row:%ld",(long)indexPath.section,(long)indexPath.row);

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


@end
