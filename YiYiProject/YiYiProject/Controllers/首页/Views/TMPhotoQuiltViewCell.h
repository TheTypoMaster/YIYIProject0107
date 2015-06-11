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

#import <UIKit/UIKit.h>
#import "TMQuiltViewCell.h"
#import "ProductModel.h"
@interface TMPhotoQuiltViewCell : TMQuiltViewCell
{
    UIView *_priceView;
    UIImageView *_priceImageView;//价格图标
    UIView *_discountView;
    UIImageView *_discountImageView;//折扣图标
    UIView *_distanceView;
    UIImageView *_distanceImageView;//距离图标
}

@property(nonatomic,retain)UIView *backGroudView;//背景view

@property (nonatomic, retain) UIImageView *photoView;
@property (nonatomic, retain) UILabel *titleLabel;

//@property(nonatomic,retain)UIView *titleView;//存放 店铺名、距离
@property(nonatomic,retain)UILabel *dianPuName_Label;//店铺名
@property(nonatomic,retain)UILabel *distance_label;//距离

@property(nonatomic,retain)UIView *infoView;//存放 价格 打折 收藏

@property(nonatomic,retain)UILabel *price_label;//价格
@property(nonatomic,retain)UILabel *discount_label;//打折

@property(nonatomic,retain)UIButton *likeBackBtn;//喜欢的背景大button
@property(nonatomic,retain)UIButton *like_btn;//喜欢标识
@property(nonatomic,retain)UILabel *like_label;//喜欢数量

- (void)setCellWithModel:(ProductModel *)aModel;

@end
