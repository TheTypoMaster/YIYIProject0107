//
//  LRichTextView.m
//  YiYiProject
//
//  Created by lichaowei on 15/6/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "LRichTextView.h"
#import "AFNetworking.h"


@implementation LRichTextView
{
    NSMutableArray *content_arr;//存储高度、内容
    CGFloat _constImageWidth;//固定图片显示宽度
}

-(instancetype)initWithFrame:(CGRect)frame rootViewController:(UIViewController *)rootVc
{
    self = [super initWithFrame:frame];
    if (self) {
        
        rootViewController = rootVc;
        originalHeight = frame.size.height;
        
        _constImageWidth = DEVICE_WIDTH - 20;//图片显示宽度
        
//        self.backgroundColor = [UIColor greenColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHidden:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        //    tap.enabled = NO;
        
//        self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, DEVICE_WIDTH - 20, 40)];
//        _titleTextField.font = [UIFont systemFontOfSize:18];
//        _titleTextField.attributedPlaceholder = [LTools attributedString:@"标题" keyword:@"标题" color:[UIColor lightGrayColor]];
//        [self addSubview:_titleTextField];
        
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _titleTextField.bottom - 0.5, DEVICE_WIDTH, 0.5)];
//        line.backgroundColor = RGBCOLOR(223, 222, 222);
//        [self addSubview:line];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        //存放每个cell的高度、内容
        content_arr = [NSMutableArray array];
        
        //默认一个文字输入框,高度为100
        NSDictionary *params = @{CELL_NEW_HEIGHT:[NSNumber numberWithFloat:ORIGINAL_HEIGHT],CELL_NEW_WIDTH:[NSNumber numberWithFloat:100]};//宽度暂定
        
        [content_arr addObject:params];
        
        // 创建一个textView实例用于计算高度
        [self createCalcuteTextView];
        
        [self createTools];
        
    }
    return self;
}

#pragma mark 创建视图

/**
 *  创建工具
 */
- (void)createTools
{
    toolsView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 40)];
    toolsView.backgroundColor = [UIColor clearColor];
    [self addSubview:toolsView];
    
    //收缩键盘按钮
    
    UIButton *keyboard_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [keyboard_button setImage:[UIImage imageNamed:@"fabu_shous"] forState:UIControlStateNormal];
    keyboard_button.frame = CGRectMake(toolsView.width - 50, 0, 50, 40);
    keyboard_button.backgroundColor = [UIColor clearColor];
    
    [toolsView addSubview:keyboard_button];
    
    [keyboard_button addTarget:self action:@selector(clickToHidden:) forControlEvents:UIControlEventTouchUpInside];
}

//创建一个textView用来计算需要的高度
- (void)createCalcuteTextView
{
    calculate_textView = [[UITextView alloc]init];
    calculate_textView.font = [UIFont systemFontOfSize:18];
    [self addSubview:calculate_textView];
}

#pragma mark 事件处理

- (NSArray *)content
{
    return content_arr;
}

- (NSString *)editorTitle
{
    return self.titleTextField.text;
}

/**
 *  编辑内容
 *
 *  @param contentArr 是个数组
 */
- (void)editContentArray:(NSArray *)contentArr
{
    //不是正确格式数据return,不做处理
    if (![contentArr isKindOfClass:[NSArray class]] || contentArr.count == 0) {
        return;
    }
    
    //处理content_arr
    
    [content_arr removeAllObjects];
    
    for (NSDictionary *aDic in contentArr) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        int type = [aDic[@"type"]intValue];
        
        if (type == 1) {
            
            //文字
            //文字处理
            
            NSString *content = aDic[@"content"];
            
            CGFloat height = [self heightForText:content];
            
            [dic setObject:[NSNumber numberWithFloat:height] forKey:CELL_NEW_HEIGHT];
            [dic setObject:[NSNumber numberWithFloat:_constImageWidth] forKey:CELL_NEW_WIDTH];
            [dic setObject:content forKey:CELL_CONTENT];
            
            [content_arr addObject:dic];

            
        }else if (type == 2){
            
            //图片
            //图片处理
            
            CGFloat imageHeight = [aDic[@"height"]floatValue];
            CGFloat imageWidth = [aDic[@"width"]floatValue];
            NSString *image = aDic[@"src"];
            
            [dic setObject:[NSNumber numberWithFloat:[LTools heightForImageHeight:imageHeight imageWidth:imageWidth originalWidth:_constImageWidth]] forKey:CELL_NEW_HEIGHT];
            [dic setObject:[NSNumber numberWithFloat:_constImageWidth] forKey:CELL_NEW_WIDTH];
            [dic setObject:image forKey:CELL_CONTENT];
        
            [content_arr addObject:dic];
        }
    }
    
    [_tableView reloadData];
}

