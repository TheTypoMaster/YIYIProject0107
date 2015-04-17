//
//  GsearchViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/3/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GsearchViewController.h"
#import "GrefreshTableView.h"
#import "GmPrepareNetData.h"
#import "NSDictionary+GJson.h"
#import "GcustomSearchTableViewCell.h"
#import "GStorePinpaiViewController.h"//店铺主页
#import "GnearbyStoreViewController.h"//商场主页
#import "ProductDetailController.h"//单品详情页


@interface GsearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,GrefreshDelegate,UIScrollViewDelegate>
{
    UIView *_searchHeaderView;
    UITextField * _searchTextField;
    UIView *_menu_view;
    NSMutableArray *_btnArray;
    int _selectIndex;
    
    GrefreshTableView *_tableView;
    int _page;//第几页
    int _pageCapacity;//一页请求几条数据
    NSArray *_dataArray;//数据源
    
    //定位相关
    NSDictionary *_locationDic;
    
    
    GcustomSearchTableViewCell *_tmpCell;//用于获取高度的临时cell
    
    
}
@end

@implementation GsearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    self.myTitleLabel.textColor = [UIColor whiteColor];
    self.myTitle = @"搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _pageCapacity = 20;
    
    //创建搜索标题
    [self creatSearchHeaderView];
    
    _selectIndex = 100;
    
    //创建tableview
    _tableView = [[GrefreshTableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchHeaderView.frame), DEVICE_WIDTH, DEVICE_HEIGHT - _searchHeaderView.frame.size.height-64)];
    _tableView.GrefreshDelegate = self;
//    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    __weak typeof(self)weakSelf = self;
    [[GMAPI appDeledate]startDingweiWithBlock:^(NSDictionary *dic) {
        
        [weakSelf theLocationDictionary:dic];
    }];
    
    
}


