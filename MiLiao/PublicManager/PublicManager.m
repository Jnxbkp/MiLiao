//
//  PublicManager.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/9.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "PublicManager.h"

@implementation PublicManager

//video-sts-token获取
// GET /v1/oss/getOSSVideoToken
+ (void)NetGetgetOSSVideoToken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    [manager GET:[NSString stringWithFormat:@"%@/v1/oss/getOSSVideoToken?token=%@",HLRequestUrl,token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//获取是否隐藏视频
//GET /v1/app/getHideVersion
+ (void)NetGetgetHideVersionsuccess:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platform"] = @"IOS";
    [manager GET:[NSString stringWithFormat:@"%@/v1/app/getHideVersion",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
