//
//  MyYiChuViewController.m
//  YiYiProject
//
//  Created by szk on 14/12/27.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "MyYiChuViewController.h"
#import "UploadPicViewController.h"
#import "ClasscationClothesViewController.h"
#import "FreeCollocationViewController.h"
@interface MyYiChuViewController ()
{
    UIScrollView *_rootScrollView ;//根rootScrollView
    UIView       *_maskView;//遮罩层
    UITextField  *_textField;//输入文本框
    NSMutableArray  *_dataSourceArray;
    UIView *_fenGeView;
    UIView       *_editMaskView;//修改遮罩层
    UIView *editBgView;
    UIView *editNameBgView;
    NSDictionary *editCurentDic;//要编辑的当前分类
}
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
    self.rightImageName = @"chun_down";
    _dataSourceArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createRootScrollView];
    [self createHeadView];
    [self createRightBarItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareMyYiChuListData) name:@"refreshMyYiChuList" object:nil];
    //先读取缓存 然后网络请求数据 更新缓存
    _dataSourceArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"myYiChuCaCh"] objectForKey:@"list"];
    if(_dataSourceArray.count > 0)
    {
        [self createListViewWithFrame:_fenGeView.frame listArray:_dataSourceArray];
    }
    [self prepareMyYiChuListData];
    // Do any additional setup after loading the view.
}
-(void)createRightBarItem
{
    UIButton *rightBarItem = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 111/3.0, 111/3.0) normalTitle:nil image:nil backgroudImage:[UIImage imageNamed:@"t_paizhao"] superView:nil target:self action:@selector(rightBtnClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarItem];
    
}
//创建滑动的scrollView
-(void)createRootScrollView
{
     _rootScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _rootScrollView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:_rootScrollView];
}
//顶部创建两个按钮 - 添加分类 我要搭配
-(void)createHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 65)];
    headView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [_rootScrollView addSubview:headView];
    
    float buttonWintht = (DEVICE_WIDTH - 25 -11) / 2.0;
    UIButton *addClassificationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addClassificationButton.frame = CGRectMake(25/2.0, 25/2.0,buttonWintht, 40);
    addClassificationButton.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
    [addClassificationButton setTitle:@"添加分类" forState:UIControlStateNormal];
    addClassificationButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [addClassificationButton setTitleColor:[UIColor colorWithHexString:@"848484"] forState:UIControlStateNormal];
    [addClassificationButton setTitleColor:[UIColor colorWithHexString:@"848484"] forState:UIControlStateHighlighted];
    [addClassificationButton.layer setMasksToBounds:YES];
    [addClassificationButton.layer setCornerRadius:5];//设置矩形是个圆角半径
    [addClassificationButton.layer setBorderWidth:0.5];//边框宽度
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGColorRef colorRef=CGColorCreate(colorSpace, (CGFloat[]){204/255.0,204/255.0,204/255.0,1});
    [addClassificationButton.layer setBorderColor:colorRef];
    [addClassificationButton addTarget:self action:@selector(addClassiButonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:addClassificationButton];
    
    UIButton *myMatchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    myMatchButton.frame = CGRectMake(DEVICE_WIDTH-25/2.0-buttonWintht, 25/2.0,buttonWintht, 40);
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
    [headView addSubview:myMatchButton];
    
    _fenGeView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y+headView.frame.size.height, DEVICE_WIDTH, 12)];
    _fenGeView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [_rootScrollView addSubview:_fenGeView];
    
}
//类别ImageView
-(void)createListViewWithFrame:(CGRect ) frame  listArray:(NSArray *) array
{
    
    for(UIImageView *imageView in _rootScrollView.subviews)
    {
        if(imageView.tag >= 100)
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
            
            UIView *titleViewLeft = [[UIView alloc] initWithFrame:CGRectMake(10, classificationImageView.height-10-22, 30, 22)];
            titleViewLeft.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            titleViewLeft.layer.cornerRadius = 10.f;
            titleViewLeft.clipsToBounds = YES;
            [classificationImageView addSubview:titleViewLeft];
            
            
            UILabel *titleLabelLeft = [LTools createLabelFrame:titleViewLeft.bounds title:@"" font:13 align:NSTextAlignmentCenter textColor:[UIColor colorWithHexString:@"ffffff"]];
            [titleViewLeft addSubview:titleLabelLeft];
            
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
                    titleLabel.text = [[_dataSourceArray objectAtIndex:j +i*2] objectForKey:@"sort_name"];
                    NSDictionary *dic = [array objectAtIndex:j +i*2];
                    NSArray * array = [dic objectForKey:@"clothes"];
                    if(array.count > 0)
                    {
                        NSDictionary *dicSmall = [array objectAtIndex:0];
                        [classificationImageView sd_setImageWithURL:[NSURL URLWithString:[dicSmall objectForKey:@"image_url"]]];
                    }
                    titleLabelLeft.text = [NSString stringWithFormat:@"%ld",array.count];
                }
            }
            else
            {
                titleLabel.text = [[_dataSourceArray objectAtIndex:j +i*2] objectForKey:@"sort_name"];
                NSDictionary *dic = [array objectAtIndex:j +i*2];
                NSArray * array = [dic objectForKey:@"clothes"];
                if(array.count > 0)
                {
                    NSDictionary *dicSmall = [array objectAtIndex:0];
                    [classificationImageView sd_setImageWithURL:[NSURL URLWithString:[dicSmall objectForKey:@"image_url"]]];
                }
                 titleLabelLeft.text = [NSString stringWithFormat:@"%ld",array.count];
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
//隐藏手势
-(void)hiddenMaskView:(UIButton *) sender
{
    _maskView.hidden = YES;
    [_textField resignFirstResponder];
}
//添加名字确定
-(void)confirmBtonClick:(UIButton *) sender
{
    if(_textField.text.length == 0)
    {
        return;
    }
    NSString *api = [NSString stringWithFormat:GET_ADDCLASSICATION_URL,_textField.text,[GMAPI getAuthkey]];
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
        {
            [self prepareMyYiChuListData];
            [self hiddenMaskView];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"%@",failDic);
        
    }];
    
}
//添加名字取消
-(void)cancelBtonClick:(UIButton *) sender
{
    _maskView.hidden = YES;
    _textField.text = @"";
    [_textField resignFirstResponder];
}
//隐藏遮罩层
-(void)hiddenMaskView
{
    _maskView.hidden = YES;
    _textField.text = @"";
    [_textField resignFirstResponder];
}
//隐藏编辑的遮罩层
-(void)hiddenEditMaskView
{
    _editMaskView.hidden = YES;
}
//点击搭配类别进入的界面
-(void)listTap:(UITapGestureRecognizer *) tap
{
    ClasscationClothesViewController *classcationVC = [[ClasscationClothesViewController alloc] init];
    classcationVC -> sourceDic = [_dataSourceArray objectAtIndex:tap.view.tag - 100];
    [self.navigationController pushViewController:classcationVC animated:YES];
}
//长按搭配类别
-(void)listLongPress:(UILongPressGestureRecognizer *) longPress
{
    editCurentDic = [_dataSourceArray objectAtIndex:longPress.view.tag - 100];
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
            UIButton *addClassificationButton = [UIButton buttonWithType:UIButtonTypeSystem];
            addClassificationButton.frame = CGRectMake(0,i*editBgView.height/3,buttonWintht, editBgView.height/3);
            addClassificationButton.tag = 101 +i;
            addClassificationButton.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
            [addClassificationButton setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            addClassificationButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [addClassificationButton setTitleColor:[UIColor colorWithHexString:@"848484"] forState:UIControlStateNormal];
            [addClassificationButton setTitleColor:[UIColor colorWithHexString:@"848484"] forState:UIControlStateHighlighted];
            [addClassificationButton.layer setMasksToBounds:YES];
            [addClassificationButton.layer setCornerRadius:5];//设置矩形是个圆角半径
            [addClassificationButton.layer setBorderWidth:0.5];//边框宽度
            CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
            CGColorRef colorRef=CGColorCreate(colorSpace, (CGFloat[]){204/255.0,204/255.0,204/255.0,1});
            [addClassificationButton.layer setBorderColor:colorRef];
            [addClassificationButton addTarget:self action:@selector(editButonClick:) forControlEvents:UIControlEventTouchUpInside];
            [editBgView addSubview:addClassificationButton];
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
-(void)editButonClick:(UIButton *) sender
{
    if(sender.tag == 101)
    {
        editBgView.hidden = YES;
        editNameBgView.hidden = NO;
        _textField.text = [editCurentDic objectForKeyedSubscript:@"sort_name"];
    }
    //删除分类
    if(sender.tag == 102)
    {
        NSString *api = [NSString stringWithFormat:GET_DELETECLASSICATION_URL,[editCurentDic objectForKey:@"sort_id"],[GMAPI getAuthkey]];
        GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
        [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
            if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
            {
                [self prepareMyYiChuListData];
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
-(void)editCancelBtonClick:(UIButton *) sender
{
    _editMaskView.hidden = YES;
    [_textField resignFirstResponder];
}

-(void)editConfirmBtonClick:(UIButton *) sender
{
    if(_textField.text.length == 0)
    {
        return;
    }
    NSString *api = [NSString stringWithFormat:GET_EDITCLASSICATION_URL,[editCurentDic objectForKey:@"sort_id"],_textField.text,[GMAPI getAuthkey]];
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
        {
            [self prepareMyYiChuListData];
            _editMaskView.hidden = YES;
        }
        NSLog(@"%@",result);
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"%@",failDic);
        
    }];
    _editMaskView.hidden = YES;
    [_textField resignFirstResponder];
}
-(void)rightBtnClick:(UIButton *) sender
{
    UIActionSheet *selectPhotoSheet=[[UIActionSheet alloc]initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    selectPhotoSheet.actionSheetStyle=UIActionSheetStyleDefault;
    [selectPhotoSheet showInView:self.view];
}
#pragma mark--UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if(buttonIndex==0)
        {
            UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            }
            UIImagePickerController *picker=[[UIImagePickerController alloc]init];
            picker.delegate=self;
            picker.sourceType=sourceType;
            //picker.allowsEditing=YES;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
            
        }else if(buttonIndex==1)
        {
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.maximumNumberOfSelection = 9;
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            picker.showEmptyGroups=NO;
            picker.delegate=self;
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 5;
                } else {
                    return YES;
                }
            }];
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
    
}
#pragma mark--ZYQAssetPickerControllerDelegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;
{
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:1];
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [imageArray addObject:tempImg];
        }

    UploadPicViewController *uplpaoadVC = [[UploadPicViewController alloc] init];
    uplpaoadVC ->imageArray = imageArray;
    [self.navigationController pushViewController:uplpaoadVC animated:NO];
}
#pragma mark--UIImagePickerControllerDelegate 
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageNew = [info objectForKey:UIImagePickerControllerOriginalImage];
     NSMutableArray *imageArray = [NSMutableArray arrayWithObject:imageNew];
    [picker dismissViewControllerAnimated:YES completion:^{
        UploadPicViewController *uplpaoadVC = [[UploadPicViewController alloc] init];
        uplpaoadVC ->imageArray = imageArray;
        [self.navigationController pushViewController:uplpaoadVC animated:NO];
        
    }];
    
    
}
#pragma mark--获取整体数据

-(void)prepareMyYiChuListData{
    NSString *api = [NSString stringWithFormat:GET_MYYICHU_LIST_URL,[GMAPI getAuthkey]];
    
    NSLog(@"api===%@",api);
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
        {
            _dataSourceArray = [result objectForKey:@"list"];
            //缓存
            [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"myYiChuCaCh"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self createListViewWithFrame:_fenGeView.frame listArray:_dataSourceArray];
        }
        
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
