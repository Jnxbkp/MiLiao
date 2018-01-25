//
//  NickNameViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/6.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "NickNameViewController.h"

@interface NickNameViewController ()
{
    BOOL _canedit;
}
@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"设置昵称"];
    
}
- (IBAction)sure:(id)sender {
    if (self.backBlock) {
        self.backBlock(self.textFiled.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (toBeString.length<=7) {
        _canedit =YES;
    }
    if (_canedit==NO) {
        //        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已超过字数限制" preferredStyle:UIAlertControllerStyleAlert];
        //        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        //        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textFiled becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.textFiled resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
