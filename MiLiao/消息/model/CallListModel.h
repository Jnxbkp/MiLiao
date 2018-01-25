//
//  CallListModel.h
//  MiLiao
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallListModel : NSObject
@property (strong, nonatomic) NSString *headUrl;//头像
@property (strong, nonatomic) NSString *createDate;//时间
@property (strong, nonatomic) NSString *anchorAccount;
@property (strong, nonatomic) NSString *anchorId;
@property (strong, nonatomic) NSString *userAccount;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *callId;
@property (strong, nonatomic) NSString *callTime;
@end
