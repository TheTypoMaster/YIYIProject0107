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
        
        self.backGroudView = [[UIView alloc]init];
        _backGroudView.clipsToBounds = YES;
        [self addSubview:_backGroudView];
        
        //大图 大图放置赞
        self.photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        _photoView.userInteractionEnabled =  YES;
        [_backGroudView addSubview:_photoView];
        
        self.likeBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBackBtn addCornerRadius:3.f];
        _likeBackBtn.backgroundColor = [UIColor colorWithHexString:@"fdf8f9"];
        [_photoView addSubview:_likeBackBtn];
        
        _likeBackBtn.alpha = 0.8;

        
        self.like_label = [[UILabel alloc]init];
        _like_label.backgroundColor = [UIColor clearColor];
        _like_label.font = [UIFont systemFontOfSize:10];
        _like_label.textAlignment = NSTextAlignmentCenter;
        _like_label.textColor = [UIColor colorWithHexString:@"df81a3"];
        [_likeBackBtn addSubview:_like_label];

        
        self.like_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_like_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_like_btn setImage:[UIImage imageNamed:@"danpin_zan_normal"] forState:UIControlStateNormal];
        [_like_btn setImage:[UIImage imageNamed:@"danpin_zan_selected"] forState:UIControlStateSelected];
        [_likeBackBtn addSubview:_like_btn];
        _like_btn.userInteractionEnabled = NO;
        
        
        //infoView 存放 店铺名 价格 打折 距离
        
        self.infoView = [[UIView alloc]init];
        _infoView.backgroundColor = [UIColor whiteColor];
        [_backGroudView addSubview:_infoView];
        [_infoView setBorderWidth:0.5 borderColor:DEFAULT_VIEW_BACKGROUNDCOLOR];
        
        //店铺名
        
        self.dianPuName_Label = [[UILabel alloc] init];
        _dianPuName_Label.textColor = [UIColor colorWithHexString:@"323232"];
        _dianPuName_Label.textAlignment = NSTextAlignmentLeft;
        _dianPuName_Label.font = [UIFont systemFontOfSize:12];
        [_infoView addSubview:_dianPuName_Label];

//        _priceView = [[UIView alloc]init];
//        [_infoView addSubview:_priceView];
        
        //价格图标
        _priceImageView = [[UIImageView alloc]init];
        _priceImageView.image = [UIImage imageNamed:@"danpin_price_b"];
        [_infoView addSubview:_priceImageView];
        
        //价格
        self.price_label = [[UILabel alloc] init];
        _price_label.textColor = [UIColor colorWithHexString:@"bc2f42"];
        _price_label.font = [UIFont systemFontOfSize:10];
        [_infoView addSubview:_price_label];
        
        _discountView = [[UIView alloc]init];
        [_infoView addSubview:_discountView];
        
        //折扣图标
        _discountImageView = [[UIImageView alloc]init];
        _discountImageView.image = [UIImage imageNamed:@"danpin_discount_b"];
        [_discountView addSubview:_discountImageView];
        
        //折扣
        self.discount_label = [[UILabel alloc] init];
        _discount_label.textColor = [UIColor colorWithHexString:@"4e4e4e"];
        _discount_label.font = [UIFont systemFontOfSize:10];
        [_discountView addSubview:_discount_label];
        
        //距离图标
        _distanceImageView = [[UIImageView alloc]init];
        _distanceImageView.image = [UIImage imageNamed:@"danpin_distance_b"];
        [_infoView addSubview:_distanceImageView];
        
        //距离
        self.distance_label = [[UILabel alloc] init];
        _distance_label.font = [UIFont systemFontOfSize:10.f];
        _distance_label.textColor = [UIColor colorWithHexString:@"4e4e4e"];
        _distance_label.textAlignment = NSTextAlignmentLeft;
        [_infoView addSubview:_distance_label];
        
