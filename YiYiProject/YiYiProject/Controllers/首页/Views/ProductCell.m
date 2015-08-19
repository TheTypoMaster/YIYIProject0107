//
//  ProductCell.m
//  YiYiProject
//
//  Created by lichaowei on 15/8/18.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)dealloc {
    _photoView = nil;
    _titleLabel = nil;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.backGroudView = [[UIView alloc]init];
        _backGroudView.clipsToBounds = YES;
        [self addSubview:_backGroudView];
        _backGroudView.userInteractionEnabled = NO;
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
        
        //底部竖线
        self.lineHeng = [[UIView alloc]init];
        _lineHeng.backgroundColor = DEFAULT_LINE_COLOR;
        [_dianPuName_Label addSubview:_lineHeng];
        
#pragma - mark 价格
        
        //价格
        self.price_label = [[UILabel alloc] init];
        _price_label.textColor = [UIColor colorWithHexString:@"bc2f42"];
        _price_label.font = [UIFont systemFontOfSize:10];
        _price_label.textAlignment = NSTextAlignmentCenter;
        [_infoView addSubview:_price_label];
        
#pragma - mark 打折
        //折扣
        self.discount_label = [[UILabel alloc] init];
        _discount_label.textColor = [UIColor colorWithHexString:@"4e4e4e"];
        _discount_label.font = [UIFont systemFontOfSize:10];
        _discount_label.textAlignment = NSTextAlignmentCenter;
        [_infoView addSubview:_discount_label];
        
        self.lineShuLeft = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.5, 10)];
        _lineShuLeft.backgroundColor = DEFAULT_LINE_COLOR;
        [_discount_label addSubview:_lineShuLeft];
        
