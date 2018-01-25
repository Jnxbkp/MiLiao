//
//  UZNavigationTitleLabel.m
//  fangchan
//
//  Created by cuibin on 16/3/28.
//  Copyright © 2016年 youzai. All rights reserved.
//

#import "YZNavigationTitleLabel.h"

@implementation YZNavigationTitleLabel
- (void)layoutSubviews{
    [super layoutSubviews];
}
+ (instancetype)titleLabelWithText:(NSString *)text{
    CGSize size = [text sizeWithFont:YZFont(18)];
    
    YZNavigationTitleLabel * label = [[YZNavigationTitleLabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 44)];
    label.font = YZFont(18);
    label.textColor = [UIColor blackColor];
    label.text = text;
    return label;
}
@end
