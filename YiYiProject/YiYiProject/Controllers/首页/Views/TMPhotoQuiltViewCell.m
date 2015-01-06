//
//  TMQuiltView
//
//  Created by Bruno Virlet on 7/20/12.
//
//  Copyright (c) 2012 1000memories

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//


#import "TMPhotoQuiltViewCell.h"

const CGFloat kTMPhotoQuiltViewMargin = 0;

@implementation TMPhotoQuiltViewCell

@synthesize photoView = _photoView;
@synthesize titleLabel = _titleLabel;

- (void)dealloc {
     _photoView = nil;
    _titleLabel = nil;
    
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
//        @property(nonatomic,retain)UIView *titleView;//存放 店铺名、距离
//        @property(nonatomic,retain)UILabel *dianPuName_Label;//店铺名
//        @property(nonatomic,retain)UILabel *distance_label;//距离
//        
//        @property(nonatomic,retain)UIView *infoView;//存放 价格 打折 收藏
//        @property(nonatomic,retain)UILabel *price_label;//价格
//        @property(nonatomic,retain)UILabel *discount_label;//打折
//        @property(nonatomic,retain)UIButton *like_btn;//喜欢标识
//        @property(nonatomic,retain)UILabel *like_label;//喜欢数量
        
        self.backGroudView = [[UIView alloc]init];
        _backGroudView.clipsToBounds = YES;
        [self addSubview:_backGroudView];
        
        self.photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        [_backGroudView addSubview:_photoView];
        
        //存放 店铺名、距离
        
        self.titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_backGroudView addSubview:_titleView];
        
        //店铺名
        
        self.dianPuName_Label = [[UILabel alloc] init];
        _dianPuName_Label.backgroundColor = [UIColor clearColor];
        _dianPuName_Label.textColor = [UIColor whiteColor];
        _dianPuName_Label.textAlignment = NSTextAlignmentLeft;
        _dianPuName_Label.font = [UIFont systemFontOfSize:14.f];
        [_titleView addSubview:_dianPuName_Label];
        
        //距离
        
        self.distance_label = [[UILabel alloc] init];
        _distance_label.backgroundColor = [UIColor clearColor];
        _distance_label.font = [UIFont systemFontOfSize:12.f];
        _distance_label.textColor = [UIColor whiteColor];
        _distance_label.textAlignment = NSTextAlignmentRight;
        [_titleView addSubview:_distance_label];
        
        //存放 价格 打折 收藏
        
        self.infoView = [[UIView alloc]init];
        _infoView.backgroundColor = [UIColor whiteColor];
        [_backGroudView addSubview:_infoView];
        
        //价格
        self.price_label = [UIButton buttonWithType:UIButtonTypeCustom];
        _price_label.backgroundColor = [UIColor colorWithHexString:@"acacac"];
        _price_label.titleLabel.font = [UIFont systemFontOfSize:12];
        [_infoView addSubview:_price_label];
        
        //折扣
        self.discount_label = [UIButton buttonWithType:UIButtonTypeCustom];
        _discount_label.backgroundColor = [UIColor colorWithHexString:@"acacac"];;
        _discount_label.titleLabel.font = [UIFont systemFontOfSize:12];
        [_infoView addSubview:_discount_label];
        
        self.like_label = [[UILabel alloc]init];
        _like_label.backgroundColor = [UIColor clearColor];
        _like_label.font = [UIFont systemFontOfSize:12];
        _like_label.textAlignment = NSTextAlignmentRight;
        [_infoView addSubview:_like_label];
        
        
        self.like_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_like_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_like_btn setImage:[UIImage imageNamed:@"love_up"] forState:UIControlStateNormal];
        [_like_btn setImage:[UIImage imageNamed:@"love_down"] forState:UIControlStateSelected];
        [_infoView addSubview:_like_btn];
    }
    return self;
}

//- (UIImageView *)photoView {
//    if (!_photoView) {
//        _photoView = [[UIImageView alloc] init];
//        _photoView.contentMode = UIViewContentModeScaleAspectFill;
//        _photoView.clipsToBounds = YES;
//        [self addSubview:_photoView];
//    }
//    return _photoView;
//}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

    
- (void)layoutSubviews {
    
    _backGroudView.frame = CGRectMake(0, 0, self.width, self.height);
    _backGroudView.layer.cornerRadius = 3.f;
    
    CGRect aBound = self.bounds;
    aBound.size.height -= 33;
    self.photoView.frame = CGRectInset(aBound, kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
    
    self.titleView.frame = CGRectMake(0, _photoView.bottom - 20, _photoView.width, 20);
    self.dianPuName_Label.frame = CGRectMake(5, 0, _titleView.width * 2/3.f, _titleView.height);
    self.distance_label.frame = CGRectMake(_titleView.width - _distance_label.width - 5, 0, _distance_label.width, _titleView.height);
    
    self.infoView.frame = CGRectMake(0, _photoView.bottom, _photoView.width, 33);
    self.price_label.frame = CGRectMake(5, 0, 50, 20);
    _price_label.center = CGPointMake(_price_label.center.x, _infoView.height / 2.f);
    
    self.discount_label.frame = CGRectMake(_price_label.right + 5, _price_label.top, 40, 20);
    
    self.like_label.frame = CGRectMake(_infoView.width - 5 - _like_label.width, _discount_label.top, _like_label.width, 20);
    
    self.like_btn.frame = CGRectMake(_like_label.left - 20 - 2, 0, 20, 20);
    _like_btn.center = CGPointMake(_like_btn.center.x, _like_label.center.y);
}

- (void)setCellWithModel:(ProductModel *)aModel
{
    NSString *imageurl;
    if (aModel.imagelist.count >= 1) {
        
        NSDictionary *imageDic = aModel.imagelist[0];
        NSDictionary *middleImage = imageDic[@"540Middle"];
        imageurl = middleImage[@"src"];
    }

    [self.photoView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:nil];
    self.dianPuName_Label.text = aModel.mall_name;
    
    NSString *distanceStr = [NSString stringWithFormat:@"%@m",aModel.distance];
    self.distance_label.text = distanceStr;
    _distance_label.width = [LTools widthForText:distanceStr font:12];
    
    NSString *price = [NSString stringWithFormat:@"%.1f",[aModel.product_price floatValue]];
    [self.price_label setTitle:price forState:UIControlStateNormal];
    self.price_label.layer.cornerRadius = 10;
    
    CGFloat disc = aModel.discount_num;
    
    if (disc == 0 || disc == 1) {
        
        self.discount_label.hidden = YES;
    }else
    {
        self.discount_label.hidden = NO;
    }
        
    NSString *discount = [NSString stringWithFormat:@"%.1f折",aModel.discount_num * 10];
    [self.discount_label setTitle:discount forState:UIControlStateNormal];
    self.discount_label.layer.cornerRadius = 10;
    
    self.like_btn.selected = aModel.is_like == 1 ? YES : NO;
    
    NSLog(@"like ---- > %d",(int)aModel.is_like);
    
    self.like_label.text = aModel.product_like_num;
    
    _like_label.width = [LTools widthForText:aModel.product_like_num font:12.f];
    
    [self layoutSubviews];
}

@end
