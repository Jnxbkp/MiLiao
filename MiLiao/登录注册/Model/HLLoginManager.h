//
//  HLLoginManager.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLLoginManager : NSObject

//获取短信验证码
//GET /v1/user/getVerifyCode
+ (void)NetGetgetVerifyCodeMobile:(NSString *)mobile verifyMobile:(NSString *)verifyMobile success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//oss-token获取
//GET /v1/oss/getOSSToken
+ (void)NetGetgetOSSToken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//用户注册
//POST /v1/user/register
+ (void)NetPostRegisterMobile:(NSString *)mobile password:(NSString *)password msgId:(NSString *)msgId verifyCode:(NSString *)verifyCode deviceType:(NSNumber *)deviceType success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//用户登录
//POST /v1/user/login
+ (void)NetPostLoginMobile:(NSString *)mobile password:(NSString *)password  deviceType:(NSNumber *)deviceType utdeviceId:(NSString *)utdeviceId success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//重置密码
//POST /v1/user/resetpwd
+ (void)NetPostresetpwdMobile:(NSString *)mobile password:(NSString *)password msgId:(NSString *)msgId verifyCode:(NSString *)verifyCode success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//快速登录
//POST /v1/user/quickLogin
+ (void)NetPostquickLoginName:(NSString *)name platform:(NSString *)platform token:(NSString *)platform uid:(NSString *)uid success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//更新头像昵称
//POST /v1/user/updateHeadUrl
+ (void)NetPostupdateHeadUrl:(NSString *)headUrl nickName:(NSString *)nickName token:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//POST /v1/bigV/saveBigV 认证大V
+ (void)NetPostupdateV:(NSString *)country province:(NSString *)province city:(NSString *)city constellation :(NSString *)constellation  description:(NSString *)description height:(NSNumber *)height nickName:(NSString *)nickName personalSign:(NSString *)personalSign personalTags :(NSArray *)personalTags posters:(NSArray *)posters token:(NSString *)token weight :(NSNumber *)weight wechat:(NSString *)wechat success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//获取用户信息
//GET /v1/user/getUserInfo
+ (void)NetGetgetUserInfoToken:(NSString *)token UserId:(NSString *)userId success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//获取通话记录
//POST /v1/call/getCallInfoList
+ (void)NetGetgetCallInfoListToken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//提现信息申请
//POST /v1/wirthdraw/saveWirthdrawInfo
+ (void)saveWirthdrawInfoamount:(NSNumber *)amount bz:(NSString *)Token collectionAccount:(NSString *)collectionAccount mobile :(NSString *)mobile  userId:(NSString *)userId userName:(NSString *)userName success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//保存用户账户提现信息
//POST /v1/user/saveUserWirthdrawInfo
+ (void)saveUserWirthdrawInfoverifyCode:(NSString *)verifyCode token:(NSString *)token account:(NSString *)account accountName :(NSString *)accountName  success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//大V设置单价
//POST /v1/user/setPrice
+ (void)setPrice:(int  )price token:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//获取我的提现信息
// GET /v1/moneyDetail/getWalletInfo
+ (void)getWalletInfotoken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//POST /v1/user/saveUserWirthdrawInfo 保存用户提现账户信息
+ (void)saveUserWirthdrawInfotoken:(NSString *)token Account:(NSString *)account AccountName:(NSString *)accountName success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//POST /v1/wirthdraw/saveWirthdrawInfo 提现信息申请
+ (void)saveWirthdrawInfotoken:(NSString *)token amount:(NSNumber *)amount collectionAccount:(NSString *)collectionAccount collectionName:(NSString *)collectionName mobile:(NSString *)mobile remark:(NSString *)remark success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//GET /v1/dict/getTags 获取评论标签
+ (void)getTagstoken:(NSString *)token type:(NSString *)type success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//POST /v1/video/saveVideo 视频保存
+ (void)NetPostSaveVideotoken:(NSString *)token videoId:(NSString *)videoId videoName:(NSString *)videoName videoUrl:(NSString *)videoUrl success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
// GET /v1/moneyDetail/withdrawDetails 提现明细
+ (void)withdrawDetailstoken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//GET /v1/moneyDetail/incomeDetails 收入明细  /v1/moneyDetail/incomeDetails/{pageNumber}/{pageSize}/{token}
+ (void)incomeDetailstoken:(NSString *)token  pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//GET /v1/moneyDetail/expenditureDetails 支出明细
+ (void)expenditureDetailstoken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//GET /v1/user/center     /v1/user/center个人中心首页
+ (void)centertoken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//  GET  /v1/user/verifyCodeResetPWD 检验验证码
+ (void)verifyCodeResetPWD:(NSString *)mobile verifyCode:(NSString *)verifyCode  success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//POST /v1/user/updateStatus 修改用户在线状态
+ (void)updateStatustoken:(NSString *)token status:(NSString *)status success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
// GET /v1/moneyDetail/getUserMoneyInfo  获取用户撩币信息
+ (void)getUserMoneyInfotoken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
@end
