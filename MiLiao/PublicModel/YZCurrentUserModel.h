//
//  UZCurrentUserModel.h
//  fangchan
//
//  Created by cuibin on 16/3/31.
//  Copyright © 2016年 youzai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface YZCurrentUserModel : NSObject




/**用户名*/
@property (nonatomic, strong) NSString      * username;
@property (nonatomic, strong) NSString      * balance;
@property (nonatomic, strong) NSNumber      * userID;
@property (nonatomic, strong) NSString      *user_id;
@property (nonatomic, strong) NSString      * isBigv;
@property (nonatomic, strong) NSString      * nickname;
@property (nonatomic, strong) NSString      * height;
@property (nonatomic, strong) NSString      * isAgent;
@property (nonatomic, strong) NSString      * loginType;
@property (nonatomic, strong) NSString      * token;
@property (nonatomic, strong) NSString      * weight;
@property (nonatomic, strong) NSString      * headUrl;
@property (nonatomic, strong) NSString      * rongCloudToken;
@property (nonatomic, strong) NSString      * rongCloudUserId;
@property (nonatomic, strong) NSString      * rongCloudUserName;
@property (nonatomic, strong) NSString      * price;//单价
///用户身份类别 0普通用户 1-经纪人 2-大v
@property (nonatomic, assign) NSInteger      roleType;
singleton_h(YZCurrentUserModel)

- (instancetype)initWithDictionary:(NSDictionary *)d;

+ (instancetype)userInfoWithDictionary:(NSDictionary *)d;

- (void)cleanUserData;

@end
