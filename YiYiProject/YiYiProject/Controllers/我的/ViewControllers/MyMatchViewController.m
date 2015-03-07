//
//  MyMatchViewController.m
//  YiYiProject
//
//  Created by unisedu on 15/1/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyMatchViewController.h"
#import "ClasscationClothesViewController.h"
#import "FreeCollocationViewController.h"
#import "MyMatchDetailViewController.h"
@interface MyMatchViewController ()
{
    UIView * _maskView;
    UITextField * _textField;
    NSDictionary *_sourceDic;//数据字典
    UIScrollView *_rootScrollView;
    NSInteger selectIndex;//当前选择的风格
    UIButton *addClassificationButton;
    NSDictionary *editCurentDic;
    UIView *_editMaskView;
    UIView *editBgView;
    UIView *editNameBgView;
}
@end

@implementation MyMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.myTitle=@"我的搭配";
    selectIndex = 1;
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRootScrollView];
   _sourceDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyMatchcach"];
    if(_sourceDic)
    {
       [self createViewsWithDic:_sourceDic];
    }
    [self getNetData];
}
-(void)createViewsWithDic:(NSDictionary *) dic
{
    if(_rootScrollView.subviews.count > 0)
    {
    for(UIView *imageView in _rootScrollView.subviews)
    {
        if(imageView.tag > 1000)
        {
            [imageView removeFromSuperview];
        }
    }
    }
    float tempWindth = (DEVICE_WIDTH-25-70*4)/3.0;
    NSArray *mainArray = [[dic objectForKey:@"list"] objectForKey:@"main_styles"];
    UIButton *chunBtn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(25/2.0, 25/2.0, 70, 70) normalTitle:[[mainArray objectAtIndex:0] objectForKey:@"style_name"] image:nil backgroudImage:nil superView:_rootScrollView target:self action:@selector(styleButnClick:)];
    [chunBtn setBackgroundImage:[UIImage imageNamed:@"chun_up"] forState:UIControlStateNormal];
    [chunBtn setBackgroundImage:[UIImage imageNamed:@"chun_down"] forState:UIControlStateSelected];
    chunBtn.tag = 1001;
    UIButton *xiaBtn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(chunBtn.frame.origin.x+chunBtn.width+tempWindth, 25/2.0, 70, 70) normalTitle:[[mainArray objectAtIndex:1] objectForKey:@"style_name"] image:nil backgroudImage:nil superView:_rootScrollView target:self action:@selector(styleButnClick:)];
    [xiaBtn setBackgroundImage:[UIImage imageNamed:@"xia_up"] forState:UIControlStateNormal];
    [xiaBtn setBackgroundImage:[UIImage imageNamed:@"xia_down"] forState:UIControlStateSelected];
     xiaBtn.tag = 1002;
    
    UIButton *qiuBtn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(xiaBtn.frame.origin.x+xiaBtn.width+tempWindth, 25/2.0, 70, 70) normalTitle:[[mainArray objectAtIndex:2] objectForKey:@"style_name"] image:nil backgroudImage:nil superView:_rootScrollView target:self action:@selector(styleButnClick:)];
    [qiuBtn setBackgroundImage:[UIImage imageNamed:@"qiu_up"] forState:UIControlStateNormal];
    [qiuBtn setBackgroundImage:[UIImage imageNamed:@"qiu_down"] forState:UIControlStateSelected];
    qiuBtn.tag = 1003;
    
    UIButton *dongBtn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(qiuBtn.frame.origin.x+qiuBtn.width+tempWindth, 25/2.0, 70, 70) normalTitle:[[mainArray objectAtIndex:3] objectForKey:@"style_name"] image:nil backgroudImage:nil superView:_rootScrollView target:self action:@selector(styleButnClick:)];
    [dongBtn setBackgroundImage:[UIImage imageNamed:@"dong_up"] forState:UIControlStateNormal];
    [dongBtn setBackgroundImage:[UIImage imageNamed:@"dong_down"] forState:UIControlStateSelected];
    dongBtn.tag = 1004;
    
    UIButton * selBtn = (UIButton *)[_rootScrollView viewWithTag:1000+selectIndex];
    selBtn.selected = YES;
    
     float buttonWintht = (DEVICE_WIDTH - 25 -11) / 2.0;
    addClassificationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addClassificationButton.frame = CGRectMake(25/2.0, dongBtn.frame.origin.y + dongBtn.frame.size.height+25,buttonWintht, 40);
    addClassificationButton.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
    [addClassificationButton setTitle:@"添加分类" forState:UIControlStateNormal];
    addClassificationButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [addClassificationButton setTitleColor:[UIColor colorWithHexString:@"848484"] forState:UIControlStateNormal];
    [addClassificationButton setTitleColor:[UIColor colorWithHexString:@"848484"] forState:UIControlStateHighlighted];
    addClassificationButton.tag = 1005;
    [addClassificationButton.layer setMasksToBounds:YES];
    [addClassificationButton.layer setCornerRadius:5];//设置矩形是个圆角半径
    [addClassificationButton.layer setBorderWidth:0.5];//边框宽度
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGColorRef colorRef=CGColorCreate(colorSpace, (CGFloat[]){204/255.0,204/255.0,204/255.0,1});
    [addClassificationButton.layer setBorderColor:colorRef];
    [addClassificationButton addTarget:self action:@selector(addClassiButonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rootScrollView addSubview:addClassificationButton];
    
    
    UIButton *myMatchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    myMatchButton.frame = CGRectMake(DEVICE_WIDTH-25/2.0-buttonWintht, addClassificationButton.frame.origin.y,buttonWintht, 40);
    myMatchButton.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
    [myMatchButton setTitle:@"我要搭配" forState:UIControlStateNormal];
    myMatchButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [myMatchButton setTitleColor:[UIColor colorWithHexString:@"848484"] forState:UIControlStateNormal];
    [myMatchButton setTitleColor:[UIColor colorWithHexString:@"848484"] forState:UIControlStateHighlighted];
    [myMatchButton.layer setMasksToBounds:YES];
    [myMatchButton.layer setCornerRadius:5];//设置矩形是个圆角半径
    [myMatchButton.layer setBorderWidth:0.5];//边框宽度
    [myMatchButton.layer setBorderColor:colorRef];
    [myMatchButton addTarget:self action:@selector(myMatchButonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rootScrollView addSubview:myMatchButton];
    [self createListViewWithFrame:addClassificationButton.frame listArray:[[[_sourceDic objectForKey:@"list"] objectForKey:@"c_styles"] objectForKey:[NSString stringWithFormat:@"%ld",selectIndex]]];
}
//类别ImageView
-(void)createListViewWithFrame:(CGRect ) frame  listArray:(NSArray *) array
{
    
    for(UIImageView *imageView in _rootScrollView.subviews)
    {
        if(imageView.tag >= 100 && imageView.tag < 1000)
        {
            [imageView removeFromSuperview];
        }
    }
    float imageViewWindth = (DEVICE_WIDTH - 25 -11) / 2.0;
    int columnNum = 2;//列数
    int rowNum = (int)(array.count/2 +array.count%2);//行数
    float sourceX = 25/2.0;
    float sourceY = frame.origin.y+frame.size.height+25/2.0;
    for(int i = 0; i < rowNum ; i++)
    {
        for(int j = 0 ;j < columnNum ; j++)
        {
            UIImageView *classificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(sourceX, sourceY, imageViewWindth, imageViewWindth)];
            classificationImageView.backgroundColor = RGBCOLOR(255,155,155);
            CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
            CGColorRef colorRef=CGColorCreate(colorSpace, (CGFloat[]){204/255.0,204/255.0,204/255.0,1});
            [classificationImageView.layer setCornerRadius:5];//设置矩形是个圆角半径
            [classificationImageView.layer setBorderWidth:0.5];//边框宽度
            [classificationImageView.layer setBorderColor:colorRef];
            classificationImageView.tag = 100 + j +i*2;
            classificationImageView.userInteractionEnabled = YES;
            [_rootScrollView addSubview:classificationImageView];
            
            UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(classificationImageView.width-10-50, classificationImageView.height-10-22, 50, 22)];
            titleView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            titleView.layer.cornerRadius = 10.f;
            titleView.clipsToBounds = YES;
            [classificationImageView addSubview:titleView];
            
            UILabel *titleLabel = [LTools createLabelFrame:titleView.bounds title:@"" font:13 align:NSTextAlignmentCenter textColor:[UIColor colorWithHexString:@"ffffff"]];
            [titleView addSubview:titleLabel];
            
            sourceX = sourceX+imageViewWindth+11;
            //如果数组是奇数个 那么移除最后一个视图
            if(array.count%2 != 0)
            {
                if(i == rowNum - 1 && j == columnNum -1)
                {
                    [classificationImageView removeFromSuperview];
                }
                else
                {
                    titleLabel.text = [[array objectAtIndex:j +i*2] objectForKey:@"style_name"];
                }
            }
            else
            {
                titleLabel.text = [[array objectAtIndex:j +i*2] objectForKey:@"style_name"];
            }
            
            //点击事件
            UITapGestureRecognizer *listTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listTap:)];
            [classificationImageView addGestureRecognizer:listTap];
            
            //长按事件
            
            UILongPressGestureRecognizer *listLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(listLongPress:)];
            [classificationImageView addGestureRecognizer:listLongPress];
        }
        sourceX = 25/2.0;
        sourceY = sourceY+imageViewWindth +11;
    }
    
    _rootScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, sourceY+imageViewWindth);
}
//点击搭配类别进入的界面
-(void)listTap:(UITapGestureRecognizer *) tap
{
    MyMatchDetailViewController *myMatchDetailVC = [[MyMatchDetailViewController alloc] init];
    myMatchDetailVC -> sourceDic = [[[[_sourceDic objectForKey:@"list"] objectForKey:@"c_styles"] objectForKey:[NSString stringWithFormat:@"%ld",selectIndex]] objectAtIndex:tap.view.tag - 100];
    [self.navigationController pushViewController:myMatchDetailVC animated:YES];
}
//长按搭配类别
-(void)listLongPress:(UILongPressGestureRecognizer *) longPress
{
    editCurentDic = [[[[_sourceDic objectForKey:@"list"] objectForKey:@"c_styles"] objectForKey:[NSString stringWithFormat:@"%ld",selectIndex]] objectAtIndex:longPress.view.tag - 100];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(!_editMaskView)
        {
            UIWindow *currentWindow =(UIWindow*) [UIApplication sharedApplication].keyWindow;
            _editMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
            _editMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            [currentWindow addSubview:_editMaskView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenEditMaskView)];
            [_editMaskView addGestureRecognizer:tapGesture];
            
            editBgView = [[UIView alloc] initWithFrame:CGRectMake(80,(self.view.height - 80)/2.0, self.view.width - 80*2,150)];
            editBgView.backgroundColor = [UIColor whiteColor];
            editBgView.layer.cornerRadius = 5.f;
            editBgView.clipsToBounds = YES;
            [_editMaskView addSubview:editBgView];
            
            NSArray *titleArray = @[@"修改名称",@"删除分类",@"取消"];
            for(int i = 0; i < 3 ;i++)
            {
                float buttonWintht = editBgView.width;
                UIButton *addClassification = [UIButton buttonWithType:UIButtonTypeSystem];
                addClassification.frame = CGRectMake(0,i*editBgView.height/3,buttonWintht, editBgView.height/3);
                addClassification.tag = 101 +i;
                addClassification.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
                [addClassification setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
                addClassification.titleLabel.font = [UIFont systemFontOfSize:16];
                [addClassification setTitleColor:[UIColor colorWithHexString:@"848484"] forState:UIControlStateNormal];
                [addClassification setTitleColor:[UIColor colorWithHexString:@"848484"] forState:UIControlStateHighlighted];
                [addClassification.layer setMasksToBounds:YES];
                [addClassification.layer setCornerRadius:5];//设置矩形是个圆角半径
                [addClassification.layer setBorderWidth:0.5];//边框宽度
                CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
                CGColorRef colorRef=CGColorCreate(colorSpace, (CGFloat[]){204/255.0,204/255.0,204/255.0,1});
                [addClassification.layer setBorderColor:colorRef];
                [addClassification addTarget:self action:@selector(editButonClick:) forControlEvents:UIControlEventTouchUpInside];
                [editBgView addSubview:addClassification];
            }
            
            editNameBgView = [[UIView alloc] initWithFrame:CGRectMake(22,(self.view.height -150)/2.0, self.view.width - 22*2,150)];
            editNameBgView.backgroundColor = [UIColor whiteColor];
            editNameBgView.layer.cornerRadius = 5.f;
            editNameBgView.clipsToBounds = YES;
            editNameBgView.hidden = YES;
            [_editMaskView addSubview:editNameBgView];
            
            UIView *line_hor = [[UIView alloc]initWithFrame:CGRectMake(0, 44 , editNameBgView.width, 0.5)];
            line_hor.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
            [editNameBgView addSubview:line_hor];
            
            UILabel *titleLabel = [LTools createLabelFrame:CGRectMake((editNameBgView.width-16*6)/2.0, 15, 96, 13) title:@"修改分类名称" font:16 align:NSTextAlignmentCenter textColor:[UIColor colorWithHexString:@"000000"]];
            [editNameBgView addSubview:titleLabel];
            
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, line_hor.frame.origin.y+line_hor.frame.size.height+20,editNameBgView.width - 20*2, 40)];
            _textField.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
            _textField.keyboardType =  UIKeyboardTypeDefault;
            [editNameBgView addSubview:_textField];
            
            UIButton *cancelButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 44, 44) normalTitle:@"" image:[UIImage imageNamed:@"my_sc_guanbi"] backgroudImage:nil superView:editNameBgView target:self action:@selector(editCancelBtonClick:)];
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cancelButton.imageEdgeInsets = UIEdgeInsetsMake((44-14)/2.0, (44-21)/2.0, (44-14)/2.0, (44-21)/2.0);
            
            UIButton *confirmButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(editNameBgView.width-44, 0, 44, 44) normalTitle:@"" image:[UIImage imageNamed:@"my_sc_dui"] backgroudImage:nil superView:editNameBgView target:self action:@selector(editConfirmBtonClick:)];
            [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            confirmButton.imageEdgeInsets = UIEdgeInsetsMake((44-14)/2.0, (44-21)/2.0, (44-14)/2.0, (44-21)/2.0);
        }
        else
        {
            _editMaskView.hidden = NO;
            editBgView.hidden = NO;
            editNameBgView.hidden = YES;
        }
    }
}
//创建滑动的scrollView
-(void)createRootScrollView
{
    _rootScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _rootScrollView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:_rootScrollView];
}
#pragma mark--ButtonClickMethod
//点击事件-添加分类
-(void)addClassiButonClick:(UIButton *) sender
{
    if(!_maskView)
    {
        UIWindow *currentWindow =(UIWindow*) [UIApplication sharedApplication].keyWindow;
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [currentWindow addSubview:_maskView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMaskView:)];
        [_maskView addGestureRecognizer:tapGesture];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(22,(self.view.height -150)/2.0, self.view.width - 22*2,150)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5.f;
        bgView.clipsToBounds = YES;
        [_maskView addSubview:bgView];
        
        UIView *line_hor = [[UIView alloc]initWithFrame:CGRectMake(0, 44 , bgView.width, 0.5)];
        line_hor.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        [bgView addSubview:line_hor];
        
        UILabel *titleLabel = [LTools createLabelFrame:CGRectMake((bgView.width-16*4)/2.0, 15, 64, 13) title:@"添加分类" font:16 align:NSTextAlignmentCenter textColor:[UIColor colorWithHexString:@"000000"]];
        [bgView addSubview:titleLabel];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, line_hor.frame.origin.y+line_hor.frame.size.height+20,bgView.width - 20*2, 40)];
        _textField.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
        _textField.keyboardType =  UIKeyboardTypeDefault;
        [bgView addSubview:_textField];
        
        UIButton *cancelButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 44, 44) normalTitle:@"" image:[UIImage imageNamed:@"my_sc_guanbi"] backgroudImage:nil superView:bgView target:self action:@selector(cancelBtonClick:)];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.imageEdgeInsets = UIEdgeInsetsMake((44-14)/2.0, (44-21)/2.0, (44-14)/2.0, (44-21)/2.0);
        
        UIButton *confirmButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(bgView.width-44, 0, 44, 44) normalTitle:@"" image:[UIImage imageNamed:@"my_sc_dui"] backgroudImage:nil superView:bgView target:self action:@selector(confirmBtonClick:)];
        [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        confirmButton.imageEdgeInsets = UIEdgeInsetsMake((44-14)/2.0, (44-21)/2.0, (44-14)/2.0, (44-21)/2.0);
        
    }
    else
    {
        _maskView.hidden = NO;
    }
}
//点击事件-我要搭配
-(void)myMatchButonClick:(UIButton *) sender
{
    FreeCollocationViewController *freeCollocationVC = [[FreeCollocationViewController alloc] init];
    freeCollocationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:freeCollocationVC animated:YES];
}
-(void)editConfirmBtonClick:(UIButton *) sender
{
    if(_textField.text.length == 0)
    {
        return;
    }
    NSString *api = [NSString stringWithFormat:GET_EDITSTYLENAME_URL,[NSString stringWithFormat:@"%@",[editCurentDic objectForKey:@"style_id"]],_textField.text,[GMAPI getAuthkey]];
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
        {
            [self getNetData];
            _editMaskView.hidden = YES;
        }
        NSLog(@"%@",result);
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"%@",failDic);
        
    }];
    _editMaskView.hidden = YES;
    [_textField resignFirstResponder];
}
-(void)editButonClick:(UIButton *) sender
{
    if(sender.tag == 101)
    {
        editBgView.hidden = YES;
        editNameBgView.hidden = NO;
        _textField.text = [editCurentDic objectForKeyedSubscript:@"style_name"];
    }
    //删除分类
    if(sender.tag == 102)
    {
        NSString *api = [NSString stringWithFormat:GET_DELETESTYLENAME_URL,[editCurentDic objectForKey:@"style_id"],[GMAPI getAuthkey]];
        GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
        [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
            if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
            {
                [self getNetData];
                _editMaskView.hidden = YES;
            }
            NSLog(@"%@",result);
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            NSLog(@"%@",failDic);
            
        }];
    }
    if(sender.tag == 103)
    {
        _editMaskView.hidden = YES;
    }
}
//隐藏编辑的遮罩层
-(void)hiddenEditMaskView
{
    _editMaskView.hidden = YES;
}
-(void)editCancelBtonClick:(UIButton *) sender
{
    _editMaskView.hidden = YES;
    [_textField resignFirstResponder];
}
//隐藏手势
-(void)hiddenMaskView:(UIButton *) sender
{
    _maskView.hidden = YES;
    [_textField resignFirstResponder];
}
//添加名字取消
-(void)cancelBtonClick:(UIButton *) sender
{
    _maskView.hidden = YES;
    _textField.text = @"";
    [_textField resignFirstResponder];
}

