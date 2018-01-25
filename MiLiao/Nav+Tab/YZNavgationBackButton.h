//
//  UZNavgationBackButton.h
//  fangchan
//
//  Created by cuibin on 16/3/28.
//  Copyright © 2016年 youzai. All rights reserved.
// 自定义返回按钮

#import <UIKit/UIKit.h>

@interface YZNavgationBackButton : UIButton
/**
 *返回按钮(实现了返回方法)
 */
+ (instancetype)backBtnWithViewController:(UIViewController *)viewController;
/**
 *  返回按钮 (单纯的按钮)
 */
+ (instancetype)backBtn;
@end
