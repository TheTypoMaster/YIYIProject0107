//
//  GmoveImv.m
//  testTouchMove
//
//  Created by gaomeng on 15/4/1.
//  Copyright (c) 2015年 gaomeng. All rights reserved.
//

#import "GmoveImv.h"
#import "UILabel+GautoMatchedText.h"

#define ACHORVIEW_HEIGHT 16

@implementation GmoveImv

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //允许用户交互
        self.userInteractionEnabled = YES;
    }
    return self;
}


- (void)dealloc
{
    self.annimationView = nil;
    self.halo = nil;
    self.titleLabel = nil;
}

-(instancetype)initWithAnchorPoint:(CGPoint)anchorPoint
                             title:(NSString *)title
                             width:(CGFloat)theWidth
                               tag:(NSInteger)theTag
{
    self = [super initWithFrame:CGRectMake(anchorPoint.x, anchorPoint.y, 0, ACHORVIEW_HEIGHT)];
    if (self) {
        self.userInteractionEnabled = YES;
        
        
        self.isRight  = YES;
        
        self.tag = theTag;

        //满足此条件则放左侧
        if (anchorPoint.x > theWidth*0.5) {
            
            self.isRight = NO;
            
        }
        
        if (self.isRight) {
            
            
            
            //标记位置view
            
            self.annimationView = [[UIView alloc]initWithFrame:CGRectMake(0, (ACHORVIEW_HEIGHT - 5) /2.f, 5, 5)];
            self.annimationView.backgroundColor = [UIColor whiteColor];
            self.annimationView.layer.cornerRadius = 2.5f;
            self.annimationView.clipsToBounds = YES;
            [self addSubview:self.annimationView];
            
            self.halo = [PulsingHaloLayer layer];
            self.halo.position = self.annimationView.center;
            self.halo.animationDuration = 1.f;
            self.halo.radius = 10.f;
            self.halo.backgroundColor = [UIColor blackColor].CGColor;
            [self.layer insertSublayer:self.halo below:self.annimationView.layer];
            
            
            //文字宽度
            UILabel *tmpLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            tmpLabel.text = title;
            tmpLabel.font = [UIFont systemFontOfSize:11];
            [tmpLabel setMatchedFrame4LabelWithOrigin:CGPointZero height:12 limitMaxWidth:140];
            
            CGFloat aWidth = tmpLabel.frame.size.width;
            
            CGFloat aWidth_imageView = aWidth + 8 + 16;//8 titleLabel的frame.x  16删除按钮的宽度
            
            //箭头imageView
            
            CGFloat left = self.annimationView.right + 5;
            
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(left, 0, aWidth_imageView, ACHORVIEW_HEIGHT)];
            UIImage *image = [UIImage imageNamed:@"jiantou_anchor_right"];
            self.imageView.image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:ACHORVIEW_HEIGHT];
            [self addSubview:self.imageView];
            
            //文字显示label
            
            self.titleLabel = [LTools createLabelFrame:CGRectMake(8, 0, aWidth, ACHORVIEW_HEIGHT) title:title font:11.f align:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
            [self.imageView addSubview:self.titleLabel];
            
            self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.deleteBtn.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, ACHORVIEW_HEIGHT, ACHORVIEW_HEIGHT);
            [self.deleteBtn setImage:[UIImage imageNamed:@"g_linkdelete.png"] forState:UIControlStateNormal];
            [self.deleteBtn addTarget:self action:@selector(clickToDo:) forControlEvents:UIControlEventTouchUpInside];
            self.deleteBtn.tag = -self.tag;
            self.imageView.userInteractionEnabled = YES;
            [self.imageView addSubview:self.deleteBtn];
            
            
            [self setTheRightLocationAndFrame];
            
            
        }else{
            
            
            
            //文字宽度
            UILabel *tmpLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            tmpLabel.text = title;
            tmpLabel.font = [UIFont systemFontOfSize:11];
            [tmpLabel setMatchedFrame4LabelWithOrigin:CGPointZero height:12 limitMaxWidth:140];
            
            CGFloat aWidth = tmpLabel.frame.size.width;
            
            CGFloat aWidth_imageView = aWidth + 8 + 16;//8 titleLabel的frame.x  16删除按钮的宽度
            
            //箭头imageView
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, aWidth_imageView, ACHORVIEW_HEIGHT)];
            UIImage *image = [UIImage imageNamed:@"jiantou_anchor_left"];
            self.imageView.image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:ACHORVIEW_HEIGHT];
            [self addSubview:self.imageView];
            
            self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.deleteBtn setImage:[UIImage imageNamed:@"g_linkdelete.png"] forState:UIControlStateNormal];
            self.deleteBtn.frame = CGRectMake(0, 0, ACHORVIEW_HEIGHT, ACHORVIEW_HEIGHT);
            [self.deleteBtn addTarget:self action:@selector(clickToDo:) forControlEvents:UIControlEventTouchUpInside];
            self.deleteBtn.tag = -self.tag;
            self.imageView.userInteractionEnabled = YES;
            [self.imageView addSubview:self.deleteBtn];
            
            
            
            
            
            //文字显示label
            
            self.titleLabel = [LTools createLabelFrame:CGRectMake(self.deleteBtn.frame.size.width, 0, aWidth, ACHORVIEW_HEIGHT) title:title font:11.f align:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
            [self.imageView addSubview:self.titleLabel];
            
            
            //标记位置view
            
            self.annimationView = [[UIView alloc]initWithFrame:CGRectMake(self.imageView.right + 5, (ACHORVIEW_HEIGHT - 5) /2.f, 5, 5)];
            self.annimationView.backgroundColor = [UIColor whiteColor];
            self.annimationView.layer.cornerRadius = 2.5f;
            self.annimationView.clipsToBounds = YES;
            [self addSubview:self.annimationView];
            
            self.halo = [PulsingHaloLayer layer];
            self.halo.position = self.annimationView.center;
            self.halo.animationDuration = 1.f;
            self.halo.radius = 10.f;
            self.halo.backgroundColor = [UIColor blackColor].CGColor;
            [self.layer insertSublayer:self.halo below:self.annimationView.layer];
            
            
            [self setTheLeftLocationAndFrame];
 
            
        }
        
    }
    
    //调试颜色
