//
//  MyQianBaoTableViewCell.m
//  CarGodNet
//
//  Created by apple on 2017/5/19.
//  Copyright © 2017年 YZNHD. All rights reserved.
//

#import "MyQianBaoTableViewCell.h"
static NSString *const reuseIdentifier = @"Cell";

@implementation MyQianBaoTableViewCell
{
    NSMutableArray *selectedArray;
    NSArray *MAry;
    NSArray *moneyAry;


}
- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray * array = @[@"1",@"",@"",@"",@"",@"",@"",@"",@""];
    selectedArray = [[NSMutableArray alloc] initWithArray:array];
    MAry = [[NSArray alloc]init];
    moneyAry = [[NSArray alloc]init];
    MAry = @[@"10撩币",@"50撩币",@"100撩币",@"200撩币",@"500撩币",@"1000撩币",@"2000撩币",@"5000撩币",@"10000撩币"];
    moneyAry = @[@"￥20",@"￥100",@"￥200",@"￥400",@"￥1000",@"￥2000",@"￥4000",@"￥10000",@"￥20000"];
    [self loadData];

   
}
- (void)loadData
{
   
            UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
            flowLayout.minimumInteritemSpacing =0;
            flowLayout.minimumLineSpacing = 10;
            flowLayout.itemSize = CGSizeMake((WIDTH - 40.0)/3, 76.0);
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            self.mainCollectionView.collectionViewLayout = flowLayout;
            self.mainCollectionView.scrollEnabled = NO;
            self.mainCollectionView.delegate = self;
            self.mainCollectionView.dataSource = self;
            self.mainCollectionView.backgroundColor = ML_Color(248, 248, 248, 1);
            UINib *nib = [UINib nibWithNibName:@"CardCollectionViewCell"
                                        bundle: [NSBundle mainBundle]];
            [self.mainCollectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
   
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return dicAry.count;
    return 9;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dict = dicAry[indexPath.row];
//    NSLog(@"%@",dict);
    CardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.zhekou.text = MAry[indexPath.row];//上面的
    cell.time.text = moneyAry[indexPath.row];//下面的
    NSString * status = selectedArray[indexPath.row];
    //waixing
    if ([status isEqualToString:@"1"]) {
        cell.imageView.image  = [UIImage imageNamed:@"yanse"];
        cell.zhekou.textColor = [UIColor whiteColor];
        cell.time.textColor   = [UIColor whiteColor];
    }else{
        cell.zhekou.textColor = ML_Color(250, 114, 152, 1);
        cell.time.textColor   = ML_Color(250, 114, 152, 1);
        cell.imageView.image  = [UIImage imageNamed:@"waixing"];
        
    }

    return cell;
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * status = selectedArray[indexPath.row];
    if ([status isEqualToString:@"1"]) {
        
    }else{
        [selectedArray removeAllObjects];
        for (int i = 0; i < 10; i++) {
            if (i == indexPath.row)
            {
                [selectedArray addObject:@"1"];
            }
            else{
                [selectedArray addObject:@""];
            }
        }
        [self.mainCollectionView reloadData];
    }

    if (self.selectedBlock) {
        self.selectedBlock(indexPath.row);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
