//
//  GStorePinpaiViewController.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/10.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GStorePinpaiViewController.h"
#import "GtopScrollView.h"
#import "GRootScrollView.h"
#import "CustomSegmentView.h"

@interface GStorePinpaiViewController ()<CustomSegmentViewDelegate>
{
    CustomSegmentView *_mysegment;
    int _page;
    int _per_page;
}
@end

@implementation GStorePinpaiViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    
    NSString *aaa = [NSString stringWithFormat:@"%@.%@",self.pinpaiNameStr,self.storeNameStr];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:aaa];
    NSInteger pinpaiNameLength = self.pinpaiNameStr.length;
    NSInteger storeNameLength = self.storeNameStr.length;
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,pinpaiNameLength)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0,pinpaiNameLength)];
    
    [title addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(240, 173, 184) range:NSMakeRange(pinpaiNameLength+1, storeNameLength)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(pinpaiNameLength+1, storeNameLength)];
    
    self.myTitleLabel.attributedText = title;
    
    
    _mysegment=[[CustomSegmentView alloc]initWithFrame:CGRectMake(12, 12, DEVICE_WIDTH-24, 30)];
    _mysegment.backgroundColor = [UIColor lightGrayColor];
    [_mysegment setAllViewWithArray:[NSArray arrayWithObjects:@"ios7_newsunselect.png",@"ios7_fbunselect.png",@"ios7_userunselect.png", @"ios7_newsselected.png",@"ios7_fbselected.png",@"userselected.png",nil]];
    [_mysegment settitleWitharray:[NSArray arrayWithObjects:@"新品",@"折扣",@"热销", nil]];
    // mysegment.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"segbackground.png"]];
    [self.view addSubview:_mysegment];
    _mysegment.delegate=self;
    
    
    
}

#pragma mark - CustomSegmentViewDelegate
-(void)buttonClick:(int)buttonSelected{
    NSLog(@"buttonSelect:%d",buttonSelected);
    
    _page = 1;
    _per_page = 10;
    
    NSString *api = nil;
    if (buttonSelected == 0) {//新品
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"bytime",self.storeIdStr,_page,_per_page];
        
    }else if (buttonSelected == 1){//折扣
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"bydiscount",self.storeIdStr,_page,_per_page];
    }else if (buttonSelected == 2){//热销
        api = [NSString stringWithFormat:@"%@&action=%@&mb_id=%@&page=%d&per_page=%d",HOME_CLOTH_STORE_PINPAILIST,@"byhot",self.storeIdStr,_page,_per_page];
    }
    
    NSLog(@"请求的接口%@",api);
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result : %@",result);
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
