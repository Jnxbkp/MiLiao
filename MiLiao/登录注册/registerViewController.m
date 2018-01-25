//
//  registerViewController.m
//  MChat
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "registerViewController.h"
#import "HLLoginManager.h"
#import "LoginViewController.h"
#import "phoneLoginViewController.h"
//#import "MeViewController.h"
#define CountDown 60

@interface registerViewController ()
@property(nonatomic,assign) NSInteger secondCountDown;
@property(nonatomic,strong) NSTimer *countDownTimer;
@property(nonatomic,strong) NSString *msgId;

@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *yanzhengNum;
@property (strong, nonatomic) IBOutlet UIButton *getButton;//获取验证码

@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"注册"];
    UIButton *leftButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame  = CGRectMake(0, 0, 50, 30);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(leftButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    _password.secureTextEntry = YES;
}
- (void)leftButtonDidClick {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}
//- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//    [super viewWillDisappear:animated];
//}
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
//获取验证码
- (IBAction)yanzheng:(id)sender {
    if (![self.phoneNum.text isValidateMobile]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if (![self judgePassWordLegal:self.password.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入8-16位数字字母组合"];
        return;
    }
//    self.getButton.enabled=NO;
    [HLLoginManager NetGetgetVerifyCodeMobile:self.phoneNum.text success:^(NSDictionary *info) {
        NSLog(@"----%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            [SVProgressHUD dismiss];
            self.msgId = info[@"data"][@"verifyCode"];
            NSLog(@"--------%@",self.msgId);
            //写在网络请求里
            [self getCodeFromSer];
        }else{
            [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

        }
      

    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
    
}
- (void)getCodeFromSer{
    _secondCountDown = CountDown;
    _countDownTimer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}
//60秒倒计时
-(void)timeFireMethod{
    
    _secondCountDown--;
    
    NSString*secondStr1=[NSString stringWithFormat:@"重新发送(%ld秒)",(long)_secondCountDown];
    [self.getButton setTitle:secondStr1 forState:UIControlStateDisabled];
    
    if (_secondCountDown==0) {
        [_countDownTimer invalidate];
        [self.getButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.getButton setTitle:@"重新发送" forState:UIControlStateDisabled];
        self.getButton.enabled=YES;
        self.getButton.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    }
}
//下一步
- (IBAction)next:(id)sender {
    if ([self.password.text isNumText]&&self.password.text.length>8) {
        [SVProgressHUD showErrorWithStatus:@"请输入8-16位数字字母组合"];
        return;
    }
    [HLLoginManager NetPostRegisterMobile:self.phoneNum.text password:self.password.text msgId:self.msgId verifyCode:self.yanzhengNum.text  deviceType:[NSNumber numberWithInt:1] success:^(NSDictionary *info) {
        NSLog(@"注册---------------%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
//            phoneLoginViewController*bvc = [[phoneLoginViewController alloc]init];
//            YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:bvc];
//            [self presentViewController:nav animated:NO completion:^{
//            }];
            [self dismissViewControllerAnimated:NO completion:nil];

        }else{
            [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

        }
    } failure:^(NSError *error) {
        NSLog(@"----%@",error);
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
