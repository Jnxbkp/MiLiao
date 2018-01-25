//
//  MLDiscoverListCollectionViewCell.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLDiscoverListCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong)UIImageView      *mainImgageView;
@property (nonatomic ,strong)UIView           *belowView;
@property (nonatomic ,strong)UILabel          *timeLabel;
@property (nonatomic ,strong)UILabel          *messageLabel;
@property (nonatomic ,strong)UIImageView      *iconImageView;
@property (nonatomic ,strong)UILabel          *likeNumLabel;

@end
