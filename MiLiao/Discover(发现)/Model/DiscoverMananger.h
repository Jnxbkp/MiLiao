//
//  DiscoverMananger.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/14.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverMananger : NSObject

//视频列表 HOT:热门,NEW:最新
//GET /v1/video/videoList/{pageNumber}/{pageSize}/{token}/{videoType}
+ (void)NetGetVideoListVideoType:(NSString *)videoType token:(NSString *)token pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

@end
