//
//  GMyWalletViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/6/29.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GMyWalletViewController.h"

@interface GMyWalletViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titleArray;
    UITableView *_tableView;
}
@end



@implementation GMyWalletViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.myTitle = @"我的钱包";
    
    
    _titleArray = @[@"积分",@"奖券"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
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
    
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 15)];
    titleLabel.text = _titleArray[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 15, DEVICE_WIDTH-10-70-30, 15)];
    numLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:numLabel];
    
    if (indexPath.row == 0) {
        numLabel.text = @"302分";
    }else if (indexPath.row == 1){
        numLabel.text = @"2张";
    }
    
    
    NSMutableAttributedString *tt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",numLabel.text]];
    [tt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,numLabel.text.length-1)];
    [tt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,numLabel.text.length-1)];
    [tt addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(numLabel.text.length-1, 1)];
    [tt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(numLabel.text.length-1, 1)];
    numLabel.attributedText = tt;
    
    
    
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end
