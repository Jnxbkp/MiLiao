//
//  phoneLoginViewController.m
//  MChat
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "phoneLoginViewController.h"
#import "registerViewController.h"
#import "forgetPassViewController.h"

#import <UMSocialCore/UMSocialCore.h>
#import <RongIMKit/RongIMKit.h>
#import "User.h"
#import <MJExtension.h>
@interface phoneLoginViewController ()<UINavigationControllerDelegate>
{
    NSUserDefaults *_userDefaults;
}
@property (strong, nonatomic) IBOutlet UIButton *weChat;
@property (strong, nonatomic) IBOutlet UIButton *QQ;
@property (strong, nonatomic) IBOutlet UIButton *weiBo;
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *SEliao;
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIButton *shoujibtn;
@property (weak, nonatomic) IBOutlet UIButton *mimabtn;
@property (weak, nonatomic) IBOutlet UIButton *eye;
@property (weak, nonatomic) IBOutlet UIButton *zhuce;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *forget;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end

@implementation phoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    _password.secureTextEntry = YES;
    if (UI_IS_IPHONE6PLUS) {
        self.height.constant = 100;
    }
    if (UI_IS_IPHONEX) {
        self.height.constant = 150;
        //  现在改变你的代码
        [ self.view setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[self imageResize :[UIImage imageNamed:@"2436"] andResizeTo: self.view.frame.size]];
    }else{
        //  现在改变你的代码
        [ self.view setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[self imageResize :[UIImage imageNamed:@"bg"] andResizeTo: self.view.frame.size]];
    }
 
}
-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}
- (IBAction)eye:(UIButton *)sender {
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.password.text;
        self.password.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.password.secureTextEntry = NO;
        self.password.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.password.text;
        self.password.text = @"";
        self.password.secureTextEntry = YES;
        self.password.text = tempPwdStr;
    }
    
}

//注册
- (IBAction)registe:(id)sender {
    registerViewController *registerVC = [[registerViewController alloc]init];

    YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:registerVC];
    
    [self presentViewController:nav animated:NO completion:^{



    }];
//    [self presentViewController:registerVC animated:YES completion:^{
    
