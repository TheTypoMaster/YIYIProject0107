//
//  GCustomSegmentView.m
//  YiYiProject
//
//  Created by gaomeng on 15/3/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "GCustomSegmentView.h"

@implementation GCustomSegmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _currentPage = 0;
    }
    return self;
}


-(void)setAllViewWithArray:(NSArray *)array
{
    for (int i = 0;i < array.count/2;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.backgroundColor = [UIColor clearColor];
        
        button.adjustsImageWhenHighlighted = NO;
        
        [button setFrame:CGRectMake(0+self.frame.size.width/(array.count/2)*i,0,self.frame.size.width/(array.count/2),self.frame.size.height)];
        
        
        NSString *nornamlImageName = [array objectAtIndex:i];
        NSString *selectImageName = [array objectAtIndex:(i+array.count/2)];
        
        [button setImage:[UIImage imageNamed:nornamlImageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
        
//        [button setBackgroundImage:[UIImage imageNamed:nornamlImageName] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
//        [button setBackgroundColor:[UIColor orangeColor]];
        
        
        if (_currentPage == i)
        {
            button.selected = YES;
        }
        
        button.tag = 1+i;
        
        [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
}
-(void)settitleWitharray:(NSArray *)arrayname{
    
    for (int i=0; i<arrayname.count; i++) {
        UIButton *button_=(UIButton *)[self viewWithTag:(i+1)];
        button_.titleLabel.font=[UIFont systemFontOfSize:13];
        [button_ setTitle:[NSString stringWithFormat:@"%@",[arrayname objectAtIndex:i]] forState:UIControlStateNormal];
        if (i==0) {
            [button_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button_ setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            
            
        }else{
            [button_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button_ setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            
        }
    }
}
-(void)doButton:(UIButton *)button
{
    UIButton * button1 = (UIButton *)[self viewWithTag:(_currentPage+1)];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.selected = NO;
    
    button.selected = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _currentPage = button.tag-1;
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonClick:)])
    {
        [self.delegate buttonClick:_currentPage];
    }
    
    
}

@end
