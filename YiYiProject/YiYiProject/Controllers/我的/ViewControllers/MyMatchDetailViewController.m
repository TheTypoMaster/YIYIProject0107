//
//  MyMatchDetailViewController.m
//  YiYiProject
//
//  Created by unisedu on 15/1/10.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "MyMatchDetailViewController.h"
#import "MyMatchDivisionDetailViewController.h"
#import "UIImageView+LBBlurredImage.h"
@interface MyMatchDetailViewController ()
{
    NSMutableArray * _dataSourceArray;
}
@end

@implementation MyMatchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTitle=@"我的搭配详情";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.view.backgroundColor = [UIColor whiteColor];
    waterFlow = [[LWaterflowView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - 44) waterDelegate:self waterDataSource:self];
    waterFlow.backgroundColor = RGBCOLOR(240, 230, 235);
    [self.view addSubview:waterFlow];
    [self getNetData];
}
- (void)getNetData
{
    NSString *api = [NSString stringWithFormat:GET_DIVISOINBYSTYLE_URL,[sourceDic objectForKey:@"style_id"],[GMAPI getAuthkey]];
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
    MyMatchDivisionDetailViewController *myMatchDetail = [[MyMatchDivisionDetailViewController alloc] init];
    myMatchDetail -> sourceDic = currentDic;
    [self.navigationController pushViewController:myMatchDetail animated:YES];
}

- (CGFloat)waterHeightForCellIndexPath:(NSIndexPath *)indexPath
{
    return (DEVICE_WIDTH-3*10)/2;
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
    TMQuiltViewCell *cell = (TMQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (DEVICE_WIDTH-3*10)/2, (DEVICE_WIDTH-3*10)/2)];
        imageView.tag = 1001;
        imageView.backgroundColor = RGBCOLOR(180, 180, 180);
        [cell addSubview:imageView];
        
        
        UIView *maskView = [[UIView alloc] initWithFrame:imageView.bounds];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha  = 0.5;
        [imageView addSubview:maskView];
        
        UILabel *lable = [LTools createLabelFrame:CGRectMake(0, 0, imageView.width, imageView.height) title:@"共8件衣服" font:15 align:(NSTextAlignmentCenter) textColor:[UIColor whiteColor]];
        lable.tag = 1002;
        [imageView addSubview:lable];
        
    }
    cell.layer.cornerRadius = 3.f;
   __weak UIImageView *imageView = (UIImageView *)[cell viewWithTag:1001];
    imageView.hidden = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[[_dataSourceArray objectAtIndex:indexPath.row] objectForKey:@"first_photo"] ] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [imageView setImageToBlur:image blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:^{
            imageView.hidden = NO;
            NSLog(@"The blurred image has been set");
        }];
    }];
    
    UILabel *label =(UILabel *) [imageView viewWithTag:1002];
    NSString * str = [[_dataSourceArray objectAtIndex:indexPath.row] objectForKey:@"detail"];
    NSArray *array = [str componentsSeparatedByString:@","];
    label.text  = [NSString stringWithFormat:@"共%ld件衣服",array.count];
    
    NSLog(@".......%@",[[_dataSourceArray objectAtIndex:indexPath.row] objectForKey:@"first_photo"]);
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
