//
//  GChooseColorAndSizeViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/9/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GChooseColorAndSizeViewController.h"
#import "GChooseColorSizeTableViewCell.h"

@interface GChooseColorAndSizeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tab;
}
@end

@implementation GChooseColorAndSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.myTitle = @"颜色尺码选择";
    
    [self creatTab];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MyMethod

-(void)creatTab{
    _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStylePlain];
    _tab.delegate = self;
    _tab.dataSource = self;
    [self.view addSubview:_tab];
}



#pragma mark - UITableViewDelegate && UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GChooseColorSizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GChooseColorSizeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    [cell loadCustomViewWithIndexPath:indexPath];
    
    
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}








@end
