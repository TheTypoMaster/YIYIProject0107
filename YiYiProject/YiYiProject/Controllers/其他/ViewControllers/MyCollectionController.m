//
//  MyCollectionController.m
//  YiYiProject
//
//  Created by lichaowei on 15/1/2.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyCollectionController.h"

#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"

#import "LWaterflowView.h"

#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "ProductModel.h"

#import "ProductDetailController.h"


@interface MyCollectionController ()<TMQuiltViewDataSource,WaterFlowDelegate>
{
    LWaterflowView *waterFlow;
    
    SORT_SEX_TYPE sex_type;
    SORT_Discount_TYPE discount_type;
    //    NSArray *dataArray;
}

@end

@implementation MyCollectionController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    self.navigationController.navigationBarHidden = YES;
//}

-(void)leftButtonTap:(UIButton *)sender
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBCOLOR(200, 200, 200);
    
    self.myTitleLabel.text = @"我的收藏";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - 44) waterDelegate:self waterDataSource:self];
    waterFlow.backgroundColor = RGBCOLOR(240, 230, 235);
    [self.view addSubview:waterFlow];
    
    [waterFlow showRefreshHeader:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 事件处理


/**
 *  我的收藏
 */
- (void)getMyCollection
{
    NSString *longtitud = @"116.42111721";
    NSString *latitude = @"39.90304099";
    
    NSString *url = [NSString stringWithFormat:GET_MY_CILLECTION,longtitud,latitude,waterFlow.pageNum,L_PAGE_SIZE,[GMAPI getAuthkey]];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSMutableArray *arr;
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *list = result[@"list"];
            arr = [NSMutableArray arrayWithCapacity:list.count];
            if ([list isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *aDic in list) {
                    
                    ProductModel *aModel = [[ProductModel alloc]initWithDictionary:aDic];
                    
                    [arr addObject:aModel];
                }
                
            }
            
        }
        
        [waterFlow reloadData:arr total:100];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failBlock == %@",failDic[RESULT_INFO]);
        [waterFlow loadFail];
        
    }];
}


#pragma mark - WaterFlowDelegate

- (void)waterLoadNewData
{
    [self getMyCollection];
}
- (void)waterLoadMoreData
{
    [self getMyCollection];
}

- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    
    //    [LTools alertText:aMode.product_name];
    
    ProductDetailController *detail = [[ProductDetailController alloc]init];
    detail.product_id = aMode.product_id;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    CGFloat aHeight = 0.f;
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    if (aMode.imagelist.count >= 1) {
        
        NSDictionary *imageDic = aMode.imagelist[0];
        NSDictionary *middleImage = imageDic[@"540Middle"];
        //        CGFloat aWidth = [middleImage[@"width"]floatValue];
        aHeight = [middleImage[@"height"]floatValue];
    }
    
    return aHeight / 2.f + 33;
}
- (CGFloat)waterViewNumberOfColumns
{
    
    return 2;
}

#pragma mark - TMQuiltViewDataSource

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [waterFlow.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    
    cell.layer.cornerRadius = 3.f;
    
    ProductModel *aMode = waterFlow.dataArray[indexPath.row];
    [cell setCellWithModel:aMode];
    
    
    return cell;
}

@end
