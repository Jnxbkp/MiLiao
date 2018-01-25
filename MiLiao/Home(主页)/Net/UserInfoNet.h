//
//  UserInfoNet.h
//  MiLiao
//
//  Created by King on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "Networking.h"

//#import <RongCallLib/RCCallSession.h>


typedef NS_ENUM(NSUInteger, MoneyEnoughType) {
    ///不充足
    MoneyEnoughTypeNotEnough,
    ///充足
    MoneyEnoughTypeEnough,
    ///账户余额为0
    MoneyEnoughTypeEmpty
};

///保存到后台的通话状态
typedef NS_ENUM(NSUInteger, SelfCallEndState) {
    ///通话异常结束
    SelfCallEndStateUnusual,
    ///完成
    SelfCallEndStateComplete,
    ///已取消
    SelfCallEndStateCancle,
    ///已拒绝
    SelfCallEndStateReject,
    ///未接听
    SelfCallEndStateNoAnswer,
    ///对方繁忙
    SelfCallEndStateRemoteBusy,
    ///对方取消
    SelfCallEndStateRemoteCancle,
    ///对方拒绝
    SelfCallEndStateRemoteReject,
    ///对方未接听
    SelfCallEndStateRemoteNoAnswer
    
};


//获取当前用户的token
NSString *tokenForCurrentUser(void);

///返回当前要保存到后台的通话状态
SelfCallEndState getSelfCallState(NSInteger callState);

@interface UserInfoNet : Networking


/**
获取用户的M币

 @param balance M币
 */
+ (void)getUserBalance:(void(^)(CGFloat balance))balance;

///判定余额足够消费
+ (void)canCall:(NSString *)userName result:(RequestModelResult)result;



/**
 分钟扣费

 @param userName 发起通话的用户名
 @param costUserName 大V的用户名
 @param pid pid
 @param result 返回
 */
+ (void)perMinuteDedectionUserName:(NSString *)userName costUserName:(NSString *)costUserName pid:(NSString *)pid result:(RequestModelResult)result;


///保存通话记录
+ (void)saveCallAnchorAccount:(NSString *)anchorAccount anchorId:(NSString *)anchorId callId:(NSString *)callId callTime:(NSString *)callTime callType:(NSInteger)callType remark:(NSString *)remark complete:(CompleteBlock)complete;

///获取评价标签
+ (void)getEvaluate:(RequestResult)result;



/**
 视频通话的最终扣费

 @param callTime 通话时间
  @param callId callID
 @param costUserName 对端用户名
 @param pid pid
 @param result 返回的结果
 */
+ (void)finalDeductMoneyCallTime:(NSString *)callTime callID:(NSString *)callId costUserName:(NSString *)costUserName userName:(NSString *)userName pid:(NSString *)pid result:(void(^)(RequestState success, NSDictionary *dict, NSString *msg))result;



/**
 保存对大V的评价

 @param anchorName 大V的用户名
 @param callId 通话id
 @param score 评级 星星的个数
 @param tags 标签id数组
 @param complete 完成
 */
+ (void)saveEvaluateAnchorName:(NSString *)anchorName callId:(NSString *)callId score:(NSString *)score tags:(NSArray *)tags complete:(CompleteBlock)complete;



/**
 获取用户角色

 @param complete <#complete description#>
 */
+ (void)getUserRole:(void(^)(RequestState success, NSDictionary *dict, NSString *msg))complete;
@end
