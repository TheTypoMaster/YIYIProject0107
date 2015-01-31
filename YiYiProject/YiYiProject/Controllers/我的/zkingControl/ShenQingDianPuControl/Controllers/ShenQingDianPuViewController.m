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
#import "GChooseStoreViewController.h"
#import "NSDictionary+GJson.h"
#import "GchooseFloorPinpaiViewController.h"
#import "LTools.h"
#import "GchooseAdressViewController.h"


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
    
    
    
    
    
    
    //精品店相关
    UILabel *_diquLabel_jingpin;
    
    
    
    //商品店相关
    //门牌号
    UITextField *_menpaihaoTf;
    //电话
    UITextField *_phoneTf;
    //验证码
    UITextField *_yanzhengmaTf;
    //验证码按钮
    UIButton *_yanzhengBtn_shangchang;
    //计时器
    NSTimer *_timer_shangchang;
    //计时数
    int _timeNum_shangchang;
    
    
    
    
    //精品店相关
    UIButton *_yanzhengBtn_jingpin;
    //计时器
    NSTimer *_timer_jingpin;
    //计时数
    int _timeNum_jingpin;
    

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
    self.chooseTextFieldArray = [NSMutableArray arrayWithCapacity:1];
    
    
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
    _pickeView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, DEVICE_WIDTH, 216)];
    _pickeView.delegate = self;
    _pickeView.dataSource = self;
    _isChooseArea = NO;
    
    
    NSLog(@"%@",NSStringFromCGRect(_pickeView.frame));
    
    
    //确定按钮
    UIButton *quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quedingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [quedingBtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    quedingBtn.frame = CGRectMake(DEVICE_WIDTH-70, 5, 60, 40);
    quedingBtn.layer.borderWidth = 1;
    quedingBtn.layer.borderColor = [[UIColor blackColor]CGColor];
    quedingBtn.layer.cornerRadius = 5;
    [quedingBtn addTarget:self action:@selector(areaHidden) forControlEvents:UIControlEventTouchUpInside];

    //地区选择
    self.backPickView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 310)];
    self.backPickView .backgroundColor = [UIColor whiteColor];
    
    [self.backPickView addSubview:quedingBtn];
    [self.backPickView addSubview:_pickeView];
    
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"garea" ofType:@"plist"];
    _data = [NSArray arrayWithContentsOfFile:path];
    
    [self.view addSubview:self.backPickView];
    
    
}

#pragma mark - 地区选择

//地区出现
-(void)areaShow{
    NSLog(@"_backPickView");
    __weak typeof (self)bself = self;
    [UIView animateWithDuration:0.3 animations:^{
        bself.backPickView.frame = CGRectMake(0,DEVICE_HEIGHT-310, DEVICE_WIDTH, 310);
    }];
    
    
}

-(void)areaHidden{//地区隐藏
    __weak typeof (self)bself = self;
    
    NSLog(@"省:%@ 市:%@",self.province,self.city);
    
    [UIView animateWithDuration:0.3 animations:^{
        bself.backPickView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 310);
        if (_jingpingdianView.hidden) {
            UILabel *diquLabel = self.chooseLabelArray[0];
            diquLabel.text = [NSString stringWithFormat:@"选择地区  %@%@",self.province,self.city];
        }else if (_shanchangdianView.hidden){
            _diquLabel_jingpin.text = [NSString stringWithFormat:@"%@%@",self.province,self.city];

        }
        
        
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
        //字符转id
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
        //字符转id
        NSString *pppccc = [NSString stringWithFormat:@"%@%@",self.province,self.city];
        self.cityIn = [GMAPI cityIdForName:pppccc];//上传
        
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
    _shanchangdianView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT+58*3);
    _shanchangdianView.hidden = YES;
    [self.view addSubview:_shanchangdianView];
    
    //精品
    [self createJingPinDianView];
    
    //商场店
    [self createShangchangdianView];
    
    
}

