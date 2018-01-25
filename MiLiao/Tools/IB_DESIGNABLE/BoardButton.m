//
//  BoardButton.m
//  RYMart
//
//  Created by iMac on 2017/10/24.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "BoardButton.h"

@implementation BoardButton
- (void)setupBackgroundImageWithColor:(UIColor *)color controlState:(UIControlState)state {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:state];
}

#pragma mark - 设置边框宽度
- (void)setBorderWidth:(CGFloat)borderWidth {
    
    if (borderWidth < 0) return;
    
    self.layer.borderWidth = borderWidth;
}

#pragma mark - 设置边框颜色
- (void)setBorderColor:(UIColor *)borderColor {
    
    self.layer.borderColor = borderColor.CGColor;
}

#pragma mark - 设置圆角
- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

@end
