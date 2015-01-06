//
//  Header.h
//  TestTextEditor
//
//  Created by lichaowei on 14/12/3.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#ifndef TestTextEditor_Header_h
#define TestTextEditor_Header_h

//整屏幕的Frame
#define ALL_FRAME [UIScreen mainScreen].applicationFrame

//整屏幕的Frame 宽
#define ALL_FRAME_WIDTH ALL_FRAME.size.width

//整屏幕的Frame 高
#define ALL_FRAME_HEIGHT ALL_FRAME.size.height

#define CELL_NEW_HEIGHT @"CELL_NEW_HEIGHT" //cell 高度

#define KEYBOARD_FRAME_Y @"KEYBOARD_FRAME_Y" //键盘 y

#define CELL_TEXT @"CELL_TEXT" //内容

#define First_TextView @"First_TextView" //记录当前响应者 textView
#define First_IndexPath @"First_IndexPath" //记录响应者 indexPath

#define ORIGINAL_HEIGHT 38.F

#define ORIGINAL_HEIGHT_IMAGE 200.F

#import "UIView+Frame.h"
#import "LImageCell.h"
#import "LTextViewCell.h"
#import "LPropertyActionSheet.h"

#endif
