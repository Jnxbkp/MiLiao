//
//  DiscoverMananger.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/14.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "DiscoverMananger.h"

@implementation DiscoverMananger

static NSString *LoginControllerName = @"phoneLoginViewController";


+ (void)updateRootController:(id)responseObject {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if ([responseObject[@"resultCode"] integerValue] == 1004) {
            [SVProgressHUD showErrorWithStatus:@"您的登录信息已失效，请重新登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[NSClassFromString(LoginControllerName) alloc] init];
        }
    }
}

//视频列表 HOT:热门,NEW:最新
//GET /v1/video/videoList/{pageNumber}/{pageSize}/{token}/{videoType}
+ (void)NetGetVideoListVideoType:(NSString *)videoType token:(NSString *)token pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
//    NSLog(@"-----------net---%@",[NSString stringWithFormat:@"%@/v1/video/videoList/%@/%@/%@/%@",HLRequestUrl,pageNumber,pageSize,token,videoType]);
    [manager GET:[NSString stringWithFormat:@"%@/v1/video/videoList/%@/%@/%@/%@",HLRequestUrl,pageNumber,pageSize,token,videoType] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        [self updateRootController:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//视频点赞
//POST /v1/video/updateVideoZan
+ (void)NetPostUpdateVideoZanUserId:(NSString *)userId token:(NSString *)token videoId:(NSString *)videoId zanStatus:(NSString *)zanStatus success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"anchorId"] = userId;
    param[@"token"] = token;
    param[@"videoId"] = videoId;
    param[@"zanSatatus"] = zanStatus;
    NSLog(@"-----%@-----%@",[NSString stringWithFormat:@"%@/v1/video/updateVideoZan",HLRequestUrl],param);
    [manager POST:[NSString stringWithFormat:@"%@/v1/video/updateVideoZan",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        [self updateRootController:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

//是否已关注daV  anchorId(大vID)
// GET /v1/bigV/getAnchorSfgz
+ (void)NetGetgetAnchorSfgzVodeoId:(NSString *)videoId token:(NSString *)token anchorId:(NSString *)anchorId success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"videoId"] = videoId;
    param[@"token"] = token;
    param[@"anchorId"] = anchorId;
    [manager GET:[NSString stringWithFormat:@"%@/v1/bigV/getAnchorSfgz",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        [self updateRootController:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
