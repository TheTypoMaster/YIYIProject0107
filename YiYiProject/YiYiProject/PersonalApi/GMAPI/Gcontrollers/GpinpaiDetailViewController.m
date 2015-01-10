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
#import "GStorePinpaiViewController.h"

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
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTitleLabel.textColor = [UIColor whiteColor];
    self.myTitle = self.pinpaiName;
    
    
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    //数据源
    NSDictionary *dic = _dataArray[indexPath.row];
    
    //name
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 18, 0, 16)];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.text = [dic stringValueForKey:@"mall_name"];
    [nameLabel sizeToFit];
    
    //距离
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+15, nameLabel.frame.origin.y+4, 0, nameLabel.frame.size.height)];
    distanceLabel.font = [UIFont systemFontOfSize:12];
    distanceLabel.textColor = RGBCOLOR(153, 153, 153);
    distanceLabel.text = [NSString stringWithFormat:@"%@m",[dic stringValueForKey:@"distance"]];
    [distanceLabel sizeToFit];
    
    
    //活动
    UILabel *activeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+10, 0, 15)];
    activeLabel.font = [UIFont systemFontOfSize:14];
    activeLabel.textColor = RGBCOLOR(114, 114, 114);
    activeLabel.text = [dic stringValueForKey:@"activity_info"];
    [activeLabel sizeToFit];
    
    
    
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:distanceLabel];
    [cell.contentView addSubview:activeLabel];
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = _dataArray[indexPath.row];
    
    GStorePinpaiViewController *cc = [[GStorePinpaiViewController alloc]init];
    cc.storeIdStr = [dic stringValueForKey:@"mall_id"];
    cc.pinpaiNameStr = self.pinpaiName;
    cc.storeNameStr = [dic stringValueForKey:@"mall_name"];
    [self.navigationController pushViewController:cc animated:YES];
    
    
}






@end
