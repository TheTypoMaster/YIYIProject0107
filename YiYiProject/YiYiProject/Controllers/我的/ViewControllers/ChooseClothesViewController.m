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

}
-(void)createTableView
{
    myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 70;
    [self.view addSubview:myTableView];
    
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
        imageView.backgroundColor = [UIColor grayColor];
        imageView.tag = 101;
        [cell addSubview:imageView];
        UILabel *nameLabel = [LTools createLabelFrame:CGRectMake(imageView.frame.origin.x + imageView.width +10, (70-15)/2.0, 100, 15) title:@"测试数据" font:15 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"686868"]];
        nameLabel.tag = 102;
        [cell addSubview:nameLabel];
               
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
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
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
