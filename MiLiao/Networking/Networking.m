//
//  Networking.m
//  MiLiao
//
//  Created by King on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "Networking.h"




@implementation Networking



+ (void)Post:(NSString *)urtString parameters:(id)parameters modelClass:(Class)modelClass result:(RequestResult)result {
    [self POST:urtString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RequestState success;
        NSArray *modelArray;
        if ([responseObject isKindOfClass:[NSDictionary class]]
            &&
            [responseObject[ResultCode] integerValue] == SUCCESS
            &&
            [responseObject[@"data"] isKindOfClass:[NSArray class]])
        {
            
            if (modelClass) modelArray = [modelClass mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            success = Success;
        } else {
            success = Failure;
        }
        !result?:result(success, modelArray,[responseObject[ResultCode] integerValue], responseObject[ResultMsg]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !result?:result(Failure, nil, 0, @"网络连接失败,请稍后再试");
    }];
}




+ (void)Post:(NSString *)urtString parameters:(id)parameters modelClass:(Class )modelClass modelResult:(RequestModelResult)modelResult
{
    [self POST:urtString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RequestState success;
        id model;
        
        if (([responseObject[ResultCode] integerValue] == SUCCESS
             ||
             [responseObject[@"code"] integerValue] == SUCCESS)
            &&
            [responseObject[@"data"] isKindOfClass:[NSDictionary class]])
        {
            if (modelClass){
                 model = [modelClass mj_objectWithKeyValues:responseObject[@"data"]];
            }
            success = Success;
        }
        else
        {
            success = Failure;
        }
        
        !modelResult?:modelResult(success, model,[responseObject[ResultCode] integerValue], responseObject[ResultMsg]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !modelResult?:modelResult(Failure, nil, 0, @"网络连接失败,请稍后再试");
    }];
}


/**
 post请求 返回一个字典
 
 @param urlString url
 @param parameters parameers
 @param dictResult 返回的字典回调
 */
+ (void)Post:(NSString *)urlString parameters:(id)parameters dictResult:(RequestDictResult)dictResult {
    
    [self POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RequestState state = Failure;
        NSDictionary *dict;
        if ([responseObject[ResultCode] integerValue] == SUCCESS
            ||
            [responseObject[@"code"] integerValue] == SUCCESS)
        {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                state = Success;
                dict = responseObject[@"data"];
            }
        }
        !dictResult?:dictResult(state, dict, responseObject[ResultMsg]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !dictResult?:dictResult(Failure, nil, @"网络连接失败");
    }];
}




+ (void)Post:(NSString *)urlString parameters:(id)parameters complete:(CompleteBlock)complete {
    [self POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            RequestState state = [responseObject[ResultCode] integerValue];
            NSString *msg = responseObject[ResultMsg];
            !complete?:complete(state, msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !complete?:complete(Failure, @"网络连接失败,请稍后再试");
    }];
}




//======== GET请求 ========
/**
 get请求 返回单个模型
 
 @param urlString url
 @param parameters paramenter
 @param modelClass 模型类
 @param modelResult 返回的模型
 */
+ (void)Get:(NSString *)urlString parameters:(id)parameters modelClass:(Class)modelClass modelResult:(RequestModelResult)modelResult {
    
    [self GET:urlString parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
          
          RequestState state = Failure;
          NSString *errMsg = @"";
          id model;
          NSInteger errCode = 0;
          
          if (([responseObject[ResultCode] integerValue] == SUCCESS
               ||
               [responseObject[@"code"] integerValue] == SUCCESS)
              &&
              [responseObject[@"data"] isKindOfClass:[NSDictionary class]])
          {
              state = Success;
              if (modelClass) {
                  model = [modelClass mj_objectWithKeyValues:responseObject[@"data"]];
              }
          } else {
              errCode = [responseObject[ResultCode] integerValue];
              errMsg = responseObject[ResultMsg];
          }
          !modelResult?:modelResult(state, model, errCode, errMsg);
          
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
           !modelResult?:modelResult(Failure, nil, 0, @"网络连接失败");
      }];
}


/**
 Get请求 返回一个字典
 
 @param urlString url
 @param parameters parameter
 @param result 返回的字典
 */
+ (void)Get:(NSString *)urlString parameters:(id)parameters result:(void(^)(RequestState success, NSDictionary *dict, NSString *errMsg))result {
    [self GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RequestState state = Failure;
        NSString *errMsg = @"";
        NSDictionary *dictonary;
        NSInteger errCode;
        if (([responseObject[@"code"] integerValue] == SUCCESS
             ||
             [responseObject[ResultCode] integerValue] == SUCCESS)
            &&
            [responseObject[@"data"] isKindOfClass:[NSDictionary class]])
        {
            state = Success;
            dictonary = responseObject[@"data"];
            
        } else {
            errCode = [responseObject[ResultCode] integerValue];
            errMsg = responseObject[ResultMsg];
        }
        !result?:result(state, dictonary, errMsg);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !result?:result(Failure, nil, @"网络连接失败");
    }];
}



/**
 GET请求 返回成功或失败
 
 @param urlString
 @param parameters
 @param complete 返回成功或失败
 */
+ (void)Get:(NSString *)urlString parameters:(id)parameters complete:(CompleteBlock)complete {
    [self GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RequestState state = Failure;
        NSString *errMsg = @"";
        if ([responseObject[ResultCode] integerValue] == SUCCESS
            ||
            [responseObject[@"code"] integerValue] == SUCCESS) {
            state = Success;
        } else {
            errMsg = responseObject[ResultMsg];
        }
        !complete?:complete(state, errMsg);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !complete?:complete(Failure, @"网络连接失败");
    }];
}


/**
 GET请求 - 返回模型数组
 
 @param urlString url
 @param parameters prameters
 @param modelClass model类
 @param result 返回的结果集
 */
+ (void)Get:(NSString *)urlString parameters:(id)parameters modelClass:(Class)modelClass result:(RequestResult)result {
    [self GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RequestState state = Failure;
        NSArray *modelArray;
        NSInteger code = 0;
        
        if (
            ([responseObject[ResultCode] integerValue] == SUCCESS
             ||
             [responseObject[@"code"] integerValue] == SUCCESS)
            &&
            [responseObject[@"data"] isKindOfClass:[NSArray class]])
        {
            if (modelClass) {
                modelArray = [modelClass mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                state = Success;
            }
        }
        if (responseObject[ResultCode]) {
            code = [responseObject[ResultCode] integerValue];
        }
        if (responseObject[@"code"]) {
            code = [responseObject[@"code"] integerValue];
        }
        !result?:result(state, modelArray, code, responseObject[ResultMsg]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !result?:result(Failure, nil, 1000, @"网络连接失败");
    }];
}





@end
