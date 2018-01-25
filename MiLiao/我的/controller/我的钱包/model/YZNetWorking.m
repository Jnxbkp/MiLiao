//
//  UZNetWorking.m
//  fangchan
//
//  Created by cuibin on 16/3/28.
//  Copyright © 2016年 youzai. All rights reserved.
//

#import "YZNetWorking.h"

@interface YZNetWorking ()

@end

@implementation YZNetWorking
//get请求
+ (void)GET:(NSString *)urlString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 防止解析不出来
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",HLRequestUrl,urlString]);
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:[NSString stringWithFormat:@"%@%@",HLRequestUrl,urlString] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleReslutCode:responseObject];
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

//post请求
+ (void)POST:(NSString *)urlString
  parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",HLRequestUrl,urlString]);
    
//    [manager.requestSerializer setValue:HEADERappid forHTTPHeaderField:@"appid"];
//    [manager.requestSerializer setValue:HEADERappkey forHTTPHeaderField:@"appkey"];
    
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager POST:[NSString stringWithFormat:@"%@%@",HLRequestUrl,urlString] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleReslutCode:responseObject];
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}
+(void)POST:(NSString *)urlString
 parameters:(id)parameters
 image:(UIImage *)image
    success:(void (^)(NSURLSessionDataTask *, id))success
    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 防止解析不出来
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",HLRequestUrl,urlString]);
    //    [manager.requestSerializer setValue:HEADERappid forHTTPHeaderField:@"appid"];
    //    [manager.requestSerializer setValue:HEADERappkey forHTTPHeaderField:@"appkey"];
    
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *fileName = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    [manager POST:[NSString stringWithFormat:@"%@%@",HLRequestUrl,urlString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (data) {
            [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            success(task, responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];

}
/**带图片的post请求*/
+(void)POST:(NSString *)urlString
 parameters:(id)parameters
    imgData:(NSData *)imgData

    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 防止解析不出来
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",HLRequestUrl,urlString]);
//    [manager.requestSerializer setValue:HEADERappid forHTTPHeaderField:@"appid"];
//    [manager.requestSerializer setValue:HEADERappkey forHTTPHeaderField:@"appkey"];
    
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *fileName = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    [manager POST:[NSString stringWithFormat:@"%@%@",HLRequestUrl,urlString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imgData) {
            [formData appendPartWithFileData:imgData name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleReslutCode:responseObject];
        
        if (success) {
            
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}


+ (void)handleReslutCode:(NSDictionary *)responseObject{
    
    int resultCode = [responseObject[@"result"] intValue];
    switch (resultCode) {
            // 用户被踢下线
        case 8888:
        {
        }
            break;
            
        default:
            break;
    }
}

@end

