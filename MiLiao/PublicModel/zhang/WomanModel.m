//
//  WomanModel.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "WomanModel.h"

@implementation WomanModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.user_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        self.nickname = [dict objectForKey:@"nickname"];
        self.status = [dict objectForKey:@"status"];
        self.descriptionStr = [dict objectForKey:@"description"];
        self.headUrl = [dict objectForKey:@"headUrl"];
        self.height = [NSString stringWithFormat:@"%@",[dict objectForKey:@"height"]];
        self.isAgent = [NSString stringWithFormat:@"%@",[dict objectForKey:@"isAgent"]];
        self.isBigv = [NSString stringWithFormat:@"%@",[dict objectForKey:@"isBigv"]];
        self.sfgz = [NSString stringWithFormat:@"%@",[dict objectForKey:@"sfgz"]];
        self.wechat = [NSString stringWithFormat:@"%@",[dict objectForKey:@"wechat"]];
        self.fansNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fansNum"]];
        self.price = [NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]];
        
        self.isCommon = [dict objectForKey:@"isCommon"];
        self.jtl = [dict objectForKey:@"jtl"];
        self.personalSign = [dict objectForKey:@"personalSign"];
        self.province = [dict objectForKey:@"province"];
        self.username = [dict objectForKey:@"username"];
        self.weight = [NSString stringWithFormat:@"%@",[dict objectForKey:@"weight"]];
        self.token = [dict objectForKey:@"token"];
        self.city = [dict objectForKey:@"city"];
        self.constellation = [dict objectForKey:@"constellation"];
        self.country = [dict objectForKey:@"country"];
        
        
        self.evaluationList = [NSArray array];
        self.evaluationList = [dict objectForKey:@"evaluationList"];
        
        self.imageList = [NSArray array];
        self.imageList = [dict objectForKey:@"imageList"];
        
        self.userTags = [NSArray array];
        self.userTags = [dict objectForKey:@"userTags"];
        
        self.orderList = [NSArray array];
        self.orderList = [dict objectForKey:@"orderList"];
        
    }
    return self;
}
@end
