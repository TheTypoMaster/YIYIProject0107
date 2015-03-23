//
//  GrefreshTableHeaderView.m
//  GRefreTableView
//
//  Created by gaomeng on 15/3/23.
//  Copyright (c) 2015年 gaomeng. All rights reserved.
//

#import "GrefreshTableHeaderView.h"

#define TEXT_COLOR1	 [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1.0]
#define TEXT_COLOR2	 [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@implementation GrefreshTableHeaderView

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
        
        UILabel *label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 22.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:9.0f];
        label.textColor = TEXT_COLOR2;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _lastUpdatedLabel=label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 42.0f, frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:11.0f];
        label.textColor = TEXT_COLOR1;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(75.0f, frame.size.height - 40.0f, 16.0f, 31.0f);
        layer.contentsGravity = kCAGravityResizeAspect;
//        layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
        layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            layer.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif
        
        [[self layer] addSublayer:layer];
        _arrowImage=layer;
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = CGRectMake(72.0f, frame.size.height - 35.0f, 20.0f, 20.0f);
        [self addSubview:view];
        _activityView = view;
        
        
        [self setState:GPullRefreshNormal];
        
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"icon_refresh.png" textColor:nil];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
    
    if (_delegate) {
        
        NSDate *date = [_delegate GRefreshTableDataSourceLastUpdated:self];
        
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        _lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [dateFormatter stringFromDate:date]];
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"GRefreshTableView_LastRefresh"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        _lastUpdatedLabel.text = nil;
        
    }
    
}

- (void)setState:(GPullRefreshState)aState{
    
    switch (aState) {
        case GPullRefreshPulling:
            
            _statusLabel.text = NSLocalizedString(@"松开即可更新", @"松开即可更新");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            
            break;
        case GPullRefreshNormal:
            
            if (_state == GPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            
            _statusLabel.text = NSLocalizedString(@"下拉即可更新", @"下拉即可更新");
            [_activityView stopAnimating];
            [_activityView setHidden:YES];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            [self refreshLastUpdatedDate];
            
            break;
        case GPullRefreshLoading:
            
            _statusLabel.text = NSLocalizedString(@"加载中~", @"加载中~");
            [_activityView startAnimating];
            [_activityView setHidden:NO];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            
            break;
        default:
            break;
    }
    
    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)GRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_state == GPullRefreshLoading) {
        
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        
    } else if (scrollView.isDragging) {
        
        BOOL _loading = NO;
        if (_delegate) {
            _loading = [_delegate GRefreshTableDataSourceIsLoading:self];
        }
        
        if (_state == GPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
            [self setState:GPullRefreshNormal];
        } else if (_state == GPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
            [self setState:GPullRefreshPulling];
        }
        
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)GRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    BOOL _loading = NO;
    if (_delegate) {
        _loading = [_delegate GRefreshTableDataSourceIsLoading:self];
    }
    
    if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
        
        if (_delegate) {
            [_delegate GRefreshTableDidTriggerRefresh:GRefreshHeader];
        }
        [self setState:GPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
    }
}

- (void)GRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
    } completion:^(BOOL finished) {
        
        [self setState:GPullRefreshNormal];
    }];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    _delegate=nil;
    _activityView = nil;
    _statusLabel = nil;
    _arrowImage = nil;
    _lastUpdatedLabel = nil;
}


@end
