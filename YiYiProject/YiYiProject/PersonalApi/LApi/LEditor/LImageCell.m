//
//  LImageCell.m
//  TestTextEditor
//
//  Created by lichaowei on 14/12/3.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "LImageCell.h"
#import "Header.h"

@implementation LImageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //初始高度 20
        self.aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, ALL_FRAME_WIDTH - 20, 0)];
        _aImageView.backgroundColor = [UIColor whiteColor];
        
        _aImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _aImageView.userInteractionEnabled = YES;
        
        [self addSubview:_aImageView];
        
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesture:)];
        longGes.minimumPressDuration = 0.5;
        [_aImageView addGestureRecognizer:longGes];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setImageGestureBlock:(ImageGestureBlock)aBlock
{
    imageBlock = aBlock;
}

- (void)longGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        if (imageBlock) {
            imageBlock(Image_longPress,self.aImageView,self.indexPath);
        }
        
        
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        //未用
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        //未用
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        
        
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (imageBlock) {
            imageBlock(Image_tap,self.aImageView,self.indexPath);
        }
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        //未用
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
