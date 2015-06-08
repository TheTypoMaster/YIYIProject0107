//
//  ChooseClothesViewController.m
//  YiYiProject
//
//  Created by unisedu on 15/1/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ChooseClothesViewController.h"
#import "UIImageView+WebCache.m"
#import "ChooseImageViewController.h"
@interface ChooseClothesViewController ()
{
    UITableView *myTableView;
    NSMutableArray * _dataSourceArray;
    UIView *_chooseImageView;
    UIScrollView  *myScrollView;
    NSMutableArray *_imageAarray;
    float zuoBiaoX ;
}
@end

@implementation ChooseClothesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.myTitle=@"选择图片";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    [self prepareMyYiChuListData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addImage:) name:@"addImag" object:nil];
    zuoBiaoX = 10;

}
-(void)createTableView
{
    myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 70;
    [self.view addSubview:myTableView];
    [self addImageViewForWindow];
    
}
-(void)addImageViewForWindow
{
    UIWindow *currentWindow =(UIWindow*) [UIApplication sharedApplication].keyWindow;
    _chooseImageView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-120, DEVICE_WIDTH, 120)];
    _chooseImageView.backgroundColor = [UIColor whiteColor];
    [currentWindow addSubview:_chooseImageView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
    headView.backgroundColor = [UIColor grayColor];
    [_chooseImageView addSubview:headView];
    
    UIButton *button  = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(DEVICE_WIDTH-20-50, 5, 50, 30) normalTitle:@"确定" image:nil backgroudImage:nil superView:headView target:self action:@selector(confirmBtn:)];
    button.backgroundColor = [UIColor colorWithHexString:@"eb6fb7"];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y+headView.frame.size.height, DEVICE_WIDTH, _chooseImageView.height-headView.height)];
    myScrollView.backgroundColor = [UIColor whiteColor];
    [_chooseImageView addSubview:myScrollView];
    
}
-(void)confirmBtn:(UIButton *) sender
{
    zuoBiaoX = 10;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addImageWithArray" object:_imageAarray];
    UIViewController *popVC = (UIViewController *)[self.navigationController.viewControllers objectAtIndex:2];
    [self.navigationController popToViewController:popVC animated:YES];
    [_chooseImageView removeFromSuperview];
}
-(void)addImage:(NSNotification*)notify
{
    if(!_imageAarray)
    {
        _imageAarray = [NSMutableArray arrayWithCapacity:1];
    }
    NSDictionary *dic = [notify object];
    [_imageAarray addObject:[NSURL URLWithString:[dic objectForKey:@"image_url"]]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(zuoBiaoX, 10, 60, 60)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image_url"]] placeholderImage:nil];
    [myScrollView addSubview:imageView];
    
    zuoBiaoX += 70;
    
    myScrollView.contentSize = CGSizeMake(imageView.frame.origin.x+imageView.width, _chooseImageView.height- 40);
    
}
-(void)leftButtonTap:(UIButton *)sender
{
    [_chooseImageView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--UItableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
        
        UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        imageView.backgroundColor = RGBCOLOR(255,155,155);
        imageView.tag = 101;
        [cell addSubview:imageView];
        UILabel *nameLabel = [LTools createLabelFrame:CGRectMake(imageView.frame.origin.x + imageView.width +10, (70-15)/2.0, 100, 15) title:@"测试数据" font:15 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"686868"]];
        nameLabel.tag = 102;
        [cell addSubview:nameLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    UIImageView  *currentImageView = (UIImageView *)[cell viewWithTag:101];
    UILabel *currentLabel = (UILabel *)[cell viewWithTag:102];
    NSDictionary *currentDic = [_dataSourceArray objectAtIndex:indexPath.row];
    NSArray *clothesArray = (NSArray *)[currentDic objectForKey:@"clothes"];
    long count = clothesArray.count;
    currentLabel.text = [NSString stringWithFormat:@"%@(%ld)",[currentDic objectForKey:@"sort_name"],count];
    if(clothesArray.count > 0)
    {
        NSURL *url = [NSURL URLWithString:[[clothesArray objectAtIndex:0] objectForKey:@"image_url"]];;
        [currentImageView sd_setImageWithURL:url placeholderImage:nil];
    }
    return cell;
}
#pragma mark--UItableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseImageViewController *chooseImageVC = [[ChooseImageViewController alloc] init];
    chooseImageVC.hidesBottomBarWhenPushed = YES;
    chooseImageVC -> sourceDic = [_dataSourceArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:chooseImageVC animated:YES];
}
#pragma mark--获取整体数据

-(void)prepareMyYiChuListData{
    NSString *api = [NSString stringWithFormat:GET_MYYICHU_LIST_URL,[GMAPI getAuthkey]];
    NSLog(@"api===%@",api);
    LTools *gg = [[LTools alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
        {
            _dataSourceArray = [result objectForKey:@"list"];
            [myTableView reloadData];
        }
        
        NSLog(@"%@",result);
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"%@",failDic);
        
    }];
    
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
