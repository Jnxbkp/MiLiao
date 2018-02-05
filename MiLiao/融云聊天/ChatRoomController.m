//
//  ChatRoomController.m
//  XinMart
//
//  Created by iMac on 2017/9/5.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "ChatRoomController.h"
#import "RongCallKit.h"
#import "VideoUserModel.h"
#import "UserInfoNet.h"
#import "UserCallPowerModel.h"//通话能力
#import "PayWebViewController.h"
#import "GoPayTableViewController.h"
#import "EnoughCallTool.h"

#import "EvaluateVideoViewController.h"//评价
//#import "PersonHomepageController.h"
//#import "DatingModel.h"
@interface ChatRoomController ()<RCIMUserInfoDataSource>
{
    NSUserDefaults *_userDefaults;
    MoneyEnoughType moneyType;
}
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, assign) NSInteger typeCode;
///评价控制器
@property (nonatomic, strong) EvaluateVideoViewController *evaluateVideoViewConroller;
@end

@implementation ChatRoomController
- (EvaluateVideoViewController *)evaluateVideoViewConroller {
    if (!_evaluateVideoViewConroller) {
        _evaluateVideoViewConroller = [[EvaluateVideoViewController alloc] init];
        _evaluateVideoViewConroller.superview = self.view;
    }
    return _evaluateVideoViewConroller;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [UserInfoNet canCall:self.videoUser.username powerEnough:^(RequestState success, NSString *msg, MoneyEnoughType enoughType) {
        if (success) {

              moneyType = enoughType;
        }
    }];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
//    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    double systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    if (systemVersion < 11) {
        if ([self.isFSBase isEqualToString:@"YES"]) {
            self.conversationMessageCollectionView.contentInset = UIEdgeInsetsMake(ML_NavBarHeight, 0, 0, 0);
        }
    }
    if (UI_IS_IPHONEX) {
        if ([self.isFSBase isEqualToString:@"YES"]) {
            self.navView = [[UIView alloc]init];
            self.navView.backgroundColor = [UIColor whiteColor];
            self.navView.frame = CGRectMake(0, 0, WIDTH,  ML_StatusBarHeight);
            [self.navigationController.view addSubview:self.navView];
            self.conversationMessageCollectionView.contentInset = UIEdgeInsetsMake(ML_NavBarHeight, 0, 0, 0);
        }
    }
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:0];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:0];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:0];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:0];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:1];


    [RCIM sharedRCIM].userInfoDataSource = self;
    [self listenNotification];
}
- (void)leftButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 通知方法
- (void)listenNotification {
    ListenNotificationName_Func(VideoCallEnd, @selector(notificationFunc:));
    ListenNotificationName_Func(SetMoneySuccess, @selector(notificationFunc:));
}

- (void)notificationFunc:(NSNotification *)notification {
    
    [self saveSetMoneySuccessLog:notification];
    
    if ([NSThread isMainThread]) {
        //视频通话结束 添加评价界面
        if ([notification.name isEqualToString:VideoCallEnd]) {
            [self.evaluateVideoViewConroller showEvaluaateView:notification.userInfo];
        }
        //结算成功
        if ([notification.name isEqualToString:SetMoneySuccess]) {
            [self.evaluateVideoViewConroller showSetMoneySuccessView:notification.userInfo];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            //视频通话结束 添加评价界面
            if ([notification.name isEqualToString:VideoCallEnd]) {
                [self.evaluateVideoViewConroller showEvaluaateView:notification.userInfo];
            }
            //结算成功
            if ([notification.name isEqualToString:SetMoneySuccess]) {
                
                [self.evaluateVideoViewConroller showSetMoneySuccessView:notification.userInfo];
            }
        });
    }
}

- (void)saveSetMoneySuccessLog:(NSNotification *)notification {
    // 日常日志保存
    NSArray  *dirArr  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirPath = dirArr[0];
    NSString *logDir = [dirPath stringByAppendingString:@"/通话结算Log"];
    
    BOOL isExistLogDir = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logDir]) {
        isExistLogDir = [fileManager createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *threadName = [NSThread isMainThread]?@"主线程":@"子线程";
    NSString *className = NSStringFromClass([self class]);
    NSString *logStr = [NSString stringWithFormat:@"\n\n\n当前时间%@,\n通知名称:%@,\n通知内的字典内容:%@,\n当前线程:%@,\n 当前类别:%@", currentDateStr, notification.name, [notification.userInfo mj_JSONString], threadName, NSStringFromClass([self class])];
    if (isExistLogDir) {
        
        NSString *logPath = [logDir stringByAppendingString:@"/通话结束结算通知Log.txt"];
        if ([fileManager fileExistsAtPath:logPath]) {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:logPath];
            [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
            NSData* stringData  = [logStr dataUsingEncoding:NSUTF8StringEncoding];
            [fileHandle writeData:stringData]; //追加写入数据
            [fileHandle closeFile];
        } else {
            [logStr writeToFile:logPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        }
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view  = [UICollectionReusableView new];
    return view;
}
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    NSLog(@"userid 聊天聊天室啊==== %@",userId);
    [HLLoginManager NetGetgetUserInfoToken:[_userDefaults objectForKey:@"token"] UserId:userId success:^(NSDictionary *info) {
        NSLog(@"%@",info);
        RCUserInfo *infoo = [[RCUserInfo alloc] initWithUserId:userId name:info[@"data"][@"nickName"] portrait:info[@"data"][@"headUrl"]];
        completion(infoo);
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//发送消息
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent
{
    __weak typeof(self) weakSelf = self;
    //余额不充足 不能聊天
    if (moneyType == MoneyEnoughTypeNotEnough) {
        [self showPayAlertController:^{
            [weakSelf goPay];
            [self.view endEditing:YES];

        }];
        return nil;
    }
    //余额为0
    if (moneyType == MoneyEnoughTypeEmpty) {
        [self showPayAlertController:^{
            [weakSelf goPay];
            [self.view endEditing:YES];

        }];
        return nil;
    }
    return messageContent;
}
- (void)goPay {
    GoPayTableViewController *payViewController = [[GoPayTableViewController alloc] init];
    [self.navigationController pushViewController:payViewController animated:YES];
}
///去充值
- (void)showPayAlertController:(void(^)(void))pay {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的撩币不足" message:@"是否立即充值" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.view endEditing:YES];

    }];
    UIAlertAction *payAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.view endEditing:YES];
        !pay?:pay();
    }];
    [payAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
    [alertController addAction:cancleAction];
    [alertController addAction:payAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*!
 扩展功能板的点击回调
 
 @param pluginBoardView 输入扩展功能板View
 @param tag             输入扩展功能(Item)的唯一标示
 */
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    NSLog(@"%ld", tag);
    if (tag == 1102) {
        [[RCCall sharedRCCall] startSingleVideoCallToVideoUser:self.videoUser];
    } else {
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
}


- (void)didTapMessageCell:(RCMessageModel *)model
{
    if ([model.objectName isEqualToString:@"RC:VCSummary"]) {
        return;
    } else {
        [super didTapMessageCell:model];
    }
}
// @param userId  点击头像对应的用户ID
- (void)didTapCellPortrait:(NSString *)userId {
//    RtLog(@"%@",userId);
//    PersonHomepageController *person = [[UIStoryboard XinMartStoryboard] instantiateViewControllerWithIdentifier:@"PersonHomepageController"];
//    person.user_id = userId;
//    [self.navigationController pushViewController:person animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
