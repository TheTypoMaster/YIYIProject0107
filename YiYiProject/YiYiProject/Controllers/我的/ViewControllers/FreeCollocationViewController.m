//
//  FreeCollocationViewController.m
//  YiYiProject
//
//  Created by unisedu on 15/1/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "FreeCollocationViewController.h"
#import "ChooseClothesViewController.h"
@interface FreeCollocationViewController ()
{
    UIView *contentView ;
    UIView *_editMaskView;
    UIView *editBgView;
    NSDictionary *_sourceDic;
    NSInteger selectedIndex;
    NSArray *imageArray;
    NSString *sonId;
}
@end

@implementation FreeCollocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.myTitle= @"自由搭配";
    self.rightString = @"完成";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f0f1"];
    [self createViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addImageWithArray:) name:@"addImageWithArray" object:nil];
}
-(void)createViews
{
    contentView = [[UIView alloc] initWithFrame:CGRectMake(25, 25, DEVICE_WIDTH-50, (DEVICE_WIDTH-50)*1.4)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    UIButton *addImageBtn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(DEVICE_WIDTH-30-70, contentView.frame.origin.y+contentView.height+10, 70, 30) normalTitle:@"添加" image:nil backgroudImage:nil superView:self.view target:self action:@selector(addImageClick:)];
    addImageBtn.backgroundColor = [UIColor colorWithHexString:@"bebebe"];
    
}
-(void)addImageClick:(UIButton *) sender
{
    ChooseClothesViewController *chooseClothesVC = [[ChooseClothesViewController alloc] init];
    chooseClothesVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chooseClothesVC animated:YES];
}
-(void)addImageWithArray:(NSNotification *) sender
{
    imageArray = [sender object];
    float imageViewWindth = (contentView.width - 25 -22) / 3.0;
    float imageViewHeight = (contentView.height - 25 -22) / 3.0;
    
    float sourceX = 25/2.0;
    float sourceY = 25/2.0;
    for(int i = 0; i < 3 ; i++)
    {
        for(int j = 0 ; j < 3 ; j++)
        {
            UIImageView *classificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(sourceX, sourceY, imageViewWindth, imageViewHeight)];
            classificationImageView.backgroundColor = RGBCOLOR(180, 180, 180);
            CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
            CGColorRef colorRef=CGColorCreate(colorSpace, (CGFloat[]){204/255.0,204/255.0,204/255.0,1});
            [classificationImageView.layer setCornerRadius:5];//设置矩形是个圆角半径
            [classificationImageView.layer setBorderWidth:0.5];//边框宽度
            [classificationImageView.layer setBorderColor:colorRef];
            classificationImageView.tag = 100 + j +i*3;
            classificationImageView.userInteractionEnabled = YES;
            [contentView addSubview:classificationImageView];
            sourceX = sourceX+imageViewWindth+11;
            NSLog(@"lllll = %d",j +i*3);
            if(classificationImageView.tag-100 < imageArray.count)
            {
                [classificationImageView sd_setImageWithURL:[imageArray objectAtIndex:j +i*3]];
            }
            else
            {
                [classificationImageView removeFromSuperview];
            }
        }
        sourceX = 25/2.0;
        sourceY = sourceY+imageViewHeight +11;
    }
}
-(void)rightButtonTap:(UIButton *) sender
{
    UIWindow *currentWindow =(UIWindow*) [UIApplication sharedApplication].keyWindow;
    _editMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    _editMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [currentWindow addSubview:_editMaskView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenEditMaskView)];
    tapGesture.delegate = self;
    [_editMaskView addGestureRecognizer:tapGesture];
    
    editBgView = [[UIView alloc] initWithFrame:CGRectMake(80,(self.view.height - 80)/2.0, self.view.width - 80*2,150)];
    editBgView.backgroundColor = [UIColor whiteColor];
    editBgView.layer.cornerRadius = 5.f;
    editBgView.clipsToBounds = YES;
    [_editMaskView addSubview:editBgView];
    
    NSArray *titleArray = @[@"春季",@"夏季",@"秋季",@"冬季"];
    for(int i = 0; i < titleArray.count ;i++)
    {
        float buttonWintht = editBgView.width;
        UIButton *addClassificationButton = [UIButton buttonWithType:UIButtonTypeSystem];
        addClassificationButton.frame = CGRectMake(0,i*editBgView.height/4,buttonWintht, editBgView.height/4);
        addClassificationButton.tag = 101 +i;
        addClassificationButton.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
        [addClassificationButton setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        addClassificationButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [addClassificationButton setTitleColor:[UIColor colorWithHexString:@"848484"] forState:UIControlStateNormal];
        [addClassificationButton setTitleColor:[UIColor colorWithHexString:@"848484"] forState:UIControlStateHighlighted];
        [addClassificationButton.layer setMasksToBounds:YES];
        [addClassificationButton.layer setCornerRadius:5];//设置矩形是个圆角半径
        [addClassificationButton.layer setBorderWidth:0.2];//边框宽度
        CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
        CGColorRef colorRef=CGColorCreate(colorSpace, (CGFloat[]){204/255.0,204/255.0,204/255.0,1});
        [addClassificationButton.layer setBorderColor:colorRef];
        [addClassificationButton addTarget:self action:@selector(editButonClick:) forControlEvents:UIControlEventTouchUpInside];
        [editBgView addSubview:addClassificationButton];
    }
}

