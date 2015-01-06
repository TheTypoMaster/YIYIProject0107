//
//  LTextViewCell.m
//  TestTextEditor
//
//  Created by lichaowei on 14/12/3.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "LTextViewCell.h"
#import "Header.h"

@implementation LTextViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //初始高度 20
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, ALL_FRAME_WIDTH - 20, ORIGINAL_HEIGHT)];
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.scrollEnabled = NO;
        [self addSubview:_textView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellChangeStyelBlock:(TextChangeBlock)aBlock
{
    changeBlock = aBlock;
    
    if (self.showPlaceholder) {
        
        if (placeHolderLabel == nil) {
            placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, ORIGINAL_HEIGHT)];
            placeHolderLabel.text = self.placeHolder.length > 0 ? self.placeHolder : @"正文";
            placeHolderLabel.font = [UIFont systemFontOfSize:18];
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = [UIColor lightGrayColor];
            [_textView addSubview:placeHolderLabel];
        }
       
    }else
    {
        if (placeHolderLabel) {
            placeHolderLabel.hidden = YES;
            [placeHolderLabel removeFromSuperview];
            
        }
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewShouldBeginEditing");
    
    if (changeBlock) {
        changeBlock(Text_ShouldBeginEditing,textView,nil);
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"textViewShouldEndEditing");
    
    CGFloat aHeight = [self newHeight];
    
    textView.height = aHeight;
    
    NSDictionary *parsms = @{CELL_NEW_HEIGHT:[NSNumber numberWithFloat:aHeight]};
    
    if (changeBlock) {
        changeBlock(Text_ShouldEndEditing,textView,parsms);
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewShouldEndEditing");
    if (changeBlock) {
        changeBlock(Text_DidBeginEditing,textView,nil);
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textViewShouldEndEditing");
    if (changeBlock) {
        changeBlock(Text_DidEndEditing,textView,nil);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length == 0 && range.length == 0 && range.location == 0) {
        
        //删除
        
        NSLog(@"textViewText %@ range %@ text %@",textView.text,NSStringFromRange(range),text);
        
        if (changeBlock) {
            changeBlock(Text_Delete,textView,nil);
        }
    }
    
    CGFloat aHeight = [self newHeight];
    
    textView.height = aHeight;
    
    NSDictionary *parsms = @{CELL_NEW_HEIGHT:[NSNumber numberWithFloat:aHeight]};
    
    if (changeBlock) {
        changeBlock(Text_ShouldChangeTextInRange,textView,parsms);
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
//    if (self.showPlaceholder) {
    
        if (textView.text.length == 0) {
            placeHolderLabel.hidden = NO;
            
//            NSLog(@"placeHolderLabel.hidden NO %@",placeHolderLabel);
        }else
        {
            placeHolderLabel.hidden = YES;
//            NSLog(@"placeHolderLabel.hidden YES %@",placeHolderLabel);
        }
//    }
    
    CGFloat aHeight = [self newHeight];
    
    textView.height = aHeight;
    
    NSDictionary *parsms = @{CELL_NEW_HEIGHT:[NSNumber numberWithFloat:aHeight]};
    
    NSLog(@"新的高度 %f",textView.height);
    
    if (changeBlock) {
        changeBlock(Text_DidChange,textView,parsms);
    }
}

//新高度

- (CGFloat)newHeight
{
    CGFloat aHeight = [self.textView sizeThatFits:CGSizeMake(ALL_FRAME_WIDTH - 20, MAXFLOAT)].height;
    
    aHeight = aHeight > ORIGINAL_HEIGHT ? aHeight : ORIGINAL_HEIGHT;
    
    return aHeight;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}
//
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0)
//{
//    
//}
//
//- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0)
//{
//    
//}


@end
