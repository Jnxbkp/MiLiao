//
//  PriceView.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/1.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSStringSize.h"

@interface PriceView : UIView

@property (nonatomic ,strong)UIImageView         *iconImageView;
@property (nonatomic ,strong)UILabel             *priceLabel;
@property (nonatomic ,strong)NSString            *price;

- (instancetype)initWithFrame:(CGRect)frame withPrice:(NSString *)price kind:(NSString *)kind;

- (void)setPrice:(NSString *)price;
@end
