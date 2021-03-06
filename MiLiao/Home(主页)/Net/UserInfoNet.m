//
//  UserInfoNet.m
//  MiLiao
//
//  Created by King on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "UserInfoNet.h"

#import "UserCallPowerModel.h"

/////////API
///获取用户信息的api
static NSString *GetUserInfo = @"/v1/user/getUserInfo";

static NSString *CanCallEnoughAPI = @"/v1/cost/enoughCall";

//每分钟扣费
static NSString *EveryMinuAPI = @"/v1/cost/minuteCost";

///分钟扣费 最新
static NSString *PerMinuDedetion_LastNew = @"/v1/cost/costCoins";
///保存通话记录
static NSString *SaveCall = @"/v1/call/saveUserCall";

///获取用户身份类别
static NSString *GetUserRoleType = @"/v1/user/getUserRole";

///获取评价标签
static NSString *GetEvaluate = @"/v1/dict/getTags";
///最终扣费
static NSString *FinalDeduct = @"/v1/cost/overCost";

///获取本次通话费用
static NSString *GetCallFee = @"/v1/cost/getCallFee";

///评价标签模型
static NSString *EvaluateTagModel = @"EvaluateTagModel";

///保存对大V的评价
static NSString *SaveEvaluate = @"/v1/bigV/saveBigVEvaluation";


static NSString *GetAnchorInfoByMobile = @"/v1/user/getAnchorInfoByMobile";

///更新主播状态
static NSString *UpdataUserStatus = @"/v1/user/updateStatus";

/////////类名

///通话能力模型
static NSString *UserCallPowerModelClass = @"UserCallPowerModel";

///网红(主播)模型
static NSString *RemoteUserInfoModelClassString = @"RemoteUserInfoModel";

#pragma mark - 获取当前用户的token
///获取当前用户的token
NSString *tokenForCurrentUser() {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"token"];
}

#pragma mark - 返回当前要保存到后台的通话状态
///返回当前要保存到后台的通话状态
/*callState 由融云返回，具体字段请参考RongCallLib/RCCallSession.h下的disconnectReason属性
 */
SelfCallEndState getSelfCallState(NSInteger callState) {
    switch (callState) {
        case 0:
            return 100;
        case 1:
            return SelfCallEndStateCancle;
        case 2:
            return SelfCallEndStateCancle;
        case 3:
            return SelfCallEndStateComplete;
        case 4:
            return SelfCallEndStateUnusual;
        case 5:
            return SelfCallEndStateNoAnswer;
        case 6:
//            return SelfCallEndStateUnusual;
        case 7:
            return SelfCallEndStateUnusual;
//        case 8:
//            return
//        case 9:
//            return
//        case 10:
//            return
        case 11:
            return SelfCallEndStateRemoteCancle;
        case 12:
            return SelfCallEndStateUnusual;
        case 13:
            return SelfCallEndStateComplete;
        case 14:
            return SelfCallEndStateRemoteBusy;
        case 15:
            return SelfCallEndStateRemoteNoAnswer;
        case 16:
            return SelfCallEndStateUnusual;
//        case 17:
//            return
//        case 18:
//            return
        
        default:
            return SelfCallEndStateUnusual;
    }
}

@implementation UserInfoNet

#pragma mark -  获取用户的撩币
/**
 获取用户的撩币
 
 @param balance 撩币
 */
+ (void)getUserBalance:(void(^)(CGFloat balance))balance {
    
    NSString *token = tokenForCurrentUser();
    NSString *userName = [YZCurrentUserModel sharedYZCurrentUserModel].username;
    
    NSDictionary *parameter = @{@"token":token,
                                @"userName":userName
                                };
    
    [self Get:GetUserInfo parameters:parameter result:^(RequestState success, NSDictionary *dict, NSString *errMsg) {
        if (success) {
            !balance?:balance([dict[@"balance"] floatValue]);
        }
    }];
}

#pragma mark - 判定余额足够消费
///判定余额足够消费
+ (void)canCall:(NSString *)userName result:(RequestModelResult)result {
    
    NSDictionary *parameters = @{@"token":tokenForCurrentUser(),
                                 @"userName":userName
                                 };
    [self Get:CanCallEnoughAPI parameters:parameters modelClass:NSClassFromString(UserCallPowerModelClass) modelResult:result];
}

