//
//  administrateAccountViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "administrateAccountViewController.h"

@interface administrateAccountViewController ()
{
    NSUserDefaults *_userDefaults;
    
}
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *accountName;

@end

@implementation administrateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"管理提现账户"];
    self.view.backgroundColor = ML_Color(248, 248, 248, 1);
    _userDefaults = [NSUserDefaults standardUserDefaults];

}
- (IBAction)sure:(id)sender {
    [HLLoginManager saveUserWirthdrawInfotoken:[_userDefaults objectForKey:@"token"] Account:self.account.text AccountName:self.accountName.text success:^(NSDictionary *info) {
        NSLog(@"%@",info);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
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
