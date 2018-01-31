//
//  AppDelegate.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MLTabBarController.h"
#import "LoginViewController.h"
#import "phoneLoginViewController.h"
//#import <UMSocialCore/UMSocialCore.h>
#import "ViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <RongCallLib/RongCallLib.h>

#import "FUVideoFrameObserverManager.h"

#import "IQKeyboardManager.h"

//#import <AlipaySDK/AlipaySDK.h>

#import "PublicManager.h"
// iOS 10 notification
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<RCIMReceiveMessageDelegate,UNUserNotificationCenterDelegate>
{
    NSUserDefaults *_userDefaults;
    // iOS 10通知中心
    UNUserNotificationCenter *_notificationCenter;
}

@end

@implementation AppDelegate

//test
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
   
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *isLog = [_userDefaults stringForKey:@"isLog"];
    if ([isLog isEqualToString:@"yes"]) {
        self.window.rootViewController = [[MLTabBarController alloc] init];
    } else {
        self.window.rootViewController = [[phoneLoginViewController alloc]init];
    }
    
    [self.window makeKeyAndVisible];
    [self autoLogin];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootViewController:) name:@"KSwitchRootViewControllerNotification" object:nil];
    
//    /* 打开调试日志 */
//    [[UMSocialManager defaultManager] openLog:YES];
//
//    /* 设置友盟appkey */
//    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    
//    [self configUSharePlatforms];
    
//    [self confitUShareSettings];
    
    // 初始化阿里云推送SDK
    [self initCloudPush];
    // APNs注册，获取deviceToken并上报
    [self registerAPNS:application];
    // 监听推送消息到达
    [self registerMessageReceive];
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:launchOptions];
    
    
    //融云
    [[RCIM sharedRCIM] initWithAppKey:@"8w7jv4qb8ch6y"];//8brlm7uf8djg3(release)    8luwapkv8rtcl(debug)
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].receiveMessageDelegate = self;

    [self settingRCIMToken:[_userDefaults objectForKey:@"rongCloudToken"]];

    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    //设置视频分辨率
    [[RCCallClient sharedRCCallClient] setVideoProfile:RC_VIDEO_PROFILE_720P];
    //注册监听 美颜视频流
//    [FUVideoFrameObserverManager registerVideoFrameObserver];
    

    [_userDefaults setObject:@"no" forKey:@"isHidden"];
//    [self getHiddenVersion];
    return YES;
}
#pragma mark APNs Register
/**
 *    向APNs注册，获取deviceToken用于推送
 *
 *
 */
- (void)registerAPNS:(UIApplication *)application {
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersionNum >= 10.0) {
        // iOS 10 notifications
        _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
         _notificationCenter.delegate = self; //遵循协议
        // 创建category，并注册到通知中心
        [self createCustomNotificationCategory];
        _notificationCenter.delegate = self;
        // 请求推送权限
        [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // granted
                NSLog(@"User authored notification.");
                // 向APNs注册，获取deviceToken
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
            } else {
                // not granted
                NSLog(@"User denied notification.");
            }
        }];
    } else if (systemVersionNum >= 8.0) {
        // iOS 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
#pragma clang diagnostic pop
    } else {
        // iOS < 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#pragma clang diagnostic pop
    }
}
/*
*  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
*/
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success.");
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}
/*
 *  APNs注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}
/**
 *  创建并注册通知category(iOS 10+)
 */
- (void)createCustomNotificationCategory {
    // 自定义`action1`和`action2`
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"test1" options: UNNotificationActionOptionNone];
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"test2" options: UNNotificationActionOptionNone];
    // 创建id为`test_category`的category，并注册两个action到category
    // UNNotificationCategoryOptionCustomDismissAction表明可以触发通知的dismiss回调
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"test_category" actions:@[action1, action2] intentIdentifiers:@[] options:
                                        UNNotificationCategoryOptionCustomDismissAction];
    // 注册category到通知中心
    [_notificationCenter setNotificationCategories:[NSSet setWithObjects:category, nil]];
}
/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOS10Notification:(UNNotification *)notification {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    NSDate *noticeDate = notification.date;
    // 标题
    NSString *title = content.title;
    // 副标题
    NSString *subtitle = content.subtitle;
    // 内容
    NSString *body = content.body;
    // 角标
    int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *extras = [userInfo valueForKey:@"Extras"];
    // 通知角标数清0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 同步角标数到服务端
    // [self syncBadgeNum:0];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);
}
/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Receive a notification in foregound.");
    // 处理iOS 10通知，并上报通知打开回执
    [self handleiOS10Notification:notification];
    // 通知不弹出
    completionHandler(UNNotificationPresentationOptionNone);
    
    // 通知弹出，且带有声音、内容和角标
    //completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}
/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        NSLog(@"User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        [self handleiOS10Notification:response.notification];
    }
    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        NSLog(@"User dismissed the notification.");
    }
    NSString *customAction1 = @"action1";
    NSString *customAction2 = @"action2";
    // 点击用户自定义Action1
    if ([userAction isEqualToString:customAction1]) {
        NSLog(@"User custom action1.");
    }
    
    // 点击用户自定义Action2
    if ([userAction isEqualToString:customAction2]) {
        NSLog(@"User custom action2.");
    }
    completionHandler();
}