/**
 *  自动加一行文本编辑区域,或者 下面有文本编辑区域的 让其变为第一响应者
 */

- (void)addNewTextCellForIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndexPath];
    
    if ([nextCell isKindOfClass:[LTextViewCell class]]) {
        
        LTextViewCell *textCell = (LTextViewCell *)nextCell;
        [textCell.textView becomeFirstResponder];
        
        [self.tableView scrollRectToVisible:textCell.frame animated:YES];
        
    }else
    {
        [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndexPath];
        LTextViewCell *textCell = (LTextViewCell *)nextCell;
        [textCell.textView becomeFirstResponder];
    }
}


/**
 *  计算文字高度
 *
 *  @param text 文字内容
 *
 *  @return 返回高度
 */
- (CGFloat)heightForText:(NSString *)text
{
    calculate_textView.text = text;
    
    CGFloat aHeight_head = [calculate_textView sizeThatFits:CGSizeMake(ALL_FRAME_WIDTH - 20, MAXFLOAT)].height;
    
    aHeight_head = (aHeight_head < ORIGINAL_HEIGHT) ? ORIGINAL_HEIGHT : aHeight_head;
    
    NSLog(@"--->%f",aHeight_head);
    
    return aHeight_head;
}

#pragma - mark 控制 image

/**
 *  计算图片显示时自适应高度
 *
 *  @param aImage 需要显示的image
 *
 *  @return
 */
- (CGFloat)heightForImage:(UIImage *)aImage
{
    //图片无效,返回 0
    if (!aImage) {
        
        return 0.f;
    }
    
    CGSize imageSize = aImage.size;
    
    //图片宽度和高度有效
    if (imageSize.width && imageSize.height) {
        
        CGFloat height = (_constImageWidth * imageSize.height) / imageSize.width;
        
        NSLog(@"imageHeight %f",height);
        
        return height;
    }
    
    return 0.f;
}

/**
 *  插入图片
 *
 *  @param aImage 图片对象
 */
- (void)addNewImage:(UIImage *)aImage
{
    //如果最后一个没有内容则干掉
    
    NSDictionary *lastDic = [content_arr lastObject];
    id content = [lastDic objectForKey:CELL_CONTENT];
    //内容为nil或者是空字符串,则remove掉
    if (!content || ([content isKindOfClass:[NSString class]] && ((NSString *)content).length == 0)) {
        
        [content_arr removeLastObject];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSNumber numberWithFloat:[self heightForImage:aImage]] forKey:CELL_NEW_HEIGHT];
    [dic setObject:[NSNumber numberWithFloat:_constImageWidth] forKey:CELL_NEW_WIDTH];
    [dic setObject:aImage forKey:CELL_CONTENT];
    
    [content_arr addObject:dic];
    
    [self.tableView reloadData];
    
}

/**
 *  文字中间插入 图片
 */
