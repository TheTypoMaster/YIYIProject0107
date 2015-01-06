//
//  GStarsView.h
//  YiYiProject
//
//  Created by gaomeng on 14/12/20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GStarsView;

@protocol GStarsViewDelegate <NSObject>
@optional
///返回的score自己看着调整
-(void)starRatingView:(GStarsView *)view score:(float)score;
@end


@interface GStarsView : UIView

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;
@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, weak) id <GStarsViewDelegate> delegate;

@end
