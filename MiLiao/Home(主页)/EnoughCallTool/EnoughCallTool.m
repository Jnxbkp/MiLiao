//
//  EnoughCallTool.m
//  MiLiao
//
//  Created by King on 2018/1/31.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "EnoughCallTool.h"

@implementation EnoughCallTool
///弹出是否充值的alert
+ (void)viewController:(UIViewController *)viewControlelr showPayAlertController:(void(^)(void))pay continueCall:(void(^)(void))continueCall {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的M不足不够与大V通话5分钟" message:@"是否去充值" preferredStyle:UIAlertControllerStyleAlert];
    //继续通话
    UIAlertAction *continueCallAction = [UIAlertAction actionWithTitle:@"继续通话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !continueCall?:continueCall();
    }];
    
    //充值
    UIAlertAction *payAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !pay?:pay();
    }];
    [payAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
    
    [alertController addAction:continueCallAction];
    [alertController addAction:payAction];
    [viewControlelr presentViewController:alertController animated:YES completion:nil];
}

///去充值
+ (void)viewController:(UIViewController *)viewController showPayAlertController:(void(^)(void))pay {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的M不足" message:@"是否立即充值" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *payAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !pay?:pay();
    }];
    [payAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
    [alertController addAction:cancleAction];
    [alertController addAction:payAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