- (void)insertImage:(UIImage *)aImage
{
    UITextView *currentTextView = firstResponder_dic[First_TextView];
    
    NSIndexPath *currentIndexPath = firstResponder_dic[First_IndexPath];
    
    NSRange currentRange = currentTextView.selectedRange;//光标位置
    
    NSString *headText = [currentTextView.text substringToIndex:currentRange.location];
    
    headText = [self StringNoNull:headText];
    
    NSString *trailText = [currentTextView.text substringFromIndex:currentRange.location];
    
    trailText = [self StringNoNull:trailText];
    
    
    if (trailText.length == 0) { //说明不是文字中间插入 图片
        
        [self addNewImage:aImage];
        
        [self addNewTextCell];
        
        NSIndexPath *imageIndexPath = [NSIndexPath indexPathForRow:content_arr.count - 1 - 1 inSection:0];
        
        [self addNewTextCellForIndexPath:imageIndexPath];
        
        return;
    }
    
    
    //更新当前text 为前部分截取 text 及 高度
    
    [self updateHeight:[self heightForText:headText] forIndexPath:currentIndexPath];
    [self updateText:headText forIndexPath:currentIndexPath];
    
    //插入图片
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithFloat:[self heightForImage:aImage]] forKey:CELL_NEW_HEIGHT];
    [dic setObject:[NSNumber numberWithFloat:_constImageWidth] forKey:CELL_NEW_WIDTH];
    [dic setObject:aImage forKey:CELL_CONTENT];
    
    if (content_arr.count == currentIndexPath.row + 1) {
        [content_arr addObject:dic];
    }else
    {
        [content_arr insertObject:dic atIndex:currentIndexPath.row + 1];
    }
    
    //插入后面截取text

    NSMutableDictionary *dic_text = [NSMutableDictionary dictionary];
    
    [dic_text setObject:[NSNumber numberWithFloat:[self heightForText:trailText]] forKey:CELL_NEW_HEIGHT];
    [dic_text setObject:[NSNumber numberWithFloat:_constImageWidth] forKey:CELL_NEW_WIDTH];
    
    [dic_text setObject:trailText forKey:CELL_CONTENT];
    
    if (content_arr.count == currentIndexPath.row + 2) {
        [content_arr addObject:dic_text];
    }else
    {
        [content_arr insertObject:dic_text atIndex:currentIndexPath.row + 2];
    }
    
    [self.tableView reloadData];
    
    
    NSIndexPath *forIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + 1 inSection:0];
    
    [self addNewTextCellForIndexPath:forIndexPath];
}

#pragma - mark 控制 text

/**
 *  插入一个文本cell
 */
- (void)addNewTextCell
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    //text
    
    [dic setObject:[NSNumber numberWithFloat:ORIGINAL_HEIGHT] forKey:CELL_NEW_HEIGHT];
    
    [content_arr addObject:dic];
    
    [self.tableView reloadData];
}

/**
 *  根据indexPath获取cell高度
 *
 *  @param indexPath
 *
 *  @return
 */
- (CGFloat)getHeightForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat aHeight = ORIGINAL_HEIGHT;
    
    if (indexPath.row >= content_arr.count) {
        
        return aHeight;
    }
    
    NSDictionary *parms = [content_arr objectAtIndex:indexPath.row];
    
    if (parms) {
        aHeight = [[parms objectForKey:CELL_NEW_HEIGHT]floatValue];
    }
    
    return aHeight;
}

/**
 *  根据indexPath来更新对应的高度
 *
 *  @param aHeight   新的高度
 *  @param indexPath
 */
- (void)updateHeight:(CGFloat)aHeight forIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row >= content_arr.count) {
        return;
    }
    NSDictionary *parms = [content_arr objectAtIndex:indexPath.row];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parms];
    
    [dic setObject:[NSNumber numberWithFloat:aHeight] forKey:CELL_NEW_HEIGHT];
    
    [content_arr replaceObjectAtIndex:indexPath.row withObject:dic];
}


/**
 *  根据indexPath来获取对应的文本内容
 *
 *  @param indexPath
 *
 *  @return
 */
- (NSString *)getTextForIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = @"";
    
    if (indexPath.row >= content_arr.count) {
        
        return text;
    }
    
    NSDictionary *parms = [content_arr objectAtIndex:indexPath.row];
    
    if (parms) {
        text = [parms objectForKey:CELL_CONTENT];
    }
    
    return text;
}

/**
 *  根据indexPath来更新内容
 *
 *  @param text      新的文本内容
 *  @param indexPath
 */
- (void)updateText:(NSString *)text forIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *parms = [content_arr objectAtIndex:indexPath.row];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parms];
    
    if (text.length == 0) {
        text = @"";
    }
    
    [dic setObject:text forKey:CELL_CONTENT];
    
    [content_arr replaceObjectAtIndex:indexPath.row withObject:dic];
}

/**
 *  保证文字不能nil
 *
 *  @param text
 *
 *  @return
 */
- (NSString *)StringNoNull:(NSString *)text
{
    if (text == nil) {
        return @"";
    }
    return text;
}

