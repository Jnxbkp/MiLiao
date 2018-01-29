//
//  UZCurrentUserModel.m
//  fangchan
//
//  Created by cuibin on 16/3/31.
//  Copyright © 2016年 youzai. All rights reserved.
//

#import "YZCurrentUserModel.h"
#import <objc/runtime.h>
@implementation YZCurrentUserModel
singleton_m(YZCurrentUserModel)


NSString *const RoleTypeCommon = @"COMMON";
NSString *const RoleTypeAgent = @"AGENT";
NSString *const RoleTypeBigV = @"BIGV";

- (id)init
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 加载资源
            //
        });
    }
    return self;
}
- (instancetype)initWithDictionary:(NSDictionary *)d
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:d];
        
    }
    return self;
}

+ (instancetype)userInfoWithDictionary:(NSDictionary *)d {
    return  [[self alloc] initWithDictionary:d];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.userID = value;
        NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
        self.user_id = [format stringFromNumber:(NSNumber *)value];
    }
    if ([key isEqualToString:@"roleType"]) {
        NSLog(@"%@", value);
    }
    // 当发现没有定义的key值时 不处理
}
- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    NSLog(@"--------%@",value);
    if ([key isEqualToString:@"nickname"]) {
        self.nickname = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
}

- (void)cleanUserData{
    NSLog(@"-------12312321------");
    // 1.清除单例内存数据
    [self setValuesForKeysWithDictionary:[self toDicationary]];
    // 2.清除数据
    [HLUserDefaults removeObjectForKey:CurrentUserAccount];
    [HLUserDefaults removeObjectForKey:CurrentUserToken];
    [HLUserDefaults synchronize];
}
//获取key为成员变量,value为空的字典
- (NSDictionary *)toDicationary
{
    NSMutableDictionary * dictionaryFormat = [NSMutableDictionary dictionary];
    Class class = [self class];
    unsigned int ivarsCnt = 0;
    Ivar * ivars = class_copyIvarList(class, &ivarsCnt);
    for (const Ivar * p = ivars; p < ivars + ivarsCnt; ++p) {
        Ivar const ivar = *p;
        NSString * _key = [NSString stringWithUTF8String:ivar_getName(ivar)];//_key(@property)有下标"_"
        NSString * key = [_key substringFromIndex:1];
        id value = [self valueForKey:_key];
        if (value && ![key isEqualToString:@"lng"] && ![key isEqualToString:@"lat"] && ![key isEqualToString:@"cityname"] && ![key isEqualToString:@"CityID"] && ![key isEqualToString:@"DWCityID"]) {
            [dictionaryFormat setObject:[NSNull null] forKey:key];
        }

//        [dictionaryFormat setObject:[NSNull null] forKey:key];
    }
    NSLog(@"%@", dictionaryFormat);
    
    return dictionaryFormat;
}
- (id)isNull:(id)obj {
    if (obj == nil) {
        return [NSNull null];
    }else {
        return obj;
    }
}
@end
