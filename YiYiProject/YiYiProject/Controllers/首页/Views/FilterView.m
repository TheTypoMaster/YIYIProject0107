//
//  FilterView.m
//  YiYiProject
//
//  Created by lichaowei on 14/12/21.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "FilterView.h"

static const int kSexKadding = 1000;//性别
static const int kSortKadding = 2000;//排序
static const int kPriceKadding = 3000;//价格
static const int kFenleiKadding = 4000;//分类

@implementation FilterView

+ (id)shareInstance
{
    static dispatch_once_t once_t;
    static FilterView *dataBlock;
    
    dispatch_once(&once_t, ^{
        dataBlock = [[FilterView alloc]init];
    });
    
    return dataBlock;
}

- (instancetype)initWithStyle:(FilterStyle)style
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        CGFloat bgView_dis = 0.f; //控制bgView高度
        
        if (style == FilterStyle_NoSexAndSort) {
            
            bgView_dis = 140;
            
        }else if (style == FilterStyle_NoSort){
            
            bgView_dis = 70;
        }
        
        CGFloat bgViewHeight = 495 - bgView_dis;
        
        //适配 4s 和 5s 5
        
        if (DEVICE_WIDTH <= 320) {
            
            bgViewHeight = DEVICE_HEIGHT - 40 * 2 - 85 - (style == FilterStyle_NoSexAndSort ? 45 : 0);
        }
        
        bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(22, 0, self.width - 22 * 2, bgViewHeight)];
        bgView.backgroundColor = [UIColor whiteColor];
        [bgView addCornerRadius:5.f];
        [self addSubview:bgView];
        bgView.delegate = self;
        bgView.center = CGPointMake(bgView.center.x, DEVICE_HEIGHT/2.f);
        bgView.contentSize = CGSizeMake(bgView.width, 495 - bgView_dis);
        
        //-150
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)];
        [bgView addGestureRecognizer:tap];
        
        CGFloat priceTop = 0.f;
        CGFloat sortHeight = 31.f;
        
        if (style == FilterStyle_Default || style == FilterStyle_NoSort) {
            
            //性别选择
            
            UILabel *titleLabel = [LTools createLabelFrame:CGRectMake(24, 15, 100, 13) title:@"想看到的衣服" font:13 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"999999"]];
            [bgView addSubview:titleLabel];
            
            UIView *sexView = [[UIView alloc]initWithFrame:CGRectMake(18, titleLabel.bottom + 10, bgView.width - 18 * 2, 31)];
            sexView.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
            sexView.layer.cornerRadius = 5.f;
            sexView.layer.borderWidth = 1.f;
            sexView.layer.borderColor = [UIColor colorWithHexString:@"e2e2e2"].CGColor;
            sexView.clipsToBounds = YES;
            [bgView addSubview:sexView];
            
            priceTop = sexView.bottom;//

            NSArray *sex_titles = @[@"全部",@"  女",@"  男"];
            
            
            CGFloat sexWidth = (sexView.width - 2) / 3.f;
            
            for (int i = 0; i < 3; i ++) {
                
                UIButton *btn = [self buttonWithFrame:CGRectMake((sexWidth + 1) * i, 0, sexWidth, sexView.height) title:sex_titles[i] normalColor:[UIColor blackColor] selectedColor:[UIColor colorWithHexString:@"dc4c63"] fontSize:14 selector:@selector(selectSex:) tag:kSexKadding + i];
                [sexView addSubview:btn];
                
                if (i == 1) {
                    
                    [btn setImage:[UIImage imageNamed:@"shaixuan_girl"] forState:UIControlStateNormal];
                }
                
                if (i == 2) {
                    
                    [btn setImage:[UIImage imageNamed:@"shaixuan_boy"] forState:UIControlStateNormal];
                }
            }
            
            
            if (style == FilterStyle_Default) {
                
                //排序选择
                
                UILabel *sortLabel = [LTools createLabelFrame:CGRectMake(24, sexView.bottom + 15, 100, 13) title:@"排序选项" font:13 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"999999"]];
                [bgView addSubview:sortLabel];
                
                UIView *sortView = [[UIView alloc]initWithFrame:CGRectMake(18, sortLabel.bottom + 10, bgView.width - 18 * 2, 31)];
                sortView.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
                [sortView addCornerRadius:5.f];
                [sortView setBorderWidth:1.f borderColor:[UIColor colorWithHexString:@"e2e2e2"]];
                sortView.clipsToBounds = YES;
                [bgView addSubview:sortView];
                
                priceTop = sortView.bottom;//
                
                NSArray *sort_titles = @[@"距离优先",@"折扣优先"];
                CGFloat sortWidth = (sortView.width - 2) / 2.f;
                
                for (int i = 0; i < 2; i ++) {
                    
                    UIButton *btn = [self buttonWithFrame:CGRectMake((sortWidth + 1) * i, 0, sortWidth, sortView.height) title:sort_titles[i] normalColor:[UIColor blackColor] selectedColor:[UIColor colorWithHexString:@"dc4c63"] fontSize:14 selector:@selector(selectSort:) tag:kSortKadding + i];
                    [sortView addSubview:btn];
                }

            }
            
        }
        
        
        //价格区间
        
        UILabel *priceLabel = [LTools createLabelFrame:CGRectMake(24, priceTop + 15, 100, 13) title:@"价格区间" font:13 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"999999"]];
        [bgView addSubview:priceLabel];
        
        //低价
        _lowPrice = [[UITextField alloc]initWithFrame:CGRectMake(18, priceLabel.bottom + 10, 70, sortHeight)];
        [bgView addSubview:_lowPrice];
        _lowPrice.keyboardType = UIKeyboardTypeNumberPad;
        
        [_lowPrice setBorderWidth:1.f borderColor:[UIColor colorWithHexString:@"e2e2e2"]];
        [_lowPrice addCornerRadius:5.f];
        _lowPrice.font = [UIFont systemFontOfSize:12];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_lowPrice.right + 10, 0, 15, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        [bgView addSubview:line];
        line.centerY = _lowPrice.centerY;
        
        //高价
        _highPrice = [[UITextField alloc]initWithFrame:CGRectMake(_lowPrice.right + 20 + 15, priceLabel.bottom + 10, 70, sortHeight)];
        [bgView addSubview:_highPrice];
        _highPrice.keyboardType = UIKeyboardTypeNumberPad;
        _highPrice.font = [UIFont systemFontOfSize:12];
        
        
        [_highPrice setBorderWidth:1.f borderColor:[UIColor colorWithHexString:@"e2e2e2"]];
        [_highPrice addCornerRadius:5.f];
        
        //价格固定范围
        
        NSArray *priceArray = @[@"100以下",@"100-199",@"200-299",@"300-399",@"400-499",@"500以上",@"不限"];
        
        CGFloat sortWidth = (bgView.width - 18 * 2 - 3 * 10) / 4.f;
        
        CGFloat top = _highPrice.bottom + 15;
        
        for (int i = 0; i < priceArray.count; i ++) {
            
            UIButton *btn = [self buttonWithFrame:CGRectMake(18 + (sortWidth + 10) * (i % 4), _highPrice.bottom + 10 + (i / 4) * (sortHeight + 10), sortWidth, sortHeight) title:priceArray[i] normalColor:[UIColor blackColor] selectedColor:[UIColor colorWithHexString:@"dc4c63"] fontSize:12 selector:@selector(selectPrice:) tag:kPriceKadding + i];
            
            [btn setBorderWidth:1.f borderColor:[UIColor colorWithHexString:@"e2e2e2"]];
            [btn addCornerRadius:5.f];
            
            [bgView addSubview:btn];
            
            top = btn.bottom;
        }
        
        
        //分类
        
        UILabel *fenleiLabel = [LTools createLabelFrame:CGRectMake(24, top + 15, 100, 13) title:@"分类" font:13 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"999999"]];
        [bgView addSubview:fenleiLabel];
        
        
        //分类
        
        NSArray *fenleiArray = PRODUCT_FENLEI;
        
        sortWidth = (bgView.width - 18 * 2 - 3 * 10) / 5.f;
        
        for (int i = 0; i < fenleiArray.count; i ++) {
            
            UIButton *btn = [self buttonWithFrame:CGRectMake(18 + (sortWidth + 10) * (i % 5), fenleiLabel.bottom + 10 + (i / 5) * (sortHeight + 10), sortWidth, sortHeight) title:fenleiArray[i] normalColor:[UIColor blackColor] selectedColor:[UIColor colorWithHexString:@"dc4c63"] fontSize:12 selector:@selector(selectFenlei:) tag:kFenleiKadding + i];
            [btn setBorderWidth:1.f borderColor:[UIColor colorWithHexString:@"e2e2e2"]];
            [btn addCornerRadius:5.f];
            [bgView addSubview:btn];
            
            top = btn.bottom;
            
        }
        
        //重置按钮
        
        UIButton *resetButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, top + 15, 60, sortHeight) normalTitle:@"重置" image:nil backgroudImage:nil superView:nil target:self action:@selector(clickToReset:)];
        [bgView addSubview:resetButton];
        resetButton.backgroundColor = [UIColor colorWithHexString:@"f9da44"];
        [resetButton addCornerRadius:5.f];
        resetButton.titleLabel.font = [UIFont systemFontOfSize:12];
        resetButton.centerX = bgView.width / 2.f;
        
        //确定 取消
        
        UIView *line_hor = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.contentSize.height - 44 - 0.5, bgView.width, 0.5)];
        line_hor.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        [bgView addSubview:line_hor];
        
        CGFloat aWidth = (bgView.width - 1) / 2.f;
        UIButton *cancel_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, line_hor.bottom, aWidth, 44) normalTitle:@"取消" image:nil backgroudImage:nil superView:bgView target:self action:@selector(clickToCancel:)];
        [cancel_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel_btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        UIView *line_ver = [[UIView alloc]initWithFrame:CGRectMake(cancel_btn.right, bgView.contentSize.height - 44 - 0.5, 0.5, 44)];
        line_ver.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        [bgView addSubview:line_ver];
        
        UIButton *sure_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(cancel_btn.right + 0.5, line_hor.bottom, aWidth, 44) normalTitle:@"确定" image:nil backgroudImage:nil superView:bgView target:self action:@selector(clickToSure:)];
        [sure_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sure_btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        /**
         *  初始设置
         */
        [self selectSex:[self buttonForTag:kSexKadding]];
        [self selectSort:[self buttonForTag:kSortKadding]];
        [self selectFenlei:[self buttonForTag:kFenleiKadding]];
        
    }
    return self;
}


