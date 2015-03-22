//
//  GChooseStoreViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GChooseStoreViewController.h"
#import "ShenQingDianPuViewController.h"
#import "NSDictionary+GJson.h"

@interface GChooseStoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation GChooseStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gGoDismiss)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.title = @"请选择商场";
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    NSDictionary *dicInfo = self.dataArray[indexPath.row];
    
    cell.textLabel.text = [dicInfo stringValueForKey:@"mall_name"];
    cell.detailTextLabel.text = [dicInfo stringValueForKey:@"address"];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dicInfo = self.dataArray[indexPath.row];
    NSLog(@"mall_id%@",[dicInfo stringValueForKey:@"mall_id"]);
    [self gGodismissAndFuzhiWithMallid:[dicInfo stringValueForKey:@"mall_id"] theMallName:[dicInfo stringValueForKey:@"mall_name"] floorInfoDic:[dicInfo dictionaryValueForKey:@"floor_num"]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}




//视图消失并且赋值
-(void)gGodismissAndFuzhiWithMallid:(NSString *)mallId theMallName:(NSString *)mallName floorInfoDic:(NSDictionary *)dicInfo{
    [self dismissViewControllerAnimated:YES completion:^{
        UILabel *label = self.delegate.chooseLabelArray[1];
        label.text = [NSString stringWithFormat:@"选择商场  %@",mallName];
        
        NSLog(@"mallid:%@",mallId);
        self.delegate.mallId = mallId;
        
        NSLog(@"%@",dicInfo);
        
    }];
}




//视图消失
-(void)gGoDismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



@end
