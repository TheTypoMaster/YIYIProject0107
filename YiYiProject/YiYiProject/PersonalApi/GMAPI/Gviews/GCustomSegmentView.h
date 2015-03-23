//
//  GCustomSegmentView.h
//  YiYiProject
//
//  Created by gaomeng on 15/3/23.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GCustomSegmentViewDelegate <NSObject>

-(void)buttonClick:(NSInteger)buttonSelected;

@end

@interface GCustomSegmentView : UIView

@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)id<GCustomSegmentViewDelegate>delegate;


-(void)setDelegate:(id<GCustomSegmentViewDelegate>)delegate1;
-(void)setAllViewWithArray:(NSArray *)array;
-(void)settitleWitharray:(NSArray *)arrayname;

@end