//创建商场店view
-(void)createShangchangdianView{
    UIView *witheBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 300)];
    
    witheBgView.backgroundColor=[UIColor whiteColor];
    [_shanchangdianView addSubview:witheBgView];
    
    NSArray *titleArr=@[@"选择地区",@"选择商场",@"选择楼层品牌",@"门牌号",@"电话",@"验证码"];
    
    for (int i=0; i<6; i++) {
        
        
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
        
        
        if (i == 3) {//门牌号
            _menpaihaoTf = [[UITextField alloc]initWithFrame:CGRectMake(55, 0, title_Label.frame.size.width, title_Label.frame.size.height)];
            _menpaihaoTf.font = [UIFont systemFontOfSize:17];
            _menpaihaoTf.textColor = RGBCOLOR(95, 95, 95);
            _menpaihaoTf.delegate = self;
            [title_Label addSubview:_menpaihaoTf];
            [self.chooseTextFieldArray addObject:_menpaihaoTf];
        }else if (i == 4){//电话
            _phoneTf = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, title_Label.frame.size.width, title_Label.frame.size.height)];
            _phoneTf.keyboardType = UIKeyboardTypePhonePad;
            _phoneTf.font = [UIFont systemFontOfSize:17];
            _phoneTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            _phoneTf.textColor = RGBCOLOR(95, 95, 95);
            _phoneTf.delegate = self;
            [title_Label addSubview:_phoneTf];
            [self.chooseTextFieldArray addObject:_phoneTf];
        }else if (i == 5){//验证码
            _yanzhengmaTf = [[UITextField alloc]initWithFrame:CGRectMake(55, 0, title_Label.frame.size.width, title_Label.frame.size.height)];
            _yanzhengmaTf.keyboardType = UIKeyboardTypePhonePad;
            _yanzhengmaTf.font = [UIFont systemFontOfSize:17];
            _yanzhengmaTf.textColor = RGBCOLOR(95, 95, 95);
            _yanzhengmaTf.delegate = self;
            [title_Label addSubview:_yanzhengmaTf];
            [self.chooseTextFieldArray addObject:_yanzhengmaTf];
            
            //获取验证码
            _yanzhengBtn_shangchang = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yanzhengBtn_shangchang setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_yanzhengBtn_shangchang setTitleColor:RGBCOLOR(95, 95, 95) forState:UIControlStateNormal];
            _yanzhengBtn_shangchang.titleLabel.font = [UIFont systemFontOfSize:12];
            [_yanzhengBtn_shangchang addTarget:self action:@selector(yanzheng_shangchang) forControlEvents:UIControlEventTouchUpInside];
            [_yanzhengBtn_shangchang setFrame:CGRectMake(DEVICE_WIDTH-100-17, 0, 90, title_Label.frame.size.height)];
            [title_Label addSubview:_yanzhengBtn_shangchang];
            
        }
        
        
        
    }
    
    UIButton *commitButton=[LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(20, 340, DEVICE_WIDTH-40, 44) normalTitle:@"提交" image:nil backgroudImage:nil superView:witheBgView target:self action:@selector(tijiao:)];
    
    commitButton.tag=300;
    commitButton.backgroundColor=RGBCOLOR(208, 40, 73);
    
    CALayer *l = [commitButton layer];   //获取ImageView的层
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.0f];
    
    [_shanchangdianView addSubview:commitButton];

}



//申请商场店获取验证码
-(void)yanzheng_shangchang{
    
    
    //网络请求
    
    
    if ([LTools isValidateMobile:_phoneTf.text]) {
        NSString *api = [NSString stringWithFormat:PHONE_YANZHENGMA_SHENQINGSHANGCHANGDIAN,_phoneTf.text];
        GmPrepareNetData *ccc =[[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            
            NSLog(@"%@",result);
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            
        }];
        
        
        _timer_shangchang = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtnTitle_shangchang) userInfo:nil repeats:YES];
        [_timer_shangchang fire];
        
        _timeNum_shangchang = 60;
        
        [_yanzhengBtn_shangchang setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum_shangchang] forState:UIControlStateNormal];
        _yanzhengBtn_shangchang.userInteractionEnabled = NO;
        
        
    }else{
        [GMAPI showAutoHiddenMBProgressWithText:@"请输入正确的手机号" addToView:self.view];
    }
    
    
    
    
    
    
    
    
    
    
}

