//
//  YIYIChatViewController.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/26.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "YIYIChatViewController.h"

@implementation YIYIChatViewController




-(id)init{
    self = [super init];
    if (self) {
        self.GTitleLabel = [[UILabel alloc]init];
    }
    
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton1.width = MY_MACRO_NAME?-13:5;
    
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME? -5:5,8,40,44)];
    [button_back addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH - 100, 44)];
    [self.GTitleLabel setFrame:titleView.bounds];
    self.GTitleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:self.GTitleLabel];
    UIBarButtonItem *title_item = [[UIBarButtonItem alloc]initWithCustomView:titleView];
    self.navigationItem.leftBarButtonItems=@[spaceButton1,back_item,title_item];
    
}

@end
