//
//  UIView+IBBorder.h
//  CarGodNet
//
//  Created by King_zh on 16/8/19.
//  Copyright © 2016年 YZNHD. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE

@interface UIView (IBBorder)
/// 边线颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

/// 边线宽度
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/// 圆角半径
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end