-(void)changeBtnTitle_shangchang{//商场
    
    
    
    _yanzhengBtn_shangchang.titleLabel.font = [UIFont systemFontOfSize:12];
    _timeNum_shangchang--;
    [_yanzhengBtn_shangchang setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum_shangchang] forState:UIControlStateNormal];
    
    if (_timeNum_shangchang == 0) {
        [_yanzhengBtn_shangchang setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer_shangchang invalidate];
        _yanzhengBtn_shangchang.userInteractionEnabled = YES;
    }
}



//商场店选择手势
-(void)tapClicked:(UIGestureRecognizer *)sender{
    NSInteger tapIdTag = sender.view.tag;
    NSLog(@"sender.tag = %ld",(long)tapIdTag);
    [self gShou];
    
    if (tapIdTag == 1000) {//地区选择
        UILabel *shangchangLabel = (UILabel*)[self.view viewWithTag:1001];
        UILabel *loucengpinpaiLabel = (UILabel *)[self.view viewWithTag:1002];
        shangchangLabel.text = @"选择商场";
        loucengpinpaiLabel.text = @"选择楼层品牌";
        [self areaShow];
    }else if (tapIdTag == 1001){//选择商场
        UILabel *diquLabel = (UILabel*)[self.view viewWithTag:1000];
        if (diquLabel.text.length<=4) {
            [GMAPI showAutoHiddenMBProgressWithText:@"请先选择地区" addToView:self.view];
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self prepareNetDataForStoreList];
        
    }else if (tapIdTag == 1002){//选择楼层品牌
        UILabel *shangchangLabel = (UILabel*)[self.view viewWithTag:1001];
        if (shangchangLabel.text.length<=4) {
            [GMAPI showAutoHiddenMBProgressWithText:@"请先选择商场" addToView:self.view];
            return;
        }
        
        [self prepareNetDataForFloorAndPinpai];
    }
}