///判定余额足够消费
+ (void)canCall:(NSString *)userName powerEnough:(void(^)(RequestState success, NSString *msg, MoneyEnoughType enoughType))powerEnough {
    [self canCall:userName result:^(RequestState success, id model, NSInteger code, NSString *msg) {
        UserCallPowerModel *callPower = (UserCallPowerModel *)model;
        MoneyEnoughType enoughType = MoneyEnoughTypeEmpty;
        long seconds = [callPower.seconds longLongValue];
        if (seconds >= 5*60) {
            enoughType = MoneyEnoughTypeEnough;
        } else if (seconds >60) {
            enoughType = MoneyEnoughTypeNotEnough;
        } else {
            enoughType = MoneyEnoughTypeEmpty;
        }
        !powerEnough?:powerEnough(success, msg, enoughType);
    }];
}

#pragma mark - 分钟扣费 - 最新 2月3号
/**
 最新分钟扣费
 
 @param userName 扣费的手机号
 @param anchor 主播的手机号
 @param consumeId 第一次访问设为0，以后从返回的参数里获取
 @param rechargeId 一次访问设为0，以后从我返回的参数里获取
 @param result 返回
 */
+ (void)perMinuteDedectionUserName:(NSString *)userName anchorPhoneNum:(NSString *)anchor consumeId:(NSString *)consumeId rechargeId:(NSString *)rechargeId result:(RequestModelResult)result {
    if (consumeId == nil || consumeId.length <1) {
        consumeId = @"0";
    }
    if (rechargeId == nil || rechargeId.length < 1) {
        rechargeId = @"0";
    }
    NSDictionary *parameters = @{
                                 @"username":userName,
                                 @"token":tokenForCurrentUser(),
                                 @"rechargeId":rechargeId,
                                 @"consumeId":consumeId,
                                 @"anchor":anchor
                                 };
    [self Post:PerMinuDedetion_LastNew parameters:parameters modelClass:NSClassFromString(UserCallPowerModelClass) modelResult:result];
}

#pragma mark - 分钟扣费 - 废弃
/**
 分钟扣费
 
 @param userName 发起通话的用户名
 @param costUserName 大V的用户名
 @param pid pid
 @param result 返回
 */
+ (void)perMinuteDedectionUserName:(NSString *)userName costUserName:(NSString *)costUserName pid:(NSString *)pid result:(RequestModelResult)result {
   
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"costUserName"] = costUserName;
    parameter[@"token"] = tokenForCurrentUser();
    parameter[@"userName"] = userName;
    NSLog(@"传入的pid：%@", pid);
    if (pid || pid.length >=1) {
         parameter[@"pid"] = pid;
    } else {
        parameter[@"pid"] = @"0";
    }
    NSLog(@"\n\n\n执行扣费接口的pid:%@", pid);
    
    [self Post:EveryMinuAPI parameters:parameter modelClass:NSClassFromString(UserCallPowerModelClass) modelResult:result];
    
}

#pragma mark - 保存通话记录
///保存通话记录
+ (void)saveCallAnchorAccount:(NSString *)anchorAccount anchorId:(NSString *)anchorId callId:(NSString *)callId callTime:(NSString *)callTime callType:(NSInteger)callType remark:(NSString *)remark complete:(CompleteBlock)complete {
    YZCurrentUserModel *user = [YZCurrentUserModel sharedYZCurrentUserModel];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"anchorAccount"] = anchorAccount;
    parameter[@"callId"] = callId;
    parameter[@"callTime"] = callTime;
    parameter[@"callType"] = @(callType);
    parameter[@"remark"] = remark;
    parameter[@"token"] = tokenForCurrentUser();
    parameter[@"userAccount"] = user.username;
    parameter[@"userId"] = user.user_id;
    if (anchorId) {
        parameter[@"anchorId"] = anchorId;
    }
    
    [self Post:SaveCall parameters:parameter complete:complete];
    
}


#pragma mark - 视频通话的最终扣费 废弃
/**
 视频通话的最终扣费 废弃
 
 @param callTime 通话时间
 @param costUserName 对端用户名
 @param pid pid
 @param result 返回的结果
 */
+ (void)finalDeductMoneyCallTime:(NSString *)callTime callID:(NSString *)callId costUserName:(NSString *)costUserName userName:(NSString *)userName pid:(NSString *)pid result:(void(^)(RequestState success, NSDictionary *dict, NSString *msg))result {
    
    NSDictionary *parameters = @{
                                 @"callTime":callTime,
                                 @"callId":callId,
                                 @"costUserName":costUserName,
                                 @"pid":pid,
                                 @"token":tokenForCurrentUser(),
                                 @"userName":userName
                                 };
    [self Post:FinalDeduct parameters:parameters dictResult:result];
   
}