//    self.titleLabel.backgroundColor = [UIColor redColor];
//    self.imageView.backgroundColor = [UIColor orangeColor];
//    self.backgroundColor = [UIColor purpleColor];
    
    return self;
}


-(void)loadNewTitle:(NSString *)title{
    
    NSLog(@"自适应长度 self.isRight = %d",self.isRight);
    
    if (self.isRight) {
        
        //文字宽度
        UILabel *tmpLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        tmpLabel.text = title;
        tmpLabel.font = [UIFont systemFontOfSize:11];
        [tmpLabel setMatchedFrame4LabelWithOrigin:CGPointZero height:12 limitMaxWidth:140];
        
        CGFloat aWidth = tmpLabel.frame.size.width;
        
        CGFloat aWidth_imageView = aWidth + 8 + 16;//8 titleLabel的frame.x  16删除按钮的宽度

        
        //图
        
        CGRect r = self.imageView.frame;
        r.size.width = aWidth_imageView;
        self.imageView.frame = r;
        
        
        //文字
        
        CGRect r_c = self.titleLabel.frame;
        r_c.size.width = aWidth;
        self.titleLabel.frame = r_c;
        
        //删除按钮
        CGRect r_d = self.deleteBtn.frame;
        r_d.origin.x = CGRectGetMaxX(self.titleLabel.frame);
        self.deleteBtn.frame = r_d;
        
        
        
        
        //只改变宽度
        CGRect r_s = self.frame;
        r_s.size.width = self.annimationView.frame.size.width + 5 + self.imageView.frame.size.width;
        self.frame = r_s;
        
        
    }else{
        //文字宽度
        UILabel *tmpLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        tmpLabel.text = title;
        tmpLabel.font = [UIFont systemFontOfSize:11];
        [tmpLabel setMatchedFrame4LabelWithOrigin:CGPointZero height:12 limitMaxWidth:140];
        
        CGFloat aWidth = tmpLabel.frame.size.width;
        
        CGFloat aWidth_imageView = aWidth + 13 * 2;//左侧 右侧 13
        
        //图
        
        CGRect r = self.imageView.frame;
        r.size.width = aWidth_imageView;
        self.imageView.frame = r;
        
        //文字
        
        CGRect r_c = self.titleLabel.frame;
        r_c.size.width = aWidth;
        self.titleLabel.frame = r_c;
        
        
        //标记位置view
        
        CGRect r_a = self.annimationView.frame;
        r_a.origin.x = self.imageView.right + 5;
        self.annimationView.frame = r_a;
        
        
        self.halo.position = self.annimationView.center;
        
        
        //改变fame
        CGRect r_s = self.frame;
        r_s.size.width = self.annimationView.frame.size.width + 5 + self.imageView.frame.size.width;
        r_s.origin.x = self.frame.origin.x +self.frame.size.width - r_s.size.width;
        
        self.frame = r_s;
        
        
    }
    
    
    
    
        //调试颜色
//        self.titleLabel.backgroundColor = [UIColor orangeColor];
//        self.imageView.backgroundColor = [UIColor redColor];
//        self.backgroundColor = [UIColor purpleColor];
    
    
}