//隐藏编辑的遮罩层
-(void)hiddenEditMaskView
{
    _editMaskView.hidden = YES;
}
-(void)editButonClick:(UIButton *) sender
{
    selectedIndex = sender.tag - 100;
    [self getNetData];
  
}
-(void)createErJIFenLei
{
    for(UIView *view in editBgView.subviews)
    {
        if(view.tag > 100)
        {
            [view removeFromSuperview];
        }
    }
    UITableView *myTableView = [[UITableView alloc] initWithFrame:editBgView.bounds];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 150/4;
    [editBgView addSubview:myTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)uploadInfo
{
    if(imageArray.count == 0)
    {
        return;
    }
    //测试
    NSString *authkey = [GMAPI getAuthkey];
    NSString *photo = @"";
    for(NSString * imageUrl in imageArray)
    {
        photo = [photo stringByAppendingString:[NSString stringWithFormat:@",%@",imageUrl]];
    }
    photo = [photo substringFromIndex:1];
    
    NSString *post = [NSString stringWithFormat:@"authcode=%@&style_id=%@&style_pid=%ld&photo=%@",authkey,sonId,selectedIndex,photo];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *url = [NSString stringWithFormat:POST_ADDDAPEISTYLE_URL];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
       
    [_editMaskView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
    }];
}
#pragma mark--UIgestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
#pragma mark--获取网络数据
-(void)getNetData
{
    
    NSString *api = [NSString stringWithFormat:GET_GETMYSTYLE_URL,[GMAPI getAuthkey]];
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
        {
            _sourceDic = result;
            [self createErJIFenLei];
        }
        NSLog(@"%@",result);
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"%@",failDic);
        
    }];
    
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array = [[[_sourceDic objectForKey:@"list"] objectForKey:@"c_styles"] objectForKey:[NSString stringWithFormat:@"%ld",selectedIndex]];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"848484"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    NSArray * array = [[[_sourceDic objectForKey:@"list"] objectForKey:@"c_styles"] objectForKey:[NSString stringWithFormat:@"%ld",selectedIndex]] ;
    cell.textLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"style_name"];
    return cell;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      NSArray * array = [[[_sourceDic objectForKey:@"list"] objectForKey:@"c_styles"] objectForKey:[NSString stringWithFormat:@"%ld",selectedIndex]];
    sonId = [[array objectAtIndex:indexPath.row] objectForKey:@"style_id"];
    [self uploadInfo];
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