#pragma mark - 本次通话费用
///获取本次通话费用
+ (void)getCallFeeFromUserName:(NSString *)userName pid:(NSString *)pid dictResult:(RequestDictResult)dictResult {
    
    if (!pid || pid.length < 1) {
        pid = @"0";
    }
    NSDictionary *parameters = @{@"costUserName":[YZCurrentUserModel sharedYZCurrentUserModel].username,
                                 @"pid":pid,
                                 @"token":tokenForCurrentUser(),
                                 @"userName":userName
                                 };
    [self Post:GetCallFee parameters:parameters dictResult:dictResult];
}

#pragma mark - 获取评价标签
///获取评价标签
+ (void)getEvaluate:(RequestResult)result {
    [self Get:GetEvaluate parameters:@{@"token":tokenForCurrentUser(),
                                       @"type":@"BIGV"
                                       } modelClass:NSClassFromString(EvaluateTagModel) result:result];
}

+ (void)getUserType:(NSString *)userType evaluateResult:(RequestResult)result {
    [self Get:GetEvaluate parameters:@{@"token":tokenForCurrentUser(),
                                       @"type":userType
                                       } modelClass:NSClassFromString(EvaluateTagModel) result:result];
}


#pragma mark - 保存对大V的评价
/**
 保存对大V的评价
 
 @param anchorName 大V的用户名
 @param callId 通话id
 @param score 评级 星星的个数
 @param tags 标签id数组
 @param complete 完成
 */
+ (void)saveEvaluateAnchorName:(NSString *)anchorName callId:(NSString *)callId score:(NSString *)score tags:(NSArray *)tags complete:(CompleteBlock)complete {
    NSDictionary *parameters = @{
                                 @"anchorName":anchorName,
                                 @"callId":callId,
                                 @"score":score,
                                 @"tags":tags,
                                 @"token":tokenForCurrentUser(),
                                 @"userName":[YZCurrentUserModel sharedYZCurrentUserModel].username
                                 };
    [self Post:SaveEvaluate parameters:parameters complete:complete];
}

#pragma mark - 获取用户角色
/**
 获取用户角色
 */
+ (void)getUserRole:(void(^)(RequestState success, NSDictionary *dict, NSString *msg))complete {
    NSDictionary *parameter = @{
                                @"username":[YZCurrentUserModel sharedYZCurrentUserModel].username,
                                @"token":tokenForCurrentUser()
                                };
    NSString *userName = [YZCurrentUserModel sharedYZCurrentUserModel].username;
    NSString *token = tokenForCurrentUser();
    NSString *api = [GetUserRoleType stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", userName, token]];
    [self Get:api parameters:nil result:complete];
}


#pragma mark -  获取指定手机号的主播(网红)模型
/**
 获取指定手机号的主播(网红)模型
 
 @param mobile 手机号
 @param modelResult 模型
 */
+ (void)getAncherInfoByMobile:(NSString *)mobile modelResult:(RequestModelResult)modelResult {
    NSDictionary *parameters = @{@"mobile":mobile,@"token":tokenForCurrentUser()};
    [self Get:GetAnchorInfoByMobile parameters:parameters modelClass:NSClassFromString(RemoteUserInfoModelClassString) modelResult:modelResult];
}

#pragma mark - 获取用户信息
/**
 获取给定手机号的用户信息
 
 @param userId 手机号
 @param modelResult 用户模型
 */
+ (void)getUserInfoFromUserName:(NSString *)userId modelResult:(RequestModelResult)modelResult {
    NSDictionary *parameters = @{@"userId":userId,
                                 @"token":tokenForCurrentUser()
                                 };
    [self Get:GetUserInfo parameters:parameters modelClass:NSClassFromString(RemoteUserInfoModelClassString) modelResult:modelResult];
    
}

#pragma mark - 更新主播的状态
/**
 更新主播的状态
 
 @param status status
 */
+ (void)updateUserStatus:(NSString *)status {
    [self Post:UpdataUserStatus parameters:@{@"status":status,
                                             @"token":tokenForCurrentUser()
                                             } complete:^(RequestState success, NSString *msg) {
        
    }];
}

@end
