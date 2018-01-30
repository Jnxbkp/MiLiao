//
//  FilterView.m
//
//  Created by liuyang on 16/10/20.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import "FilterView.h"
#import "UIImage+demobar.h"

@interface filterCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation filterCell

@end

@implementation FilterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;
    
    [self registerNib:[UINib nibWithNibName:@"filterCell" bundle:nil] forCellWithReuseIdentifier:@"filterCell"];
}

- (void)setFiltersDataSource:(NSArray<NSString *> *)filtersDataSource
{
    _filtersDataSource = filtersDataSource;
    
    [self reloadData];
}

-(NSInteger)numberOfSections{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _filtersDataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    filterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filterCell" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageWithName:_filtersDataSource[indexPath.row]];
    cell.filterNameLabel.text = _filtersDataSource[indexPath.row];
    
    cell.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.imageView.layer.borderWidth = 0.0;
    
    if (_selectedFilter == indexPath.row) {
        cell.imageView.layer.borderColor = [UIColor colorWithRed:255 / 255.0 green:190 / 255.0 blue:29 / 255.0 alpha:1.0].CGColor;
        cell.imageView.layer.borderWidth = 1.8;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _selectedFilter) {
        return;
    }
    NSIndexPath *preIndex = [NSIndexPath indexPathForRow:_selectedFilter inSection:0];
    _selectedFilter = indexPath.row;
    [collectionView reloadItemsAtIndexPaths:@[indexPath,preIndex]];
    
    if ([self.mdelegate respondsToSelector:@selector(didSelectedFilter:)]) {
        [self.mdelegate didSelectedFilter:_filtersDataSource[indexPath.row]];
    }
}

- (void)selectNextFilter
{
    NSInteger item = _selectedFilter + 1;
    if (item >= _filtersDataSource.count) {
        item = _filtersDataSource.count - 1;
    }
    [self selectItemAtIndexPath:[NSIndexPath indexPathForRow:item inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
    [self collectionView:self didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:item inSection:0]];
}

- (void)selectPreFilter
{
    NSInteger item = _selectedFilter - 1;
    if (item < 0) {
        item = 0;
    }
    [self selectItemAtIndexPath:[NSIndexPath indexPathForRow:item inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
    [self collectionView:self didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:item inSection:0]];
}

@end
