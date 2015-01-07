//
//  UploadPicViewController.h
//  YiYiProject
//
//  Created by unisedu on 15/1/4.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyViewController.h"
#import "ZYQAssetPickerController.h"
@interface UploadPicViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>
{   @public
    NSMutableArray * imageArray;
}

@end
