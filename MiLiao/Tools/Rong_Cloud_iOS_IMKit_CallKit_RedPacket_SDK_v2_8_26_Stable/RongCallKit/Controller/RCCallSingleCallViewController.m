//
//  RCCallSingleCallViewController.m
//  RongCallKit
//
//  Created by 岑裕 on 16/3/21.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCCallSingleCallViewController.h"
#import "RCCallFloatingBoard.h"
#import "RCCallKitUtility.h"
#import "RCUserInfoCacheManager.h"
#import "RCloudImageView.h"

#import "FUVideoFrameObserverManager.h"
#import "FUManager.h"
#import "FUAPIDemoBar.h"

#import "CountDownView.h"//倒计时view
#import "UserInfoNet.h"
#import "UserCallPowerModel.h"//可通话能力
#import "PayWebViewController.h"

#import "RCCallKitUtility.h"
#import "RemoteUserInfoModel.h"//主播模型


@interface RCCallSingleCallViewController ()<FUAPIDemoBarDelegate, UIGestureRecognizerDelegate, CountDownViewDelegate>

@property(nonatomic, strong) RCUserInfo *remoteUserInfo;

///是否关闭相关控件
@property (nonatomic, assign, getter=isCloseControl) BOOL closeControl;
///是否展示底部的bar
@property (nonatomic, assign, getter=isShowBar) BOOL showBar;

@property (nonatomic, strong) FUAPIDemoBar *bar;
///控件容器数组
@property (nonatomic, strong) NSArray *controlContainerArray;
///检查撩币的定时器
@property (nonatomic, strong) dispatch_source_t checkMoneyTimer;

///准备倒计时的倒计时
@property (nonatomic, strong) dispatch_source_t prepareShowCountDownTimer;

///检查是否充值的定时器
@property (nonatomic, strong) dispatch_source_t checkPayMoneyTimer;

///倒计时view
@property (nonatomic, strong) CountDownView *countDownView;

///是呼入还是呼出的电话 yes - 呼入 no - 呼出
@property (nonatomic, assign, getter=isCallIn) BOOL callIn;
///用于每分钟扣费的参数
@property (nonatomic, strong) NSString *pid;

///电话是否接通过
@property (nonatomic, assign, getter=isCallConnect) BOOL callConnect;

///主播每分钟扣费金额的label
@property (nonatomic, strong) UILabel *anchorPricerLabel;

///对端的主播
@property (nonatomic, strong) RemoteUserInfoModel *remoteAncher;

///已经开始准备倒计时
@property (nonatomic, assign, getter=isDidPrepareCountDown) BOOL didPrepareCountDown;


@end



///分钟计费的时间间隔(秒)
static CGFloat DEDUCT_MONEY_INTERVAL_TIME = 60;

@implementation RCCallSingleCallViewController

#pragma mark - getter
- (NSArray *)controlContainerArray {
    if (!_controlContainerArray) {
        NSMutableArray *array = [NSMutableArray array];
        //挂断的button
        [array addObject:self.hangupButton];
        //切换前后摄像头
        [array addObject:self.cameraSwitchButton];
        //静音
        [array addObject:self.muteButton];
        _controlContainerArray = [array copy];
    }
    return _controlContainerArray;
}

- (CountDownView *)countDownView {
    if (!_countDownView) {
        _countDownView = [CountDownView CountDownView];
        _countDownView.delegate = self;
    }
    return _countDownView;
}


/**
 Faceunity道具美颜工具条
 初始化 FUAPIDemoBar，设置初始美颜参数

 */
-(FUAPIDemoBar *)bar {
    if (!_bar ) {
        _bar = [[FUAPIDemoBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 208)];
        
        _bar.itemsDataSource =  [FUManager shareManager].itemsDataSource;
        _bar.filtersDataSource = [FUManager shareManager].filtersDataSource;
        
        _bar.selectedItem = [FUManager shareManager].selectedItem;
        _bar.selectedFilter = [FUManager shareManager].selectedFilter;
        _bar.selectedBlur = [FUManager shareManager].selectedBlur;
        _bar.beautyLevel = [FUManager shareManager].beautyLevel;
        _bar.thinningLevel = [FUManager shareManager].thinningLevel;
        _bar.enlargingLevel = [FUManager shareManager].enlargingLevel;
        _bar.faceShapeLevel = [FUManager shareManager].faceShapeLevel;
        _bar.faceShape = [FUManager shareManager].faceShape;
        _bar.redLevel = [FUManager shareManager].redLevel;
        _bar.delegate = self;
        
        
    }
    return _bar ;
}

