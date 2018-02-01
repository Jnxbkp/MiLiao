//
//  EnoughCallTool.h
//  MiLiao
//
//  Created by King on 2018/1/31.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnoughCallTool : NSObject

///弹出是否充值的alert
+ (void)viewController:(UIViewController *)viewControlelr showPayAlertController:(void(^)(void))pay continueCall:(void(^)(void))continueCall;

///去充值
+ (void)viewController:(UIViewController *)viewController showPayAlertController:(void(^)(void))pay;

@end
