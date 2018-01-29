//
//  MainMananger.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/12.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MainMananger.h"

@implementation MainMananger
//推荐
//GET /v1/index/recommand/{pageNumber}/{pageSize}/{token}
//关注
//GET /v1/index/care/{pageNumber}/{pageSize}/{token}
//新人
//GET /v1/index/new/{pageNumber}/{pageSize}/{token}
+ (void)NetGetMainListKind:(NSString *)kind token:(NSString *)token pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSString *url = [NSString string];
    if ([kind isEqualToString:@"new"]) {
        url = [NSString stringWithFormat:@"%@/v1/index/new/%@/%@/%@",HLRequestUrl,pageNumber,pageSize,token];
    } else if ([kind isEqualToString:@"care"]) {
        url = [NSString stringWithFormat:@"%@/v1/index/care/%@/%@/%@",HLRequestUrl,pageNumber,pageSize,token];
    } else {
        url = [NSString stringWithFormat:@"%@/v1/index/recommand/%@/%@/%@",HLRequestUrl,pageNumber,pageSize,token];
    }
    
    NSLog(@"------------>>>>>>>>>>--%@",url);
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//获取主播信息/搜索
//GET /v1/user/getAnchorInfo  获取主播信息    (    *传入userId时查询，nickname参数值无效*
+ (void)NetGetgetAnchorInfoNickName:(NSString *)nickname token:(NSString *)token userid:(NSString *)userid success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
 
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"nickname"] = nickname;
    param[@"token"] = token;
    param[@"userid"] = userid;
    [manager GET:[NSString stringWithFormat:@"%@/v1/user/getAnchorInfo",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//根据用户id获取视频列表
//Get /v1/video/getVideoListById/{pageNumber}/{pageSize}/{token}/{userId}
+ (void)NetGetgetVideoListById:(NSString *)userId token:(NSString *)token pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    [manager GET:[NSString stringWithFormat:@"%@/v1/video/getVideoListById/%@/%@/%@/%@",HLRequestUrl,pageNumber,pageSize,token,userId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//关注大VV
//POST  /v1/bigV/careUser
/*
 McGuanZhuDto {
 bgzaccount (string): 被关注者账号 ,
 gzaccount (string): 关注者账号 ,
 sfgz (string, optional): 是否关注 ,
 token (string): Token
 }
 */
+ (void)NetPostCareBigVToken:(NSString *)token sfgz:(NSString *)sfgz bgzaccount:(NSString *)bgzaccount gzaccount:(NSString *)gzaccount success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    muDic[@"bgzaccount"] = bgzaccount;
    muDic[@"token"] = token;
    muDic[@"gzaccount"] = gzaccount;
    muDic[@"sfgz"] = sfgz;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"McGuanZhuDto"] = muDic;
    
    
    [manager POST:[NSString stringWithFormat:@"%@/v1/bigV/careUser",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//获取大V评价
//GET /v1/bigV/getEvals/{pageNumber}/{pageSize}/{userName}/{token}
+ (void)NetGetBigVgetEvalsUsername:(NSString *)username pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize token:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    [manager GET:[NSString stringWithFormat:@"%@/v1/bigV/getEvals/%@/%@/%@/%@",HLRequestUrl,pageNumber,pageSize,username,token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//获取大V亲密度列表
//Get /v1/bigV/getIntimateList
+ (void)NetGetIntimateListUsername:(NSString *)username success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"username"] = username;
    [manager GET:[NSString stringWithFormat:@"%@/v1/bigV/getIntimateList",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//关注大V
//POST /v1/bigV/careUser
+ (void)NetPostCareuserBgzaccount:(NSString *)bgzaccount gzaccount:(NSString *)gzaccount sfgz:(NSString *)sfgz token:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"bgzaccount"] = bgzaccount;
    param[@"gzaccount"] = gzaccount;
    param[@"sfgz"] = sfgz;
    param[@"token"] = token;
//    NSLog(@"----->>%@",param);
    [manager POST:[NSString stringWithFormat:@"%@/v1/bigV/careUser",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
   
}

//购买微信
//GET /v1/cost/buyWechatInfo
+ (void)NetGetbuyWechatInfoToken:(NSString *)token anchorId:(NSString *)anchorId price:(NSString *)price success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"anchorId"] = anchorId;
    param[@"price"] = price;
    [manager GET:[NSString stringWithFormat:@"%@/v1/cost/buyWechatInfo",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
