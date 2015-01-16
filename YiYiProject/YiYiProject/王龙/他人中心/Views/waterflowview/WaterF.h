//
//  WaterF.h
//  CollectionView
//
//  Created by d2space on 14-2-21.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFLayout.h"
#import "ParallaxHeaderView.h"
#import "TPlatModel.h"
@protocol CollectionClickDelegate <NSObject>

-(void)itemCick:(NSString *)good_id andCount:(NSString *)mcount;

@end

@interface WaterF : UICollectionViewController 

@property (nonatomic,strong) NSArray* imagesArr;
@property (nonatomic,strong) NSArray* textsArr;
@property (nonatomic,assign) NSInteger sectionNum;
@property (nonatomic) NSInteger imagewidth;
@property (nonatomic) CGFloat textViewHeight;
@property (nonatomic,strong) NSMutableArray* buttons;
@property (nonatomic,strong) NSMutableArray* buttonStates;

@property (nonatomic,assign) id <CollectionClickDelegate> delegate;
@property (nonatomic,strong) ParallaxHeaderView *headerView;
@end
