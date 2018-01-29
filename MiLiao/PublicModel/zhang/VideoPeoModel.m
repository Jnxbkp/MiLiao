//
//  VideoPeoModel.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/29.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "VideoPeoModel.h"

@implementation VideoPeoModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.userId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
        self.nickname = [dict objectForKey:@"nickname"];
        self.fansNum = [dict objectForKey:@"fansNum"];
        self.likeStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"likeStatus"]];
        self.headUrl = [dict objectForKey:@"headUrl"];
        self.videoCount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"videoCount"]];
        self.videoId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"videoId"]];
        self.zanStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"zanStatus"]];
        self.videoUp = [NSString stringWithFormat:@"%@",[dict objectForKey:@"videoUp"]];
        self.videoUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"videoUrl"]];
        self.videoName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"videoName"]];
        
    }
    return self;
}

@end