//创建精品店view
-(void)createJingPinDianView{
    
    //收键盘
    //收键盘
    UIControl *backControl = [[UIControl alloc]initWithFrame:_jingpingdianView.bounds];
    [backControl addTarget:self action:@selector(gShou) forControlEvents:UIControlEventTouchDown];
    [_jingpingdianView addSubview:backControl];
    
    
    //背景色
    UIView *witheBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 300)];
    witheBgView.backgroundColor=[UIColor whiteColor];
    witheBgView.userInteractionEnabled = NO;
    [_jingpingdianView addSubview:witheBgView];
    
    
    NSArray *titleArr=@[@"地区",@"名称",@"地图选址",@"地址",@"电话",@"验证码"];

    for (int i=0; i<6; i++) {
        
        
        
        UILabel *title_Label=[LTools createLabelFrame:CGRectMake(17, i*50, 65, 50) title:titleArr[i] font:17 align:NSTextAlignmentLeft textColor:RGBCOLOR(95, 95, 95)];
        [_jingpingdianView addSubview:title_Label];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 50*i, DEVICE_WIDTH, 0.5)];
        lineView.backgroundColor=RGBCOLOR(229, 229, 229);
        [_jingpingdianView addSubview:lineView];
        
        UITextField *shuRuTextfield=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title_Label.frame), i*50, DEVICE_WIDTH-17-title_Label.frame.size.width-17, 50)];
        
        shuRuTextfield.tag=10000+i;
        [self.shuruTextFieldArray addObject:shuRuTextfield];
        shuRuTextfield.delegate = self;
        [_jingpingdianView addSubview:shuRuTextfield];
        
        if (i ==2) {
            shuRuTextfield.hidden = YES;
            title_Label.frame = CGRectMake(17, i*50, 70, 50);
            UILabel *jingweiduLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title_Label.frame)+10, i*50, DEVICE_WIDTH-17-title_Label.frame.size.width-17, 50)];
            jingweiduLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jingweiduTap:)];
            [jingweiduLabel addGestureRecognizer:labelTap];
            [_jingpingdianView addSubview:jingweiduLabel];
            
            
        }
        
        
        if (i == 0) {
            shuRuTextfield.hidden = YES;
            _diquLabel_jingpin = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title_Label.frame), i*50, DEVICE_WIDTH-17-title_Label.frame.size.width-17, 50)];
            _diquLabel_jingpin.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap_diqu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(diqu_jingpin)];
            [_diquLabel_jingpin addGestureRecognizer:tap_diqu];
            [_jingpingdianView addSubview:_diquLabel_jingpin];
            
        }
        
        
        //电话
        if (i == 4) {
            shuRuTextfield.keyboardType = UIKeyboardTypePhonePad;
        }
        
        
        //获取验证码
        if (i == 5) {
            [shuRuTextfield setFrame:CGRectMake(CGRectGetMaxX(title_Label.frame), i*50, DEVICE_WIDTH-17-title_Label.frame.size.width-17-90, 50)];
            shuRuTextfield.keyboardType = UIKeyboardTypePhonePad;
            //获取验证码
            _yanzhengBtn_jingpin = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yanzhengBtn_jingpin setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_yanzhengBtn_jingpin setTitleColor:RGBCOLOR(95, 95, 95) forState:UIControlStateNormal];
            _yanzhengBtn_jingpin.titleLabel.font = [UIFont systemFontOfSize:12];
            [_yanzhengBtn_jingpin addTarget:self action:@selector(yanzheng_jingpin) forControlEvents:UIControlEventTouchUpInside];
            [_yanzhengBtn_jingpin setFrame:CGRectMake(DEVICE_WIDTH-100, shuRuTextfield.frame.origin.y, 90, shuRuTextfield.frame.size.height)];
            NSLog(@"%@",NSStringFromCGRect(_yanzhengBtn_jingpin.frame));
            NSLog(@"%@",NSStringFromCGRect(shuRuTextfield.frame));
            [_jingpingdianView addSubview:_yanzhengBtn_jingpin];
        }
        
        
        
        
        
        
    }
    
    UIButton *commitButton=[LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(20, 340, DEVICE_WIDTH-40, 44) normalTitle:@"提交" image:nil backgroudImage:nil superView:_jingpingdianView target:self action:@selector(tijiao:)];
    commitButton.tag=400;
    commitButton.backgroundColor=RGBCOLOR(208, 40, 73);
    
    CALayer *l = [commitButton layer];   //获取ImageView的层
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.0f];
    
    [_jingpingdianView addSubview:commitButton];

}


-(void)diqu_jingpin{
    [self areaShow];
}



//获取验证码 精品店
-(void)yanzheng_jingpin{
    //网络请求
    
    UITextField *tf = (UITextField*)[self.view viewWithTag:10004];
    NSLog(@"%@",tf.text);
    if ([LTools isValidateMobile:tf.text]) {
        
        NSString *api = [NSString stringWithFormat:PHONE_YANZHENGMA_SHENQINGSHANGCHANGDIAN,tf.text];
        GmPrepareNetData *ccc =[[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            
        }];
        
        
        _timer_jingpin = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtnTitle_jingpin) userInfo:nil repeats:YES];
        [_timer_jingpin fire];
        
        _timeNum_jingpin = 60;
        
        [_yanzhengBtn_jingpin setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum_jingpin] forState:UIControlStateNormal];
        _yanzhengBtn_jingpin.userInteractionEnabled = NO;
        
        
    }else{
        [GMAPI showAutoHiddenMBProgressWithText:@"请输入正确的手机号" addToView:self.view];
    }
}


//更改精品店验证码按钮状态
-(void)changeBtnTitle_jingpin{
    _yanzhengBtn_jingpin.titleLabel.font = [UIFont systemFontOfSize:12];
    _timeNum_jingpin--;
    [_yanzhengBtn_jingpin setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum_jingpin] forState:UIControlStateNormal];
    
    if (_timeNum_jingpin == 0) {
        [_yanzhengBtn_jingpin setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer_jingpin invalidate];
        _yanzhengBtn_jingpin.userInteractionEnabled = YES;
    }
}



