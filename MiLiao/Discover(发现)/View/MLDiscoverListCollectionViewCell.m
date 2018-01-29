//
//  MLDiscoverListCollectionViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//
#define itemWidth                 (WIDTH-32)/2
#define itemHeight                 itemWidth*16/9

#import "MLDiscoverListCollectionViewCell.h"

@implementation MLDiscoverListCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creat];
    }
    return self;
}

- (void)creat {
    self.backgroundColor = [UIColor redColor];
    _mainImgageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
    [_mainImgageView setContentMode:UIViewContentModeScaleAspectFill];
    _mainImgageView.clipsToBounds = YES;
    
    _belowView = [[UIView alloc]initWithFrame:CGRectMake(0, itemHeight-56, itemWidth, 56)];
    _belowView.backgroundColor = ML_Color(0, 0, 0, 0.1);
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, _belowView.frame.origin.y+12, itemWidth-24, 12)];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.font = [UIFont systemFontOfSize:12.0];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, _messageLabel.frame.origin.y+24, (itemWidth-24)/2, 12.5)];
    _timeLabel.textColor = ML_Color(204, 204, 204, 1);
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    
    _likeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake((itemWidth-24)/2, _timeLabel.frame.origin.y, 30, 12)];
    _likeNumLabel.font = [UIFont systemFontOfSize:12.0];
    _likeNumLabel.textColor = ML_Color(228, 228, 228, 1);
    
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_likeNumLabel.frame.origin.x-18, _timeLabel.frame.origin.y+1.5, 10, 9)];
    _iconImageView.image = [UIImage imageNamed:@"xiaoxin"];
    
    [self.contentView addSubview:_mainImgageView];
    [self.contentView addSubview:_belowView];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_messageLabel];
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_likeNumLabel];
}
@end
