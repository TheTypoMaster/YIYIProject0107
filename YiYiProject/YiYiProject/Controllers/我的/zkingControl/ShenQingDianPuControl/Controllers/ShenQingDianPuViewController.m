//
//  ShenQingDianPuViewController.m
//  YiYiProject
//
//  Created by szk on 15/1/5.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ShenQingDianPuViewController.h"
#import "GRootScrollView.h"
#import "GtopScrollView.h"

@interface ShenQingDianPuViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{

    UIView *_indicator;
    
    
    UIScrollView *_jingpingdianView;
    UIScrollView *_shanchangdianView;
    
    //地区选择
    UIPickerView *_pickeView;
    NSArray *_data;//地区数据
    NSInteger _flagRow;//pickerView地区标志位
    //地区数据字符串拼接
    NSString *_str3;
    NSString *_str1;
    NSString *_str2;
    BOOL _isChooseArea;//是否修改了地区

}
//地区相关
@property(nonatomic,strong)UIView *backPickView;//地区选择pickerView后面的背景view
@property(nonatomic,strong)NSString *province;//省
@property(nonatomic,strong)NSString *city;//城市
@property(nonatomic,assign)NSInteger provinceIn;//省份对应id
@property(nonatomic,assign)NSInteger cityIn;//市区对应id

@end

@implementation ShenQingDianPuViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden=NO;
    

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];

    self.navigationController.navigationBarHidden=YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.myTitle=@"申请店铺";
    
    self.view.backgroundColor=RGBCOLOR(239, 239, 239);
    
    //分配内存
    self.shuruTextFieldArray = [NSMutableArray arrayWithCapacity:1];
    self.chooseLabelArray = [NSMutableArray arrayWithCapacity:1];
    
    //创建按钮view
    [self createSegButton];
    
    //创建内容view
    [self createViews];
    
    //创建地区选择pickerview
    [self createAreaPickView];
    
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gShou) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    // Do any additional setup after loading the view.
}




-(void)createAreaPickView{
    //地区pickview
    _pickeView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 20, DEVICE_WIDTH, 216)];
    _pickeView.delegate = self;
    _pickeView.dataSource = self;
    _isChooseArea = NO;
    
    
    //确定按钮
    UIButton *quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quedingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [quedingBtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    quedingBtn.frame = CGRectMake(270, 0, 35, 30);
    [quedingBtn addTarget:self action:@selector(areaHidden) forControlEvents:UIControlEventTouchUpInside];
    //上下横线
    UIView *shangxian = [[UIView alloc]initWithFrame:CGRectMake(270, 5, 35, 0.5)];
    shangxian.backgroundColor = [UIColor blackColor];
    UIView *xiaxian = [[UIView alloc]initWithFrame:CGRectMake(270, 25, 35, 0.5)];
    xiaxian.backgroundColor = [UIColor blackColor];

    //地区选择
    self.backPickView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 216+30)];
    self.backPickView .backgroundColor = [UIColor whiteColor];
    [self.backPickView addSubview:shangxian];
    [self.backPickView addSubview:xiaxian];
    [self.backPickView addSubview:quedingBtn];
    [self.backPickView addSubview:_pickeView];
    
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
    _data = [NSArray arrayWithContentsOfFile:path];
    
    [self.view addSubview:self.backPickView];
    
    
}

#pragma mark - 地区选择

//地区出现
-(void)areaShow{
    NSLog(@"_backPickView");
    __weak typeof (self)bself = self;
    [UIView animateWithDuration:0.3 animations:^{
        bself.backPickView.frame = CGRectMake(0,DEVICE_HEIGHT-216-30, DEVICE_WIDTH, 216);
    }];
    
    
}

-(void)areaHidden{//地区隐藏
    __weak typeof (self)bself = self;
    [UIView animateWithDuration:0.3 animations:^{
        bself.backPickView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, iPhone5?444:360);
        
    }];
    
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _data.count;
    } else if (component == 1) {
        NSArray * cities = _data[_flagRow][@"Cities"];
        return cities.count;
    }
    return 0;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
            if ([_data[row][@"State"] isEqualToString:@"省份"]) {
                self.province = @"";
            }else{
                self.province = _data[row][@"State"];
            }
        
        NSString *provinceStr = [NSString stringWithFormat:@"%@",_data[row][@"State"]];
