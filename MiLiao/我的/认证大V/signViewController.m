//
//  signViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/8.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "signViewController.h"

@interface signViewController ()

@end

@implementation signViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"填写个性签名"];
}
- (IBAction)sure:(id)sender {
    if (self.backBlock) {
//        self.backBlock(self.textField.text);
        self.backBlock(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