#pragma - mark 距离
        
        //距离
        self.distance_label = [[UILabel alloc] init];
        _distance_label.font = [UIFont systemFontOfSize:10.f];
        _distance_label.textColor = [UIColor colorWithHexString:@"4e4e4e"];
        _distance_label.textAlignment = NSTextAlignmentCenter;
        [_infoView addSubview:_distance_label];
        
        self.lineShuRight = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.5, 10)];
        _lineShuRight.backgroundColor = DEFAULT_LINE_COLOR;
        [_distance_label addSubview:_lineShuRight];
        
        //        _price_label.backgroundColor = [UIColor redColor];
        //        _distance_label.backgroundColor = [UIColor greenColor];
        //        _discount_label.backgroundColor = [UIColor blueColor];
        
        //        _priceView.backgroundColor = [UIColor orangeColor];
        //        _distanceView.backgroundColor = [UIColor redColor];
        //        _discountView.backgroundColor = [UIColor lightGrayColor];
        
        
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
    
    CGFloat infoHeight = 0.f;//infoView高度
    if (self.cellStyle == CELLSTYLE_DanPinList) {
        infoHeight = 45.f;
    }else if (_cellStyle == CELLSTYLE_DianPuList || _cellStyle == CELLSTYLE_CollectList || _cellStyle == CELLSTYLE_BrandRecommendList){
        infoHeight = 25.f;
    }
    
    CGRect aBound = self.bounds;
    aBound.size.height -= infoHeight;
    self.photoView.frame = CGRectInset(aBound, 0, 0);
    
    //infoView 存放 店铺名 价格 打折 距离
    self.infoView.frame = CGRectMake(0, _photoView.bottom, _photoView.width, infoHeight);
    
    //3分之1宽度
    CGFloat evertyWidth = _photoView.width / 3.f;
    CGFloat top = (infoHeight - 20) - 2.5;
    
    CGFloat top_likeBackBtn = _photoView.height - 3 - 17;//赞 背景view
    
    //店铺名
    self.dianPuName_Label.frame = CGRectMake(5, 0, _infoView.width - 5 * 2, infoHeight/2.f);
    if (infoHeight == 0.f || infoHeight == 25.f) {
        
        self.lineHeng.hidden = YES;
        
    }else
    {
        self.lineHeng.frame = CGRectMake(0, _dianPuName_Label.height - 0.5, _infoView.width, 0.5);
        self.lineHeng.hidden = NO;
    }
    
    if (_cellStyle == CELLSTYLE_DianPuList) {
        //价格
        self.price_label.frame = CGRectMake(0, top + 5, evertyWidth, 10);
        //打折
        self.discount_label.frame = CGRectMake(evertyWidth, _price_label.top, _price_label.width, _price_label.height);
        
        //控制赞 显示位置
        [_infoView addSubview:_likeBackBtn];
        top_likeBackBtn = (_infoView.height - 17)/2.f;
        
    }else if (_cellStyle == CELLSTYLE_CollectList || _cellStyle == CELLSTYLE_BrandRecommendList){
        
        //价格
        self.price_label.frame = CGRectMake(0, top + 5, evertyWidth, 10);
        //打折
        self.discount_label.frame = CGRectMake(evertyWidth, _price_label.top, _price_label.width, _price_label.height);
        
        //隐藏店铺名
        self.dianPuName_Label.hidden = YES;
        
        //控制赞 显示位置
        [_infoView addSubview:_likeBackBtn];
        top_likeBackBtn = (_infoView.height - 17)/2.f;
        
    }else
    {
        //价格
        self.price_label.frame = CGRectMake(0, top + 5, evertyWidth, 10);
        //打折
        self.discount_label.frame = CGRectMake(evertyWidth, _price_label.top, _price_label.width, _price_label.height);
        //距离
        self.distance_label.frame = CGRectMake(evertyWidth * 2, _price_label.top,  _price_label.width, _price_label.height);
    }
    
    //赞view
    CGFloat likeBackBtnWidth = 40;
    self.likeBackBtn.frame = CGRectMake(_photoView.width - 5 - likeBackBtnWidth, top_likeBackBtn, likeBackBtnWidth, 17);
    self.like_btn.frame = CGRectMake(0, 0, 17, 17);
    self.like_label.frame = CGRectMake(_like_btn.right, 0, likeBackBtnWidth - _like_btn.width, 17);
    
    
    
    //    CELLSTYLE_DanPinList = 0, //单品列表样式 有店名、价格、折扣、距离,点赞在图片左下角
    //    CELLSTYLE_CollectList = 2, //收藏 和 单品列表类似,只是没有店名
    //    CELLSTYLE_BrandRecommendList = 3 //品牌推荐 只有点赞、大图
    //    CELLSTYLE_DianPuList = 1, //店铺列表样式 有店名、价格、折扣、不显示距离,点赞不在图片上,在价格等infoView上
    
}


- (NSAttributedString *)textForString:(NSString *)text
                                image:(UIImage *)image
{
    NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];//添加附件,图片
    textAttachment.image = image;
    CGRect bounds = textAttachment.bounds;
    bounds.origin.y = -1;
    bounds.size = CGSizeMake(10, 10);
    textAttachment.bounds = bounds;
    
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:text];
    [str insertAttributedString:imageStr atIndex:0];
    return str;
}

