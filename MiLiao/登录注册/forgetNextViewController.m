//
//  forgetNextViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/4.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "forgetNextViewController.h"

@interface forgetNextViewController ()
@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation forgetNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"忘记密码"];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}
//判断8-16位数字、字母组合
-(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 8){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}
//确定
- (IBAction)confirm:(id)sender {
    if (![self judgePassWordLegal:self.password.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入8-16位数字字母组合"];
        return;
    }
    [HLLoginManager NetPostresetpwdMobile:self.phoneNum password:self.password.text msgId:self.msgId verifyCode:self.yanZhengNum success:^(NSDictionary *info) {
        NSLog(@"------>>%@",info);

       NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
         [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
@end
