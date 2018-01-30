//
//  FilterView.h
//
//  Created by liuyang on 16/10/20.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewDelegate <NSObject>

- (void)didSelectedFilter:(NSString *)filter;

@end

@interface FilterView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<NSString *> *filtersDataSource;

@property (nonatomic, assign) id<FilterViewDelegate> mdelegate;

@property (nonatomic, assign) NSInteger       selectedFilter;

- (void)selectNextFilter;
- (void)selectPreFilter;
@end