- (void)theLocationDictionary:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    _locationDic = dic;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//创建搜索框
-(void)creatSearchHeaderView{
    _searchHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0,0, DEVICE_WIDTH,82)];
    _searchHeaderView.backgroundColor=RGBCOLOR(247, 247, 247);
    [self.view addSubview:_searchHeaderView];
    
    //搜索条图片
    UIImageView *imgbc=[[UIImageView alloc]initWithFrame:CGRectMake(6, 6, self.view.bounds.size.width-60, 56/2)];
    imgbc.image=[UIImage imageNamed:@"ios7_newssearchbar.png"];
    [_searchHeaderView addSubview:imgbc];
    
    _searchTextField=[[UITextField alloc]initWithFrame:CGRectMake(30+6,MY_MACRO_NAME? 6:12,self.view.bounds.size.width-90,58/2)];
    _searchTextField.delegate=self;
    [_searchTextField becomeFirstResponder];
    _searchTextField.font=[UIFont systemFontOfSize:12.f];
    _searchTextField.placeholder=@"输入关键词";
    _searchTextField.returnKeyType=UIReturnKeySearch;
    _searchTextField.userInteractionEnabled = TRUE;
    [_searchHeaderView addSubview:_searchTextField];
    
    //确定搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(_searchHeaderView.frame.size.width-60, 0, 60, 40)];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_searchHeaderView addSubview:searchBtn];
    
    
    
    //分割线
    UIView *selectview=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(imgbc.frame)+5, DEVICE_WIDTH, 1)];
    selectview.backgroundColor=RGBCOLOR(235, 235, 235);
    [_searchHeaderView addSubview:selectview];
    
    //选择搜索类型view
    CGFloat aWidth = (ALL_FRAME_WIDTH - 24)/ 3.f;
    _menu_view = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(selectview.frame)+5, aWidth * 3, 30)];
    _menu_view.clipsToBounds = YES;
    _menu_view.layer.cornerRadius = 15.f;
    _menu_view.backgroundColor = RGBCOLOR(212, 59, 85);
    [_searchHeaderView addSubview:_menu_view];
    NSLog(@"%@",NSStringFromCGRect(_menu_view.frame));
    
    NSArray *titles = @[@"品牌",@"商铺",@"单品"];
    _btnArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(aWidth * i + 0.5 * i, 0, aWidth, 30);
        
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setHighlighted:NO];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        btn.tag = 100 + i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"d7425c"] forState:UIControlStateSelected];
        
        [_menu_view addSubview:btn];
        [_btnArray addObject:btn];
        [btn addTarget:self action:@selector(GbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    UIButton *btn = (UIButton *)[_menu_view viewWithTag:100];
    _selectIndex = 100;
    btn.backgroundColor = RGBCOLOR(240, 122, 142);
    
    
    
}

- (void)GbtnClicked:(UIButton *)sender
{
    int tag = (int)sender.tag;
    //改变点击颜色
    for (UIButton *btn in _btnArray) {
        btn.backgroundColor = RGBCOLOR(212, 59, 85);
    }
    sender.backgroundColor = RGBCOLOR(240, 122, 142);
    
    _selectIndex = tag;
    NSLog(@"selectIndex = %d",_selectIndex);
    if (_searchTextField.text.length==0) {
        return;
    }else{
        _tableView.hidden = NO;
        [self gshou];
    }
    if (_selectIndex == 100) {//品牌
        [_tableView showRefreshHeader:YES];
    }else if (_selectIndex == 101){//店铺
        [_tableView showRefreshHeader:YES];
    }else if (_selectIndex == 102){//单品
        [_tableView showRefreshHeader:YES];
    }
}

//点击搜索按钮
-(void)searchBtnClicked{
    if (_searchTextField.text.length == 0) {
        return;
    }
    [self gshou];
    _tableView.hidden = NO;
    [_tableView showRefreshHeader:YES];
}

//收键盘
-(void)gshou{
    [_searchTextField resignFirstResponder];
}


//请求网络数据
-(void)prepareNetData{
    
    NSString *theWord = _searchTextField.text;
    
    NSString *url = [NSString stringWithFormat:@"%@&keywords=%@&page=%d&per_page=%d&long=%@&lat=%@",GSEARCH,theWord,_page,_pageCapacity,[_locationDic stringValueForKey:@"long"],[_locationDic stringValueForKey:@"lat"]];
    
    if (_selectIndex == 100) {//搜索品牌
        url = [url stringByAppendingString:@"&type=brand"];
    }else if (_selectIndex == 101){//搜索商铺
        url = [url stringByAppendingString:@"&type=mall"];
    }else if (_selectIndex == 102){//搜索单品
        url = [url stringByAppendingString:@"&type=product"];
    }
    
    //接口url:
    NSLog(@"请求用户通知接口:%@",url);
    
    __weak typeof (self)bself = self;
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:url isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
//        NSString *errorcode = [result stringValueForKey:@"errorcode"];
//        if ([errorcode intValue]!= 0) {
//            [GMAPI showAutoHiddenMBProgressWithText:[result stringValueForKey:@"msg"] addToView:self.view];
//            return;
//        }
        
        NSArray *arr = [result arrayValueForKey:@"list"];
        
        if (arr.count < _pageCapacity) {
            
            _tableView.isHaveMoreData = NO;
        }else
        {
            _tableView.isHaveMoreData = YES;
        }
        
        
        [bself reloadData:arr isReload:_tableView.isReloadData];
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        if (_tableView.isReloadData) {
            
            _page --;
            
            [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
        }
    }];
    
}

#pragma mark - 下拉刷新上提加载更多
/**
 *  刷新数据列表
 *
 *  @param dataArr  新请求的数据
 *  @param isReload 判断在刷新或者加载更多
 */
- (void)reloadData:(NSArray *)dataArr isReload:(BOOL)isReload
{
    if (isReload) {
        
        _dataArray = dataArr;
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _dataArray = newArr;
    }
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}