- (UILabel *)anchorPricerLabel {
    if (!_anchorPricerLabel) {
        _anchorPricerLabel = [[UILabel alloc] init];
        _anchorPricerLabel.backgroundColor = RGBColor(0XCCCCCC);
        _anchorPricerLabel.layer.cornerRadius = 15.0;
        _anchorPricerLabel.layer.masksToBounds = YES;
        _anchorPricerLabel.textColor = [UIColor whiteColor];
        _anchorPricerLabel.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView addSubview:_anchorPricerLabel];
        [_anchorPricerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.mas_equalTo(self.hangupButton.mas_top).mas_offset(-15);
            make.height.equalTo(@30);
        }];
    }
    return _anchorPricerLabel;
}


///获取本次通话的callID
- (NSString *)getCurrentCallID {
    NSString *callID = self.callSession.callId;
    return [callID stringByAppendingString:[NSString stringWithFormat:@"|%.0lf", [[NSDate date] timeIntervalSince1970]]];
}

#pragma mark - setter
- (void)setCloseControl:(BOOL)closeControl {
    _closeControl = closeControl;
    //显示或隐藏相关控件
    for (UIView *view in self.controlContainerArray) {
        view.hidden = closeControl;
    }
}


///显示或隐藏底部的美颜bar
- (void)setShowBar:(BOOL)showBar {
    _showBar = showBar;
    self.bar.hidden = !showBar;
}

- (void)setRemoteAncher:(RemoteUserInfoModel *)remoteAncher {
    _remoteAncher = remoteAncher;
    if ([[YZCurrentUserModel sharedYZCurrentUserModel].roleType isEqualToString:RoleTypeCommon]) {
        NSString *price = [NSString stringWithFormat:@"每分钟%@撩币", remoteAncher.price];
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:price];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,3)];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(3,2)];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(5,2)];
//        self.anchorPricerLabel.attributedText = str;
        self.anchorPricerLabel.text = price;
        [self.anchorPricerLabel sizeToFit];
        CGFloat width = self.anchorPricerLabel.width + 30;
        [self.anchorPricerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(width));
        }];
    }
   
    
}


#pragma mark - init
- (instancetype)initWithIncomingCall:(RCCallSession *)callSession {
    return [super initWithIncomingCall:callSession];
}

- (instancetype)initWithOutgoingCall:(NSString *)targetId mediaType:(RCCallMediaType)mediaType {
    return [super initWithOutgoingCall:ConversationType_PRIVATE
                              targetId:targetId
                             mediaType:mediaType
                            userIdList:@[ targetId ]];
}

- (instancetype)initWithActiveCall:(RCCallSession *)callSession {
    return [super initWithActiveCall:callSession];
}


#pragma mark - View

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (self.callSession.isMuted) {
//        [self.callSession setMuted:NO];
//    }
    [UserInfoNet getUserInfoFromUserName:self.targetId modelResult:^(RequestState success, id model, NSInteger code, NSString *msg) {
        NSLog(@"%@", model);
        self.remoteAncher = (RemoteUserInfoModel *)model;
    }];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block RCUserInfo *userInfo;
    //判断电话 是呼入还是呼出
    if (self.callSession.callStatus == RCCallDialing) {
        //呼出
        self.callIn = NO;
        userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.callSession.targetId];
        NSLog(@"%@", userInfo);
        if (!userInfo) {
            NSString *name;
            NSString *portrait;
            if (self.videoUser) {
                name = self.videoUser.nickname;
                portrait = self.videoUser.posterUrl;
            }
            
            if (self.callListModel) {
                name = self.callListModel.nickName;
                portrait = self.callListModel.headUrl;
            }
            userInfo = [[RCUserInfo alloc] initWithUserId:self.callSession.targetId name:name portrait:portrait];
        }
        self.remoteUserInfo = userInfo;
        [self.remoteNameLabel setText:userInfo.name];
        [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];
    }
    if (self.callSession.callStatus == RCCallIncoming) {
        //呼入
        self.callIn = YES;
        if (self.remoteAncher) {
            self.remoteUserInfo = [[RCUserInfo alloc] initWithUserId:self.targetId name:self.remoteAncher.nickName portrait:self.remoteAncher.headUrl];
            [self.remoteNameLabel setText:userInfo.name];
            [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];
        } else {
            [UserInfoNet getUserInfoFromUserName:self.targetId modelResult:^(RequestState success, id model, NSInteger code, NSString *msg) {
                self.remoteAncher = (RemoteUserInfoModel *)model;
                self.remoteUserInfo = [[RCUserInfo alloc] initWithUserId:self.targetId name:self.remoteAncher.nickName portrait:self.remoteAncher.headUrl];
                [self.remoteNameLabel setText:self.remoteUserInfo.name];
                [self.remotePortraitView setImageURL:[NSURL URLWithString:self.remoteUserInfo.portraitUri]];
            }];
        } 
       
    }
    
    //验证用户身份
    [self checkoutUserRole];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUserInfoUpdate:)
                                                 name:RCKitDispatchUserInfoUpdateNotification
                                               object:nil];
    //加载手势
    [self loadGesture];
    
    //添加倒计时view 并默认隐藏
    [self addCountDownView];
    
    //加载底部的美颜bar 并默认隐藏
    [self addBottomBar];
    //初始化美颜
    [[FUManager shareManager] setUpFaceunity];
    //注册监听 美颜视频流
    [FUVideoFrameObserverManager registerVideoFrameObserver];
    
    NSLog(@"%@", self.mainVideoView);
    
}