- (UIButton *)buttonWithFrame:(CGRect)aFrame
                       title:(NSString *)title
                 normalColor:(UIColor *)normalColor
               selectedColor:(UIColor *)selectedColor
                    fontSize:(CGFloat)fontSize
                    selector:(SEL)selector
                         tag:(int)tag
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = aFrame;
    [btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:normalColor forState:UIControlStateNormal];
    [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    return btn;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([FilterView class]) owner:self options:nil]lastObject];
        
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        
        CGFloat bgViewHeight = 495;
        
        //适配 4s 和 5s 5
        
        if (DEVICE_WIDTH <= 320) {
            
            bgViewHeight = DEVICE_HEIGHT - 40 * 2 - 85;
        }
        
        bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(22, 0, self.width - 22 * 2, bgViewHeight)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5.f;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        bgView.delegate = self;
        
        bgView.center = CGPointMake(bgView.center.x, DEVICE_HEIGHT/2.f);
        
        bgView.contentSize = CGSizeMake(bgView.width, 495);
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)];
        [bgView addGestureRecognizer:tap];

        //性别选择
        
        UILabel *titleLabel = [LTools createLabelFrame:CGRectMake(24, 15, 100, 13) title:@"想看到的衣服" font:13 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"999999"]];
        [bgView addSubview:titleLabel];
        
        UIView *sexView = [[UIView alloc]initWithFrame:CGRectMake(18, titleLabel.bottom + 10, bgView.width - 18 * 2, 31)];
        sexView.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        sexView.layer.cornerRadius = 5.f;
        sexView.layer.borderWidth = 1.f;
        sexView.layer.borderColor = [UIColor colorWithHexString:@"e2e2e2"].CGColor;
        sexView.clipsToBounds = YES;
        [bgView addSubview:sexView];
        
        
        NSArray *sex_titles = @[@"全部",@"  女",@"  男"];
        
        
        CGFloat sexWidth = (sexView.width - 2) / 3.f;
    
        for (int i = 0; i < 3; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((sexWidth + 1) * i, 0, sexWidth, sexView.height);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn setTitle:sex_titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"dc4c63"] forState:UIControlStateSelected];
            [sexView addSubview:btn];
            
            if (i == 1) {
                
                [btn setImage:[UIImage imageNamed:@"shaixuan_girl"] forState:UIControlStateNormal];
            }
            
            if (i == 2) {
                
                [btn setImage:[UIImage imageNamed:@"shaixuan_boy"] forState:UIControlStateNormal];
            }
            
            [btn addTarget:self action:@selector(selectSex:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.tag = kSexKadding + i;
        }
        
        
        //排序选择
        
        UILabel *sortLabel = [LTools createLabelFrame:CGRectMake(24, sexView.bottom + 15, 100, 13) title:@"排序选项" font:13 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"999999"]];
        [bgView addSubview:sortLabel];
        
        UIView *sortView = [[UIView alloc]initWithFrame:CGRectMake(18, sortLabel.bottom + 10, bgView.width - 18 * 2, 31)];
        sortView.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        sortView.layer.cornerRadius = 5.f;
        sortView.layer.borderWidth = 1.f;
        sortView.layer.borderColor = [UIColor colorWithHexString:@"e2e2e2"].CGColor;
        sortView.clipsToBounds = YES;
        [bgView addSubview:sortView];
        
        NSArray *sort_titles = @[@"距离优先",@"折扣优先"];
        CGFloat sortWidth = (sortView.width - 2) / 2.f;
        
        for (int i = 0; i < 2; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((sortWidth + 1) * i, 0, sortWidth, sortView.height);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn setTitle:sort_titles[i] forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"dc4c63"] forState:UIControlStateSelected];
            
            [sortView addSubview:btn];
            
            [btn addTarget:self action:@selector(selectSort:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = kSortKadding + i;
            
        }
        
        //价格区间
        
        UILabel *priceLabel = [LTools createLabelFrame:CGRectMake(24, sortView.bottom + 15, 100, 13) title:@"价格区间" font:13 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"999999"]];
        [bgView addSubview:priceLabel];
        
        //低价
        _lowPrice = [[UITextField alloc]initWithFrame:CGRectMake(18, priceLabel.bottom + 10, 70, sortView.height)];
        [bgView addSubview:_lowPrice];
        _lowPrice.keyboardType = UIKeyboardTypeNumberPad;
        
        [_lowPrice setBorderWidth:1.f borderColor:[UIColor colorWithHexString:@"e2e2e2"]];
        [_lowPrice addCornerRadius:5.f];
        _lowPrice.font = [UIFont systemFontOfSize:12];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_lowPrice.right + 10, 0, 15, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        [bgView addSubview:line];
        line.centerY = _lowPrice.centerY;
        
        //高价
        _highPrice = [[UITextField alloc]initWithFrame:CGRectMake(_lowPrice.right + 20 + 15, priceLabel.bottom + 10, 70, sortView.height)];
        [bgView addSubview:_highPrice];
        _highPrice.keyboardType = UIKeyboardTypeNumberPad;
        _highPrice.font = [UIFont systemFontOfSize:12];


        [_highPrice setBorderWidth:1.f borderColor:[UIColor colorWithHexString:@"e2e2e2"]];
        [_highPrice addCornerRadius:5.f];
        
        //价格固定范围
        
        NSArray *priceArray = @[@"100以下",@"100-199",@"200-299",@"300-399",@"400-499",@"500以上"];
        
        sortWidth = (bgView.width - 18 * 2 - 3 * 10) / 4.f;
        
        CGFloat top = _highPrice.bottom + 15;
        
        for (int i = 0; i < priceArray.count; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(18 + (sortWidth + 10) * (i % 4), _highPrice.bottom + 10 + (i / 4) * (sortView.height + 10), sortWidth, sortView.height);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [btn setTitle:priceArray[i] forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"dc4c63"] forState:UIControlStateSelected];
            
            [btn setBorderWidth:1.f borderColor:[UIColor colorWithHexString:@"e2e2e2"]];
            [btn addCornerRadius:5.f];
            
            [bgView addSubview:btn];
            
            [btn addTarget:self action:@selector(selectPrice:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = kPriceKadding + i;
            
            top = btn.bottom;
            
        }
        
        
        //分类
        
        UILabel *fenleiLabel = [LTools createLabelFrame:CGRectMake(24, top + 15, 100, 13) title:@"分类" font:13 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"999999"]];
        [bgView addSubview:fenleiLabel];
        
        
        //分类
        
        NSArray *fenleiArray = PRODUCT_FENLEI;
        
        sortWidth = (bgView.width - 18 * 2 - 3 * 10) / 5.f;
        
        for (int i = 0; i < fenleiArray.count; i ++) {
            
            UIButton *btn = [[UIButton alloc]initWithframe:CGRectMake(18 + (sortWidth + 10) * (i % 5), fenleiLabel.bottom + 10 + (i / 5) * (sortView.height + 10), sortWidth, sortView.height) buttonType:UIButtonTypeCustom normalTitle:fenleiArray[i] selectedTitle:nil target:self action:@selector(selectFenlei:)];
            [bgView addSubview:btn];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [btn setTitleColor:[UIColor colorWithHexString:@"dc4c63"] forState:UIControlStateSelected];
            
            [btn setBorderWidth:1.f borderColor:[UIColor colorWithHexString:@"e2e2e2"]];
            [btn addCornerRadius:5.f];
            
            [bgView addSubview:btn];
            
            btn.tag = kFenleiKadding + i;
            
            top = btn.bottom;
            
        }

        //重置按钮
        
        UIButton *resetButton = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, top + 15, 60, sortView.height) normalTitle:@"重置" image:nil backgroudImage:nil superView:nil target:self action:@selector(clickToReset:)];
        [bgView addSubview:resetButton];
        resetButton.backgroundColor = [UIColor colorWithHexString:@"f9da44"];
        [resetButton addCornerRadius:5.f];
        resetButton.titleLabel.font = [UIFont systemFontOfSize:12];
        resetButton.centerX = bgView.width / 2.f;
        
        //确定 取消
        
        UIView *line_hor = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.contentSize.height - 44 - 0.5, bgView.width, 0.5)];
        line_hor.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        [bgView addSubview:line_hor];
        
        CGFloat aWidth = (bgView.width - 1) / 2.f;
        UIButton *cancel_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, line_hor.bottom, aWidth, 44) normalTitle:@"取消" image:nil backgroudImage:nil superView:bgView target:self action:@selector(clickToCancel:)];
        [cancel_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel_btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        UIView *line_ver = [[UIView alloc]initWithFrame:CGRectMake(cancel_btn.right, bgView.contentSize.height - 44 - 0.5, 0.5, 44)];
        line_ver.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        [bgView addSubview:line_ver];
        
        UIButton *sure_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(cancel_btn.right + 0.5, line_hor.bottom, aWidth, 44) normalTitle:@"确定" image:nil backgroudImage:nil superView:bgView target:self action:@selector(clickToSure:)];
        [sure_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sure_btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        /**
         *  初始设置
         */
        [self selectSex:[self buttonForTag:kSexKadding]];
        [self selectSort:[self buttonForTag:kSortKadding]];
        [self selectFenlei:[self buttonForTag:kFenleiKadding]];
        
    }
    return self;
}

