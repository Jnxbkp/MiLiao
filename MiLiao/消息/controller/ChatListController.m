//
//  ChatListController.m
//  XinMart
//
//  Created by iMac on 2017/9/5.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "ChatListController.h"
#import "ChatRoomController.h"
#import "messageView.h"
#import "MyCallViewController.h"
#import "MyMViewController.h"
#import "MyNoticeViewController.h"

#import "VideoUserModel.h"
//#import "DatingModel.h"
@interface ChatListController ()<RCIMUserInfoDataSource>
{
    NSUserDefaults *_userDefaults;
}
@end

@implementation ChatListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    double systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    if (systemVersion < 11) {
        self.conversationListTableView.contentInset = UIEdgeInsetsMake(ML_TopHeight, 0, 0, 0);
    }
    
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"消息"];
    _userDefaults = [NSUserDefaults standardUserDefaults];

    // Do any additional setup after loading the view.
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    //设置需要显示哪些类型的会话
    

    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)
//                                        @(ConversationType_DISCUSSION),
//                                        @(ConversationType_CHATROOM),
//                                        @(ConversationType_GROUP),
//                                        @(ConversationType_APPSERVICE),
//                                        @(ConversationType_CUSTOMERSERVICE),
//                                        @(ConversationType_PUSHSERVICE),
//                                        @(ConversationType_SYSTEM)
                                        ]
     ];
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.conversationListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-ML_TopHeight-ML_TabBarHeight)];
    messageView *vc = [[NSBundle mainBundle] loadNibNamed:
                       @"messageView" owner:nil options:nil ].lastObject;
    __weak typeof(self) weakSelf = self;

    vc.tonghuaBlock = ^{
        //我的通话
        MyCallViewController *myCallVC = [[MyCallViewController alloc]init];
        [self.navigationController pushViewController:myCallVC animated:YES];
        NSLog(@"我的通话");
    };
    vc.MBlock = ^{
        //我的M币
        NSLog(@"我的M币");
        MyMViewController *Mvc = [[MyMViewController alloc]init];
        [weakSelf.navigationController pushViewController:Mvc animated:YES];
    };
//    vc.xitongBlock = ^{
//        //系统通知
//        NSLog(@"系统通知");
//
//    };
    if ([[_userDefaults objectForKey:@"isHidden"]isEqualToString:@"yes"])
    {
        vc.MImageView.hidden = YES;
        vc.MLabel.hidden = YES;
        vc.Mjiantou.hidden = YES;
        vc.btnM.hidden = YES;
        vc.frame = CGRectMake(0, 0, WIDTH, 90);
    }
    self.conversationListTableView.tableHeaderView = vc;
    
    self.conversationListTableView.tableFooterView = [UIView new];

//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiaoxi"]];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.emptyConversationView = imageView;
    
//    [self.emptyConversationView removeFromSuperview];
    
    if ([self.conversationListTableView respondsToSelector:@selector (setSeparatorInset:)]) {
        [self.conversationListTableView setSeparatorInset:UIEdgeInsetsZero ];
        [self.conversationListTableView setSeparatorColor:[UIColor colorWithHexString:@"EEEEEE"]];
    }
    
    UIButton *leftButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame  = CGRectMake(0, 0, 50, 30);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftButton setImage:[UIImage imageNamed:@"fanhui2"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(leftButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    [RCIM sharedRCIM].userInfoDataSource = self;

}
- (void)leftButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    //通过刷新列表给cell赋值
    NSLog(@"userid 聊天聊天列表 ==== %@",userId);
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

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ChatRoomController *conversationVC = [[ChatRoomController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    VideoUserModel *user = [[VideoUserModel alloc] init];
    user.username = model.targetId;
    conversationVC.videoUser = user;
    
    [self.navigationController pushViewController:conversationVC animated:YES];
}




@end
