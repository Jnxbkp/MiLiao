//
//  User.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/5.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "User.h"
#import <MJExtension.h>
@implementation User

static User *sharedObject;
+ (User *) ShardInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[User alloc] init];
    });
    return sharedObject;
}

-(void)saveUserInfoWithInfo:(NSDictionary *)userInfo {
  sharedObject =  [User mj_objectWithKeyValues:userInfo];
    NSLog(@"%@", sharedObject.username);
}
@end
