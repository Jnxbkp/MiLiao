//
//  Networking.h
//  MiLiao
//
//  Created by King on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "BaseNetworking.h"


#define ResultCode @"resultCode"
#define ResultMsg @"resultMsg"

///请求状态
typedef NS_ENUM(NSUInteger, RequestState) {
    ///失败
    Failure,
    ///成功
    Success
};

///网络返回数组(列表)的回调
typedef void(^RequestResult)(RequestState success, NSArray *modelArray, NSInteger code, NSString *msg);


///网络返回字典(单个模型)的回调
typedef void(^RequestModelResult)(RequestState success, id model, NSInteger code, NSString *msg);


typedef void(^CompleteBlock)(RequestState success, NSString *msg);



@interface Networking : BaseNetworking



/**
 post请求 返回模型数组
 
 @param urtString url
 @param parameters parametr
 @param modelClass 模型class
 @param result 返回
 */
+ (void)Post:(NSString *)urtString parameters:(id)parameters modelClass:(Class)modelClass result:(RequestResult)result;


/**
 post请求 返回单个模型
 
 @param urtString url
 @param parameters parameter
 @param modelClass model Class
 @param modelResult 返回的模型
 */
+ (void)Post:(NSString *)urtString parameters:(id)parameters modelClass:(Class)modelClass modelResult:(RequestModelResult)modelResult;



/**
 post请求 返回一个字典

 @param urlString url
 @param parameters parameers
 @param result 返回的字典回调
 */
+ (void)Post:(NSString *)urlString parameters:(id)parameters result:(void(^)(RequestState success, NSDictionary *dict, NSString *errMsg))result;



/**
 post请求 返回成功或失败
 
 @param urlString url
 @param parameters parameter
 @param complete 返回成功或失败
 */
+ (void)Post:(NSString *)urlString parameters:(id)parameters complete:(CompleteBlock)complete;



/**
 get请求 返回单个模型

 @param urlString url
 @param parameters paramenter
 @param modelClass 模型类
 @param modelResult 返回的模型
 */
+ (void)Get:(NSString *)urlString parameters:(id)parameters modelClass:(Class)modelClass modelResult:(RequestModelResult)modelResult;


/**
 Get请求 返回一个字典

 @param urlString url
 @param parameters parameter
 @param result 返回的字典
 */
+ (void)Get:(NSString *)urlString parameters:(id)parameters result:(void(^)(RequestState success, NSDictionary *dict, NSString *errMsg))result;



/**
 GET请求 返回成功或失败

 @param urlString
 @param parameters
 @param complete 返回成功或失败
 */
+ (void)Get:(NSString *)urlString parameters:(id)parameters complete:(CompleteBlock)complete;



/**
 GET请求 - 返回模型数组

 @param urlString url
 @param parameters prameters
 @param modelClass model类
 @param result 返回的结果集
 */
+ (void)Get:(NSString *)urlString parameters:(id)parameters modelClass:(Class)modelClass result:(RequestResult)result;

@end
