//
//  AnchorPiontView.m
//  YiYiProject
//
//  Created by lichaowei on 15/4/24.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "AnchorPiontView.h"

#define ACHORVIEW_HEIGHT 16

@implementation AnchorPiontView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
//    NSLog(@"--%s--",__FUNCTION__);
    self.annimationView = nil;
    self.halo = nil;
    self.titleLabel = nil;
}

-(instancetype)initWithAnchorPoint:(CGPoint)anchorPoint
                             title:(NSString *)title
{
    self = [super initWithFrame:CGRectMake(anchorPoint.x, anchorPoint.y, 0, ACHORVIEW_HEIGHT)];
    if (self) {
        
//        self.backgroundColor = [UIColor orangeColor];
        
        BOOL isRight  = YES;
        
        //满足此条件则放左侧
        if (anchorPoint.x > DEVICE_WIDTH - 50) {
            
            isRight = NO;
        }
        
        if (isRight) {
            
            //标记位置view
            
            self.annimationView = [[UIView alloc]initWithFrame:CGRectMake(0, (ACHORVIEW_HEIGHT - 5) /2.f, 5, 5)];
            self.annimationView.backgroundColor = [UIColor whiteColor];
            self.annimationView.layer.cornerRadius = 2.5f;
            self.annimationView.clipsToBounds = YES;
            [self addSubview:_annimationView];
            
            self.halo = [PulsingHaloLayer layer];
            self.halo.position = self.annimationView.center;
            self.halo.animationDuration = 1.f;
            self.halo.radius = 10.f;
            self.halo.backgroundColor = [UIColor blackColor].CGColor;
            [self.layer insertSublayer:self.halo below:self.annimationView.layer];
            
            
            //文字宽度
            
            CGFloat aWidth = [LTools widthForText:title font:11.f];
            
            CGFloat aWidth_imageView = aWidth + 7 * 2;//左侧 右侧 7
            
            //箭头imageView
            
            CGFloat left = _annimationView.right + 5;
            
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(left, 0, aWidth_imageView, ACHORVIEW_HEIGHT)];
            UIImage *image = [UIImage imageNamed:@"jiantou_anchor_right"];
            _imageView.image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:ACHORVIEW_HEIGHT];
            [self addSubview:_imageView];
            
            //文字显示label
            
            self.titleLabel = [LTools createLabelFrame:CGRectMake(10, 0, aWidth, ACHORVIEW_HEIGHT) title:title font:11.f align:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
            [_imageView addSubview:_titleLabel];
            
        }else
        {
            //文字宽度
            
            CGFloat aWidth = [LTools widthForText:title font:11.f];
            
            CGFloat aWidth_imageView = aWidth + 7 * 2;//左侧 右侧 7
            
            //箭头imageView
            
            CGFloat left = 0;
            
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(left, 0, aWidth_imageView, ACHORVIEW_HEIGHT)];
            UIImage *image = [UIImage imageNamed:@"jiantou_anchor_left"];
            _imageView.image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:ACHORVIEW_HEIGHT];
            [self addSubview:_imageView];
            
            //文字显示label
            
            self.titleLabel = [LTools createLabelFrame:CGRectMake(5, 0, aWidth, ACHORVIEW_HEIGHT) title:title font:11.f align:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
            [_imageView addSubview:_titleLabel];
            
            
            //标记位置view
            
            self.annimationView = [[UIView alloc]initWithFrame:CGRectMake(_imageView.right + 5, (ACHORVIEW_HEIGHT - 5) /2.f, 5, 5)];
            self.annimationView.backgroundColor = [UIColor whiteColor];
            self.annimationView.layer.cornerRadius = 2.5f;
            self.annimationView.clipsToBounds = YES;
            [self addSubview:_annimationView];
            
            self.halo = [PulsingHaloLayer layer];
            self.halo.position = self.annimationView.center;
            self.halo.animationDuration = 1.f;
            self.halo.radius = 10.f;
            self.halo.backgroundColor = [UIColor blackColor].CGColor;
            [self.layer insertSublayer:self.halo below:self.annimationView.layer];
            
            self.left = anchorPoint.x - _imageView.width - 5 - _annimationView.width;

        }
        
        self.width = _imageView.width + 5 + _annimationView.width;
        
//        self.height += 50;
        
        
        //判端右侧边界情况
        
        if (self.right > DEVICE_WIDTH - 10) {
            
            CGFloat dis = self.right - (DEVICE_WIDTH - 10);
            self.width -= dis;
            _titleLabel.width -= dis;
            _imageView.width -= dis;
        }
        
        
        UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clickButton.frame = self.bounds;
//        clickButton.backgroundColor = [UIColor redColor];
        [clickButton addTarget:self action:@selector(clickToDo:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clickButton];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"----->began");
}

- (void)setAnchorBlock:(AnchorClickBlock)anchorBlock
{
    _anchorClickBlock = anchorBlock;
}

-(void)clickToDo:(UIButton *)sender
{
    NSLog(@"----->end");

    if (_anchorClickBlock) {
        
        _anchorClickBlock(_infoId,_infoName);
    }
}

@end
