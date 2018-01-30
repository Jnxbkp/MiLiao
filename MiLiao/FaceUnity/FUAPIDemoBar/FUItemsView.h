//
//  ItemsView.h
//
//  Created by 刘洋 on 2017/1/6.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FUItemsViewDelegate <NSObject>

- (void)didSelectedItem:(NSString *)item;

@end

@interface FUItemsView : UICollectionView

@property (nonatomic, weak) id<FUItemsViewDelegate>mdelegate;

@property (nonatomic, strong) NSArray<NSString *> *itemsDataSource;

@property (nonatomic, assign) NSInteger       selectedItem;

@end
