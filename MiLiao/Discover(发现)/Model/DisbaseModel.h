//
//  DisbaseModel.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "BaseModel.h"
#import "DisVideoModel.h"


@interface DisbaseModel : BaseModel

@property (nonatomic, strong) NSString *StatusCode;
@property (nonatomic, strong) NSString *AccessKeyId;
@property (nonatomic, strong) NSString *AccessKeySecret;
@property (nonatomic, strong) NSString *SecurityToken;
@property (nonatomic, strong) NSString *Expiration;
@property (nonatomic, strong) DisVideoModelList *videoList;

@end
