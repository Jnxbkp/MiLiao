//
//  FUAPIDemoBar.m
//  FUAPIDemoBar
//
//  Created by 刘洋 on 2017/1/10.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "FUAPIDemoBar.h"
#import "FUDemoBar.h"

@interface FUAPIDemoBar ()<FUDemoBarDelegate>
{
    FUDemoBar *bar;
}

@end

@implementation FUAPIDemoBar
@synthesize itemsDataSource = _itemsDataSource;
@synthesize filtersDataSource = _filtersDataSource;
@synthesize selectedItem = _selectedItem;
@synthesize selectedFilter = _selectedFilter;
@synthesize selectedBlur = _selectedBlur;
@synthesize beautyLevel = _beautyLevel;
@synthesize thinningLevel = _thinningLevel;
@synthesize enlargingLevel = _enlargingLevel;
@synthesize faceShape = _faceShape;
@synthesize redLevel = _redLevel;
@synthesize faceShapeLevel = _faceShapeLevel;
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
//    NSBundle *frameWorkBundle = [NSBundle bundleForClass:FUDemoBar.class];
    bar = (FUDemoBar *)[[NSBundle mainBundle] loadNibNamed:@"FUDemoBar" owner:self options:nil].firstObject;
    bar.frame = self.bounds;
    bar.delegate = self;
    bar.itemsDataSource = _itemsDataSource;
    bar.filtersDataSource = _filtersDataSource;
    bar.selectedItem = _selectedItem;
    bar.selectedFilter = _selectedFilter;
    bar.selectedBlur = _selectedBlur;
    bar.beautyLevel = _beautyLevel;
    bar.thinningLevel = _thinningLevel;
    bar.enlargingLevel = _enlargingLevel;
    bar.redLevel = _redLevel;
    bar.faceShapeLevel = _faceShapeLevel;
    bar.faceShape = _faceShape;
    [self addSubview:bar];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        NSBundle *frameWorkBundle = [NSBundle bundleForClass:FUDemoBar.class];
        bar = (FUDemoBar *)[frameWorkBundle loadNibNamed:@"FUDemoBar" owner:self options:NULL].firstObject;
        bar.frame = self.bounds;
        bar.delegate = self;
        bar.itemsDataSource = _itemsDataSource;
        bar.filtersDataSource = _filtersDataSource;
        bar.selectedItem = _selectedItem;
        bar.selectedFilter = _selectedFilter;
        bar.selectedBlur = _selectedBlur;
        bar.beautyLevel = _beautyLevel;
        bar.thinningLevel = _thinningLevel;
        bar.enlargingLevel = _enlargingLevel;
        bar.redLevel = _redLevel;
        bar.faceShapeLevel = _faceShapeLevel;
        bar.faceShape = _faceShape;
        [self addSubview:bar];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    bar.frame = self.bounds;
}

- (double)beautyLevel
{
    return bar.beautyLevel;
}

- (void)setBeautyLevel:(double)beautyLevel
{
    _beautyLevel = beautyLevel;
    bar.beautyLevel = beautyLevel;
}

- (NSInteger)selectedBlur
{
    return bar.selectedBlur;
}

- (void)setSelectedBlur:(NSInteger)selectedBlur
{
    _selectedBlur = selectedBlur;
    bar.selectedBlur = selectedBlur;
}

- (NSString *)selectedItem
{
    if (!bar.selectedItem) {
        return _selectedItem;
    }
    return bar.selectedItem;
}

- (void)setSelectedItem:(NSString *)selectedItem
{
    _selectedItem = selectedItem;
    bar.selectedItem = selectedItem;
}

- (NSString *)selectedFilter
{
    if (!bar.selectedFilter) {
        return _selectedFilter;
    }
    return bar.selectedFilter;
}

- (void)setSelectedFilter:(NSString *)selectedFilter
{
    _selectedFilter = selectedFilter;
    bar.selectedFilter = selectedFilter;
}

- (double)enlargingLevel
{
    return bar.enlargingLevel;
}

- (void)setEnlargingLevel:(double)enlargingLevel
{
    _enlargingLevel = enlargingLevel;
    bar.enlargingLevel = enlargingLevel;
}

- (NSInteger)faceShape
{
    return bar.faceShape;
}

- (void)setFaceShape:(NSInteger)faceShape
{
    _faceShape = faceShape;
    bar.faceShape = faceShape;
}

- (double)redLevel
{
    return bar.redLevel;
}

- (void)setRedLevel:(double)redLevel
{
    _redLevel = redLevel;
    bar.redLevel = redLevel;
}

- (double)faceShapeLevel
{
    return bar.faceShapeLevel;
}

- (void)setFaceShapeLevel:(double)faceShapeLevel
{
    _faceShapeLevel = faceShapeLevel;
    bar.faceShapeLevel = faceShapeLevel;
}

- (double)thinningLevel
{
    return bar.thinningLevel;
}

- (void)setThinningLevel:(double)thinningLevel
{
    _thinningLevel = thinningLevel;
    bar.thinningLevel = thinningLevel;
}

- (NSArray<NSString *> *)itemsDataSource
{
    if (!bar.itemsDataSource) {
        return _itemsDataSource;
    }
    return bar.itemsDataSource;
}

- (void)setItemsDataSource:(NSArray<NSString *> *)itemsDataSource
{
    _itemsDataSource = itemsDataSource;
    bar.itemsDataSource = itemsDataSource;
}

- (NSArray<NSString *> *)filtersDataSource
{
    if (!bar.filtersDataSource) {
        return _filtersDataSource;
    }
    
    return bar.filtersDataSource;
}

- (void)setFiltersDataSource:(NSArray<NSString *> *)filtersDataSource
{
    _filtersDataSource = filtersDataSource;
    bar.filtersDataSource = filtersDataSource;
}

#pragma -FUDemoBarDelegate

- (void)demoBarDidSelectedItem:(NSString *)item
{
    if ([self.delegate respondsToSelector:@selector(demoBarDidSelectedItem:)]) {
        [self.delegate demoBarDidSelectedItem:item];
    }
}

- (void)demoBarDidSelectedFilter:(NSString *)filter
{
    if ([self.delegate respondsToSelector:@selector(demoBarDidSelectedFilter:)]) {
        [self.delegate demoBarDidSelectedFilter:filter];
    }
}


- (void)demoBarBeautyParamChanged
{
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}
//- (void)demoBarDidSelectedBlur:(NSInteger)blur
//{
//    if ([self.delegate respondsToSelector:@selector(demoBarDidSelectedBlur:)]) {
//        [self.delegate demoBarDidSelectedBlur:blur];
//    }
//}
//
//- (void)demoBarLevelDidChanged:(double)level
//{
//    if ([self.delegate respondsToSelector:@selector(demoBarLevelDidChanged:)]) {
//        [self.delegate demoBarLevelDidChanged:level];
//    }
//}


@end