-(void)setDeleteBlock:(DeleteBlock)deleteBlock{
    _deleteBlock = deleteBlock;
}

-(void)clickToDo:(UIButton *)sender{
    NSLog(@"----->end");
    

    
    if (_deleteBlock) {
        self.deleteBlock(sender.tag);
    }
    
}








- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self];
    _startPoint = point;
    
    //该view置于最前
    [[self superview] bringSubviewToFront:self];
    
    [self becomeFirstResponder];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //计算位移=当前位置-起始位置
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - _startPoint.x;
    float dy = point.y - _startPoint.y;
    
    //计算移动后的view中心点
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    
    /* 限制用户不可将视图托出屏幕 */
    float halfx = CGRectGetMidX(self.bounds);
    //x坐标左边界
    newcenter.x = MAX(halfx, newcenter.x);
    //x坐标右边界
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    
    //y坐标同理
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    
    //移动view
    self.center = newcenter;
    
    NSLog(@"GmoveImv x = %f  y = %f",self.center.x,self.center.y);
    if (self.isRight) {
        self.location_x = self.frame.origin.x ;
        self.location_y = self.frame.origin.y + ACHORVIEW_HEIGHT * 0.5;
        NSLog(@"right 移动后的locationx = %f locationy = %f",self.location_x,self.location_y);
    }else{
        
        self.location_x = self.right-2;
        self.location_y = self.frame.origin.y + ACHORVIEW_HEIGHT *0.5;
        NSLog(@"left 移动后的locationx = %f locationy = %f",self.location_x,self.location_y);
    }
    
    
    
    NSLog(@"%d",self.isFirstResponder);
}



//设置右边 在init方法里使用
-(void)setTheRightLocationAndFrame{
    
    
    
    CGRect r = self.frame;
    r.origin.x = self.frame.origin.x - 2;
    r.origin.y = self.frame.origin.y - ACHORVIEW_HEIGHT*0.5;
    r.size.width = self.annimationView.frame.size.width + 5 + self.imageView.frame.size.width;
    self.frame = r;
    
    self.location_x = self.frame.origin.x;
    self.location_y = self.frame.origin.y + ACHORVIEW_HEIGHT * 0.5;
    NSLog(@"right 初始化的locationx = %f locationy = %f",self.location_x,self.location_y);
    
}



//设置左边 在init方法里使用
-(void)setTheLeftLocationAndFrame{
    
    
    CGRect r = self.frame;
    r.origin.x = self.frame.origin.x - self.imageView.frame.size.width - 5 - self.annimationView.frame.size.width;
    r.origin.y = self.frame.origin.y - ACHORVIEW_HEIGHT * 0.5;
    r.size.width = self.annimationView.frame.size.width + 5 + self.imageView.frame.size.width;
    
    self.location_x = r.origin.x + ACHORVIEW_HEIGHT *0.5 + r.size.width - 2;
    self.location_y = r.origin.y + ACHORVIEW_HEIGHT*0.5;
    
    NSLog(@"left 初始化的locationx = %f locationy = %f",self.location_x,self.location_y);
    
    self.frame = r;
}












@end
