//
//  VideoUserModel.h
//  MiLiao
//
//  Created by King on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoUserModel : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *personalSign;
@property (nonatomic, strong) NSString *posterUrl;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *price;
///用户的手机号 融云的用户id
@property (nonatomic, strong) NSString *username;
@end
