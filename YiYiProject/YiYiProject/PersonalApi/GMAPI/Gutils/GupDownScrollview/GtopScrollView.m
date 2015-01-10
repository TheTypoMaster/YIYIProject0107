//
//  GtopScrollView.m
//  YiYiProject
//
//  Created by gaomeng on 15/1/4.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GtopScrollView.h"
#import "GRootScrollView.h"



////滑条宽度
//#define CONTENTSIZEX 320

//按钮空隙
#define BUTTONGAP 1

//按钮id
#define BUTTONID (sender.tag-100)
//滑动id
#define BUTTONSELECTEDID (self.scrollViewSelectedChannelID - 100)

//高度
#define GtopScrollViewHeight 28





@implementation GtopScrollView

- (void)dealloc
{
    
    NSLog(@"%s",__FUNCTION__);
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        _userSelectedChannelID = 100;
        _scrollViewSelectedChannelID = 100;
        
        self.buttonOriginXArray = [NSMutableArray array];
        self.buttonWithArray = [NSMutableArray array];
    }
    return self;
}




- (void)initWithNameButtons
{
    
    
    
    if (self.theTopType == GTOPPINPAI) {//品牌
        
    }
    
    
    float xPos = 0;
    for (int i = 0; i < [self.nameArray count]; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [self.nameArray objectAtIndex:i];
        
        [button setTag:i+100];
        if (i == 0) {
            button.selected = YES;
        }
        
        [button setBackgroundImage:[UIImage imageNamed:@"gGray.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"gRed.png"] forState:UIControlStateSelected];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        
//        int buttonWidth = [title sizeWithFont:button.titleLabel.font
//                            constrainedToSize:CGSizeMake(150, 30)
//                                lineBreakMode:NSLineBreakByClipping].width;
        
        button.frame = CGRectMake(xPos, 0, 70, GtopScrollViewHeight);
        
        [_buttonOriginXArray addObject:@(xPos)];
        
        xPos += button.frame.size.width+BUTTONGAP;
        
        [_buttonWithArray addObject:@(button.frame.size.width)];
        
        [self addSubview:button];
    }
    
    self.contentSize = CGSizeMake(xPos, GtopScrollViewHeight);
    
}


//点击顶部条滚动标签
- (void)selectNameButton:(UIButton *)sender
{
    [self adjustScrollViewContentX:sender];
    
    //如果更换按钮
    if (sender.tag != self.userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self viewWithTag:self.userSelectedChannelID];
        lastButton.selected = NO;
        //赋值按钮ID
        self.userSelectedChannelID = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            
//            [shadowImageView setFrame:CGRectMake(sender.frame.origin.x, 0, [[_buttonWithArray objectAtIndex:BUTTONID] floatValue], 44)];
            
        } completion:^(BOOL finished) {
            if (finished) {
                //设置新闻页出现
                [self.myRootScrollView setContentOffset:CGPointMake(BUTTONID*self.myRootScrollView.frame.size.width, 0) animated:YES];
                //赋值滑动列表选择频道ID
                self.scrollViewSelectedChannelID = sender.tag;
            }
        }];
        
    }
    //重复点击选中按钮
    else {
        
    }
}


- (void)adjustScrollViewContentX:(UIButton *)sender
{
    float originX = [[_buttonOriginXArray objectAtIndex:BUTTONID] floatValue];
    float width = [[_buttonWithArray objectAtIndex:BUTTONID] floatValue];
    
    if (sender.frame.origin.x - self.contentOffset.x > self.frame.size.width-(BUTTONGAP+width)) {
        [self setContentOffset:CGPointMake(originX - 30, 0)  animated:YES];
    }
    
    if (sender.frame.origin.x - self.contentOffset.x < 5) {
        [self setContentOffset:CGPointMake(originX,0)  animated:YES];
    }
}




//滚动内容页顶部滚动
- (void)setButtonUnSelect
{
    //滑动撤销选中按钮
    UIButton *lastButton = (UIButton *)[self viewWithTag:self.scrollViewSelectedChannelID];
    lastButton.selected = NO;
}

- (void)setButtonSelect
{
    //滑动选中按钮
    UIButton *button = (UIButton *)[self viewWithTag:self.scrollViewSelectedChannelID];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        
    } completion:^(BOOL finished) {
        if (finished) {
            if (!button.selected) {
                button.selected = YES;
                self.userSelectedChannelID = button.tag;
            }
        }
    }];
    
}

-(void)setScrollViewContentOffset
{
    float originX = [[self.buttonOriginXArray objectAtIndex:BUTTONSELECTEDID] floatValue];
    float width = [[self.buttonWithArray objectAtIndex:BUTTONSELECTEDID] floatValue];

    if (originX - self.contentOffset.x > self.frame.size.width-(BUTTONGAP+width)) {
        [self setContentOffset:CGPointMake(originX - 30, 0)  animated:YES];
    }

    if (originX - self.contentOffset.x < 5) {
        [self setContentOffset:CGPointMake(originX,0)  animated:YES];
    }
}

@end
