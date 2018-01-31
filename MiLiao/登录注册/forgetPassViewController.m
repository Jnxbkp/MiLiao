//
//  forgetPassViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/4.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "forgetPassViewController.h"
#import "forgetNextViewController.h"
#define CountDown 60

@interface forgetPassViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *yanZhengNum;
@property (strong, nonatomic) IBOutlet UIButton *getButton;
@property(nonatomic,assign) NSInteger secondCountDown;
@property(nonatomic,strong) NSTimer *countDownTimer;
@property(nonatomic,strong) NSString *msgId;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation forgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"忘记密码"];
    _getButton.backgroundColor = [UIColor grayColor];
    _nextBtn.backgroundColor = [UIColor whiteColor];
    [_phoneNum addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_yanZhengNum addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIButton *leftButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame  = CGRectMake(0, 0, 50, 30);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(leftButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark -输入框实时变化改变颜色
-(void)textFieldDidChange :(UITextField *)theTextField{
    if (theTextField == self.phoneNum) {
        if ([_phoneNum.text isEqualToString:@""]) {
            self.getButton.enabled=NO;
            _getButton.backgroundColor = [UIColor grayColor];
            
        }else{
            self.getButton.enabled=YES;
            
            _getButton.backgroundColor = ML_Color(250, 114, 152, 1);// 250  114  152
            
        }
    }
    if (theTextField == self.yanZhengNum) {
        if ([_yanZhengNum.text isEqualToString:@""]) {
            self.nextBtn.enabled=NO;
            _nextBtn.backgroundColor = [UIColor whiteColor];
            [_nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }else{
            self.nextBtn.enabled=YES;
            
            _nextBtn.backgroundColor = ML_Color(250, 114, 152, 1);// 250  114  152
           [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
    }
    
}
- (void)leftButtonDidClick {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}
- (IBAction)yanzheng:(id)sender {
    [self.view endEditing:YES];
    if (![self.phoneNum.text isValidateMobile]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    self.getButton.enabled=NO;
    
    [HLLoginManager NetGetgetVerifyCodeMobile:self.phoneNum.text verifyMobile:@"1" success:^(NSDictionary *info) {
        NSLog(@"----%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
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
//下一步
- (IBAction)next:(id)sender {
    [HLLoginManager verifyCodeResetPWD:self.phoneNum.text verifyCode:self.yanZhengNum.text success:^(NSDictionary *info){
        NSLog(@"----------------%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            forgetNextViewController *next = [[forgetNextViewController alloc]init];
            next.phoneNum = self.phoneNum.text;
            next.yanZhengNum = self.yanZhengNum.text;
            next.msgId = self.msgId;//验证码
            [self.navigationController pushViewController:next animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

        }
        
    } failure:^(NSError *error) {
        
    }];
  
}
- (void)getCodeFromSer{
    _secondCountDown = CountDown;
    _countDownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}
//60秒倒计时
-(void)timeFireMethod{
    
    _secondCountDown--;
    
    NSString*secondStr1=[NSString stringWithFormat:@"重新发送(%ld秒)",(long)_secondCountDown];
    [self.getButton setTitle:secondStr1 forState:UIControlStateNormal];
    
    if (_secondCountDown==0) {
        [_countDownTimer invalidate];
        [self.getButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.getButton setTitle:@"重新发送" forState:UIControlStateDisabled];
        self.getButton.enabled=YES;
        self.getButton.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
@end