- (void)showFilterBlock:(FilterBlcok)aBlock
{
    filterBlock = aBlock;
    
    UIView *root = [UIApplication sharedApplication].keyWindow;
    [root addSubview:self];
    
    [self shakeView:bgView];
}

/**
 *  抖动动画
 *
 *  @param viewToShake
 */
-(void)shakeView:(UIView*)viewToShake
{
    //下边是嵌套使用,先变大再消失的动画效果.
    [UIView animateWithDuration:0.2 animations:^{
        CGAffineTransform newTransform = CGAffineTransformMakeScale(1.05, 1.05);
        [viewToShake setTransform:newTransform];
        
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.1 animations:^{
                             
                             [viewToShake setAlpha:1];
                             
                             [viewToShake setTransform:CGAffineTransformIdentity];
                             
                         } completion:^(BOOL finished){
                             
                             
                         }];
                     }];
    

    
}

- (void)hidden
{
    
//    [self removeFromSuperview];
    
    [self hiddenAnimation:bgView];
}


-(void)hiddenAnimation:(UIView*)viewToShake
{
    //下边是嵌套使用,先变大再消失的动画效果.
    [UIView animateWithDuration:0.2 animations:^{
        
//        self.alpha = 0.f;
        CGAffineTransform newTransform = CGAffineTransformMakeScale(0, 0);
        [viewToShake setTransform:newTransform];
    }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                    }];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *anyTouch = [touches anyObject];
    
    _isLastReset = NO;

    if (anyTouch.view == bgView) {
        return;
    }
    
    [self hidden];
}

