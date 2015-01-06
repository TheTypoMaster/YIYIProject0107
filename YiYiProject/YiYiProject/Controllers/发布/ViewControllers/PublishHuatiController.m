//
//  PublishHuatiController.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/28.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "PublishHuatiController.h"
#import "LEditor.h"

@interface PublishHuatiController ()
{
    LEditor *editor;
}

@end

@implementation PublishHuatiController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [editor setFirstResponder];
//    [editor performSelector:@selector(setFirstResponder) withObject:nil afterDelay:0.1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTitleLabel.text = @"发布话题";
    self.myTitleLabel.textColor = [UIColor whiteColor];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    [self createNavigationbarTools];
    
    editor = [[LEditor alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - 50 - 20) rootViewController:self];
    [self.view addSubview:editor];
}

#pragma mark - 事件处理

- (void)clickToPub:(UIButton *)sender
{
    NSLog(@"发布 %@",[editor content]);
    
    NSArray *contentArr = [NSArray arrayWithArray:[editor content]];
    
    NSMutableString *allContent = [[NSMutableString alloc]initWithString:@""];
    
    int imageIndex = 0;
    for (NSDictionary *aDic in contentArr) {
        
        NSString *content = aDic[CELL_TEXT];
        if ([content isKindOfClass:[UIImage class]]) {
            
            
            
        }else
        {
            [allContent appendString:content];
        }
    }
    
}

- (IBAction)clickToOpenAlbum:(id)sender {
    
    [editor clickToAddAlbum:sender];
}

#pragma mark - 创建视图

- (void)createNavigationbarTools
{
    
    UIButton *rightView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    rightView.backgroundColor=[UIColor clearColor];
    
    UIButton *insertButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [insertButton addTarget:self action:@selector(clickToOpenAlbum:) forControlEvents:UIControlEventTouchUpInside];
    //    [heartButton setTitle:@"喜欢" forState:UIControlStateNormal];
    [insertButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [insertButton setImage:[UIImage imageNamed:@"fabu_pic"] forState:UIControlStateNormal];
    [insertButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    //收藏的
    
    UIButton *fabuButton =[[UIButton alloc]initWithFrame:CGRectMake(rightView.width - 44,0, 44,42.5)];
    [fabuButton addTarget:self action:@selector(clickToPub:) forControlEvents:UIControlEventTouchUpInside];
//    [fabuButton setImage:[UIImage imageNamed:@"shoucangb"] forState:UIControlStateNormal];
    [fabuButton setTitle:@"发布" forState:UIControlStateNormal];
    [fabuButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [fabuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fabuButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(44 + 8, 7 + 5, 0.5, 20)];
    line.backgroundColor = [UIColor whiteColor];
    [rightView addSubview:line];

    
    
    [rightView addSubview:insertButton];
    [rightView addSubview:fabuButton];
    
    UIBarButtonItem *comment_item=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    
    self.navigationItem.rightBarButtonItem = comment_item;
}


@end
