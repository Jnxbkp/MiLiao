//
//  introduceViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/8.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "introduceViewController.h"

@interface introduceViewController ()

@end

@implementation introduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"填写个人介绍"];
}




- (IBAction)sure:(id)sender {
    if (self.backBlock) {
        self.backBlock(self.introduceField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}


@end