//加载底部的美颜bar,并默认隐藏
- (void)addBottomBar {
    [self.view addSubview:self.bar];
    [self.bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@208);
    }];
    self.bar.hidden = YES;
}

///验证用户的身份类别
- (void)checkoutUserRole {
    [UserInfoNet getUserRole:^(RequestState success, NSDictionary *dict, NSString *msg) {
        if (success) {
            [YZCurrentUserModel sharedYZCurrentUserModel].roleType = dict[@"roleType"];
            [self setupCostUserName];
        }
    }];
}

- (void)setupCostUserName {
    NSString *roleType = [YZCurrentUserModel sharedYZCurrentUserModel].roleType;
    //普通用户
    if ([roleType isEqualToString:RoleTypeCommon]) {
        NSLog(@"%@", self.targetId);
        self.netHotUserName = self.targetId;
        self.costUserName = self.callSession.myProfile.userId;
    }
    //大V
    if ([roleType isEqualToString:RoleTypeBigV]) {
       
        self.costUserName = self.targetId;
        self.netHotUserName = self.callSession.myProfile.userId;
    }
    
    NSLog(@"costUserName is %@", self.costUserName);
    NSLog(@"netHotUserName is %@", self.netHotUserName);
}

#pragma mark - 倒计时view的回调
//充值回调
- (void)payAction {
    PayWebViewController *payWebViewController = [[PayWebViewController alloc] init];
    [self.navigationController pushViewController:payWebViewController animated:YES];
}

///倒计时结束
- (void)countDownEnd {
    [self hangupButton];
}


- (void)countDownSeconds:(NSInteger)second {
    
    if (second <= 3) {
        
        if (self.checkPayMoneyTimer) {
            return;
        }
        self.checkPayMoneyTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_source_set_timer(self.checkPayMoneyTimer, DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.checkPayMoneyTimer, ^{
            [self checkIsPayMoney];
        });
        dispatch_resume(self.checkPayMoneyTimer);
    }
}

#pragma mark - 通话能力相关方法

//检查是否已充值
- (void)checkIsPayMoney {
    
    NSString *userName = self.targetId;
    NSString *costUserName = self.callSession.myProfile.userId;
    
    [UserInfoNet perMinuteDedectionUserName:userName costUserName:costUserName pid:self.pid result:^(RequestState success, id model, NSInteger code, NSString *msg) {
       
        if (success) {
            UserCallPowerModel *canCall = (UserCallPowerModel *)model;
            self.pid = canCall.pid;
            long seconds = [canCall.seconds longLongValue];
            if (seconds >= 60*2) {
                dispatch_cancel(self.checkMoneyTimer);
                self.countDownView.hidden = YES;
                [self.countDownView reset];
            }
        }
    }];
}

