//
//  GchooseFloorPinpaiViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/17.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GchooseFloorPinpaiViewController.h"

#import "ShenQingDianPuViewController.h"

@interface GchooseFloorPinpaiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation GchooseFloorPinpaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gGoDismiss)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.title = @"选择楼层和品牌";
    
    
    NSLog(@"有品牌的楼层%@",self.havePinpaiFloordic);
    NSArray *titleArray = [self.havePinpaiFloordic allKeys];
    self.floorArray = [titleArray sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSString *key in self.floorArray) {
        NSLog(@"楼层:%@",key);
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *contentArray = [self.havePinpaiFloordic objectForKey:self.floorArray[section]];
    return contentArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.floorArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //数据源
    NSArray *contentArray = [self.havePinpaiFloordic objectForKey:self.floorArray[indexPath.section]];
    NSDictionary *dicInfo = contentArray[indexPath.row];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    UIImageView *logoImv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
    
    [logoImv sd_setImageWithURL:[NSURL URLWithString:[dicInfo objectForKey:@"brand_logo"]] placeholderImage:nil];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImv.frame)+10, 15, DEVICE_WIDTH - 15-10-55, 40)];
    titleLabel.text = [dicInfo objectForKey:@"brand_name"];
    
    [cell.contentView addSubview:logoImv];
    [cell.contentView addSubview:titleLabel];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 30)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, view.frame.size.height-10)];
    [view addSubview:titleLabel];
    
    
    NSString *key = self.floorArray[section];
    NSString *title = nil;
    if ([key intValue]<0) {
        int a = [key intValue];
        a = -1*a;
        title = [NSString stringWithFormat:@"B%d",a];
    }else{
        title = [NSString stringWithFormat:@"%@F",key];
    }
    
    titleLabel.text = title;
    
    
    
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *contentArray = [self.havePinpaiFloordic objectForKey:self.floorArray[indexPath.section]];
    NSDictionary *dicInfo = contentArray[indexPath.row];
    
    NSLog(@"dicInfo:%@",dicInfo);
    
    NSString *key = self.floorArray[indexPath.section];
    NSString *title = nil;
    if ([key intValue]<0) {
        int a = [key intValue];
        a = -1*a;
        title = [NSString stringWithFormat:@"B%d",a];
    }else{
        title = [NSString stringWithFormat:@"%@F",key];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.delegate.floor = [dicInfo objectForKey:@"floor"];
        self.delegate.pinpai = [dicInfo objectForKey:@"brand_name"];
        UILabel *titleLabel = self.delegate.chooseLabelArray[2];
        titleLabel.text = [NSString stringWithFormat:@"选择楼层品牌  %@ %@",title,[dicInfo objectForKey:@"brand_name"]];
    }];
    
}







//视图消失
-(void)gGoDismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



@end
