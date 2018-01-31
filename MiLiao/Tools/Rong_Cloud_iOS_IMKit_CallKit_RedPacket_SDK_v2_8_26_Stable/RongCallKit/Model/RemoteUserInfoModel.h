//
//  AncherModel.h
//  MiLiao
//
//  Created by King on 2018/1/31.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 网红模型
 */
@interface RemoteUserInfoModel : NSObject

///手机号
@property (nonatomic, strong) NSString *username;

///昵称
@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *price;

///头像url
@property (nonatomic, strong) NSString *headUrl;
@end