#pragma mark SDK Init
- (void)initCloudPush {
    
#ifdef DEBUG
    // 正式上线建议关闭
    [CloudPushSDK turnOnDebug];
#endif
    // SDK初始化
    [CloudPushSDK asyncInit:ALiPushAppKey appSecret:ALiPushAppSecret callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}
#pragma mark Notification Open
/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"Receive one notification.");
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 同步通知角标数到服务端
    // [self syncBadgeNum:0];
    // 通知打开回执上报
    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:userInfo];
}

/**
 *    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
/**
 *    处理到来推送消息
 *
 *
 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}
- (void)autoLogin{
  
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[_userDefaults objectForKey:@"token"]];
    if (tokenStr.length>0&&![tokenStr isEqualToString:@"(null)"]) {
      
        [HLLoginManager NetGetgetUserInfoToken:tokenStr UserId:@"0" success:^(NSDictionary *info) {
            
//            [[User ShardInstance] saveUserInfoWithInfo:info[@"data"]];
            [YZCurrentUserModel userInfoWithDictionary:info[@"data"]];
            
            _userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *isBigV = [NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"isBigv"]];
            [_userDefaults setObject:isBigV forKey:@"isBigV"];
            NSString *token = info[@"data"][@"token"];
            [_userDefaults setObject:token forKey:@"token"];
            [_userDefaults synchronize];
            
        } failure:^(NSError *error) {
            
        }];
    } 

}
//是否是隐藏
- (void)getHiddenVersion {
    [PublicManager NetGetgetHideVersionsuccess:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            NSString *str = [NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"hideVersion"]];
         
            if ([str isEqualToString:@"0"]) {
                [_userDefaults setObject:@"no" forKey:@"isHidden"];
            } else {
                [_userDefaults setObject:@"yes" forKey:@"isHidden"];
            }
            NSString *isBigV = [NSString stringWithFormat:@"%@",[_userDefaults objectForKey:@"isBigV"]];
            NSString *isLog = [NSString stringWithFormat:@"%@",[_userDefaults objectForKey:@"isLog"]];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:isBigV,@"isBigV",isLog,@"isLog", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:dic];
        } else {
            [_userDefaults setObject:@"yes" forKey:@"isHidden"];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
        [_userDefaults setObject:@"yes" forKey:@"isHidden"];
        
    }];
}
/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param left        还剩余的未接收的消息数，left>=0
 
 @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
}

// [_userDefaults objectForKey:@"token"]
- (void)settingRCIMToken:(NSString *)rongCloudToken {
    if (!rongCloudToken) return;
    

        [[RCIM sharedRCIM] connectWithToken:rongCloudToken  success:^(NSString *userId) {
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
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}
- (void)configUSharePlatforms
{
//    /*
//     设置微信的appKey和appSecret
//     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
//     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:nil];
//    /*
//     * 移除相应平台的分享，如微信收藏
//     */
//    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
//    
//    /* 设置分享到QQ互联的appID
//     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//     100424468.no permission of union id
//     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
//     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//    
//    /*
//     设置新浪的appKey和appSecret
//     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
//     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaWeiboAppKey  appSecret:SinaWeiboSecret redirectURL:@"https://www.baidu.com"];
    
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
//    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
//    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
//            NSLog(@"result = %@",resultDic);
//        }];
//    }
//    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
//
//        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
//            NSLog(@"result = %@",resultDic);
//        }];
//    }
    return YES;
    
    
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
     _enterBackgroundFlag = true;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
//    UIViewController *topmostVC = [self topViewController];
//    if ([topmostVC isKindOfClass:[ViewController class]]) {
//        ViewController *VC = topmostVC;
//        [VC resumeCapturePreview];
//    } else {
//        
//    }
//    [self switchRootViewController:nil];
     _enterBackgroundFlag = false;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    UIViewController *topmostVC = [self topViewController];
//    if ([topmostVC isKindOfClass:[ViewController class]]) {
//        ViewController *VC = topmostVC;
//        [VC clear];
//    } else {
//
//    }
}
//AFNetWorking leaks
static AFHTTPSessionManager *manager ;
- (AFHTTPSessionManager *)sharedHTTPSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 10;
        
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
        AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [security setValidatesDomainName:NO];
        security.allowInvalidCertificates = YES;
        manager.securityPolicy = security;
        
    });
        return manager;
}
//获取最上层VC
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
//选择bar
- (void)switchRootViewController:(NSNotification *)note {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isBigV = [userDefaults objectForKey:@"isBigV"];
    NSString *isLog = [userDefaults objectForKey:@"isLog"];
  
    if ([isLog isEqualToString:@"yes"]) {
        MLTabBarController *tabBarVC = [[MLTabBarController alloc] init];
        tabBarVC.selectedViewController = [tabBarVC.viewControllers objectAtIndex:0];
        self.window.rootViewController = tabBarVC;
    } else {
        self.window.rootViewController = [[phoneLoginViewController alloc]init];
        
    }
    
}
@end
