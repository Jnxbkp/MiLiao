//
//  VideoDeduction.h
//  MiLiao
//
//  Created by King on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 视频扣费
 */
@interface VideoDeduction : NSObject


/**
 计算可通话时长

 @param videoCallUserID 视频通话的对端用户id
 @param canCall <#canCall description#>
 */
+ (void)calculatorCallTime:(NSString *)videoCallUserID canCallTime:(void(^)(BOOL canCall))canCall;


/**
 每分钟扣费

 @param minute 返回的剩余时间分钟数
 */
+ (void)perMinuteDedection:(void(^)(NSInteger minute))minute;
@end
