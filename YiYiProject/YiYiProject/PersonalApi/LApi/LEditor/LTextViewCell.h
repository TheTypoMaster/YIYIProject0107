//
//  LTextViewCell.h
//  TestTextEditor
//
//  Created by lichaowei on 14/12/3.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum {
    Text_ShouldBeginEditing = 0,
    Text_ShouldEndEditing,
    Text_DidBeginEditing,
    Text_DidEndEditing,
    Text_DidChange,
    Text_ShouldChangeTextInRange,
    Text_Delete
    
}TextChangeStyle;

typedef void(^TextChangeBlock)(TextChangeStyle textChangeStyle,UITextView *textView,NSDictionary *params);

@interface LTextViewCell : UITableViewCell<UITextViewDelegate>
{
    TextChangeBlock changeBlock;
    
    CGFloat keyboard_y;

    UILabel *placeHolderLabel;
}

@property(nonatomic,retain)UITextView *textView;

@property(nonatomic,assign)BOOL showPlaceholder;//是否显示placeholder
@property(nonatomic,retain)NSString *placeHolder;

- (void)setCellChangeStyelBlock:(TextChangeBlock)aBlock;

@end