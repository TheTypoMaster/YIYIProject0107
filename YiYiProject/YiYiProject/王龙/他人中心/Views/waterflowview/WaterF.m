//
//  WaterF.m
//  CollectionView
//
//  Created by d2space on 14-2-21.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import "WaterF.h"
#import "WaterFCell.h"
#import "WaterFallHeader.h"
#import "WaterFallFooter.h"
#import "UIImageView+WebCache.h"
@interface WaterF ()

@property (nonatomic, strong) WaterFCell* cell;
@end

@implementation WaterF

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        [self.collectionView registerClass:[WaterFCell class] forCellWithReuseIdentifier:@"cell"];

        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect collRec = self.collectionView.frame;
    
    collRec.origin.y = 0;
    
    self.collectionView.frame = collRec;
}

#pragma mark UICollectionViewDataSource
//required
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/* For now, we won't return any sections */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArr.count;
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    
    WaterFCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 3.f;
    
    TPlatModel *aMode = self.imagesArr[indexPath.row];
    [cell setCellWithModel:aMode];

    return cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (_delegate!=nil && [_delegate respondsToSelector:@selector(itemCick:andCount:)]){
        
        TPlatModel *flow = [self.imagesArr objectAtIndex:indexPath.row];
        
        
        [_delegate itemCick:flow andCount:(int)indexPath.row];
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TPlatModel *aMode = self.imagesArr[indexPath.row];
    
    float image_width = [aMode.image[@"width"]floatValue];
    float image_height = [aMode.image[@"height"]floatValue];
    
   
    if (image_width == 0.0) {
        image_width = image_height;
    }
    float rate = image_height/image_width;
    
    return  CGSizeMake((DEVICE_WIDTH-30)/2.0, (DEVICE_WIDTH-30)/2.0*rate+33);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headerView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(waterScrollViewDidScroll:)]){
        
        [_delegate waterScrollViewDidScroll:scrollView];
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(waterScrollViewDidEndDragging:)]){
        
        [_delegate waterScrollViewDidEndDragging:scrollView];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
