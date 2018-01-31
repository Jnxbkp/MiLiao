//
//  FUDemoBar.m
//
//  Created by ly on 2016/12/3.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import "FUDemoBar.h"
#import "FilterView.h"
#import "FUItemsView.h"
#import "BeautySlider.h"
#import "UIImage+demobar.h"

@interface mCollectionViewLayout : UICollectionViewFlowLayout

@end

@implementation mCollectionViewLayout

@end

@interface blurCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation blurCell

@end


@interface FUDemoBar()<FilterViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FUItemsViewDelegate>
{
    NSArray *typeArr;
    NSInteger currentType;
    
}
@property (weak, nonatomic) IBOutlet UIButton *redBtn;
@property (weak, nonatomic) IBOutlet UIButton *beautyBtn;
@property (weak, nonatomic) IBOutlet UIButton *itemsBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIButton *blurBtn;
@property (weak, nonatomic) IBOutlet UIButton *colorBtn;
@property (weak, nonatomic) IBOutlet UIView *sliderBg;
@property (weak, nonatomic) IBOutlet FUItemsView *itemsView;
@property (weak, nonatomic) IBOutlet FilterView *filterView;
@property (weak, nonatomic) IBOutlet BeautySlider *beautySlider;
@property (nonatomic, strong) UICollectionView *blurView;
@property (weak, nonatomic) IBOutlet UIView *beautyView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *nvshenBtn;
@property (weak, nonatomic) IBOutlet UIButton *wanghongBtn;
@property (weak, nonatomic) IBOutlet UIButton *ziranBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@property (weak, nonatomic) IBOutlet BeautySlider *gradeSlider;
@property (weak, nonatomic) IBOutlet BeautySlider *dayanSlider;
@property (weak, nonatomic) IBOutlet BeautySlider *shoulianSlider;

@end

@implementation FUDemoBar

//- (instancetype)init
//{
//    NSBundle *frameWorkBundle = [NSBundle bundleForClass:self.class];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FUDemoBar" bundle:frameWorkBundle];
//    FUDemoBar *bar = (FUDemoBar *)storyboard.instantiateInitialViewController.view;
//    
//    if (!bar) {
//        return nil;
//    }
//    
//    return bar;
//}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.filterView.mdelegate = self;
    self.itemsView.mdelegate = self;
    
    mCollectionViewLayout *layout = [[mCollectionViewLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(46, 46);
    layout.minimumLineSpacing = 5;
    
    _blurView = [[UICollectionView alloc] initWithFrame:_filterView.frame collectionViewLayout:layout];
    _blurView.delegate = self;
    _blurView.dataSource = self;
    _blurView.backgroundColor = [UIColor clearColor];
    _blurView.hidden = YES;
    [self addSubview:_blurView];
    
//    NSBundle *frameWorkBundle = [NSBundle bundleForClass:self.class];
    [_blurView registerNib:[UINib nibWithNibName:@"blurCell" bundle:nil] forCellWithReuseIdentifier:@"blurCell"];
    
    _defaultBtn.layer.cornerRadius = 15.0;
    _nvshenBtn.layer.cornerRadius = 15.0;
    _wanghongBtn.layer.cornerRadius  = 15.0;
    _ziranBtn.layer.cornerRadius = 15.0;
    
    [self bottomBtnClick:self.filterBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _blurView.frame = _filterView.frame;
    
    [_blurView reloadData];
}

- (void)setBeautyLevel:(double)beautyLevel
{
    _beautyLevel = beautyLevel;
    
    self.beautySlider.value = beautyLevel;

}

- (void)setThinningLevel:(double)thinningLevel
{
    _thinningLevel = thinningLevel;
    
    self.shoulianSlider.value = thinningLevel;
}

- (void)setFaceShapeLevel:(double)faceShapeLevel
{
    _faceShapeLevel = faceShapeLevel;
    
    self.gradeSlider.value = faceShapeLevel;
}

- (void)setEnlargingLevel:(double)enlargingLevel
{
    _enlargingLevel = enlargingLevel;
    self.dayanSlider.value = enlargingLevel;
}

- (void)setFaceShape:(NSInteger)faceShape
{
    _faceShape = faceShape;
    UIButton *button;
    if (faceShape == 0) {
        button = _nvshenBtn;
    }else if (faceShape == 1)
    {
        button  = _wanghongBtn;
    }else if (faceShape == 2)
    {
        button = _ziranBtn;
    }else
    {
        button = _defaultBtn;
    }
    
    [self beautyBtnClick:button];
}

- (void)setSelectedItem:(NSString *)selectedItem
{
    _selectedItem = selectedItem;
    
    self.itemsView.selectedItem = [self.itemsView.itemsDataSource indexOfObject:_selectedItem];
}

- (void)setItemsDataSource:(NSArray<NSString *> *)itemsDataSource
{
    _itemsDataSource = itemsDataSource;
    
    self.itemsView.itemsDataSource = itemsDataSource > 0 ? self.itemsDataSource:@[@"noitem"];
}

- (void)setSelectedFilter:(NSString *)selectedFilter
{
    _selectedFilter = selectedFilter;
    
    self.filterView.selectedFilter = [self.filterView.filtersDataSource indexOfObject:_selectedFilter];
}

-(void)setFiltersDataSource:(NSArray<NSString *> *)filtersDataSource
{
    _filtersDataSource = filtersDataSource;
    
    self.filterView.selectedFilter = [filtersDataSource indexOfObject:_selectedFilter];
    self.filterView.filtersDataSource = filtersDataSource.count > 0 ? self.filtersDataSource:@[@"nature", @"delta", @"electric", @"slowlived", @"tokyo", @"warm"];
}

-(void)makeTransformCompleted:(void(^)(void))completed
{
    if (self.hidden) {
        self.hidden = NO;
        self.alpha = 0;
        self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height * 0.3);
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
            self.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            completed();
        }];
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
            self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height * 0.3);
        } completion:^(BOOL finished) {
            self.hidden = YES;
            self.alpha = 1;
            self.transform = CGAffineTransformIdentity;
            completed();
        }];
    }
}

