//
//  HLLoginManager.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "HLLoginManager.h"

@implementation HLLoginManager
//获取短信验证码
//GET /v1/user/getVerifyCode
+ (void)NetGetgetVerifyCodeMobile:(NSString *)mobile success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
        //设置请求头
    
    [manager GET:[NSString stringWithFormat:@"%@/v1/user/getVerifyCode?mobile=%@",HLRequestUrl,mobile] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
   
}
//oss-token获取
//GET /v1/oss/getOSSToken
+ (void)NetGetgetOSSToken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    [manager GET:[NSString stringWithFormat:@"%@/v1/oss/getOSSToken?token=%@",HLRequestUrl,token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//用户注册
//POST /v1/user/register
+ (void)NetPostRegisterMobile:(NSString *)mobile password:(NSString *)password msgId:(NSString *)msgId verifyCode:(NSString *)verifyCode deviceType:(NSNumber *)deviceType success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = mobile;
    param[@"msgId"] = msgId;
    param[@"verifyCode"] = verifyCode;
    param[@"password"] = password;
    param[@"deviceType"] = deviceType;
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/register",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}
//用户登录
//POST /v1/user/login
+ (void)NetPostLoginMobile:(NSString *)mobile password:(NSString *)password  deviceType:(NSNumber *)deviceType utdeviceId:(NSString *)utdeviceId success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = mobile;
    param[@"password"] = password;
    param[@"deviceType"] = deviceType;
    param[@"utdeviceId"] = utdeviceId;

    [manager POST:[NSString stringWithFormat:@"%@/v1/user/login",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}
//重置密码
//POST /v1/user/resetpwd
+ (void)NetPostresetpwdMobile:(NSString *)mobile password:(NSString *)password msgId:(NSString *)msgId verifyCode:(NSString *)verifyCode success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = mobile;
    param[@"msgId"] = msgId;
    param[@"verifyCode"] = verifyCode;
    param[@"password"] = password;
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/resetpwd",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//快速登录
//POST /v1/user/quickLogin
+ (void)NetPostquickLoginName:(NSString *)name platform:(NSString *)platform token:(NSString *)token uid:(NSString *)uid success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"name"] = name;
    param[@"platform"] = platform;
    param[@"token"] = token;
    param[@"uid"] = uid;
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/quickLogin",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//更新头像昵称
//POST   /v1/user/updateHeadUrl
+ (void)NetPostupdateHeadUrl:(NSString *)headUrl nickName:(NSString *)nickName token:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"nickName"] = nickName;
    param[@"headUrl"] = headUrl;
    param[@"token"] = token;
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/updateHeadUrl",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//GET /v1/user/getUserInfo
+ (void)NetGetgetUserInfoToken:(NSString *)token UserId:(NSString *)userId success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    [manager GET:[NSString stringWithFormat:@"%@/v1/user/getUserInfo?token=%@&userId=%@",HLRequestUrl,token,userId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//POST /v1/bigV/saveBigV 认证大V
+ (void)NetPostupdateV:(NSString *)country province:(NSString *)province city:(NSString *)city constellation :(NSString *)constellation  description:(NSString *)description height:(NSNumber *)height nickName:(NSString *)nickName personalSign:(NSString *)personalSign personalTags :(NSArray *)personalTags posters:(NSArray *)posters token:(NSString *)token weight :(NSNumber * )weight wechat:(NSString *)wechat success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"country"] = country;
    param[@"province"] = province;
    param[@"city"] = city;
    param[@"constellation"] = constellation;
    param[@"description"] = description;
    param[@"height"] = height;
    param[@"nickName"] = nickName;
    param[@"personalSign"] = personalSign;
    param[@"personalTags"] = personalTags;
    param[@"weight"] = weight;
    param[@"posters"]= posters;
    param[@"token"] = token;
    param[@"wechat"] = wechat;

    [manager POST:[NSString stringWithFormat:@"%@/v1/bigV/saveBigV",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//获取通话记录
//Get /v1/call/getCallInfoList GET /v1/call/getCallInfoList
+ (void)NetGetgetCallInfoListToken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    [manager GET:[NSString stringWithFormat:@"%@/v1/call/getCallInfoList?token=%@",HLRequestUrl,token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//提现信息申请
//POST /v1/wirthdraw/saveWirthdrawInfo
+ (void)saveWirthdrawInfoamount:(NSNumber *)amount bz:(NSString *)Token collectionAccount:(NSString *)collectionAccount mobile :(NSString *)mobile  userId:(NSString *)userId userName:(NSString *)userName success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"amount"] = amount;
    param[@"bz"] = Token;
    param[@"collectionAccount"] = collectionAccount;
    param[@"mobile"] = mobile;
    param[@"userId"] = userId;
    param[@"userName"] = userName;
    [manager POST:[NSString stringWithFormat:@"%@/v1/wirthdraw/saveWirthdrawInfo",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//保存用户账户提现信息
//POST /v1/user/saveUserWirthdrawInfo
+ (void)saveUserWirthdrawInfoverifyCode:(NSString *)verifyCode token:(NSString *)token account:(NSString *)account accountName :(NSString *)accountName  success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"verifyCode"] = verifyCode;
    param[@"token"] = token;
    param[@"account"] = account;
    param[@"accountName"] = accountName;
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/saveUserWirthdrawInfo",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//大V设置单价
//POST /v1/user/setPrice  /v1/user/setPrice
+ (void)setPrice:(int)price token:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"money"] = [NSNumber numberWithInt:price];
    param[@"token"] = token;
    NSLog(@"%@",param);
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/setPrice",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//获取我的提现信息
// GET /v1/moneyDetail/getWalletInfo
+ (void)getWalletInfotoken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    [manager GET:[NSString stringWithFormat:@"%@/v1/moneyDetail/getWalletInfo?token=%@",HLRequestUrl,token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//POST /v1/user/saveUserWirthdrawInfo 保存用户提现账户信息
+ (void)saveUserWirthdrawInfotoken:(NSString *)token Account:(NSString *)account AccountName:(NSString *)accountName success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"account"] = account;
    param[@"token"] = token;
    param[@"accountName"] = accountName;
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/saveUserWirthdrawInfo",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//POST /v1/wirthdraw/saveWirthdrawInfo 提现信息申请
+ (void)saveWirthdrawInfotoken:(NSString *)token amount:(NSNumber *)amount collectionAccount:(NSString *)collectionAccount collectionName:(NSString *)collectionName mobile:(NSString *)mobile remark:(NSString *)remark success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"amount"] = amount;
    param[@"token"] = token;
    param[@"collectionAccount"] = collectionAccount;
    param[@"collectionName"] = collectionName;
    param[@"mobile"] = mobile;
    param[@"remark"] = remark;
    [manager POST:[NSString stringWithFormat:@"%@/v1/wirthdraw/saveWirthdrawInfo",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//POST /v1/video/saveVideo 视频保存
+ (void)NetPostSaveVideotoken:(NSString *)token videoId:(NSString *)videoId videoName:(NSString *)videoName videoUrl:(NSString *)videoUrl success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"videoId"] = videoId;
    param[@"token"] = token;
    param[@"videoName"] = videoName;
    param[@"videoUrl"] = videoUrl;
    
    [manager POST:[NSString stringWithFormat:@"%@/v1/video/saveVideo",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//GET /v1/dict/getTags 获取评论标签
+ (void)getTagstoken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    [manager GET:[NSString stringWithFormat:@"%@/v1/dict/getTags?token=%@",HLRequestUrl,token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
// GET /v1/moneyDetail/withdrawDetails 提现明细
+ (void)withdrawDetailstoken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    [manager GET:[NSString stringWithFormat:@"%@/v1/moneyDetail/withdrawDetails?token=%@",HLRequestUrl,token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//GET /v1/moneyDetail/incomeDetails 收入明细
+ (void)incomeDetailstoken:(NSString *)token  pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    [manager GET:[NSString stringWithFormat:@"%@/v1/moneyDetail/incomeDetails/%@/%@/%@",HLRequestUrl,pageNumber,pageSize,token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//支出明细 GET /v1/moneyDetail/expenditureDetails
+ (void)expenditureDetailstoken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    [manager GET:[NSString stringWithFormat:@"%@/v1/moneyDetail/expenditureDetails?token=%@",HLRequestUrl,token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//GET /v1/user/center     /v1/user/center
+ (void)centertoken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    [manager GET:[NSString stringWithFormat:@"%@/v1/user/center/%@",HLRequestUrl,token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//  GET  /v1/user/verifyCodeResetPWD
+ (void)verifyCodeResetPWD:(NSString *)mobile verifyCode:(NSString *)verifyCode  success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    [manager GET:[NSString stringWithFormat:@"%@/v1/user/verifyCodeResetPWD?mobile=%@&verifyCode=%@",HLRequestUrl,mobile,verifyCode] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//POST /v1/user/updateStatus 修改用户在线状态
+ (void)updateStatustoken:(NSString *)token status:(NSString *)status success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"status"] = status;
    
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/updateStatus",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
