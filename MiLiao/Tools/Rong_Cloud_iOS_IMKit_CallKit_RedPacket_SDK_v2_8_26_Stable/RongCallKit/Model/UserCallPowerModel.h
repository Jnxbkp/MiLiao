//
//  UserCallPowerModel.h
//  MiLiao
//
//  Created by King on 2018/1/16.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCallPowerModel : NSObject

///剩余可通话秒数
@property (nonatomic, strong) NSString *seconds;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *consumeId;
@property (nonatomic, strong) NSString *rechargeId;
///状态码
@property (nonatomic, assign) NSInteger typeCode;
@property (nonatomic, strong) NSString *pid;
@end