#pragma mark 事件处理

- (UIButton *)buttonForTag:(int)tag
{
    return (UIButton *)[self viewWithTag:tag];
}

/**
 *  选择性别
 *
 *  @param sender
 */
- (void)selectSex:(UIButton *)sender
{
    int tag = (int)sender.tag;
    
    //不是重置时记录tag 并且设置 _isLastReset = NO
    if (!_isLastReset) {
        
        _tempSexTag = tag;
        
        _isLastReset = NO;
    }
    
    for (int i = 0; i < 3; i ++) {
        
        if (tag == i + kSexKadding) {
            
            [self buttonForTag:i + kSexKadding].backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
            [self buttonForTag:i + kSexKadding].selected = YES;
        }else
        {
           [self buttonForTag:i + kSexKadding].backgroundColor = [UIColor whiteColor];
            [self buttonForTag:i + kSexKadding].selected = NO;
        }
    }
    
    switch (tag - kSexKadding) {
        case 0:
        {
            NSLog(@"全部");
            
            sex_type = Sort_Sex_No;
        }
            break;
        case 1:
        {
            NSLog(@"女");
            
            sex_type = Sort_Sex_Women;
        }
            break;
        case 2:
        {
            NSLog(@"男");
            
            sex_type = Sort_Sex_Man;
        }
            break;
            
        default:
            break;
    }
}