//隐藏键盘
- (void)clickToHidden:(id)sender
{
    UITextView *currentTextView = firstResponder_dic[First_TextView];
    
    [currentTextView resignFirstResponder];
    
    [self.tableView reloadData];
    
    [self.titleTextField resignFirstResponder];
}

- (void)tapToHidden:(UIGestureRecognizer *)ges
{
    [self setFirstResponder];
}

/**
 *  隐藏键盘
 */
- (void)hiddenKeyboard
{
    [self clickToHidden:nil];
}
//第一个textView成为第一响应者
- (void)setFirstResponder
{
    [firstTextView becomeFirstResponder];
}


#pragma mark 代理


#pragma mark - UIActionSheet

- (void)actionSheet:(LPropertyActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",(int)buttonIndex);
    
    if (buttonIndex == 0) {
        
        NSLog(@"替换图片");
        
        isReplaceImage = YES;
        
        replaceImageView = actionSheet.selectImageView;
        replaceImageView.tag = 100 + actionSheet.selectIndexPath.row;
        
        [self clickToAddAlbum:nil];
        
    }else if (buttonIndex == 1){
        
        NSLog(@"删除图片");
        
        [content_arr removeObjectAtIndex:actionSheet.selectIndexPath.row];
        
        [self.tableView reloadData];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        
        
        return NO;
    }
    return  YES;
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *parms = [content_arr objectAtIndex:indexPath.row];
    
    id content  = [parms objectForKey:CELL_CONTENT];
    
    //判断是否是图片
    if ([content isKindOfClass:[UIImage class]]) {
        
        CGFloat height = [[parms objectForKey:CELL_NEW_HEIGHT] floatValue];
        
        return height;
    }
    
    CGFloat aHeight = [self getHeightForIndexPath:indexPath];
        
    return aHeight;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return content_arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"text";
    static NSString *identify2 = @"image";
    
    __weak typeof(self)weakSelf = self;
    
    __weak typeof(tableView)weakTable = tableView;
    
    NSDictionary *parms = [content_arr objectAtIndex:indexPath.row];
    
    id content  = [parms objectForKey:CELL_CONTENT];
    
    //判断是否是图片
    if ([content isKindOfClass:[UIImage class]] || [content hasPrefix:@"http://"]) {
        
        LImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[LImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
        }
        
//        cell.backgroundColor = [UIColor redColor];
        
        if ([content isKindOfClass:[UIImage class]]) {
            
            cell.aImageView.image = (UIImage *)content;

        }else
        {
            [cell.aImageView setImageWithURL:[NSURL URLWithString:content] placeHolderText:@"加载失败" backgroundColor:[UIColor lightGrayColor] holderTextColor:[UIColor whiteColor]];
        }
        
        
        CGFloat height = [[parms objectForKey:CELL_NEW_HEIGHT] floatValue];

        cell.aImageView.frame = CGRectMake(10, 0, _constImageWidth, height);
        
        __weak typeof(cell)weakImageCell = cell;
        
        [cell setImageGestureBlock:^(ImageGesture imageGestureStyle, UIImageView *imageView, NSIndexPath *imageIndexPath) {
            
            if (imageGestureStyle == Image_tap) {
                
                
                //是最后一个
                if (indexPath.row == content_arr.count - 1) {
                    
                    [self addNewTextCell];
                    
                }else //不是最后一个的时候  下一个如果是文本输入框 则 让其成为第一响应者;如果是图片呢,插入一个文本输入框
                {
                    
                    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
                    UITableViewCell *nextCell = [tableView cellForRowAtIndexPath:nextIndexPath];
                    
                    if ([nextCell isKindOfClass:[LTextViewCell class]]) {
                        
                        LTextViewCell *textCell = (LTextViewCell *)nextCell;
                        [textCell.textView becomeFirstResponder];
                        
                        [weakTable scrollRectToVisible:textCell.frame animated:YES];
                        
                    }else
                    {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        
                        [dic setObject:[NSNumber numberWithFloat:ORIGINAL_HEIGHT] forKey:CELL_NEW_HEIGHT];
                        
                        [content_arr insertObject:dic atIndex:nextIndexPath.row];
                        
                        [_tableView reloadData];
                        
                        //                        //是图片
                        [weakTable scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

                        UITableViewCell *nextCell = [tableView cellForRowAtIndexPath:nextIndexPath];
                        LTextViewCell *textCell = (LTextViewCell *)nextCell;
                        [textCell.textView becomeFirstResponder];
                        
//                        //是图片
//                        [weakTable scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                        
//                        UITableViewCell *nextCell = [tableView cellForRowAtIndexPath:nextIndexPath];
//                        LTextViewCell *textCell = (LTextViewCell *)nextCell;
//                        [textCell.textView becomeFirstResponder];
                    }
                }
                
                
            }else if(imageGestureStyle == Image_longPress)
            {
                LPropertyActionSheet *sheet = [[LPropertyActionSheet alloc]initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"替换图片",@"删除图片", nil];
                
                sheet.selectImageView = weakImageCell.aImageView;
                sheet.selectIndexPath = indexPath;
                
                [sheet showInView:[UIApplication sharedApplication].keyWindow];
            }
            
        }];
        
        return cell;
        
    }
    
    
    LTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[LTextViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
//        cell.backgroundColor = [UIColor greenColor];
    //    cell.contentView.backgroundColor = [UIColor grayColor];
    
    cell.textView.text = [self getTextForIndexPath:indexPath];
    
    cell.textView.height = [self getHeightForIndexPath:indexPath];
    
    cell.contentView.height = [self getHeightForIndexPath:indexPath];
    
    __weak typeof(cell)weakCell = cell;
    
    
    if (indexPath.row == 0) {
        
        firstTextView = cell.textView;
        cell.showPlaceholder = YES;
        cell.placeHolder = @"内容";
        if (cell.textView.text.length) {
            
            cell.showPlaceholder = NO;
        }
        
    }else
    {
        cell.showPlaceholder = NO;
    }
    
    [cell setCellChangeStyelBlock:^(TextChangeStyle textChangeStyle, UITextView *textView, NSDictionary *params) {
        
        if (textChangeStyle == Text_ShouldChangeTextInRange) {
            
            
            
        }else if (textChangeStyle == Text_DidChange){
            
            NSLog(@"Text_DidChange");
            
            toolsView.bottom = keyboard_y - 64;
            
            [weakSelf updateText:textView.text forIndexPath:indexPath];
            CGFloat aHeight = [params[CELL_NEW_HEIGHT]floatValue];
            [weakSelf updateHeight:aHeight forIndexPath:indexPath];
            
            weakCell.height = aHeight;
            
            NSLog(@"contentSize %f",weakCell.bottom);
            
            self.tableView.contentSize = CGSizeMake(self.tableView.width, weakCell.bottom);
            
        }else if (textChangeStyle == Text_ShouldEndEditing){
            
            NSLog(@"Text_ShouldEndEditing");
            
            
        }else if (textChangeStyle == Text_Delete){
            
            //移除上一个
            
            //如果是文字 整合上一个 第一响应,是图片的话只删除当前
            if (indexPath.row > 0) {
                
                
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
                UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndexPath];
                
                //如果是图片则删除图片(修改为是图片不动图片,删除空格的这行)
                if ([lastCell isKindOfClass:[LImageCell class]]) {
                    
//                    [content_arr removeObjectAtIndex:lastIndexPath.row];
                    
                    if (textView.text.length == 0) { //删除文字,本cell为空的话 移除此cell
                        //此时可以去掉当前cell
                        
                        [content_arr removeObjectAtIndex:indexPath.row];
                        
                    }
                    
                    [weakTable reloadData];
                    
                    
                }else //上一个是 文字
                {
                    if (textView.text.length == 0) {
                        //此时可以去掉当前cell
                        
                        NSLog(@"----");
                        
                    }else
                    {
                        //此时可以合并上一个cell 去掉当前
                        
                        NSString *lastText = [self getTextForIndexPath:lastIndexPath];
                        NSString *currentText = textView.text;
                        
                        lastText = [NSString stringWithFormat:@"%@%@",lastText,currentText];
                        
                        [self updateText:lastText forIndexPath:lastIndexPath];
                        
                        [self updateHeight:[self heightForText:lastText] forIndexPath:lastIndexPath];
                    }
                    
                    [content_arr removeObjectAtIndex:indexPath.row];
                    
                    [weakTable reloadData];
                }
                
            }
        }else if (textChangeStyle == Text_ShouldBeginEditing){
            
            
            firstResponder_dic = @{First_TextView:textView,First_IndexPath:indexPath};
            
            tap.enabled = YES;//开始编辑 手势启动
            
        }
        
    }];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

#pragma mark 键盘


- (void)keyboardWillShow:(NSNotification*)notification{
    
    NSLog(@"keyboardWillShow");
    
    //    __weak typeof(self)weakSelf = self;
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    keyboard_y = keyboardRect.origin.y;//记录键盘y
    
    toolsView.bottom = keyboardRect.origin.y - 64;
    
    
    //根据键盘调整 table 高度
    self.tableView.height = keyboardRect.origin.y - 64 - toolsView.height;
    self.height = self.tableView.height + toolsView.height;
    
    
    
    //滑动到最后
//    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:content_arr.count - 1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

- (void)keyboardWillHide:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    self.tableView.height = originalHeight;
    
    self.height = originalHeight;
    
    toolsView.bottom = DEVICE_HEIGHT;
    
    self.tableView.top = self.titleTextField.bottom;
    
}

#pragma mark 插入图片

- (void)clickToAddAlbum:(id)sender {
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //        picker.allowsEditing = YES;
        
    }else{
        NSLog(@"无法打开相册");
    }
    [rootViewController presentViewController:picker animated:YES completion:Nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    NSData *data;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        
        UIImage * scaleImage = [self scaleToSizeWithImage:originImage size:CGSizeMake(originImage.size.width>750?750:originImage.size.width,originImage.size.width>750?originImage.size.height*750/originImage.size.width:originImage.size.height)];
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil && scaleImage.size.width >= 750) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 0.5);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        if (image == nil) {
            
            [LTools showMBProgressWithText:@"图片无效" addToView:self];
            
            return;
        }

        
        if (isReplaceImage) {
            
            //显示图片修改
            
            replaceImageView.image = image;
            
            isReplaceImage = NO;
            
            NSInteger imageTag = replaceImageView.tag - 100;
            
            //数据源修改
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:imageTag inSection:0];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSNumber numberWithFloat:[self heightForImage:image]] forKey:CELL_NEW_HEIGHT];
            [dic setObject:[NSNumber numberWithFloat:_constImageWidth] forKey:CELL_NEW_WIDTH];
            [dic setObject:image forKey:CELL_CONTENT];
            
            [content_arr replaceObjectAtIndex:imageTag withObject:dic];
            
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else
        {
            [self insertImage:image];
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma - mark QBImagePicker 代理

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)aImagePickerController
{
    [aImagePickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark- 缩放图片

- (UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(10, 10, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


#pragma mark 图片上传

//上传
-(void)upLoadImage:(UIImage *)aImage{
    
    //上传的url
    NSString *uploadImageUrlStr = UPLOAD_IMAGE_URL;
    
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:uploadImageUrlStr
                                   parameters:@{
                                                @"action":@"topic_pic"
                                                }
                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                   {
                                       //开始拼接表单
                                       //获取图片的二进制形式
                                       NSData * data= UIImageJPEGRepresentation(aImage, 0.5);
                                       
                                       NSLog(@"---> 大小 %ld",(unsigned long)data.length);
                                       
                                       //将得到的二进制图片拼接到表单中
                                       /**
                                        *  data,指定上传的二进制流
                                        *  name,服务器端所需参数名
                                        *  fileName,指定文件名
                                        *  mimeType,指定文件格式
                                        */
                                       [formData appendPartWithFileData:data name:@"pic" fileName:@"icon.jpg" mimeType:@"image/jpg"];
                                       //多用途互联网邮件扩展（MIME，Multipurpose Internet Mail Extensions）
                                   }
                                   success:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                       
                                       NSLog(@"success %@",responseObject);
                                       
                                       NSError * myerr;
                                       
                                       NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:0 error:&myerr];
                                       
                                       
                                       NSLog(@"mydic == %@ err0 = %@",mydic,myerr);
                                       
                                       
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       
                                       
                                       NSLog(@"失败 : %@",error);
                                       
                                       
                                   }];
    
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
    
}

@end