//跳地图选点
-(void)jingweiduTap:(UITapGestureRecognizer*)sender{
    GchooseAdressViewController *ccc = [[GchooseAdressViewController alloc]init];
    ccc.delegate = (UILabel *)sender.view;
    ccc.delegate2 = self;
    
    [self.navigationController pushViewController:ccc animated:YES];
}


//提交申请
-(void)tijiao:(UIButton *)sender{
    
    [self gShou];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
    
    
    if (sender.tag==400)//申请精品店
    {
        //authkey
        NSString *authkey = [GMAPI getAuthkey];
        //店铺名
        UITextField *tf = (UITextField*)[self.view viewWithTag:10001];
        NSString *mall_name =tf.text;
        //地址
        UITextField *tf1 = (UITextField*)[self.view viewWithTag:10003];
        NSString *street = tf1.text;
        //电话
        UITextField *tf2 = (UITextField*)[self.view viewWithTag:10004];
        NSString *mobile = tf2.text;
        //验证码
        UITextField *tf3 = (UITextField *)[self.view viewWithTag:10005];
        NSString *code = tf3.text;
        //维度
        CGFloat lat = self.location_jingpindian.latitude;
        //经度
        CGFloat lon = self.location_jingpindian.longitude;
        //省份id
        NSInteger province_id = 0;
        if (_jingpingdianView.hidden == NO) {
            province_id = self.provinceIn;
        }
        
        //城市id
        NSInteger city_id = 0;
        if (_jingpingdianView.hidden == NO) {
            city_id = self.cityIn;
        }
        
        NSString *post = [NSString stringWithFormat:@"&mall_name=%@&street=%@&mobile=%@&code=%@&mall_type=%@&latitude=%f&longitude=%f&province_id=%ld&city_id=%ld&authcode=%@",mall_name,street,mobile,code,@"2",lat,lon,(long)province_id,(long)city_id,authkey];
        
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *url = [NSString stringWithFormat:SHENQINGJINGPINDIAN];
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"-->%@",result);
            NSLog(@"msg:%@",[result objectForKey:@"msg"]);
            [GMAPI showAutoHiddenMBProgressWithText:[result objectForKey:@"msg"] addToView:self.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SHENQINGDIANPU_SUCCESS object:nil];
            [self performSelector:@selector(shenqingtijiao) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"faildic==%@",failDic);
            
            [LTools showMBProgressWithText:failDic[@"msg"] addToView:self.view];
        }];
        
        
    }else if(sender.tag==300){//申请商场店
        //商场id
        NSString *mall_id = self.mallId;
        //楼层id
        NSString *floor_id = self.floor;
        //品牌id
        NSString *brand_id = self.pinpaiId;
        //门牌号
        NSString *door_num = _menpaihaoTf.text;
        //手机号
        NSString *mobile = _phoneTf.text;
        //验证码
        NSString *code = _yanzhengmaTf.text;
        
        NSString *post = [NSString stringWithFormat:@"&mall_id=%@&floor_id=%@&brand_id=%@&door_num=%@&mobile=%@&code=%@&authcode=%@",mall_id,floor_id,brand_id,door_num,mobile,code,[GMAPI getAuthkey]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *url = [NSString stringWithFormat:SHENQINGSHANGCHANGDIAN];
        GmPrepareNetData *ccc = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:postData];
        [ccc requestCompletion:^(NSDictionary *result, NSError *erro) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",result);
            if ([[result stringValueForKey:@"errorcode"]intValue] == 0) {
                [GMAPI showAutoHiddenMBProgressWithText:@"提交成功" addToView:self.view];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SHENQINGDIANPU_SUCCESS object:nil];
                [self performSelector:@selector(shenqingtijiao) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
            }
            
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"faildic==%@",failDic);
            
            [GMAPI showMBProgressWithText:failDic[@"msg"] addToView:self.view];
        }];
        
    }
    

}