/**
 *  选择排序
 *
 *  @param sender
 */
- (void)selectSort:(UIButton *)sender
{
    int tag = (int)sender.tag;
    
    
    if (!_isLastReset) {
        
        _tempSortTag = tag;
        _isLastReset = NO;

    }

    discount_type = (tag == kSortKadding) ? Sort_Discount_No : Sort_Discount_Yes;
    
    for (int i = 0; i < 2; i ++) {
        
        if (tag == i + kSortKadding) {
            
            [self buttonForTag:i + kSortKadding].backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
            [self buttonForTag:i + kSortKadding].selected = YES;
        }else
        {
            [self buttonForTag:i + kSortKadding].backgroundColor = [UIColor whiteColor];
            [self buttonForTag:i + kSortKadding].selected = NO;
        }
    }
    
    switch (tag - kSortKadding) {
        case 0:
        {
            NSLog(@"距离");
        }
            break;
        case 1:
        {
            NSLog(@"折扣");
        }
            break;
        default:
            break;
    }
}

/**
 *  选择价格
 *
 *  @param sender
 */
- (void)selectPrice:(UIButton *)sender
{
    int tag = (int)sender.tag;
    
    if (!_isLastReset) {
        
        _tempPriceTag = tag;
        _isLastReset = NO;

    }
    
    for (int i = 0; i < 6; i ++) {
        
        if (tag == i + kPriceKadding) {
            
            [self buttonForTag:i + kPriceKadding].backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
            [self buttonForTag:i + kPriceKadding].selected = YES;
        }else
        {
            [self buttonForTag:i + kPriceKadding].backgroundColor = [UIColor whiteColor];
            [self buttonForTag:i + kPriceKadding].selected = NO;
        }
    }
    
    NSLog(@"price %@",sender.titleLabel.text);
    switch (tag - kPriceKadding) {
        case 0:
        {
            _lowPrice.text = @"0";
            _highPrice.text = @"100";
        }
            break;
        case 1:
        {
            _lowPrice.text = @"100";
            _highPrice.text = @"199";
        }
            break;
        case 2:
        {
            _lowPrice.text = @"200";
            _highPrice.text = @"299";
        }
            break;
        case 3:
        {
            _lowPrice.text = @"300";
            _highPrice.text = @"399";
        }
            break;
        case 4:
        {
            _lowPrice.text = @"400";
            _highPrice.text = @"499";
        }
            break;
        case 5:
        {
            _lowPrice.text = @"500";
            _highPrice.text = @"不限";
        }
            break;
        case 6:
        {
            _lowPrice.text = @"0";
            _highPrice.text = @"不限";
        }
            break;
            
        default:
            break;
    }

}

