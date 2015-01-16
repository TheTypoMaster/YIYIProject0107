//
//  TMPhotoViewQuiltViewCell.m
//  YiYiProject
//
//  Created by unisedu on 15/1/16.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "TMPhotoViewQuiltViewCell.h"

@implementation TMPhotoViewQuiltViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.backGroudView = [[UIView alloc]init];
        _backGroudView.clipsToBounds = YES;
        [self addSubview:_backGroudView];
        
        self.photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        [_backGroudView addSubview:_photoView];
        }
    return self;
}

- (void)layoutSubviews
{
    
    _backGroudView.frame = CGRectMake(0, 0, self.width, self.height);
    _backGroudView.layer.cornerRadius = 3.f;
    CGRect aBound = self.bounds;
    self.photoView.frame = CGRectInset(aBound, 0, 0);
}
-(void)setValueWithDic:(NSDictionary *) dic
{
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image_url"]] placeholderImage:nil];
}
@end
