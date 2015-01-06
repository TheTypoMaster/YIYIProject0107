//
//  LImageCell.h
//  TestTextEditor
//
//  Created by lichaowei on 14/12/3.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    Image_tap = 0,
    Image_longPress,
    
}ImageGesture;

typedef void(^ImageGestureBlock)(ImageGesture imageGestureStyle,UIImageView *imageView,NSIndexPath *imageIndexPath);
@interface LImageCell : UITableViewCell
{
    ImageGestureBlock imageBlock;
}

@property(nonatomic,retain)UIImageView *aImageView;

@property(nonatomic,retain)NSIndexPath *indexPath;

- (void)setImageGestureBlock:(ImageGestureBlock)aBlock;

@end