/**
 *  选择分类
 *
 *  @param sender
 */
- (void)selectFenlei:(UIButton *)sender
{
    int tag = (int)sender.tag;
    
    if (!_isLastReset) {
        
        _tempFenleiTag = tag;
        _isLastReset = NO;

    }

    for (int i = 0; i < PRODUCT_FENLEI.count; i ++) {
        
        if (tag == i + kFenleiKadding) {
            
            [self buttonForTag:i + kFenleiKadding].backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
            [self buttonForTag:i + kFenleiKadding].selected = YES;
        }else
        {
            [self buttonForTag:i + kFenleiKadding].backgroundColor = [UIColor whiteColor];
            [self buttonForTag:i + kFenleiKadding].selected = NO;
        }
    }
    
    _fenleiIndex = tag - kFenleiKadding;
    
    if (tag - kFenleiKadding == 0) {
        _fenleiIndex = -1;
    }else if (tag - kFenleiKadding == PRODUCT_FENLEI.count - 1)
    {
        _fenleiIndex = 0;
    }
    
    NSLog(@"fenlei %@",sender.titleLabel.text);

}

/**
 *  重置
 *
 *  @param sender
 */
- (void)clickToReset:(UIButton *)sender
{
    
    //标记重置状态
    _isLastReset = YES;
    //初始之前记录之前状态
    _tempLowprice = _lowPrice.text;
    _tempHighPrice = _highPrice.text;

    /**
     *  初始设置
     */
    [self selectSex:[self buttonForTag:kSexKadding]];
    [self selectSort:[self buttonForTag:kSortKadding]];
    
    [self selectFenlei:[self buttonForTag:kFenleiKadding]];
    [self selectPrice:[self buttonForTag:kPriceKadding - 1]];
    
    _lowPrice.text = nil;
    _highPrice.text = nil;

}


- (void)clickToCancel:(UIButton *)sender
{
    
    //恢复重置之前状态
    
    if (_isLastReset) {
        
        [self selectSex:[self buttonForTag:_tempSexTag]];
        [self selectSort:[self buttonForTag:_tempSortTag]];
        
        [self selectFenlei:[self buttonForTag:_tempFenleiTag]];
        [self selectPrice:[self buttonForTag:_tempPriceTag]];
        
        _lowPrice.text = _tempLowprice;
        _highPrice.text = _tempHighPrice;
        
        _isLastReset = NO;
    }
    
    [self hidden];

}

- (void)clickToSure:(UIButton *)sender
{
    _isLastReset = NO;

    NSString *hight = [_highPrice.text isEqualToString:@"不限"] ? @"10000000" : _highPrice.text;
    if (filterBlock) {
        filterBlock(sex_type,discount_type,_lowPrice.text,hight,_fenleiIndex);
    }
    [self hidden];
}

- (void)hiddenKeyboard
{
    [_lowPrice resignFirstResponder];
    [_highPrice resignFirstResponder];
}

#pragma - mark 代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hiddenKeyboard];
}


@end
