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
//#import "PersonHomepageController.h"
//#import "DatingModel.h"
@interface ChatRoomController ()<RCIMUserInfoDataSource>
{
    NSUserDefaults *_userDefaults;
    MoneyEnoughType moneyType;
}
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, assign) NSInteger typeCode;

@end

@implementation ChatRoomController

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
}
- (void)leftButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
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
