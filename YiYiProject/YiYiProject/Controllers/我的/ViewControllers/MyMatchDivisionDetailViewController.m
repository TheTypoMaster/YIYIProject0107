//
//  MyMatchDivisionDetailViewController.m
//  YiYiProject
//
//  Created by unisedu on 15/1/10.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyMatchDivisionDetailViewController.h"
#import "TMPhotoViewQuiltViewCell.h"
@interface MyMatchDivisionDetailViewController ()
{
    NSMutableArray * _dataSourceArray;
}
@end

@implementation MyMatchDivisionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTitle=@"三级列表";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.view.backgroundColor = [UIColor whiteColor];
    waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - 44) waterDelegate:self waterDataSource:self noloadView:YES];
    waterFlow.backgroundColor = RGBCOLOR(235, 235, 235);
    [self.view addSubview:waterFlow];
    [self getNetData];
}
- (void)getNetData
{
    NSString *api = [NSString stringWithFormat:GET_DIVISION_INFO,[sourceDic objectForKey:@"division_id"],[GMAPI getAuthkey]];
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
        {
            _dataSourceArray = [result objectForKey:@"detail"];
            
        }
        [waterFlow reloadData:_dataSourceArray total:100];
        NSLog(@"%@",result);
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"%@",failDic);
        
    }];
}

#pragma mark - WaterFlowDelegate

- (void)waterLoadNewData
{
    
}
- (void)waterLoadMoreData
{
    
}

- (void)waterDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *currentDic = waterFlow.dataArray[indexPath.row];
    
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat realWidth = (DEVICE_WIDTH - 30)/2.f;
    CGFloat aHeight = 0.f;
    NSDictionary *aMode = _dataSourceArray[indexPath.row];
    aHeight = [[aMode objectForKey:@"pic_height"] floatValue];
    CGFloat aWindth = [[aMode objectForKey:@"pic_width"] floatValue];
    float rate = aHeight/aWindth;
    return  realWidth * rate;
}
- (CGFloat)waterViewNumberOfColumns
{
    return 2;
}

#pragma mark - TMQuiltViewDataSource

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    
    return [waterFlow.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath
{
    TMPhotoViewQuiltViewCell *cell = (TMPhotoViewQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoViewQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[[_dataSourceArray objectAtIndex:indexPath.row] objectForKey:@"pic_url"]] placeholderImage:nil];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
