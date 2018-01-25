//
//  DiscoverMananger.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/14.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "DiscoverMananger.h"

@implementation DiscoverMananger

//视频列表 HOT:热门,NEW:最新
//GET /v1/video/videoList/{pageNumber}/{pageSize}/{token}/{videoType}
+ (void)NetGetVideoListVideoType:(NSString *)videoType token:(NSString *)token pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    [manager GET:[NSString stringWithFormat:@"%@/v1/video/videoList/%@/%@/%@/%@",HLRequestUrl,pageNumber,pageSize,token,videoType] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
