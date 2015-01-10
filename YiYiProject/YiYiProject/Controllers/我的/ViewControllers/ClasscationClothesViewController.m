//
//  ClasscationClothesViewController.m
//  YiYiProject
//
//  Created by unisedu on 15/1/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ClasscationClothesViewController.h"

@interface ClasscationClothesViewController ()
{
    NSMutableArray *_dataSourceArray;
}
@end

@implementation ClasscationClothesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.myTitle=[sourceDic objectForKey:@"sort_name"];
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.view.backgroundColor = [UIColor whiteColor];
    
    waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - 44) waterDelegate:self waterDataSource:self];
    waterFlow.backgroundColor = RGBCOLOR(240, 230, 235);
    [self.view addSubview:waterFlow];
    [self getNetData];
    // Do any additional setup after loading the view.
}
-(void)getNetData
{
    NSString *api = [NSString stringWithFormat:GET_CLASSICATIONCLOTHES_URL,[sourceDic objectForKey:@"sort_id"],[GMAPI getAuthkey]];
    
    NSLog(@"api===%@",api);
    GmPrepareNetData *gg = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [gg requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        if(result && [[result objectForKey:@"errorcode"] integerValue] == 0)
        {
            _dataSourceArray = [result objectForKey:@"list"];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addImag" object:currentDic];
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    CGFloat aHeight = 0.f;
    NSDictionary *aMode = waterFlow.dataArray[indexPath.row];
    aHeight = [[aMode objectForKey:@"image_height"] floatValue];
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

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath
{
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        imageView.tag = 1001;
//        imageView.backgroundColor = RGBCOLOR(180, 180, 180);
//        [cell addSubview:imageView];
        //cell.backgroundColor = [UIColor redColor];
        
    }
//    NSLog(@"cell = %@",[NSValue valueWithCGRect:cell.bounds]);
//    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1001];
    [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[[_dataSourceArray objectAtIndex:indexPath.row] objectForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"dapei_jiantou"]];
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