//检查撩币
- (void)checkMoney {
    
    long start = [[NSDate date] timeIntervalSince1970];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.checkMoneyTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        //没分钟执行一次检查撩币（60秒）
        dispatch_source_set_timer(self.checkMoneyTimer, DISPATCH_TIME_NOW, DEDUCT_MONEY_INTERVAL_TIME * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        
        dispatch_source_set_event_handler(self.checkMoneyTimer, ^{
            long end = [[NSDate date] timeIntervalSince1970];
            NSLog(@"\n\n\n执行扣费间隔：%ld", end - start);
            //正在通话时 执行扣费逻辑
            if (self.callSession.callStatus == RCCallActive) {
                [self deductionCallMoney];
            }
            //已经挂断时，取消定时器
            if (self.callSession.callStatus == RCCallHangup) {
                dispatch_cancel(self.checkMoneyTimer);
            }
            
        });
        dispatch_resume(self.checkMoneyTimer);
    });
}

///判断是否可以继续通话
- (void)isContinueCanVideoCall:(UserCallPowerModel *)canCall {
    
     long seconds = [canCall.seconds longLongValue];
    
    //剩余三分钟时 开始准备倒计时
    if (seconds <= 60 * 3) {
        if (!self.isDidPrepareCountDown) {
            //准备显示倒计时
            [self prepareShowCountDownView:seconds];
        }
       
        if (seconds <= 0) {
            //通话结束
            [self hangupButtonClicked];
            self.countDownView.hidden = YES;
            [self.countDownView reset];
        }
    } else {
        if (!self.countDownView.isHidden) {
            self.countDownView.hidden = YES;
            [self.countDownView reset];
        }
        self.didPrepareCountDown = NO;
        if (self.prepareShowCountDownTimer) {
            dispatch_cancel(self.prepareShowCountDownTimer);
        }
    
    }
}

///保存通话
- (void)saveCall:(RCCallDisconnectReason)reason {
    NSString *userName;
    NSString *userID;
    
    //只保存普通用户的通话列表
    if ( ![[YZCurrentUserModel sharedYZCurrentUserModel].roleType isEqualToString:RoleTypeCommon]) {
        return;
    }

    userName = self.targetId;
    if (self.videoUser) {
        userID = self.videoUser.ID;
    }
    if (self.callListModel) {
        userID = self.callListModel.userId;
    }

    if (userID.length < 1
        &&
        userName.length < 1) {
        return;
    }
    
    SelfCallEndState callEndState = getSelfCallState(self.callSession.disconnectReason);
    NSString *callTime = [self getCallTime];
    NSString *callID = self.callSession.callId;
    callID = [callID stringByAppendingString:[NSString stringWithFormat:@"|%.0lf", [[NSDate date] timeIntervalSince1970]]];
    
    [UserInfoNet saveCallAnchorAccount:userName anchorId:userID callId:callID callTime:callTime callType:callEndState remark:@"一对一视频" complete:^(RequestState success, NSString *msg) {
        
        if (success) {
            NSLog(@"保存通话成功");
        }
        
    }];
}

///每分钟扣除通话费用
- (void)deductionCallMoney {

    if ([self isAppleCheck]) return;
    
    NSLog(@"准备执行扣费");

    NSString *userName = self.targetId;
    NSString *costUserName = self.callSession.myProfile.userId;
    NSString *pid = self.pid;
    NSLog(@"%@", pid);
    
    [UserInfoNet perMinuteDedectionUserName:userName costUserName:costUserName pid:self.pid result:^(RequestState success, id model, NSInteger code, NSString *msg) {
        NSLog(@"userName is %@", userName);
        NSLog(@"costUserName is %@", costUserName);
        if (success) {
            UserCallPowerModel *canCall = (UserCallPowerModel *)model;
            self.pid = canCall.pid;
            NSLog(@"执行扣费成功");
            if ([[YZCurrentUserModel sharedYZCurrentUserModel].roleType isEqualToString:RoleTypeCommon]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self isContinueCanVideoCall:canCall];
                });
            }
        }
    }];
}

///最终扣费
- (void)finalDeductMoney {
    
    if ([self isAppleCheck]) return;
    
    NSString *userName;//网红的
    NSString *costUserName;//扣费的

    NSString  *roleType = [YZCurrentUserModel sharedYZCurrentUserModel].roleType;
    
     //普通用户
    if ([roleType isEqualToString:RoleTypeCommon]) {
        
        userName = self.targetId;
        costUserName = self.callSession.myProfile.userId;
    } else if ([roleType isEqualToString:RoleTypeBigV]) {
        //大v
        userName = self.callSession.myProfile.userId;
        costUserName = self.targetId;
    }
    
    long callTime = [[self getCallTime] longLongValue];
    if (callTime <= 5) {
        
    } else {
        [UserInfoNet finalDeductMoneyCallTime:[self getCallTime] callID:self.callSession.callId costUserName:costUserName userName:userName pid:self.pid result:^(RequestState success, NSDictionary *dict, NSString *msg) {
            if (success) {
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                mutableDict[@"time"] = [RCCallKitUtility getReadableStringForTime:[[self getCallTime] longLongValue]];
                PostNotificationNameUserInfo(SetMoneySuccess, mutableDict);
            }
        }];
    }
    
}

