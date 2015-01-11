//
//  EditMyInfoViewController.h
//  YiYiProject
//
//  Created by 王龙 on 15/1/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyViewController.h"
#import "EditInfoView.h"
@interface EditMyInfoViewController : MyViewController <UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    UIScrollView *infoScrollView;
    EditInfoView *infoView;
    UIDatePicker *datePicker;
    //日期数据源
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    
    UIView *dateView;
}


@end