- (void)setCellWithModel:(ProductModel *)aModel
{
    NSString *imageurl;
    if (aModel.imagelist.count >= 1) {
        
        NSDictionary *imageDic = aModel.imagelist[0];
        NSDictionary *middleImage = imageDic[@"540Middle"];
        imageurl = middleImage[@"src"];
    }
    
    [self.photoView l_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:DEFAULT_YIJIAYI];
    self.photoView.backgroundColor = DEFAULT_VIEW_BACKGROUNDCOLOR;
    
    ShopType shopType = [aModel.mall_type intValue];
    
    NSString *brandName = [aModel.brand_info stringValueForKey:@"brand_name" defaultValue:@""];
    
    NSString *shopName = nil;
    if (shopType == ShopType_pinpaiDian && ![LTools isEmpty:brandName]) {
        
        shopName = [NSString stringWithFormat:@"%@.%@",brandName,aModel.mall_name];
    }else
    {
        shopName = aModel.mall_name;
    }
    
    self.dianPuName_Label.text = shopName;
    
    //距离
    NSString *distanceStr;
    double dis = [aModel.distance doubleValue];
    
    if (dis > 1000) {
        
        distanceStr = [NSString stringWithFormat:@" %.1fkm",dis/1000];
    }else
    {
        distanceStr = [NSString stringWithFormat:@" %@m",aModel.distance];
    }
    self.distance_label.text = distanceStr;
    [self.distance_label setAttributedText:[self textForString:distanceStr image:[UIImage imageNamed:@"danpin_distance_b"]]];
    
    //价格
    NSString *price = [NSString stringWithFormat:@"%.1f",[aModel.product_price floatValue]];
    price = [price stringByRemoveTrailZero];
    [self.price_label setAttributedText:[self textForString:price image:[UIImage imageNamed:@"danpin_price_b"]]];
    
    CGFloat disc = aModel.discount_num;
    if (disc == 0 || disc == 1) {
        [self.discount_label setAttributedText:nil];
    }else
    {
        NSString *discount = [NSString stringWithFormat:@" %.1f",aModel.discount_num * 10];
        discount = [NSString stringWithFormat:@"%@折",[discount stringByRemoveTrailZero]];
        [self.discount_label setAttributedText:[self textForString:discount image:[UIImage imageNamed:@"danpin_discount_b"]]];
    }
    
    self.like_btn.selected = aModel.is_like == 1 ? YES : NO;
    
    NSString *zanNum = [NSString stringWithFormat:@"%d",[aModel.product_like_num intValue]];
    self.like_label.text = zanNum;
    //    self.like_label setAttributedText:[self textForString:zanNum image:[UIImage imageNamed:@"danpin_zan_normal"]]
    
    [self layoutSubviews];
}


- (void)setCellWithModel222:(ProductModel *)aModel
{
    NSString *imageurl;
    NSDictionary *images = (NSDictionary *)aModel.images;
    if (images && [images isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *middleImage = [images objectForKey:@"540Middle"];
        imageurl = middleImage[@"src"];
        
    }
    
    [self.photoView l_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:DEFAULT_YIJIAYI];
    self.photoView.backgroundColor = DEFAULT_VIEW_BACKGROUNDCOLOR;
    
    ShopType shopType = [aModel.mall_type intValue];
    
    NSString *brandName = [aModel.brand_info stringValueForKey:@"brand_name" defaultValue:@""];
    
    NSString *shopName = nil;
    if (shopType == ShopType_pinpaiDian && ![LTools isEmpty:brandName]) {
        
        shopName = [NSString stringWithFormat:@"%@.%@",brandName,aModel.mall_name];
    }else
    {
        shopName = aModel.mall_name;
    }
    
    self.dianPuName_Label.text = shopName;
    
    //距离
    NSString *distanceStr;
    double dis = [aModel.distance doubleValue];
    
    if (dis > 1000) {
        
        distanceStr = [NSString stringWithFormat:@" %.1fkm",dis/1000];
    }else
    {
        distanceStr = [NSString stringWithFormat:@" %@m",aModel.distance];
    }
    self.distance_label.text = distanceStr;
    [self.distance_label setAttributedText:[self textForString:distanceStr image:[UIImage imageNamed:@"danpin_distance_b"]]];
    
    //价格
    NSString *price = [NSString stringWithFormat:@"%.1f",[aModel.product_price floatValue]];
    price = [price stringByRemoveTrailZero];
    [self.price_label setAttributedText:[self textForString:price image:[UIImage imageNamed:@"danpin_price_b"]]];
    
    CGFloat disc = aModel.discount_num;
    if (disc == 0 || disc == 1) {
        _discount_label.hidden = YES;
    }else
    {
        _discount_label.hidden = NO;
    }
    
    NSString *discount = [NSString stringWithFormat:@" %.1f",aModel.discount_num * 10];
    discount = [NSString stringWithFormat:@"%@折",[discount stringByRemoveTrailZero]];
    [self.discount_label setAttributedText:[self textForString:discount image:[UIImage imageNamed:@"danpin_discount_b"]]];
    
    self.like_btn.selected = aModel.is_like == 1 ? YES : NO;
    
    NSString *zanNum = [NSString stringWithFormat:@"%d",[aModel.product_like_num intValue]];
    self.like_label.text = zanNum;
    
    [self layoutSubviews];
    
}



@end