//添加名字确定
-(void)confirmBtonClick:(UIButton *) sender
{
    if(_textField.text.length == 0)
    {
        return;
    }
    NSString *api = [NSString stringWithFormat:GET_ADDSTYLE_URL,[NSString stringWithFormat:@"%ld",selectIndex],_textField.text,[GMAPI getAuthkey]];
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
        {
            [self getNetData];
            [self hiddenMaskView];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"%@",failDic);
        
    }];
    
}

//隐藏遮罩层
-(void)hiddenMaskView
{
    _maskView.hidden = YES;
    _textField.text = @"";
    [_textField resignFirstResponder];
}
-(void)styleButnClick:(UIButton *) sender
{
    [self otherBtnNoWitTag:sender.tag];
    selectIndex = sender.tag - 1000;
    [self createListViewWithFrame:addClassificationButton.frame listArray:[[[_sourceDic objectForKey:@"list"] objectForKey:@"c_styles"] objectForKey:[NSString stringWithFormat:@"%ld",selectIndex]]];
}
-(void)otherBtnNoWitTag:(NSInteger) tag
{
  for(UIButton *btn in _rootScrollView.subviews)
  {
      if([btn isKindOfClass:[UIButton class]])
      {
      if(btn.tag == tag)
      {
          btn.selected = YES;
      }
      else
      {
          btn.selected = NO;
      }
      }
  }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [[NSUserDefaults standardUserDefaults] setObject:_sourceDic forKey:@"MyMatchcach"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self createViewsWithDic:result];
    }
    NSLog(@"%@",result);
} failBlock:^(NSDictionary *failDic, NSError *erro) {
    NSLog(@"%@",failDic);
    
}];
    
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