///获取本次通话的费用
- (void)getCurrentCallFee {
    
    if ([self isAppleCheck]) return;
    if (![[YZCurrentUserModel sharedYZCurrentUserModel].roleType isEqualToString:RoleTypeCommon]) {
        return;
    }
    [UserInfoNet getCallFeeFromUserName:self.targetId pid:self.pid dictResult:^(RequestState success, NSDictionary *dict, NSString *msg) {
        NSLog(@"%@", dict);
        if (success) {
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            mutableDict[@"time"] = [RCCallKitUtility getReadableStringForTime:[[self getCallTime] longLongValue]];
            PostNotificationNameUserInfo(SetMoneySuccess, mutableDict);
        }
    }];
}

///是否是苹果审核员
- (BOOL)isAppleCheck {
    if ([[YZCurrentUserModel sharedYZCurrentUserModel].username isEqualToString:@"13988888888"]) {
        return YES;
    }
    return NO;
}


- (void)paySuccess {
    [self.countDownView removeFromSuperview];
}

#pragma mark - FUAPIDemoBarDelegate
- (void)demoBarDidSelectedItem:(NSString *)item {
    [[FUManager shareManager] loadItem:item];
}

- (void)demoBarDidSelectedFilter:(NSString *)filter {
    
    [FUManager shareManager].selectedFilter = filter ;
}

- (void)demoBarBeautyParamChanged {
    
    [self syncBeautyParams];
}

- (void)syncBeautyParams {
    
    [FUManager shareManager].selectedBlur = self.bar.selectedBlur;
    [FUManager shareManager].redLevel = self.bar.redLevel ;
    [FUManager shareManager].faceShapeLevel = self.bar.faceShapeLevel ;
    [FUManager shareManager].faceShape = self.bar.faceShape ;
    [FUManager shareManager].beautyLevel = self.bar.beautyLevel ;
    [FUManager shareManager].thinningLevel = self.bar.thinningLevel ;
    [FUManager shareManager].enlargingLevel = self.bar.enlargingLevel ;
    [FUManager shareManager].selectedFilter = self.bar.selectedFilter ;
}


#pragma mark - 倒计时view
//准备显示倒计时view
- (void)prepareShowCountDownView:(long)seconds {
    self.didPrepareCountDown = YES;
    __block long residueSeconds = seconds;
    self.prepareShowCountDownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.prepareShowCountDownTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.prepareShowCountDownTimer, ^{
        if (residueSeconds <= 60*2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //添加倒计时view
//                [self addCountDownView];
                self.countDownView.hidden = NO;
                [self.countDownView startCountDowun];
                dispatch_cancel(self.prepareShowCountDownTimer);
            });
        }
        residueSeconds--;
    });
    dispatch_resume(self.prepareShowCountDownTimer);
    
}

///添加倒计时view
- (void)addCountDownView {
    [self.mainVideoView addSubview:self.countDownView];
    [self.countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainVideoView).offset(20);
        make.top.equalTo(self.remoteNameLabel).offset(30);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
    }];
    self.countDownView.hidden = YES;
//    [self.countDownView startCountDowun];
}


#pragma mark - 手势相关
///添加手势
- (void)loadGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [self.mainVideoView addGestureRecognizer:tap];
    
}

