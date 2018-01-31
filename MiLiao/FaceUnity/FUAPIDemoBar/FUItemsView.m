//
//  ItemsView.m
//
//  Created by 刘洋 on 2017/1/6.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import "FUItemsView.h"
#import "UIImage+demobar.h"

@interface FUItemCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation FUItemCell

@end


@interface FUItemsView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation FUItemsView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.delegate = self;
    
    self.dataSource = self;
    
    [self registerNib:[UINib nibWithNibName:@"FUItemCell" bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:@"itemCell"];
}

- (void)setItemsDataSource:(NSArray<NSString *> *)itemsDataSource
{
    _itemsDataSource = itemsDataSource;
    
    [self reloadData];
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemsDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FUItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageWithName:_itemsDataSource[indexPath.row]];
    
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];

    cell.layer.cornerRadius = cell.frame.size.width * 0.5;
    
    cell.layer.masksToBounds = YES;
    
    cell.layer.borderWidth = 0.0;
    
    cell.layer.borderColor = [UIColor colorWithRed:255 / 255.0 green:190 / 255.0 blue:29 / 255.0 alpha:1.0].CGColor;
    
    if (indexPath.row == _selectedItem)
    {
        cell.layer.borderWidth = 1.0;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (_selectedItem != indexPath.row) {
        _selectedItem = indexPath.row;
        [collectionView reloadData];
        
        if ([self.mdelegate respondsToSelector:@selector(didSelectedItem:)]) {
            [self.mdelegate didSelectedItem:self.itemsDataSource[indexPath.row]];
        }
    }
}

@end