//        _price_label.backgroundColor = [UIColor redColor];
//        _distance_label.backgroundColor = [UIColor greenColor];
//        _discount_label.backgroundColor = [UIColor blueColor];
        
        
    }
    return self;
}

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
//    _backGroudView.layer.cornerRadius = 3.f;
    
    CGFloat infoHeight = 0.f;//infoView高度
    if (self.cellStyle == CELLSTYLE_DanPinList) {
        infoHeight = 45.f;
    }else if (_cellStyle == CELLSTYLE_DianPuList || _cellStyle == CELLSTYLE_CollectList){
        infoHeight = 25.f;
    }

    
    CGRect aBound = self.bounds;
    aBound.size.height -= infoHeight;
    self.photoView.frame = CGRectInset(aBound, kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
    
    
    //infoView 存放 店铺名 价格 打折 距离
    
    self.infoView.frame = CGRectMake(0, _photoView.bottom, _photoView.width, infoHeight);

    //店铺名
    self.dianPuName_Label.frame = CGRectMake(5, 0, _infoView.width - 5 * 2, _infoView.height/2.f);
    
    
    CGFloat priceTop = 0.f;
    if (self.cellStyle == CELLSTYLE_DanPinList) {
        priceTop = _dianPuName_Label.bottom;
    }else if (_cellStyle == CELLSTYLE_DianPuList || _cellStyle == CELLSTYLE_CollectList){
        priceTop = 2.5f;
    }
    
    CGFloat priceWidth = (_infoView.width - 5 - 5 - 5) / 3;
    CGFloat imageWidth = 12;//图标宽度
    CGFloat labelWidth = priceWidth - imageWidth;//价格、折扣、距离label宽度
    
    CGFloat imageTitleDis = 3.f;//图标和文字之间距离
//============== 价格 ==========
    _priceImageView.frame = CGRectMake(_dianPuName_Label.left, priceTop + 4, imageWidth, imageWidth);
    //价格
    self.price_label.frame = CGRectMake(_priceImageView.right + imageTitleDis, priceTop, labelWidth + 3, 20);
//============== 折扣 ==========
//这个比较特殊,label和imageView放在一个view上的;discount_label的宽度少6 distance_label\price_label 每个加3
    
    _discountView.frame = CGRectMake(0, priceTop, priceWidth - 6, 20);
    _discountView.centerX = _infoView.width/2.f;
    _discountImageView.frame = CGRectMake(0, 4, imageWidth, imageWidth);
    //打折
    self.discount_label.frame = CGRectMake(_discountImageView.right + imageTitleDis, 0, labelWidth - 6, 20);
//============== 距离 ==========
    
    
    //单品样式 店铺的时候没有距离
    if (_cellStyle != CELLSTYLE_DianPuList) {
        
        _distanceImageView.frame = CGRectMake(_infoView.width - 5 - imageWidth - labelWidth - imageTitleDis, _priceImageView.top, imageWidth, imageWidth);
        //距离
        self.distance_label.frame = CGRectMake(_distanceImageView.right + imageTitleDis, _price_label.top, labelWidth + 3, 20);
        
        //赞view
        CGFloat likeBackBtnWidth = 40;
        self.likeBackBtn.frame = CGRectMake(_photoView.width - 5 - likeBackBtnWidth, _photoView.height - 3 - 17, likeBackBtnWidth, 17);
        
        self.like_btn.frame = CGRectMake(0, 0, 17, 17);
        
        self.like_label.frame = CGRectMake(_like_btn.right, 0, likeBackBtnWidth - _like_btn.width, 17);
    }else
    {
        [_infoView addSubview:_like_btn];
        [_infoView addSubview:_like_label];
        
        _like_btn.frame = CGRectMake(_infoView.width - 5 - imageWidth - labelWidth - imageTitleDis, _priceImageView.top, imageWidth, imageWidth);
        _like_btn.userInteractionEnabled = YES;
        //距离
        _like_label.textAlignment = NSTextAlignmentLeft;
        self.like_label.frame = CGRectMake(_like_btn.right + imageTitleDis, _price_label.top, labelWidth + 3, 20);
    }
    
}

- (void)setCellWithModel:(ProductModel *)aModel
{
    NSString *imageurl;
    if (aModel.imagelist.count >= 1) {
        
        NSDictionary *imageDic = aModel.imagelist[0];
        NSDictionary *middleImage = imageDic[@"540Middle"];
        imageurl = middleImage[@"src"];
    }

    self.photoView.backgroundColor = [UIColor lightGrayColor];
    
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:nil];
    self.dianPuName_Label.text = aModel.mall_name;
    
    NSString *distanceStr;
    
    double dis = [aModel.distance doubleValue];
    
    if (dis > 1000) {
        
        distanceStr = [NSString stringWithFormat:@"%.1fkm",dis/1000];
    }else
    {
        distanceStr = [NSString stringWithFormat:@"%@m",aModel.distance];
    }
    
    self.distance_label.text = distanceStr;
    _distance_label.width = [LTools widthForText:distanceStr font:12];
    
    NSString *price = [NSString stringWithFormat:@"%.1f",[aModel.product_price floatValue]];
    
    self.price_label.text = [price stringByRemoveTrailZero];
    
    CGFloat disc = aModel.discount_num;
    
    if (disc == 0 || disc == 1) {
        
        _discountView.hidden = YES;
    }else
    {
        _discountView.hidden = NO;
    }
        
    NSString *discount = [NSString stringWithFormat:@"%.1f",aModel.discount_num * 10];
    self.discount_label.text = [NSString stringWithFormat:@"%@折",[discount stringByRemoveTrailZero]];
    
    self.like_btn.selected = aModel.is_like == 1 ? YES : NO;
    
    NSString *zanNum = [NSString stringWithFormat:@"%d",[aModel.product_like_num intValue]];
    self.like_label.text = zanNum;
    
    [self layoutSubviews];
}

@end
