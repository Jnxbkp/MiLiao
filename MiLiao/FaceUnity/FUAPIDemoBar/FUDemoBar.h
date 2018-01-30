//
//  FUDemoBar.h
//  FUDemoBar
//
//  Created by 刘洋 on 2017/1/7.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FUDemoBarDelegate <NSObject>

@optional
- (void)demoBarDidSelectedItem:(NSString *)item;

- (void)demoBarDidSelectedFilter:(NSString *)filter;

- (void)demoBarLevelDidChanged:(double)level;

- (void)demoBarDidSelectedBlur:(NSInteger)blur;

- (void)demoBarBeautyParamChanged;
@end

@interface FUDemoBar : UIView

@property (nonatomic, assign) id<FUDemoBarDelegate> delegate;

@property (nonatomic, assign) NSInteger selectedBlur;

@property (nonatomic, assign) double beautyLevel;

@property (nonatomic, assign) double thinningLevel;

@property (nonatomic, assign) double redLevel;

@property (nonatomic, assign) double faceShapeLevel;

@property (nonatomic, assign) NSInteger faceShape;

@property (nonatomic, assign) double enlargingLevel;

@property (nonatomic, strong) NSString *selectedItem;

@property (nonatomic, strong) NSString *selectedFilter;

@property (nonatomic, strong) NSArray<NSString *> *itemsDataSource;

@property (nonatomic, strong) NSArray<NSString *> *filtersDataSource;

@end
