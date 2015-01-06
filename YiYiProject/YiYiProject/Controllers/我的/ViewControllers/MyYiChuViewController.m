//
//  MyYiChuViewController.m
//  YiYiProject
//
//  Created by szk on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "MyYiChuViewController.h"


@interface MyYiChuViewController ()

@end

@implementation MyYiChuViewController



-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden=NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.myTitle=@"我的衣橱";
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    

    
    
    
    
    
    [self prepareMyYiChuListData];
    
    // Do any additional setup after loading the view.
}




#pragma mark--获取整体数据

-(void)prepareMyYiChuListData{
    NSString *api = [NSString stringWithFormat:GET_MYYICHU_LIST_URL,[GMAPI getAuthkey]];
    
    NSLog(@"api===%@",api);
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        
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
