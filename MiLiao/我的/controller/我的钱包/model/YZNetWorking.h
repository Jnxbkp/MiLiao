//
//  UZNetWorking.h
//  fangchan
//
//  Created by cuibin on 16/3/28.
//  Copyright © 2016年 youzai. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface YZNetWorking : NSObject
#pragma mark - GET请求
+ (void)GET:(NSString *)urlString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - POST请求
/**POST请求*/
+ (void)POST:(NSString *)urlString
  parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark--带图片的POST请求
/**带图片的post请求*/
+(void)POST:(NSString *)urlString
 parameters:(id)parameters
    imgData:(NSData *)imgData
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
/**上传单张图片*/
+(void)POST:(NSString *)urlString
 parameters:(id)parameters
    image:(UIImage *)image
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
