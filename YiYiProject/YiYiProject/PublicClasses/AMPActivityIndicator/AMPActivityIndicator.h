//
//  AMPActivityIndicator.h
//  AMPActivityIndicator Example
//
//  Created by Alejandro Martinez on 11/08/13.
//  Copyright (c) 2013 Alejandro Martinez. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@interface AMPActivityIndicator : UIView

@property (nonatomic,retain) UIColor *barColor;
@property (nonatomic) CGFloat barWidth;
@property (nonatomic) CGFloat barHeight;
@property (nonatomic) CGFloat aperture;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
