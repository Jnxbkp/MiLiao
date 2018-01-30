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


@interface RCCallSingleCallViewController ()<FUAPIDemoBarDelegate, UIGestureRecognizerDelegate, CountDownViewDelegate>

@property(nonatomic, strong) RCUserInfo *remoteUserInfo;

///是否关闭相关控件
@property (nonatomic, assign, getter=isCloseControl) BOOL closeControl;
///是否展示底部的bar
@property (nonatomic, assign, getter=isShowBar) BOOL showBar;

@property (nonatomic, strong) FUAPIDemoBar *bar;
///控件容器数组
@property (nonatomic, strong) NSArray *controlContainerArray;
///检查M币的定时器
@property (nonatomic, strong) dispatch_source_t checkMoneyTimer;

///准备倒计时的倒计时
@property (nonatomic, strong) dispatch_source_t prepareShowCountDownTimer;

///倒计时view
@property (nonatomic, strong) CountDownView *countDownView;

///是呼入还是呼出的电话 yes - 呼入 no - 呼出
@property (nonatomic, assign, getter=isCallIn) BOOL callIn;
///用于每分钟扣费的参数
@property (nonatomic, strong) NSString *pid;

///电话是否接通过
@property (nonatomic, assign, getter=isCallConnect) BOOL callConnect;



@end



///分钟计费的时间间隔
static CGFloat DEDUCT_MONEY_INTERVAL_TIME = 10;

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


// init
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
- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"通话目标:%@", self.targetId);
    NSLog(@"当前用户:%@", self.callSession.myProfile.userId);
    
    //判断电话 是呼入还是呼出
    if (self.callSession.callStatus == RCCallDialing) {
        self.callIn = NO;
    }
    if (self.callSession.callStatus == RCCallIncoming) {
        self.callIn = YES;
    }
    
    //验证用户身份
    [self checkoutUserRole];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUserInfoUpdate:)
                                                 name:RCKitDispatchUserInfoUpdateNotification
                                               object:nil];

    RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.callSession.targetId];
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
    
    //加载手势
    [self loadGesture];
    
    //加载底部的美颜bar 并默认隐藏
    [self addBottomBar];
    //初始化美颜
    [[FUManager shareManager] setUpFaceunity];
    //注册监听 美颜视频流
    [FUVideoFrameObserverManager registerVideoFrameObserver];
    
    
    
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


