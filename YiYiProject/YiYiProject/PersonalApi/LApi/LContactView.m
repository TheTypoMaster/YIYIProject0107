//
//  LContactView.m
//  YiYiProject
//
//  Created by lichaowei on 15/5/28.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "LContactView.h"

@implementation LContactView

+ (id)shareInstance
{
    static dispatch_once_t once_t;
    static LContactView *dataBlock;
    
    dispatch_once(&once_t, ^{
        dataBlock = [[LContactView alloc]init];
    });
    
    return dataBlock;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.window.windowLevel = UIAlertViewStyleDefault;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        self.alpha = 0.0;
        
        CGFloat left = DEVICE_WIDTH - 108 - 10;
        CGFloat top = DEVICE_HEIGHT - 90 - 50;
        
        UIView *_backView = [[UIView alloc]initWithFrame:CGRectMake(left, top, 108, 90)];
        [_backView addCornerRadius:5.f];
        [self addSubview:_backView];
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        
        NSArray *images = @[[UIImage imageNamed:@"productDetail_phone"],[UIImage imageNamed:@"productDetail_sixin"]];
        NSArray *titles = @[@"拨号",@"私聊"];
        
        for (int i = 0; i < images.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(19, 45 * i + 12.5, 20, 20)];
            imageView.image = images[i];
            [_backView addSubview:imageView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 10, imageView.top, 40, 20)];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.textColor = [UIColor whiteColor];
            [_backView addSubview:titleLabel];
            titleLabel.text = titles[i];
            
            UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
            sender.frame = CGRectMake(0, 45 * i, _backView.width, 45);
            [sender addTarget:self action:@selector(clickToAction:) forControlEvents:UIControlEventTouchUpInside];
            sender.tag = 100 + i;
            [_backView addSubview:sender];
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 45, _backView.width, 0.5)];
        [_backView addSubview:line];
        line.backgroundColor = [UIColor colorWithHexString:@"adadad"];

    }
    return self;
}

- (void)show
{
    UIView *root = [UIApplication sharedApplication].keyWindow;
    [root addSubview:self];
    
//    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
//        CGRect aFrame = weakSelf.backView.frame;
//        aFrame.origin.y = [UIApplication sharedApplication].keyWindow.bottom - _height_bgView;
//        bgView.frame = aFrame;
        self.alpha = 1.0;
    }];
}

- (void)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
//        CGRect aFrame = bgView.frame;
//        aFrame.origin.y = [UIApplication sharedApplication].keyWindow.bottom;
//        bgView.frame = aFrame;
        
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    NSLog(@"touch view %@",touch.view);
    
    if ([touch.view isKindOfClass:[LContactView class]]) {
        [self hidden];
        
    }
}

-(void)setContactBlock:(CONTACT_BLOCK)contactBlock
{
    
    _contactBlock = contactBlock;
}

- (void)clickToAction:(UIButton *)sender
{
    int tag = (int)sender.tag;
    
    
    [self hidden];
    
    if (self.contactBlock) {
        
        if (tag == 100) {
            
            //拨号
            
            self.contactBlock(CONTACTTYPE_PHONE,0);
            
        }else if (tag == 101){
            
            //私聊
            self.contactBlock(CONTACTTYPE_PRIVATECHAT,1);
        }
    }
    
}


@end