//        //字符转id
        self.provinceIn = [GMAPI cityIdForName:provinceStr];//上传
        return provinceStr;
        
        
    } else if (component == 1) {
        NSArray * cities = _data[_flagRow][@"Cities"];
        if ([cities[row][@"city"] isEqualToString:@"市区县"]) {
            self.city = @"";
        }else{
            self.city = cities[row][@"city"];
        }
        NSString *cityStr = [NSString stringWithFormat:@"%@",cities[row][@"city"]];
//        //字符转id
        self.cityIn = [GMAPI cityIdForName:cityStr];//上传
        return cityStr;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        _flagRow = row;
        _isChooseArea = YES;
    }else if (component == 1){
        _isChooseArea = YES;
    }
    
    [pickerView reloadAllComponents];
}




#pragma mark--切换精品店和商场店

- (void)createSegButton
{
    UIView *segView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 58)];
    segView.backgroundColor = RGBCOLOR(239, 239, 239);
    [self.view addSubview:segView];
    
    NSArray *titles = @[@"精品店",@"商场店"];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.frame = CGRectMake(DEVICE_WIDTH/2.f * i, 0, DEVICE_WIDTH/2.f, 45);
        [btn setBackgroundColor:[UIColor whiteColor]];
        [segView addSubview:btn];
        [btn addTarget:self action:@selector(clickToSwap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _indicator = [[UIView alloc]initWithFrame:CGRectMake(0, 43, DEVICE_WIDTH/2.f, 2)];
    _indicator.backgroundColor = [UIColor colorWithHexString:@"ea5670"];
    [segView addSubview:_indicator];
}


- (void)clickToSwap:(UIButton *)sender
{
    
    
    
    [self gShou];
    
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:100];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
    if (sender.tag == 100) {
        btn1.selected = YES;
        btn2.selected = NO;
        _indicator.left = 0;
        _jingpingdianView.hidden = NO;
        _shanchangdianView.hidden = YES;
    }else
    {
        btn1.selected = NO;
        btn2.selected = YES;
        _indicator.left = DEVICE_WIDTH/2.f;
        _jingpingdianView.hidden = YES;
        _shanchangdianView.hidden = NO;
    }
}


#pragma mark--精品店的view


- (void)createViews
{
    
    
    
    //精品店
    _jingpingdianView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 58, DEVICE_WIDTH, DEVICE_HEIGHT - 58)];
    _jingpingdianView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT+58+58);
    _jingpingdianView.scrollEnabled = NO;
    [self.view addSubview:_jingpingdianView];
    
    //商场店
    _shanchangdianView = [[UIScrollView alloc]initWithFrame:_jingpingdianView.frame];
    _shanchangdianView.hidden = YES;
    [self.view addSubview:_shanchangdianView];
    
    //精品
    [self createJingPinDianView];
    
    //商场店
    [self createShangchangdianView];
    
    
}

-(void)createShangchangdianView{
    UIView *witheBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 350)];
    
    witheBgView.backgroundColor=[UIColor whiteColor];
    [_shanchangdianView addSubview:witheBgView];
    
    NSArray *titleArr=@[@"选择地区",@"选择商场",@"选择楼层",@"选择品牌",@"门牌号",@"电话",@"验证码"];
    
    for (int i=0; i<7; i++) {
        
        
        UILabel *title_Label=[LTools createLabelFrame:CGRectMake(17, i*50, DEVICE_WIDTH-17-17, 50) title:titleArr[i] font:17 align:NSTextAlignmentLeft textColor:RGBCOLOR(95, 95, 95)];
        [witheBgView addSubview:title_Label];
        title_Label.userInteractionEnabled = YES;
        title_Label.tag = 1000+i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
        [title_Label addGestureRecognizer:tap];
        
        
        [self.chooseLabelArray addObject:title_Label];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 50*i, DEVICE_WIDTH, 0.5)];
        lineView.backgroundColor=RGBCOLOR(229, 229, 229);
        [witheBgView addSubview:lineView];
        
        
        
//        UITextField *shuRuTextfield=[[UITextField alloc]initWithFrame:CGRectMake(100, i*50, DEVICE_WIDTH, 50)];
//        shuRuTextfield.tag=200+i;
//        [witheBgView addSubview:shuRuTextfield];
        
    }
    
    UIButton *commitButton=[LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(20, 390, DEVICE_WIDTH-40, 44) normalTitle:@"提交" image:nil backgroudImage:nil superView:witheBgView target:self action:@selector(tijiao:)];
    
    commitButton.tag=300;
    commitButton.backgroundColor=RGBCOLOR(208, 40, 73);
    
    CALayer *l = [commitButton layer];   //获取ImageView的层
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.0f];
    
    [_shanchangdianView addSubview:commitButton];

}