#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    _page = 1;
    
    [self prepareNetData];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    _page ++;
    
    [self prepareNetData];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__FUNCTION__);
    
    [self gshou];
    
    
    if (_selectIndex == 100) {//搜索的是品牌
        NSDictionary *dic = _dataArray[indexPath.row];
        GStorePinpaiViewController *ccc = [[GStorePinpaiViewController alloc]init];
        ccc.storeIdStr = [dic stringValueForKey:@"mb_id"];
        if ([[dic stringValueForKey:@"mall_type"]intValue] != 1) {//商场店
            ccc.guanzhuleixing = @"精品店";
        }
        ccc.storeNameStr = [dic stringValueForKey:@"mall_name"];
        ccc.pinpaiNameStr = [dic stringValueForKey:@"brand_name"];
        if (self.isChooseProductLink) {
            ccc.isChooseProductLink = YES;
        }
        
        [self.navigationController pushViewController:ccc animated:YES];
        
    }else if (_selectIndex == 101){//搜索的是商铺
        NSDictionary *dic = _dataArray[indexPath.row];
        if ([[dic stringValueForKey:@"mall_type"]intValue] == 1) {//商场店
            GnearbyStoreViewController *ccc = [[GnearbyStoreViewController alloc]init];
            ccc.storeIdStr = [dic stringValueForKey:@"mall_id"];
            ccc.storeNameStr = [dic stringValueForKey:@"mall_name"];
            if (self.isChooseProductLink) {
                ccc.isChooseProductLink = YES;
            }
            [self.navigationController pushViewController:ccc animated:YES];
        }else if ([[dic stringValueForKey:@"mall_type"]intValue]==2){//精品店
            GStorePinpaiViewController *ccc = [[GStorePinpaiViewController alloc]init];
            ccc.storeIdStr = [dic stringValueForKey:@"mall_id"];
            ccc.storeNameStr = [dic stringValueForKey:@"mall_name"];
            ccc.guanzhuleixing = @"精品店";
            if (self.isChooseProductLink) {
                ccc.isChooseProductLink = YES;
            }
            [self.navigationController pushViewController:ccc animated:YES];
            
        }
    }else if (_selectIndex == 102){//搜索的是单品
        NSDictionary *dic = _dataArray[indexPath.row];
        ProductDetailController *ccc = [[ProductDetailController alloc]init];
        ccc.product_id = [dic stringValueForKey:@"product_id"];
        if (self.isChooseProductLink) {
            ccc.isChooseProductLink = YES;
        }
        [self.navigationController pushViewController:ccc animated:YES];
    }
    
    
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    if (!_tmpCell) {
        _tmpCell = [[GcustomSearchTableViewCell alloc]init];
    }
    
    if (_selectIndex == 100) {
        _tmpCell.theType = GSEARCHTYPE_PINPAI;
    }else if (_selectIndex == 101){
        _tmpCell.theType = GSEARCHTYPE_SHANGPU;
    }else if (_selectIndex == 102){
        _tmpCell.theType = GSEARCHTYPE_DANPIN;
    }
    
    NSDictionary *dic = _dataArray[indexPath.row];
    CGFloat height = [_tmpCell loadCustomViewWithData:dic indexPath:indexPath];
    
    return height;
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (!_tmpCell) {
//        _tmpCell = [[GcustomSearchTableViewCell alloc]init];
//    }
//    
//    if (_selectIndex == 100) {
//        _tmpCell.theType = GSEARCHTYPE_PINPAI;
//    }else if (_selectIndex == 101){
//        _tmpCell.theType = GSEARCHTYPE_SHANGPU;
//    }else if (_selectIndex == 102){
//        _tmpCell.theType = GSEARCHTYPE_DANPIN;
//    }
//    
//    NSDictionary *dic = _dataArray[indexPath.row];
//    CGFloat height = [_tmpCell loadCustomViewWithData:dic indexPath:indexPath];
//    
//    return height;
//}




#pragma mark -  UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GcustomSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GcustomSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (_selectIndex == 100) {//品牌
        cell.theType = GSEARCHTYPE_PINPAI;
    }else if (_selectIndex == 101){//商铺
        cell.theType = GSEARCHTYPE_SHANGPU;
    }else if (_selectIndex == 102){//单品
        cell.theType = GSEARCHTYPE_DANPIN;
    }
    
    NSDictionary *data_dic = _dataArray[indexPath.row];
    
    [cell loadCustomViewWithData:data_dic indexPath:indexPath];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}



//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"dddddddddddd %f",scrollView.contentOffset.y);
    if (scrollView == _tableView) {
        [self gshou];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchBtnClicked];
    return YES;
}


@end
