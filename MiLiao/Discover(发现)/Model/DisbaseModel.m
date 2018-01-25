//
//  DisbaseModel.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "DisbaseModel.h"

@implementation DisbaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.StatusCode = [NSString stringWithFormat:@"%@",[dict objectForKey:@"StatusCode"]];
        self.AccessKeyId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"AccessKeyId"]];
        self.AccessKeySecret = [dict objectForKey:@"AccessKeySecret"];
        self.SecurityToken = [dict objectForKey:@"SecurityToken"];
        self.Expiration = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Expiration"]];
        
        self.videoList = [[DisVideoModelList alloc]initWithArray:[dict objectForKey:@"userList"]];
    }
    return self;
}
@end