- (void)setSelectedBlur:(NSInteger)selectedBlur
{
    _selectedBlur = selectedBlur;
    
    [_blurView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(demoBarDidSelectedBlur:)]) {
        [self.delegate demoBarDidSelectedBlur:(double)selectedBlur * 4.0];
    }
    
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}

- (IBAction)beautyBtnClick:(UIButton *)sender {
    
    if (sender.selected) {
        return;
    }
    
    _defaultBtn.selected = sender == _defaultBtn;
    _defaultBtn.backgroundColor = _defaultBtn.selected ? [UIColor colorWithRed:255 / 255.0 green:190 / 255.0 blue:29 / 255.0 alpha:0.8] : [UIColor colorWithWhite:1 alpha:0.3];
    
    _nvshenBtn.selected = sender == _nvshenBtn;
    _nvshenBtn.backgroundColor = _nvshenBtn.selected ? [UIColor colorWithRed:255 / 255.0 green:190 / 255.0 blue:29 / 255.0 alpha:0.8] : [UIColor colorWithWhite:1 alpha:0.3];
    
    _wanghongBtn.selected = sender == _wanghongBtn;
    _wanghongBtn.backgroundColor = _wanghongBtn.selected ? [UIColor colorWithRed:255 / 255.0 green:190 / 255.0 blue:29 / 255.0 alpha:0.8] : [UIColor colorWithWhite:1 alpha:0.3];
    
    _ziranBtn.selected = sender == _ziranBtn;
    _ziranBtn.backgroundColor = _ziranBtn.selected ? [UIColor colorWithRed:255 / 255.0 green:190 / 255.0 blue:29 / 255.0 alpha:0.8] : [UIColor colorWithWhite:1 alpha:0.3];
    
    self.faceShape = sender.tag;
    
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}


- (IBAction)bottomBtnClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [self updateContentWithSelectedBtn:sender];
    
    [self switchSliderModelWithSender:sender];
}


- (IBAction)beautyLevelChanged:(UISlider *)sender {
    
    
    if (_colorBtn.selected) {
        _beautyLevel = sender.value;
        
    }else if (_redBtn.selected)
    {
        self.redLevel = sender.value;
    }
    
    if (sender == _gradeSlider) {
        self.faceShapeLevel = sender.value;
    }else if (sender == _dayanSlider)
    {
        self.enlargingLevel = sender.value;
    }else if (sender == _shoulianSlider)
    {
        self.thinningLevel = sender.value;
    }
    
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}

