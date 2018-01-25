//
//  LoginViewController.m
//  MChat
//
//  Created by apple on 2017/12/29.
//  Copyright © 2017年 Zc. All rights reserved.
//

#import "LoginViewController.h"
#import "phoneLoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <RongIMKit/RongIMKit.h>

@interface LoginViewController () {
    NSUserDefaults  *_userDefaults;
}

@property (strong, nonatomic) IBOutlet UIButton *weChat;
@property (strong, nonatomic) IBOutlet UIButton *QQ;
@property (strong, nonatomic) IBOutlet UIButton *WeiBo;
@property (strong, nonatomic) IBOutlet UIButton *phoneNumber;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
  
}
//- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//    [super viewWillDisappear:animated];
//}
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
    }
    if (sender == self.WeiBo) {
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
    if (sender == self.phoneNumber) {

        phoneLoginViewController*bvc = [[phoneLoginViewController alloc]init];
        
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:bvc];
        
        [self presentViewController:nav animated:NO completion:^{
            
            
            
        }];
    }
}
//快速登录
- (void)quickLogInname:(NSString *)name platform:(NSString *)platform token:(NSString *)token uid:(NSString *)uid {
    [HLLoginManager NetPostquickLoginName:name platform:platform token:token uid:uid success:^(NSDictionary *info) {
                            NSLog(@"------>>%@",info);
        NSString *resultCode = [NSString stringWithFormat:@"%@",[info objectForKey:@"resultCode"]];
        if ([resultCode isEqualToString:@"200"]) {
//            [YZCurrentUserModel userInfoWithDictionary:info[@"data"]];
            NSString *isBigV = [NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"isBigv"]];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:isBigV,@"isBigV",@"yes",@"isLog", nil];
            [_userDefaults setObject:isBigV forKey:@"isBigV"];
            [_userDefaults setObject:@"yes" forKey:@"isLog"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"token"]] forKey:@"token"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"token"]] forKey:@"token"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"nickname"]] forKey:@"nickname"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"headUrl"]] forKey:@"headUrl"];
            //rongCloudToken 登录返回的通云token
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"rongCloudToken"]] forKey:@"rongCloudToken"];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:dic];
            //融云登录操作
            [self settingRCIMToken:[_userDefaults objectForKey:@"rongCloudToken"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}

- (void)settingRCIMToken:(NSString *)rongCloudToken {
    if (!rongCloudToken) return;
    
        [[RCIM sharedRCIM] connectWithToken:rongCloudToken success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            //把自己信息存起来
            //            [[UserDataManager ShardInstance] RCIM_currentUserInfo:userId];
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
@end
