//
//  PriceView.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/1.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "PriceView.h"

@implementation PriceView

- (instancetype)initWithFrame:(CGRect)frame withPrice:(NSString *)price kind:(NSString *)kind{
    self = [super initWithFrame:frame];
    if (self) {
        self.price = price;
        NSString *str = [NSString stringWithFormat:@"%@ 撩币/分钟",price];
        CGSize labelSize = [NSStringSize getNSStringHeight:str Font:14.0];
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-labelSize.width, 0, labelSize.width, 15)];
        _priceLabel.text = str;
        
        _priceLabel.font = [UIFont systemFontOfSize:14.0];
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_priceLabel.frame.origin.x-25, 1, 18, 12)];
        
        
        if ([kind isEqualToString:@"main"]) {
            _priceLabel.textColor = Color255;
            _iconImageView.image = [UIImage imageNamed:@"icon_shipin"];
        } else {
            _priceLabel.textColor = NavColor;
            _iconImageView.image = [UIImage imageNamed:@"shipin_fen"];
        }
        [self addSubview:_priceLabel];
        [self addSubview:_iconImageView];
    }
    return self;
}
- (void)setPrice:(NSString *)price {
    NSString *str = [NSString stringWithFormat:@"%@ 撩币/分钟",price];
    CGSize labelSize = [NSStringSize getNSStringHeight:str Font:14.0];
    _priceLabel.frame = CGRectMake(self.frame.size.width-labelSize.width, 0, labelSize.width, 15);
    _priceLabel.text = str;
    _iconImageView.frame = CGRectMake(_priceLabel.frame.origin.x-25, 1, 18, 12);

}
@end
