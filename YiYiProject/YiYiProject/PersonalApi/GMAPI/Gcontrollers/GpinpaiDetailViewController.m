//
//  GpinpaiDetailViewController.m
//  YiYiProject
//
//  Created by gaomeng on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "GpinpaiDetailViewController.h"
#import "GmPrepareNetData.h"
#import "NSDictionary+GJson.h"
#import "GnearbyStoreViewController.h"

@interface GpinpaiDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation GpinpaiDetailViewController




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = self.pinpaiIdStr;
    [self.view addSubview:label];
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    [self prepareNetData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareNetData{
    
    NSString *api = [NSString stringWithFormat:@"%@&brand_id=%@&page=1&per_page=100",HOME_CLOTH_PINPAI_STORELIST,self.pinpaiIdStr];
    
    NSLog(@"%@",api);
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%@",result);
        _dataArray = [result objectForKey:@"mall_list"];
        
        [_tableView reloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"失败");
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.textLabel.text = [dic stringValueForKey:@"mall_name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"距离:%@",[dic stringValueForKey:@"distance"]];
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GnearbyStoreViewController *cc = [[GnearbyStoreViewController alloc]init];
    NSDictionary *dic = _dataArray[indexPath.row];
    cc.storeIdStr = [dic stringValueForKey:@"mall_id"];
    [self.navigationController pushViewController:cc animated:YES];
    
    
}






@end