#warning roleType
- (void)setupCostUserName {
    NSString *roleType = [YZCurrentUserModel sharedYZCurrentUserModel].roleType;
    //普通用户
    if ([roleType isEqualToString:RoleTypeCommon]) {
        NSLog(@"%@", self.targetId);
        if (self.isCallIn) {
             //打进来的电话 网红的回拨
            self.netHotUserName = self.callSession.caller;
            
        } else {
            //打出的电话
            self.netHotUserName = self.targetId;
        }
        self.costUserName = self.callSession.myProfile.userId;
    }
    //大V
    if ([roleType isEqualToString:RoleTypeBigV]) {
        if (self.isCallIn) {
            
        } else {
            
        }
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
    NSLog(@"控制器内倒计时%ld", second);
    if (second <= 5) {
        
        if (second <= 0) {
            [self hangupButton];
        }
    }
}

#pragma mark - 通话能力相关方法
//检查M币
- (void)checkMoney {
    
    long start = [[NSDate date] timeIntervalSince1970];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.checkMoneyTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        //没分钟执行一次检查M币（60秒）
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
    
    //剩余两分钟时 开始倒计时
    if (seconds <= 60 * 3) {
        //准备显示倒计时
        [self prepareShowCountDownView:seconds];
        if (seconds <= 0) {
            //通话结束
            [self hangupButtonClicked];
        }
    } else {
        if (self.prepareShowCountDownTimer) {
            dispatch_cancel(self.prepareShowCountDownTimer);
        }
    }
}

///保存通话
- (void)saveCall:(RCCallDisconnectReason)reason {
    NSString *userName;
    NSString *userID;
    
    if ( ![[YZCurrentUserModel sharedYZCurrentUserModel].roleType isEqualToString:RoleTypeCommon]) {
        return;
    }

    if (self.isCallIn) {
        
        //接听的来电
        userName = [YZCurrentUserModel sharedYZCurrentUserModel].username;
        userID = [YZCurrentUserModel sharedYZCurrentUserModel].user_id;
        
    } else {
        //呼出的
        if (self.videoUser) {
            userName = self.videoUser.username;
            userID = self.videoUser.ID;
        }
        if (self.callListModel) {
            userName = self.callListModel.userAccount;
            userID = self.callListModel.userId;
        }
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
    NSString *userName;//网红的
    NSString *costUserName;//扣费的
//    NSString *isBigV = [YZCurrentUserModel sharedYZCurrentUserModel].isBigv;
    NSString  *roleType = [YZCurrentUserModel sharedYZCurrentUserModel].roleType;
    
    if ([roleType isEqualToString:RoleTypeCommon]) {
        //普通用户
        if (self.callIn) {
            userName = self.callSession.caller;
            costUserName = [YZCurrentUserModel sharedYZCurrentUserModel].username;
        } else {
            costUserName = [YZCurrentUserModel sharedYZCurrentUserModel].username;
            if (self.videoUser) {
                userName = self.videoUser.username;
            }
            if (self.callListModel) {
                userName = self.callListModel.anchorAccount;
            }
            NSLog(@"%@", self.targetId);
        }
    } else if ([roleType isEqualToString:RoleTypeBigV]) {
        //大v
        userName = [YZCurrentUserModel sharedYZCurrentUserModel].username;
        if (self.callIn) {
            costUserName = self.callSession.caller;
        } else {
            if (self.videoUser) {
                costUserName = self.videoUser.username;
            }
            if (self.callListModel) {
                costUserName = self.callListModel.anchorAccount;
            }
        }
    }

    
    [UserInfoNet perMinuteDedectionUserName:userName costUserName:costUserName pid:self.pid result:^(RequestState success, id model, NSInteger code, NSString *msg) {
        if (success) {
            UserCallPowerModel *canCall = (UserCallPowerModel *)model;
            self.pid = canCall.pid;
            NSLog(@"执行扣费成功");
            if (!self.isCallIn) {
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
    
    if ([roleType isEqualToString:RoleTypeCommon]) {
        //普通用户
        if (self.callIn) {
            userName = self.callSession.caller;
            costUserName = [YZCurrentUserModel sharedYZCurrentUserModel].username;
        } else {
            costUserName = [YZCurrentUserModel sharedYZCurrentUserModel].username;
            if (self.videoUser) {
                userName = self.videoUser.username;
            }
            if (self.callListModel) {
                userName = self.callListModel.anchorAccount;
            }
        }
    } else if ([roleType isEqualToString:RoleTypeBigV]) {
        //大v
        userName = [YZCurrentUserModel sharedYZCurrentUserModel].username;
        if (self.callIn) {
            costUserName = self.callSession.caller;
        } else {
            if (self.videoUser) {
                costUserName = self.videoUser.username;
            }
            if (self.callListModel) {
                costUserName = self.callListModel.anchorAccount;
            }
        }
    }
    
    [UserInfoNet finalDeductMoneyCallTime:[self getCallTime] callID:self.callSession.callId costUserName:costUserName userName:userName pid:self.pid result:^(RequestState success, NSDictionary *dict, NSString *msg) {
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
    
    __block long residueSeconds = seconds;
    self.prepareShowCountDownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.prepareShowCountDownTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.prepareShowCountDownTimer, ^{
        if (residueSeconds <= 60*2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //添加倒计时view
                [self addCountDownView];
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
    [self.countDownView startCountDowun];
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


#pragma mark - 回调方法
///通话已连接
- (void)callDidConnect {
    [super callDidConnect];
    self.callConnect = YES;
     [self checkMoney];
}

- (void)callDidDisconnect {
    [super callDidDisconnect];
    RCCallDisconnectReason reason = self.callSession.disconnectReason;
    if (self.checkMoneyTimer) dispatch_cancel(self.checkMoneyTimer);
    //保存通话
    [self saveCall:reason];
    
    //如果电话接通过 则执行扣费
    if (self.isCallConnect) {
        //最终扣费
        [self finalDeductMoney];
        
        //呼出电话发通知
        if (!self.isCallIn) {
            
            NSString *anchorName;
            NSString *callId = self.callSession.callId;
            if (self.videoUser) {
                anchorName = self.videoUser.username;
            }
            
            if (self.callListModel) {
                anchorName = self.callListModel.userAccount;
            }
            NSDictionary *dict = @{
                                   @"anchorName":anchorName,
                                   @"callId":callId
                                   };
            if ([self isAppleCheck]) return;
            PostNotificationNameUserInfo(VideoCallEnd, dict);
        }
        
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
        _remoteNameLabel.textColor = [UIColor whiteColor];
        _remoteNameLabel.font = [UIFont systemFontOfSize:18];
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
        if (callStatus == RCCallDialing) {
            self.mainVideoView.hidden = NO;
            [self.callSession setVideoView:self.mainVideoView
                                    userId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
            self.blurView.hidden = YES;
        } else if (callStatus == RCCallActive) {
            self.mainVideoView.hidden = NO;
            [self.callSession setVideoView:self.mainVideoView userId:self.callSession.targetId];
            self.blurView.hidden = YES;
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