- (void)updateContentWithSelectedBtn:(UIButton *)btn
{
    _itemsBtn.selected = btn == _itemsBtn;
    _filterBtn.selected = btn == _filterBtn;
    _blurBtn.selected = btn == _blurBtn;
    _colorBtn.selected = btn == _colorBtn;
    _redBtn.selected = btn == _redBtn;
    _beautyBtn.selected = btn == _beautyBtn;
    
    self.itemsView.hidden = !self.itemsBtn.selected;
    self.filterView.hidden = !self.filterBtn.selected;
    self.blurView.hidden = !self.blurBtn.selected;
    self.sliderBg.hidden = !(self.colorBtn.selected || self.redBtn.selected);
    self.beautyView.hidden = !self.beautyBtn.selected;
    self.bgView.hidden = !self.beautyView.hidden;
    
    self.filterBtn.titleLabel.font = [UIFont systemFontOfSize:self.filterBtn.selected ? 18:17];
    self.blurBtn.titleLabel.font = [UIFont systemFontOfSize:self.blurBtn.selected ? 18:17];
    self.colorBtn.titleLabel.font = [UIFont systemFontOfSize:self.colorBtn.selected ? 18:17];
    self.itemsBtn.titleLabel.font = [UIFont systemFontOfSize:self.itemsBtn.selected ? 18:17];
    self.redBtn.titleLabel.font = [UIFont systemFontOfSize:self.redBtn.selected ? 18:17];
    self.beautyBtn.titleLabel.font = [UIFont systemFontOfSize:self.beautyBtn.selected ? 18:17];
    
    
    self.backgroundColor = !_beautyBtn.selected ? [UIColor clearColor] : [UIColor colorWithWhite:0 alpha:0.5];
}

- (void)switchSliderModelWithSender:(UIButton *)sender
{
    if (sender == _colorBtn) {
        _beautySlider.value = self.beautyLevel;
    }else if (sender == _redBtn)
    {
        _beautySlider.value = self.redLevel;
    }
}

- (void)selectNextFilter{
    [self.filterView selectNextFilter];
}

- (void)selectPreFilter{
    [self.filterView selectPreFilter];
}

- (void)didSelectedFilter:(NSString *)filter
{
    _selectedFilter = filter;
    if ([self.delegate respondsToSelector:@selector(demoBarDidSelectedFilter:)]) {
        [self.delegate demoBarDidSelectedFilter:filter];
    }
    
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}

- (void)didSelectedItem:(NSString *)item
{
    _selectedItem = item;
    if ([self.delegate respondsToSelector:@selector(demoBarDidSelectedItem:)]) {
        [self.delegate demoBarDidSelectedItem:item];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    blurCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"blurCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.imageView.hidden = NO;
        
        cell.imageView.image = [UIImage imageWithName:@"noblur"];
        cell.label.hidden = YES;
    }else
    {
        cell.label.hidden = NO;
        cell.label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        cell.imageView.hidden = YES;
    }
    
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    cell.layer.cornerRadius = 23;
    cell.layer.masksToBounds = YES;
    cell.label.font = [UIFont systemFontOfSize:24];
 
    if (_selectedBlur == indexPath.row) {
        cell.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:190 / 255.0 blue:29 / 255.0 alpha:0.8];
        cell.label.font = [UIFont systemFontOfSize:25];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedBlur == indexPath.row) {
        return;
    }
    
    _selectedBlur = indexPath.row;
    
    [collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(demoBarDidSelectedBlur:)]) {
        [self.delegate demoBarDidSelectedBlur:indexPath.row];
    }
    
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if ([collectionViewLayout isKindOfClass:[mCollectionViewLayout class]]) {
        mCollectionViewLayout *layout = (mCollectionViewLayout *)collectionViewLayout;
        
        NSInteger itemCount = [collectionView numberOfItemsInSection:section];
        CGFloat itemWidth = layout.itemSize.width;
        CGFloat minSpace = layout.minimumLineSpacing;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat sideSpace = (screenWidth - (itemCount - 1) * minSpace - itemCount * itemWidth) * 0.5;
        
        sideSpace = sideSpace < 10 ? 10:sideSpace;
        
        return UIEdgeInsetsMake((collectionView.frame.size.height - itemWidth) * 0.5, sideSpace, (collectionView.frame.size.height - itemWidth) * 0.5, sideSpace);
    }
    
    return UIEdgeInsetsMake(0, 30, 0, 30);
}

@end