//商场店选择手势
-(void)tapClicked:(UIGestureRecognizer *)sender{
    NSInteger tapIdTag = sender.view.tag;
    NSLog(@"sender.tag = %ld",(long)tapIdTag);
    
    if (tapIdTag == 1000) {//地区选择
        [self areaShow];
    }
}


-(void)createJingPinDianView{
    
    //收键盘
    //收键盘
    UIControl *backControl = [[UIControl alloc]initWithFrame:_jingpingdianView.bounds];
    [backControl addTarget:self action:@selector(gShou) forControlEvents:UIControlEventTouchDown];
    [_jingpingdianView addSubview:backControl];
    
    
    //背景色
    UIView *witheBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 200)];
    witheBgView.backgroundColor=[UIColor whiteColor];
    witheBgView.userInteractionEnabled = NO;
    [_jingpingdianView addSubview:witheBgView];
    
    
    NSArray *titleArr=@[@"名称",@"地址",@"电话",@"验证码"];

    for (int i=0; i<4; i++) {
        
        
        
        UILabel *title_Label=[LTools createLabelFrame:CGRectMake(17, i*50, 65, 50) title:titleArr[i] font:17 align:NSTextAlignmentLeft textColor:RGBCOLOR(95, 95, 95)];
        [_jingpingdianView addSubview:title_Label];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 50*i, DEVICE_WIDTH, 0.5)];
        lineView.backgroundColor=RGBCOLOR(229, 229, 229);
        [_jingpingdianView addSubview:lineView];
        
        UITextField *shuRuTextfield=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title_Label.frame), i*50, DEVICE_WIDTH-17-title_Label.frame.size.width-17, 50)];
        shuRuTextfield.tag=100+i;
        [self.shuruTextFieldArray addObject:shuRuTextfield];
        shuRuTextfield.delegate = self;
        [_jingpingdianView addSubview:shuRuTextfield];
        
        
        
        
    }
    
    UIButton *commitButton=[LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(20, 290, DEVICE_WIDTH-40, 44) normalTitle:@"提交" image:nil backgroudImage:nil superView:_jingpingdianView target:self action:@selector(tijiao:)];
    commitButton.tag=400;
    commitButton.backgroundColor=RGBCOLOR(208, 40, 73);
    
    CALayer *l = [commitButton layer];   //获取ImageView的层
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.0f];
    
    [_jingpingdianView addSubview:commitButton];

}


-(void)tijiao:(UIButton *)sender{
    
    
    
    /*mall_name 商铺名称 string 限制30字以内
     mall_type 商铺类型(商场小店), 1 商场 2 精品店
     mobile 手机号 code 验证码 latitude 维度, 小数点后8
     longitude 经度, 小数点后8
     floor_num 楼层 int
     province_id 省id int
     city_id 市id int
     disctrict_id 区id, int
     street 街道地址 string
     authcode 约定好的code 判断店铺所有人*/
    
    
    if (sender.tag==400)//申请普通精品小店
    {
        [self gShou];
        
        NSString *authkey = [GMAPI getAuthkey];
        
        
        
        NSString *post = [NSString stringWithFormat:@"&mall_name=%@&street=%@&mobile=%@&code=%@&mall_type=%@&authkey=%@",@"SS",@"知春路",@"18600912932",@"213",@"1",authkey];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *url = [NSString stringWithFormat:KAITONG_DIANPU_URL];
        LTools *tool = [[LTools alloc]initWithUrl:url isPost:YES postData:postData];
        [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
            
            NSLog(@"-->%@",result);
            
            
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            
            
            NSLog(@"faildic==%@",failDic);
            
            [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
        }];
        
        
    }else if(sender.tag==300)//申请商场店
    {
        
    
    }
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    NSLog(@"textField.tag = %ld",(long)textField.tag);
    
    _jingpingdianView.scrollEnabled = YES;
    if (textField.tag == 102||textField.tag == 103) {//电话 验证码
        if (_jingpingdianView.contentOffset.y>=58) {
            
        }else{
            _jingpingdianView.contentOffset = CGPointMake(0, 58);
        }
        
    }
    
}




-(void)gShou{
    NSLog(@"收键盘了");
    if (_jingpingdianView.contentOffset.y>=58) {
        _jingpingdianView.contentOffset = CGPointMake(0, 0);
    }
    for (UITextField *tf in self.shuruTextFieldArray) {
        [tf resignFirstResponder];
    }
    _jingpingdianView.scrollEnabled = NO;
}

@end
