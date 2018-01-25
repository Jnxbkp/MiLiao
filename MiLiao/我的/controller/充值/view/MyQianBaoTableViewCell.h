//
//  MyQianBaoTableViewCell.h
//  CarGodNet
//
//  Created by apple on 2017/5/19.
//  Copyright © 2017年 YZNHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardCollectionViewCell.h"
@interface MyQianBaoTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (nonatomic, copy) void (^selectedBlock)(NSInteger index);
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *extra_desc;

@end
