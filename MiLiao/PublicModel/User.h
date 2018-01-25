//
//  User.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/5.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
+ (User *) ShardInstance;
-(void)saveUserInfoWithInfo:(NSDictionary *)userInfo;

@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString  *user_id;
@property (nonatomic, strong) NSString  *isBigv;
@property (nonatomic, strong) NSString  *nickname;
@property (nonatomic, strong) NSString  *height;
@property (nonatomic, strong) NSString  *isAgent;
@property (nonatomic, strong) NSString   *loginType;
@property (nonatomic, strong) NSString   *token;
@property (nonatomic, strong) NSString   *username;
@property (nonatomic, strong) NSString    *weight;

@end