//    }];
//    [self.navigationController pushViewController:nav animated:YES];
}
//登录
- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    //[CloudPushSDK getDeviceId]

    [HLLoginManager NetPostLoginMobile:self.phoneNum.text password:self.password.text  deviceType:[NSNumber numberWithInt:1] utdeviceId:[CloudPushSDK getDeviceId] success:^(NSDictionary *info) {
        NSLog(@"----------------%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
              NSLog(@"---------------->>%@",info);
            [SVProgressHUD dismiss];
            //保存用户信息
            [YZCurrentUserModel userInfoWithDictionary:info[@"data"]];
            NSLog(@"%@", [YZCurrentUserModel sharedYZCurrentUserModel].roleType);
            NSLog(@"阿里推送ID是:%@",[CloudPushSDK getDeviceId]);
            NSString *isBigV = [NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"isBigv"]];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:isBigV,@"isBigV",@"yes",@"isLog", nil];
          //  0:未申请, 1:申请待审核, 2:审核未通过, 3:审核通过
            [_userDefaults setObject:isBigV forKey:@"isBigV"];
            [_userDefaults setObject:@"yes" forKey:@"isLog"];
            NSString *token = info[@"data"][@"token"];
            [_userDefaults setObject:token forKey:@"token"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"nickname"]] forKey:@"nickname"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"headUrl"]] forKey:@"headUrl"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"id"]] forKey:@"id"];
            [_userDefaults setObject:self.phoneNum.text forKey:@"phoneNum"];
            [_userDefaults setObject:self.password.text forKey:@"password"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"rongCloudToken"]] forKey:@"rongCloudToken"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"balance"]] forKey:@"balance"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"username"]] forKey:@"username"];
             [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"price"]] forKey:@"price"];
            [_userDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:dic];
            //融云登录操作
            [self settingRCIMToken:[_userDefaults objectForKey:@"rongCloudToken"]];
            

        }else{
            [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];
        }
       
    } failure:^(NSError *error) {
        NSLog(@"----<<<>>>error%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
    }];

}
//三方登录
- (IBAction)thirdLog:(UIButton *)sender {
    if (sender == self.weChat) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                
            } else {
                UMSocialUserInfoResponse *resp = result;
                
                // 授权信息
                NSLog(@"Wechat uid: %@", resp.uid);
                NSLog(@"Wechat openid: %@", resp.openid);
                NSLog(@"Wechat unionid: %@", resp.unionId);
                NSLog(@"Wechat accessToken: %@", resp.accessToken);
                NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
                NSLog(@"Wechat expiration: %@", resp.expiration);
                
                // 用户信息
                NSLog(@"Wechat name: %@", resp.name);
                NSLog(@"Wechat iconurl: %@", resp.iconurl);
                NSLog(@"Wechat gender: %@", resp.unionGender);
                
               
                [self quickLogInname:resp.name platform:@"WECHAT" token:resp.accessToken uid:resp.uid];
            }
        }];
    }
    if (sender == self.QQ) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                
            } else {
                UMSocialUserInfoResponse *resp = result;
                
                // 授权信息
                NSLog(@"QQ uid: %@", resp.uid);
                NSLog(@"QQ openid: %@", resp.openid);
                NSLog(@"QQ unionid: %@", resp.unionId);
                NSLog(@"QQ accessToken: %@", resp.accessToken);
                NSLog(@"QQ expiration: %@", resp.expiration);
                
                // 用户信息
                NSLog(@"QQ name: %@", resp.name);
                NSLog(@"QQ iconurl: %@", resp.iconurl);
                NSLog(@"QQ gender: %@", resp.unionGender);
                
                [self quickLogInname:resp.name platform:@"QQ" token:resp.accessToken uid:resp.uid];
            }
        }];
    }if (sender == self.weiBo) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                
            } else {
                UMSocialUserInfoResponse *resp = result;
                
                // 授权信息
                NSLog(@"Sina uid: %@", resp.uid);
                NSLog(@"Sina accessToken: %@", resp.accessToken);
                NSLog(@"Sina refreshToken: %@", resp.refreshToken);
                NSLog(@"Sina expiration: %@", resp.expiration);
                
                // 用户信息
                NSLog(@"Sina name: %@", resp.name);
                NSLog(@"Sina iconurl: %@", resp.iconurl);
                NSLog(@"Sina gender: %@", resp.unionGender);
                
               [self quickLogInname:resp.name platform:@"SINA" token:resp.accessToken uid:resp.uid];
            }
        }];
    }
}
//忘记密码
- (IBAction)forget:(id)sender {
    forgetPassViewController *forget = [[forgetPassViewController alloc]init];
    YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:forget];
    [self presentViewController:nav animated:NO completion:^{
    }];
}
//快速登录
- (void)quickLogInname:(NSString *)name platform:(NSString *)platform token:(NSString *)token uid:(NSString *)uid {
    [HLLoginManager NetPostquickLoginName:name platform:platform token:token uid:uid success:^(NSDictionary *info) {
        //                    NSLog(@"------>>%@",info);
        NSString *resultCode = [NSString stringWithFormat:@"%@",[info objectForKey:@"resultCode"]];
        if ([resultCode isEqualToString:@"200"]) {
            //保存用户信息
//            [YZCurrentUserModel userInfoWithDictionary:info[@"data"]];

            NSString *isBigV = [NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"isBigv"]];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:isBigV,@"isBigV",@"yes",@"isLog", nil];
            [_userDefaults setObject:isBigV forKey:@"isBigV"];
            [_userDefaults setObject:@"yes" forKey:@"isLog"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"token"]] forKey:@"token"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"nickname"]] forKey:@"nickname"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"headUrl"]] forKey:@"headUrl"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:dic];
            
            //融云登录操作
            [self settingRCIMToken:[_userDefaults objectForKey:@"rongCloudToken"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
// [_userDefaults objectForKey:@"token"]
- (void)settingRCIMToken:(NSString *)rongCloudToken {
    if (!rongCloudToken) return;

        [[RCIM sharedRCIM] connectWithToken:rongCloudToken success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            //把自己信息存起来
            [self RCIM_currentUserInfo:userId];
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];

}
- (void)RCIM_currentUserInfo:(NSString *)userId {
    //自己的信息
    RCUserInfo *_currentUserInfo =
    [[RCUserInfo alloc] initWithUserId:userId
                                  name:[_userDefaults objectForKey:@"nickname"]
                              portrait:[_userDefaults objectForKey:@"headUrl"]];
    [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.password && textField.isSecureTextEntry) {
        textField.text = toBeString;
        return NO;
    }
    return YES;
}
@end