- (void)tapClick:(UITapGestureRecognizer *)recognizer {
    if (self.isShowBar) {
        self.showBar = NO;
        self.closeControl = YES;
    } else {
        self.closeControl = !self.isCloseControl;
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

#pragma mark - 控件点击方法
//静音按钮
- (void)didTapMuteButton {
    //隐藏相关控件
    self.closeControl = YES;
    //显示底部的美颜bar
    self.showBar = YES;
}

//点击切换前后摄像头
- (void)didTapCameraSwitchButton {
    [[FUManager shareManager] onCameraChange];
}

///更新主播的状态
- (void)updataAnchorStatus:(NSString *)status {
    //更新主播的状态
    if ([[YZCurrentUserModel sharedYZCurrentUserModel].roleType isEqualToString:RoleTypeBigV]) {
        [UserInfoNet updateUserStatus:status];
    }
}


#pragma mark - 回调方法
///通话已连接
- (void)callDidConnect {
    [super callDidConnect];
    self.callConnect = YES;
     [self checkMoney];
    [self updataAnchorStatus:Update_User_Status_TALKING];
}

- (void)callDidDisconnect {
    [super callDidDisconnect];
    RCCallDisconnectReason reason = self.callSession.disconnectReason;
    if (self.checkMoneyTimer) dispatch_cancel(self.checkMoneyTimer);
    if (self.checkPayMoneyTimer) dispatch_cancel(self.checkPayMoneyTimer);
    
    [self updataAnchorStatus:Update_User_Status_ONLINE];
    
    //保存通话
    [self saveCall:reason];
    
    //如果电话接通过 则执行扣费
    if (self.isCallConnect) {
        //最终扣费
//        [self finalDeductMoney];
        [self getCurrentCallFee];
        //如果是普通用户则发通知
        if ([[YZCurrentUserModel sharedYZCurrentUserModel].roleType isEqualToString:RoleTypeCommon]) {
            NSString *anchorName = self.targetId;
            NSString *callId = [self getCurrentCallID];
            NSDictionary *dict = @{
                                   @"anchorName":anchorName,
                                   @"callId":callId
                                   };
            if ([self isAppleCheck]) return;
            PostNotificationNameUserInfo(VideoCallEnd, dict);
        }
    } else {
        /*
         如果 上一个控制器是视频播放控制器 则发出通知 以便让暂停的视频 继续播放
         */
        if ([[self getWindowTopViewController] isKindOfClass:NSClassFromString(@"VideoPlayViewController")]) {
            PostNotificationNameUserInfo(VideoCallEnd, nil);
        }
    }
     
    
    
    
   
    
}


/**
 返回当前UIApplicationDelegate中的window下的最上层控制器
 融云一对一视频内部维护了一个 Window，

 @return UIViewController
 */
- (UIViewController *)getWindowTopViewController {
    
    if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        if ([tabBarController.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
            UIViewController *vc = [navigationController.viewControllers lastObject];
            return vc;
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}

- (RCloudImageView *)remotePortraitView {
    if (!_remotePortraitView) {
        _remotePortraitView = [[RCloudImageView alloc] init];

        [self.view addSubview:_remotePortraitView];
        _remotePortraitView.hidden = YES;
        [_remotePortraitView setPlaceholderImage:[RCCallKitUtility getDefaultPortraitImage]];
        _remotePortraitView.layer.cornerRadius = 4;
        _remotePortraitView.layer.masksToBounds = YES;
    }
    return _remotePortraitView;
}

- (UILabel *)remoteNameLabel {
    if (!_remoteNameLabel) {
        _remoteNameLabel = [[UILabel alloc] init];
        _remoteNameLabel.backgroundColor = [UIColor clearColor];
        _remoteNameLabel.textColor = RGBColor(0X4e4e4e);
        _remoteNameLabel.font = [UIFont boldSystemFontOfSize:20];
        _remoteNameLabel.textAlignment = NSTextAlignmentCenter;

        [self.view addSubview:_remoteNameLabel];
        _remoteNameLabel.hidden = YES;
    }
    return _remoteNameLabel;
}

- (UIImageView *)statusView {
    if (!_statusView) {
        _statusView = [[RCloudImageView alloc] init];
        [self.view addSubview:_statusView];
        _statusView.hidden = YES;
        _statusView.image = [RCCallKitUtility imageFromVoIPBundle:@"voip/voip_connecting"];
    }
    return _statusView;
}

- (UIView *)mainVideoView {
    if (!_mainVideoView) {
        _mainVideoView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        _mainVideoView.backgroundColor = RongVoIPUIColorFromRGB(0x262e42);

        [self.backgroundView addSubview:_mainVideoView];
        _mainVideoView.hidden = YES;
    }
    return _mainVideoView;
}

- (UIView *)subVideoView {
    if (!_subVideoView) {
        _subVideoView = [[UIView alloc] init];
        _subVideoView.backgroundColor = [UIColor blackColor];
        _subVideoView.layer.borderWidth = 1;
        _subVideoView.layer.borderColor = [[UIColor whiteColor] CGColor];

        [self.view addSubview:_subVideoView];
        _subVideoView.hidden = YES;

        UITapGestureRecognizer *tap =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subVideoViewClicked)];
        [_subVideoView addGestureRecognizer:tap];
    }
    return _subVideoView;
}

- (void)subVideoViewClicked {
    if ([self.remoteUserInfo.userId isEqualToString:self.callSession.targetId]) {
        RCUserInfo *userInfo = [RCIMClient sharedRCIMClient].currentUserInfo;

        self.remoteUserInfo = userInfo;
        [self.remoteNameLabel setText:userInfo.name];
        [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];

        [self.callSession setVideoView:self.mainVideoView userId:self.remoteUserInfo.userId];
        [self.callSession setVideoView:self.subVideoView userId:self.callSession.targetId];
    } else {
        RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.callSession.targetId];
        if (!userInfo) {
            userInfo = [[RCUserInfo alloc] initWithUserId:self.callSession.targetId name:nil portrait:nil];
        }
        self.remoteUserInfo = userInfo;
        [self.remoteNameLabel setText:userInfo.name];
        [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];

        [self.callSession setVideoView:self.subVideoView userId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
        [self.callSession setVideoView:self.mainVideoView userId:self.remoteUserInfo.userId];
    }
}

- (void)resetLayout:(BOOL)isMultiCall mediaType:(RCCallMediaType)mediaType callStatus:(RCCallStatus)callStatus {
    [super resetLayout:isMultiCall mediaType:mediaType callStatus:callStatus];

    UIImage *remoteHeaderImage = self.remotePortraitView.image;

    //音频通话
    if (mediaType == RCCallMediaAudio) {
        self.remotePortraitView.frame = CGRectMake((self.view.frame.size.width - RCCallHeaderLength) / 2,
                                                   RCCallVerticalMargin * 3, RCCallHeaderLength, RCCallHeaderLength);
        self.remotePortraitView.image = remoteHeaderImage;
        self.remotePortraitView.hidden = NO;

        self.remoteNameLabel.frame =
            CGRectMake(RCCallHorizontalMargin, RCCallVerticalMargin * 3 + RCCallHeaderLength + RCCallInsideMargin,
                       self.view.frame.size.width - RCCallHorizontalMargin * 2, RCCallLabelHeight);
        self.remoteNameLabel.hidden = NO;

        self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        self.tipsLabel.textAlignment = NSTextAlignmentCenter;

        self.statusView.frame = CGRectMake((self.view.frame.size.width - 17) / 2,
                                           RCCallVerticalMargin * 3 + (RCCallHeaderLength - 4) / 2, 17, 4);

        if (callStatus == RCCallRinging || callStatus == RCCallDialing || callStatus == RCCallIncoming) {
            self.remotePortraitView.alpha = 0.5;
            self.statusView.hidden = NO;
        } else {
            self.statusView.hidden = YES;
            self.remotePortraitView.alpha = 1.0;
        }

        self.mainVideoView.hidden = YES;
        self.subVideoView.hidden = YES;
        [self resetRemoteUserInfoIfNeed];
    } else {
        //视频通话
        if (callStatus == RCCallDialing) {
            //正在呼出
            self.mainVideoView.hidden = NO;
            [self.callSession setVideoView:self.mainVideoView
                                    userId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
            self.blurView.hidden = YES;
            self.anchorPricerLabel.hidden = NO;
            self.mainVideoView.hidden = YES;
            
//            self.backgroundView.backgroundColor = [UIColor blueColor];
        } else if (callStatus == RCCallActive) {
            //正在通话
            self.mainVideoView.hidden = NO;
            self.anchorPricerLabel.hidden = YES;
            [self.callSession setVideoView:self.mainVideoView userId:self.callSession.targetId];
            self.blurView.hidden = YES;
            self.anchorPricerLabel.hidden = YES;
        } else {
            self.mainVideoView.hidden = YES;
        }

        if (callStatus == RCCallActive) {
            self.remotePortraitView.hidden = YES;

            self.remoteNameLabel.frame =
                CGRectMake(RCCallHorizontalMargin, RCCallVerticalMargin,
                           self.view.frame.size.width - RCCallHorizontalMargin * 2, RCCallLabelHeight);
            self.remoteNameLabel.hidden = NO;
            self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        } else if (callStatus == RCCallDialing) {
            self.remotePortraitView.frame =
                CGRectMake((self.view.frame.size.width - RCCallHeaderLength) / 2, RCCallVerticalMargin * 3,
                           RCCallHeaderLength, RCCallHeaderLength);
            self.remotePortraitView.image = remoteHeaderImage;
            self.remotePortraitView.hidden = NO;

            self.remoteNameLabel.frame =
                CGRectMake(RCCallHorizontalMargin, RCCallVerticalMargin * 3 + RCCallHeaderLength + RCCallInsideMargin,
                           self.view.frame.size.width - RCCallHorizontalMargin * 2, RCCallLabelHeight);
            self.remoteNameLabel.hidden = NO;
            self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        } else if (callStatus == RCCallIncoming || callStatus == RCCallRinging) {
            self.remotePortraitView.frame =
                CGRectMake((self.view.frame.size.width - RCCallHeaderLength) / 2, RCCallVerticalMargin * 3,
                           RCCallHeaderLength, RCCallHeaderLength);
            self.remotePortraitView.image = remoteHeaderImage;
            self.remotePortraitView.hidden = NO;

            self.remoteNameLabel.frame =
                CGRectMake(RCCallHorizontalMargin, RCCallVerticalMargin * 3 + RCCallHeaderLength + RCCallInsideMargin,
                           self.view.frame.size.width - RCCallHorizontalMargin * 2, RCCallLabelHeight);
            self.remoteNameLabel.hidden = NO;
            self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        }

        if (callStatus == RCCallActive) {
            if ([RCCallKitUtility isLandscape] && [self isSupportOrientation:(UIInterfaceOrientation)[UIDevice currentDevice].orientation]) {
                self.subVideoView.frame =
                    CGRectMake(self.view.frame.size.width - RCCallHeaderLength - RCCallHorizontalMargin / 2,
                               RCCallVerticalMargin, RCCallHeaderLength * 1.5, RCCallHeaderLength);
            } else {
                self.subVideoView.frame =
                    CGRectMake(self.view.frame.size.width - RCCallHeaderLength - RCCallHorizontalMargin / 2,
                               RCCallVerticalMargin, RCCallHeaderLength, RCCallHeaderLength * 1.5);
            }
            [self.callSession setVideoView:self.subVideoView
                                    userId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
            self.subVideoView.hidden = NO;
        } else {
            self.subVideoView.hidden = YES;
        }

        self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        self.statusView.frame = CGRectMake((self.view.frame.size.width - 17) / 2,
                                           RCCallVerticalMargin * 3 + (RCCallHeaderLength - 4) / 2, 17, 4);

        if (callStatus == RCCallRinging || callStatus == RCCallDialing || callStatus == RCCallIncoming) {
            self.remotePortraitView.alpha = 0.5;
            self.statusView.hidden = NO;
        } else {
            self.statusView.hidden = YES;
            self.remotePortraitView.alpha = 1.0;
        }
    }
    
    //将最小化按钮移除 暂时用不到此按钮
    self.minimizeButton.hidden = YES;
}

- (void)resetRemoteUserInfoIfNeed {
    if (![self.remoteUserInfo.userId isEqualToString:self.callSession.targetId]) {
        RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.callSession.targetId];
        if (!userInfo) {
            userInfo = [[RCUserInfo alloc] initWithUserId:self.callSession.targetId name:nil portrait:nil];
        }
        self.remoteUserInfo = userInfo;
        [self.remoteNameLabel setText:userInfo.name];
        [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];
    }
}

- (BOOL)isSupportOrientation:(UIInterfaceOrientation)orientation {
    return [[UIApplication sharedApplication]
               supportedInterfaceOrientationsForWindow:[UIApplication sharedApplication].keyWindow] &
           (1 << orientation);
}

#pragma mark - UserInfo Update
- (void)onUserInfoUpdate:(NSNotification *)notification {
    NSDictionary *userInfoDic = notification.object;
    NSString *updateUserId = userInfoDic[@"userId"];
    RCUserInfo *updateUserInfo = userInfoDic[@"userInfo"];

    if ([updateUserId isEqualToString:self.remoteUserInfo.userId]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.remoteUserInfo = updateUserInfo;
            [weakSelf.remoteNameLabel setText:updateUserInfo.name];
            [weakSelf.remotePortraitView setImageURL:[NSURL URLWithString:updateUserInfo.portraitUri]];
        });
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[FUManager shareManager] destoryFaceunityItems];
}

@end
