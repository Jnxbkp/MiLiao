//
//  MainMananger.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/12.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainMananger : NSObject
//推荐
//GET /v1/index/recommand/{pageNumber}/{pageSize}/{token}
//关注
//GET /v1/index/care/{pageNumber}/{pageSize}/{token}
//新人
//GET /v1/index/new/{pageNumber}/{pageSize}/{token}
+ (void)NetGetMainListKind:(NSString *)kind token:(NSString *)token pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//获取主播信息/搜索
//GET /v1/user/getAnchorInfo  获取主播信息    (    *传入userId时查询，nickname参数值无效*
+ (void)NetGetgetAnchorInfoNickName:(NSString *)nickname token:(NSString *)token userid:(NSString *)userid success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//根据用户id获取视频列表
//Get /v1/video/getVideoListById/{pageNumber}/{pageSize}/{token}/{userId}
+ (void)NetGetgetVideoListById:(NSString *)userId token:(NSString *)token pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//关注大VV
//POST POST /v1/bigV/careUser
/*
 McGuanZhuDto {
 bgzaccount (string): 被关注者账号 ,
 gzaccount (string): 关注者账号 ,
 sfgz (string, optional): 是否关注 ,
 token (string): Token
 }
 */
+ (void)NetPostCareBigVToken:(NSString *)token sfgz:(NSString *)sfgz bgzaccount:(NSString *)bgzaccount gzaccount:(NSString *)gzaccount success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//获取大V评价
//GET /v1/bigV/getEvals/{pageNumber}/{pageSize}/{userName}/{token}
+ (void)NetGetBigVgetEvalsUsername:(NSString *)username pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize token:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//获取大V亲密度列表
//Get /v1/bigV/getIntimateList
+ (void)NetGetIntimateListUsername:(NSString *)username success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//关注大V
//POST /v1/bigV/careUser
+ (void)NetPostCareuserBgzaccount:(NSString *)bgzaccount gzaccount:(NSString *)gzaccount sfgz:(NSString *)sfgz token:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//购买微信
//GET /v1/cost/buyWechatInfo
+ (void)NetGetbuyWechatInfoToken:(NSString *)token anchorId:(NSString *)anchorId price:(NSString *)price success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

@end