-(void)shenqingtijiao{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textField.tag = %ld",(long)textField.tag);
    
    
    //精品店相关
    if (textField.tag == 10005||textField.tag == 10003 || textField.tag == 10004) {//申请精品店的 电话 验证码 选项
        _jingpingdianView.scrollEnabled = YES;
        if (_jingpingdianView.contentOffset.y>=58) {
            
        }else{
            _jingpingdianView.contentOffset = CGPointMake(0, 58);
        }
        
    }
    
    
    //商品店相关
    if (textField == _menpaihaoTf) {//门牌号
        _shanchangdianView.scrollEnabled = YES;
        if (_shanchangdianView.contentOffset.y>=58) {
            
        }else{
            _shanchangdianView.contentOffset = CGPointMake(0, 58);
        }
    }else if (textField == _phoneTf){//电话
        _shanchangdianView.scrollEnabled = YES;
        if (_shanchangdianView.contentOffset.y>=108) {
            
        }else{
            _shanchangdianView.contentOffset = CGPointMake(0, 108);
        }
    }else if (textField == _yanzhengmaTf){//验证码
        _shanchangdianView.scrollEnabled = YES;
        if (_shanchangdianView.contentOffset.y>=158) {
            
        }else{
            _shanchangdianView.contentOffset = CGPointMake(0, 158);
        }
    }
    
    
    
}




-(void)gShou{
    NSLog(@"收键盘了");
    
    //精品店相关
    if (_jingpingdianView.contentOffset.y>=58) {
        _jingpingdianView.contentOffset = CGPointMake(0, 0);
    }
    for (UITextField *tf in self.shuruTextFieldArray) {
        [tf resignFirstResponder];
    }
    _jingpingdianView.scrollEnabled = NO;
    
    //商场店相关
    if (_shanchangdianView.contentOffset.y >=58) {
        _shanchangdianView.contentOffset = CGPointMake(0, 0);
    }
    for (UITextField *tf in self.chooseTextFieldArray) {
        [tf resignFirstResponder];
    }
    _shanchangdianView.scrollEnabled = NO;
    
}



//通过所选地区请求商店列表
-(void)prepareNetDataForStoreList{
    
    NSLog(@"%ld %ld",(long)self.provinceIn,(long)self.cityIn);
    
    NSString *api = [NSString stringWithFormat:STORELISTWITHPROVINCEANDCITY,NSStringFromInt(self.provinceIn),NSStringFromInt(self.cityIn)];
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSString *total = [result stringValueForKey:@"total"];
            int totalInt = [total intValue];
            if (totalInt == 0) {
                [GMAPI showAutoHiddenMBProgressWithText:@"此地区暂无开通此项服务" addToView:self.view];
            }else{
                
                NSDictionary *listDic = [result dictionaryValueForKey:@"list"];
                NSArray *keysArray = [listDic allKeys];
                
                NSMutableArray *storeArray = [NSMutableArray arrayWithCapacity:1];
                for (NSString *key in keysArray) {
                    [storeArray addObject:[listDic objectForKey:key]];
                }
                
                GChooseStoreViewController *ccc = [[GChooseStoreViewController alloc]init];
                ccc.delegate = self;
                UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:ccc];
                ccc.dataArray = (NSArray *)storeArray;
                [self presentViewController:navc animated:YES completion:^{
                    
                }];
                
            }
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    }];
    
    
    
}


//请求某一商场所有楼层品牌
-(void)prepareNetDataForFloorAndPinpai{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *api = nil;
    if (self.mallId) {
        api = [NSString stringWithFormat:STOREALLFLOORPINPAI,self.mallId];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",result);
        
        GchooseFloorPinpaiViewController *ccc = [[GchooseFloorPinpaiViewController alloc]init];
        ccc.delegate = self;
        ccc.havePinpaiFloordic = [result dictionaryValueForKey:@"list"];
        
        
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:ccc];
        
        [self presentViewController:navc animated:YES completion:^{
            
        }];
        
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
    }];
    
}





@end
